import React from 'react';
import { Form, Row, Col } from 'react-bootstrap';
import DatePicker from 'react-datepicker';
import 'react-datepicker/dist/react-datepicker.css';

const DateRangeFilter = ({ startDate, endDate, onStartDateChange, onEndDateChange  }) => {
return (
    <Form>
      <Row>
        <Col  md="6">
          <Form.Group controlId="formSearchStartDate">
            <DatePicker
              selected={startDate}
              onChange={onStartDateChange}
              selectsStart
              startDate={startDate}
              endDate={endDate}
              placeholderText="Start Date"
              className="form-control"
              dateFormat="MMMM d, yyyy"
            />
          </Form.Group>
        </Col>
        <Col md="6">
          <Form.Group controlId="formSearchEndDate">
            <DatePicker
              selected={endDate}
              onChange={onEndDateChange}
              selectsEnd
              startDate={startDate}
              endDate={endDate}
              placeholderText="End Date"
              className="form-control"
              dateFormat="MMMM d, yyyy"
            />
          </Form.Group>
        </Col>
      </Row>
    </Form>
  );
};

export default DateRangeFilter;
