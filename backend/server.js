const express = require('express');
const cors = require('cors');
const bodyParser = require("body-parser");
const {auth, db } = require("./config/firebase");
require('dotenv').config();
const riderRoutes = require("./routes/rider.routes");

const app = express();
app.use(cors());
app.use(bodyParser.json());

//!----------- API Routes---------------
app.use('/api', require('./routes/index'));
app.use("/api/riders", riderRoutes);

const PORT = process.env.PORT || 8000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
