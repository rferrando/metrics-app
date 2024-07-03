import React, { useEffect, useState } from 'react';
import axios from 'axios';

function ViewMetric() {
    const [metrics, setMetrics] = useState({});
    const [aggregation, setAggregation] = useState('all');

// The useEffect() hook ensures that the API is called and the data is updated each time the component updates. 
// useEffect() is a combination of componentDidMount, componentDidUpdate and componentWillUnmount lifecycle methods. 
// Allows components to respond to the changes in state or props and produce a side effect accordingly.
    useEffect(() => {
        const fetchMetrics = async () => {
            let url = 'http://localhost:3000/metrics';
            const response = await axios.get(url);
            setMetrics(response.data);
        };

        fetchMetrics();
    }, [aggregation]);

    return (
        <div>
            <div>
                <button onClick={() => setAggregation('all')}>All</button>
            </div>
            <div><p>{JSON.stringify(metrics, null, 2)}</p></div>
        </div>
    );
}

export default ViewMetric;