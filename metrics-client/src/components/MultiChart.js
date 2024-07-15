import React from 'react';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  TimeScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
} from 'chart.js';
import 'chartjs-adapter-luxon';
import { Line } from 'react-chartjs-2';
import { DateTime } from 'luxon';

// Register scales and elements
ChartJS.register(
  CategoryScale,
  LinearScale,
  TimeScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend
);

const LineChart = ({ metricKey, data }) => {
  const chartData = {
    datasets: [
      {
        label: metricKey,
        data: data.map(item => ({
          x: DateTime.fromISO(item.timestamp),
          y: parseFloat(item.average_value)
        })),
        fill: false,
        borderColor: '#e51943',
        //tension: 0.9 // curve adjustment
      }
    ],
  };

  const options = {
    responsive: true,
    plugins: {
      title: {
        display: true,
        text: metricKey,
      },
    },
    scales: {
      x: {
        type: 'time', // Time scale for datetime
        time: {
          unit: 'minute', // Time Unit
          tooltipFormat: 'DD T', //// Luxon format string //'yyyy-MM-dd HH:mm:ss',
          displayFormats: {
            minute: 'DD T', //'yyyy-MM-dd HH:mm:ss', // Format to show dates in X axis
          }
        },
        title: {
          display: true,
          text: 'Period'
        }
      },
      y: {
        type: 'linear', // Linear scale for numeric values
        title: {
          display: true,
          text: 'Average Value'
        }
      }
    }
  };

  return (
    <div style={{ flex: '1 1 100%', margin: '10px', backgroundColor: 'white', padding: '10px', borderRadius: '5px', 
      boxShadow: '0 0 10px rgba(0, 0, 0, 0.1)' }}>
        <Line data={chartData} options={options} />
    </div>
  );
};

const MultiChart = ({ metricKey, metrics }) => {
  return (
    <div style={{ display: 'flex', flexWrap: 'wrap', justifyContent: 'center' }}>
          <LineChart metricKey={metricKey} data={metrics} />
    </div>
  );
};

export default MultiChart;
