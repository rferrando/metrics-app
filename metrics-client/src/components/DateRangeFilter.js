import React from 'react';
import { Form, Row, Col } from 'react-bootstrap';
import DatePicker from 'react-datepicker';
import 'react-datepicker/dist/react-datepicker.css';

const DateRangeFilter = ({ startDate, endDate, setStartDate, setEndDate  }) => {
return (
    <Form>
      <Row>
        <Col  md="6">
          <Form.Group controlId="formSearchStartDate">
            <DatePicker
              selected={startDate}
              onChange={date => setStartDate(date)}
              selectsStart
              startDate={startDate}
              endDate={endDate}
              placeholderText="Start Date"
              className="form-control"
            />
          </Form.Group>
        </Col>
        <Col md="6">
          <Form.Group controlId="formSearchEndDate">
            <DatePicker
              selected={endDate}
              onChange={date => setEndDate(date)}
              selectsEnd
              startDate={startDate}
              endDate={endDate}
              placeholderText="End Date"
              className="form-control"
            />
          </Form.Group>
        </Col>
      </Row>
    </Form>
  );
};

export default DateRangeFilter;
