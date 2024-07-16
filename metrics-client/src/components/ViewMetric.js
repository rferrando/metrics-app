import React, { useEffect, useState } from 'react';
import axios from 'axios';
import MultiChart from './MultiChart';
import { Form, ToggleButton, ToggleButtonGroup, Container, Row, Col, Alert } from 'react-bootstrap';
import DateRangeFilter from './DateRangeFilter'; 
import ChartLegend from './ChartLegend';


function ViewMetric() {
    const [name, setName] = useState('');
    const [metrics, setMetrics] = useState([]);
    const [aggregation, setAggregation] = useState(null);
    const [startDate, setStartDate] = useState(null);
    const [endDate, setEndDate] = useState(null);
    const [error, setError] = useState(null);

    const handleChange = (e) => {
        setAggregation(e);                   
    };

// The useEffect() hook ensures that the API is called and the data is updated each time the component updates. 
// Allows components to respond to the changes in state or props and produce a side effect accordingly.
    useEffect(() => {
        setStartDate(startDate);
        setEndDate(endDate);

        let newStartDate = startDate;
        let newEndDate = endDate

        const fetchMetrics = async () => {
            let url = 'http://localhost:3000/metrics';
            if (aggregation) { 
                url += `_aggregations/by_${aggregation}`;
                if (!startDate && !endDate) {
                    
                    newEndDate = new Date() 
                    switch (aggregation) {
                      case 'minute':
                        newStartDate = new Date(newEndDate.getFullYear(), newEndDate.getMonth(), newEndDate.getDate());
                        break;
                      case 'hour':
                        newStartDate = new Date(newEndDate.getFullYear(), newEndDate.getMonth(), newEndDate.getDate() - 2);
                        break;
                      case 'day':
                        newStartDate = new Date(newEndDate.getFullYear(), newEndDate.getMonth(), newEndDate.getDate() - 7);
                        break;
                      default:
                        break;
                    } 
                } 

                await axios.get(url, { params: { name: name, start_date: newStartDate, end_date: newEndDate} })
                .then(function (response) {
                    setMetrics(response.data);
                    setError(null); // Reset error if HTTP request is successful
                })
                .catch(function (error) {
                    if (error.response) {
                        // The server responded with a status out of range 2xx
                        setError(`Error fetching metrics: ${error.response.data}`);
                      } else if (error.request) {
                        // The request was made but no response was received
                        setError(`No response received from server: ${error.message}`);
                      } else {
                        // Handling unexpected network errors or server errors
                        setError(error.message);
                      }
                });
            }
        };

        fetchMetrics();
        setStartDate(newStartDate);
        setEndDate(newEndDate);
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [aggregation, startDate, endDate, name]);

    return (
        <Container>
            <Form.Group as={Row} className="mb-2" controlId="formView">
                <Form.Label column style={{display:'flex', justifyContent:'left'}}>
                    Visualize metrics
                </Form.Label>
                <Col md={{ span: 2}} style={{justifyContent:'left'}}>
                    <Form.Control
                        type="text"
                        placeholder="Enter metric name"
                        name="name"
                        value={name}
                        onChange={(e) => setName(e.target.value)}
                    />
                </Col>
                <Col md={4}>
                    <DateRangeFilter startDate={startDate} endDate={endDate} setStartDate={setStartDate} setEndDate={setEndDate} />
                </Col>
                <Col md={4} style={{ display: 'flex', justifyContent: 'center'}}>
                    <ToggleButtonGroup type="radio" name="options" value={aggregation} onChange={handleChange}>
                        <ToggleButton id="tbg-btn-1" value={'minute'} variant="outline-danger">
                            By Minute
                        </ToggleButton>
                        <ToggleButton id="tbg-btn-2" value={'hour'} variant="outline-danger">
                            By Hour
                        </ToggleButton>
                        <ToggleButton id="tbg-btn-3" value={'day'} variant="outline-danger">
                        By Day
                        </ToggleButton>
                    </ToggleButtonGroup>
                </Col>
            </Form.Group>

            {error && <Alert variant="danger">{error}</Alert>}

            {!error && <Row className="justify-content-md-center">
                <Col md="10">
                    <MultiChart metricKey={name} metrics={metrics} period={aggregation}/>
                </Col>
                <Col md="2">
                    <ChartLegend name={name} aggregation={aggregation} startDate={startDate} endDate={endDate} />
                </Col>
            </Row>
            }
        </Container>
    );
}

export default ViewMetric;