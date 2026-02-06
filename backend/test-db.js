const mongoose = require('mongoose');
require('dotenv').config();

const testConnect = async () => {
    console.log('Attempting to connect...');
    try {
        const conn = await mongoose.connect(process.env.MONGO_URI, {
            serverSelectionTimeoutMS: 10000,
        });
        console.log('✅ Connection Successful!');
        console.log('Host:', conn.connection.host);
        console.log('Port:', conn.connection.port);
        console.log('Database Name:', conn.connection.name);

        // Try to get replica set info
        if (conn.connection.db) {
            const admin = conn.connection.db.admin();
            const info = await admin.replSetGetStatus();
            console.log('Replica Set:', info.set);
        }

        process.exit(0);
    } catch (err) {
        console.error('❌ Connection Failed:');
        console.error(err.message);
        if (err.message.includes('querySrv')) {
            console.log('💡 This looks like a DNS issue with SRV records.');
        }
        process.exit(1);
    }
};

testConnect();
