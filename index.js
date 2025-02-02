const express = require('express');
const dotenv = require('dotenv');
const swaggerUi = require('swagger-ui-express');
const YAML = require('yamljs');
const cors = require('cors');
const authRoutes = require('./routes/auth');
const customerRoutes = require('./routes/customers');
const billRoutes = require('./routes/bills');
const paymentRoutes = require('./routes/payments');
const midtransRoutes = require('./routes/midtrans');

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());
app.use(cors());
app.use(express.urlencoded({ extended: true }));

const swaggerDocument = YAML.load('./swagger.yaml');
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));

app.use('/auth', authRoutes);
app.use('/customers', customerRoutes);
app.use('/bills', billRoutes);
app.use('/payments', paymentRoutes);
app.use('/midtrans', midtransRoutes);

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
