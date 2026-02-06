const axios = require('axios');

const testFlow = async () => {
    try {
        // 1. Register/Login
        console.log('Logging in...');
        const loginRes = await axios.post('http://localhost:5000/api/auth/register', {
            name: 'Flow User',
            email: `flow_${Date.now()}@test.com`,
            password: 'password123'
        });

        const { accessToken } = loginRes.data;
        console.log('Got Token:', accessToken);

        // 2. Create Post
        console.log('Creating Post...');
        const postRes = await axios.post('http://localhost:5000/api/posts', {
            title: 'Test Post',
            content: 'Content here',
            category: 'Test'
        }, {
            headers: {
                Authorization: `Bearer ${accessToken}`
            }
        });

        console.log('Post Created:', postRes.data);
        const postId = postRes.data._id;

        // 3. Delete Post
        console.log('Deleting Post:', postId);
        const deleteRes = await axios.delete(`http://localhost:5000/api/posts/${postId}`, {
            headers: {
                Authorization: `Bearer ${accessToken}`
            }
        });

        console.log('Delete Result:', deleteRes.data);

    } catch (error) {
        if (error.response) {
            console.error('Error Status:', error.response.status);
            console.error('Error Data:', error.response.data);
        } else {
            console.error('Error:', error.message);
        }
    }
};

testFlow();
