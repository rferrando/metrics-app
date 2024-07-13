import React, { useEffect, useState } from 'react';
import axios from 'axios';
import MultiChart from './MultiChart';
import { Form, ToggleButton, ToggleButtonGroup, Container, Row, Col, InputGroup } from 'react-bootstrap';


function ViewMetric() {
    const [name, setName] = useState('');
    const [metrics, setMetrics] = useState([]);
    const [aggregation, setAggregation] = useState(['']);

    const handleChange = (e) => {
        setAggregation(e);
    };

// The useEffect() hook ensures that the API is called and the data is updated each time the component updates. 
// Allows components to respond to the changes in state or props and produce a side effect accordingly.
    useEffect(() => {
        const fetchMetrics = async () => {
            let url = 'http://localhost:3000/metrics';
            if (aggregation !== '' & name !== '') {
                url += `/by_${aggregation}`;
            
            const response = await axios.get(url, { params: { name: name } });
            setMetrics(response.data);
            setAggregation('')
            } 
        };

        fetchMetrics();
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [aggregation]);


    return (
        <Container>
            <Form.Group as={Row} className="mb-2" controlId="formView">
                <Form.Label column style={{display:'flex', justifyContent:'left'}}>
                    View metric values
                </Form.Label>
                <Col md={{ span: 3}} style={{justifyContent:'left'}}>
                    <Form.Control
                        type="text"
                        placeholder="Enter metric name"
                        name="name"
                        value={name}
                        onChange={(e) => setName(e.target.value)}
                    />
                </Col>
                <Col md={{ span: 3}}>
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

            <InputGroup size="sm" className="justify-content-md-center">
                <InputGroup.Text className="text-wrap">{JSON.stringify(metrics, null, 2)}</InputGroup.Text>
            </InputGroup>
            <Row className="justify-content-md-center">
                <Col md="10">
                    <MultiChart metricKey={name} metrics={metrics} />
                </Col>
            </Row>
        </Container>
    );
}

export default ViewMetric;