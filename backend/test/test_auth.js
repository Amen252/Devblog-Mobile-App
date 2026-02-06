const axios = require('axios');

const testRegister = async () => {
    try {
        const res = await axios.post('http://localhost:5000/api/auth/register', {
            name: 'Node Test User',
            email: 'nodetest@example.com',
            password: 'password123'
        });
        console.log('Registration Success:', res.data);
    } catch (error) {
        if (error.response) {
            console.error('Registration Failed:', error.response.data);
        } else {
            console.error('Error:', error.message);
        }
    }
};

testRegister();
