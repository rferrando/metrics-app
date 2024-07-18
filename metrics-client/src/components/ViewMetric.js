import React, { useState } from 'react';
import axios from 'axios';
import MultiChart from './MultiChart';
import { Form, Button, ButtonToolbar, Container, Row, Col, Alert } from 'react-bootstrap';
import DateRangeFilter from './DateRangeFilter'; 
import ChartLegend from './ChartLegend';


function ViewMetric() {
    const [name, setName] = useState('');
    const [metrics, setMetrics] = useState([]);
    const [aggregation, setAggregation] = useState(null);
    const [startDate, setStartDate] = useState(null);
    const [endDate, setEndDate] = useState(null);
    const [error, setError] = useState(null);

    const handleStartDateChange = (date) => {
        setStartDate(date);
      };
    
      const handleEndDateChange = (date) => {
        setEndDate(date);
      };

    const handleButtonClick = async (action) => {
        setAggregation(action)
        let newStartDate = startDate;
        let newEndDate = endDate
        let url = 'http://localhost:3000/metrics';
        if (action) { 
            url += `_aggregations/by_${action}`;
            if (!startDate && !endDate) {
                
                newEndDate = new Date()
                switch (action) {
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

                setStartDate(newStartDate);
                setEndDate(newEndDate);
            } 

            await axios.get(url, { params: { name: name, start_date: newStartDate, end_date: newEndDate} })
            .then(function (response) {
                setMetrics(response.data);
                setError(null); // Reset error if HTTP request is successful
            })
            .catch(function (error) {
                if (error.response) {
                    // The server responded with a status out of range 2xx
                    let message = error.response.data
                    if (typeof(message) != "string") {
                        message = error.response.data.error
                    }
                    
                    setError(`Error fetching metrics: ${message}`);
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
                    <DateRangeFilter startDate={startDate} endDate={endDate} onStartDateChange={handleStartDateChange} onEndDateChange={handleEndDateChange} />
                </Col>
                <Col md={4} style={{ display: 'flex', justifyContent: 'center'}}>
                    <ButtonToolbar>
                        <Button id="btn-1" onClick={() => handleButtonClick('minute')} variant="outline-danger">
                            By Minute
                        </Button>
                        <Button id="btn-2" onClick={() => handleButtonClick('hour')} variant="outline-danger">
                            By Hour
                        </Button>
                        <Button id="btn-3" onClick={() => handleButtonClick('day')} variant="outline-danger">
                            By Day
                        </Button>
                    </ButtonToolbar>
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