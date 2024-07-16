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

const LineChart = ({ metricKey, data, period }) => {
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
          unit: period, // Time Unit
          tooltipFormat: 'DD H', // Luxon format string
          displayFormats: {
            minute: 'DD T', //Format to show dates in X axis,
            hour: 'DD H',
            day: 'DD'
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

const MultiChart = ({ metricKey, metrics, period }) => {
  return (
    <div style={{ display: 'flex', flexWrap: 'wrap', justifyContent: 'center' }}>
          <LineChart metricKey={metricKey} data={metrics} period={period} />
    </div>
  );
};

export default MultiChart;
