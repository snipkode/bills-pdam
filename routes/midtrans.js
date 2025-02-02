const express = require('express');
const router = express.Router();
const db = require('../config/db'); 
const { verifyToken, verifyRole } = require('../middleware/auth');

router.use(verifyToken);
router.use(verifyRole(['admin', 'staff']));

// Midtrans webhook callback
router.post('/webhook', (req, res) => {
  const { order_id, transaction_status, gross_amount } = req.body;

  const query = 'INSERT INTO midtrans_logs (order_id, transaction_status, gross_amount) VALUES (?, ?, ?)';
  db.query(query, [order_id, transaction_status, gross_amount], (err, result) => {
    if (err) {
      return res.status(500).json({ error: 'Database error' });
    }
    res.status(200).json({ message: 'Webhook received successfully' });
  });

  // Update payment status based on webhook data
  const updateQuery = 'UPDATE payments SET status = ? WHERE id = ?';
  db.query(updateQuery, [transaction_status, order_id], (err, result) => {
    if (err) {
      console.error('Error updating payment status:', err);
    }
  });
});

module.exports = router;
