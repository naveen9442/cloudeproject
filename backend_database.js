// backend/src/config/database.js
const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    const mongoURI = process.env.MONGODB_URI || 'mongodb://mongodb:27017/fullstack_app';

    await mongoose.connect(mongoURI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    console.log('MongoDB Connected Successfully');
  } catch (error) {
    console.error('MongoDB Connection Error:', error.message);
    setTimeout(connectDB, 5000); // Retry after 5 seconds
  }
};

// Handle MongoDB disconnection
mongoose.connection.on('disconnected', () => {
  console.warn('MongoDB Disconnected');
});

module.exports = connectDB;
