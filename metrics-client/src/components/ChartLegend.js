import React from 'react';
import { Card } from 'react-bootstrap';
import { format } from 'date-fns';

const ChartLegend = ({ name, aggregation, startDate, endDate }) => {
const formatDate = (date) => {
    if (!date) return 'N/A';
    return format(date, 'yyyy-MM-dd');
    };
  return (
    <Card bg="Secondary" border="danger" style={{ width: '18rem' }}>
      <Card.Body>
      <Card.Header>Legend</Card.Header>
        <Card.Text className="small">
          <strong>Period:</strong> {aggregation}<br />
          <strong>Metric Name:</strong> {name}<br />
          <strong>Start Date:</strong> {formatDate(startDate)}<br />
          <strong>End Date:</strong> {formatDate(endDate)}
        </Card.Text>
      </Card.Body>
    </Card>
  );
};

export default ChartLegend;
