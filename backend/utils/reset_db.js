const mongoose = require('mongoose');
require('dotenv').config();
const Post = require('../models/Post');

const resetDb = async () => {
    try {
        const conn = await mongoose.connect(process.env.MONGO_URI || 'mongodb://127.0.0.1:27017/blog-app');
        console.log(`MongoDB Connected: ${conn.connection.host}`);

        await Post.deleteMany({});
        console.log('All posts deleted.');

        process.exit();
    } catch (error) {
        console.error(error);
        process.exit(1);
    }
};

resetDb();
