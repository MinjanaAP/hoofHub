import express from 'express';
import cors from 'cors';
import bodyParser from 'body-parser';
import dotenv from 'dotenv';

import { auth, db } from './config/firebase.js';
import riderRoutes from './routes/rider.routes.js';
import guideRoutes from './routes/guide.routes.js';
import indexRoutes from './routes/index.js';
import userRoutes from './routes/user.routes.js'
import adminRoutes from './routes/admin.routes.js';
import rideRoutes  from './routes/rides.routes.js';
import horseRoutes from './routes/horse.routes.js';
import bookingRoutes from './routes/booking.routes.js';
import paymentRoutes from './routes/payment.routes.js';
import notificationRoutes from  './routes/notification.routes.js';

dotenv.config();

const app = express();
app.use(cors());
app.use(bodyParser.json());

//!----------- API Routes---------------
app.use('/api', indexRoutes);
app.use("/api/riders", riderRoutes);
app.use("/api/guides", guideRoutes);
app.use("/api/users",userRoutes);
app.use("/api/admins", adminRoutes);
app.use('/api/rides', rideRoutes);
app.use('/api/horses', horseRoutes);
app.use("/api/bookings", bookingRoutes);
app.use("/api/payment", paymentRoutes);
app.use("/api/notifications", notificationRoutes);

const PORT = process.env.PORT || 8000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
