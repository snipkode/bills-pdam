const express = require('express');
const router = express.Router();
const db = require('../config/db'); 
const { verifyToken, verifyRole } = require('../middleware/auth');

router.use(verifyToken);
router.use(verifyRole(['admin', 'staff']));

// Get list of customers
router.get('/', (req, res) => {
  const query = 'SELECT * FROM customers';
  db.query(query, (err, results) => {
    if (err) {
      return res.status(500).json({ error: 'Database error' });
    }
    res.json(results);
  });
});

// Add a new customer
router.post('/', (req, res) => {
  const { name, address } = req.body;
  const query = 'INSERT INTO customers (name, address) VALUES (?, ?)';
  db.query(query, [name, address], (err, result) => {
    if (err) {
      return res.status(500).json({ error: 'Database error' });
    }
    res.status(201).json({ message: 'Customer added successfully' });
  });
});

module.exports = router;
