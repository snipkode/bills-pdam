const jwt = require('jsonwebtoken');
require('dotenv').config();

// Middleware to verify token
const verifyToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
      return res.sendStatus(401);
    }
  
    jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
      if (err) {
        console.log("VERIFY TOKEN", err);
        return res.sendStatus(403);
      }
      req.user = user;

      next();
    });
  };


// Middleware to verify role
const verifyRole = (role) => {
  return (req, res, next) => {
    if (req.user.role !== role) {
     console.log("VERIFY ROLE ", req.user.role);
      return res.sendStatus(403);
    }
    next();
  };
};

module.exports = { verifyToken, verifyRole };
