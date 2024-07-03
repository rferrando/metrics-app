import React, { useState } from 'react';
import axios from 'axios';

function PostMetric() {
    const [name, setName] = useState('');
    const [value, setValue] = useState('');

    const handleSubmit = async (e) => {
        e.preventDefault();
        await axios.post('http://localhost:3000/metrics', {
            metric: { name, value }
        });
    };

    return (
        <form onSubmit={handleSubmit}>
            <input type="text" placeholder="Name" value={name} onChange={(e) => setName(e.target.value)} />
            <input type="number" placeholder="Value" value={value} onChange={(e) => setValue(e.target.value)} />
            <button type="submit">Post Metric</button>
        </form>
    );
}

export default PostMetric;