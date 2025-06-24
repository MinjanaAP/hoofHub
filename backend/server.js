import express from 'express';
import cors from 'cors';
import bodyParser from 'body-parser';
import dotenv from 'dotenv';

import { auth, db } from './config/firebase.js';
import riderRoutes from './routes/rider.routes.js';
import guideRoutes from './routes/guide.routes.js';
import indexRoutes from './routes/index.js';

dotenv.config();

const app = express();
app.use(cors());
app.use(bodyParser.json());

//!----------- API Routes---------------
app.use('/api', indexRoutes);
app.use("/api/riders", riderRoutes);
app.use("/api/guides", guideRoutes);

const PORT = process.env.PORT || 8000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
