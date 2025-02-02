const express = require('express');
const router = express.Router();
const db = require('../db');
const { verifyToken, verifyRole } = require('../middleware/auth');

router.use(verifyToken);
router.use(verifyRole(['admin', 'staff']));

// Get bills for a customer
router.get('/:customer_id', (req, res) => {
  const { customer_id } = req.params;
  const query = 'SELECT * FROM bills WHERE customer_id = ?';
  db.query(query, [customer_id], (err, results) => {
    if (err) {
      return res.status(500).json({ error: 'Database error' });
    }
    res.json(results);
  });
});

// Add a new bill
router.post('/', (req, res) => {
  const { customer_id, amount, meter_reading } = req.body;
  const query = 'INSERT INTO bills (customer_id, amount, meter_reading) VALUES (?, ?, ?)';
  db.query(query, [customer_id, amount, meter_reading], (err, result) => {
    if (err) {
      return res.status(500).json({ error: 'Database error' });
    }
    res.status(201).json({ message: 'Bill added successfully' });
  });
});

module.exports = router;
