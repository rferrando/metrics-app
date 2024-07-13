import React, { useState } from 'react';
import axios from 'axios';
import { Form, Button, Container, Row, Col } from 'react-bootstrap';

function PostMetric() {
    const [metric, setMetric] = useState({ name: '', value: ''});

    const handleChange = (e) => {
        const { name, value } = e.target;
        setMetric({ ...metric, [name]: value });
      };
    
    const handleSubmit = async (e) => {
        e.preventDefault();
        await axios.post('http://localhost:3000/metrics', {
            metric: metric
        });
    };

    return (
    <Container>
        <Form onSubmit={handleSubmit}>
            <Row className="align-items-end">
                <Col md="3">
                <Form.Label>Post a Metric</Form.Label>
                </Col>
                <Col md="3">
                    <Form.Group controlId="formMetricName">
                        <Form.Control
                            type="text"
                            placeholder="Enter metric name"
                            name="name"
                            value={metric.name}
                            onChange={handleChange}
                        />
                    </Form.Group>
                </Col>
                <Col md="3">
                    <Form.Group controlId="formMetricValue">
                        
                        <Form.Control
                            type="number"
                            placeholder="Enter metric value"
                            name="value"
                            value={metric.value}
                            onChange={handleChange}
                    />
                    </Form.Group>
                </Col>
                <Col md="3">
                    <Button variant="outline-danger" type="submit">
                        Submit
                    </Button>
                </Col>
            </Row>
        </Form>
    </Container>
    );
}

export default PostMetric;