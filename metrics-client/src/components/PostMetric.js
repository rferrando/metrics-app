import React, { useState } from 'react';
import axios from 'axios';
import { Form, Button, Container, Row, Col, Alert } from 'react-bootstrap';
import DatePicker from 'react-datepicker';
import 'react-datepicker/dist/react-datepicker.css';

function PostMetric() {
    const [metric, setMetric] = useState({ name: '', value: '', timestamp: null});
    const [error, setError] = useState(null);

    const handleChange = (e) => {
        const { name, value } = e.target;
        setMetric((prevMetric) => ({ ...prevMetric, [name]: value }));
      };

    const handleDateChange = (date) => {
        setMetric((prevMetric) => ({ ...prevMetric, timestamp: date }));
      };
    
    const handleSubmit = async (e) => {
        // Format timestamp to ISO string before sending it
        const metricToSubmit = { ...metric, timestamp: metric.timestamp?.toISOString() };

        e.preventDefault();
        await axios.post('http://localhost:3000/metrics', {
            metric: metricToSubmit
        })
        .then(function (response) {
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
    };

    return (
    <Container>
        <Form onSubmit={handleSubmit}>
            <Row className="align-items-end">
                <Col md="2">
                <Form.Label>Post a metric</Form.Label>
                </Col>
                <Col md="2">
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
                <Col md="2">
                    <Form.Group controlId="formMetricValue">
                        <Form.Control
                            type="number"
                            step="0.01"
                            placeholder="Enter metric value"
                            name="value"
                            value={metric.value}
                            onChange={handleChange}
                    />
                    </Form.Group>
                </Col>
                <Col md="2">
                    <Form.Group controlId="formMetricTimestamp">
                        <DatePicker
                            selected={metric.timestamp}
                            onChange={handleDateChange}
                            showTimeSelect
                            timeFormat="HH:mm"
                            timeIntervals={15}
                            dateFormat="MMMM d, yyyy h:mm aa"
                            className="form-control"
                            placeholderText="Select a date and time"
                    />
                    </Form.Group>
                </Col>
                <Col md={{ span: 2, offset: 1}} xs="auto" className="align-self-end">
                    <Button variant="outline-danger" type="submit">
                        Submit
                    </Button>
                </Col>
            </Row>
        </Form>

        {error && <Alert variant="danger">{error}</Alert>}
    </Container>
    );
}

export default PostMetric;