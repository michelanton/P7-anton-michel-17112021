const express = require("express");
const router = express.Router();
const userCtrl = require("../controllers/user");
const auth = require('../middleware/auth');
const multer = require('../middleware/multer-config');
// POST d'un user
router.post("/signup",  multer, userCtrl.signup);
// LOG d'un user
router.post('/login', userCtrl.login);
// GET tout les user 
router.get('/users', auth, userCtrl.userAll);
// GET un user par son email
router.get('/users/:email', auth, userCtrl.userEmail);
// DELETE le user
router.delete('/users/:id', auth, userCtrl.supUsrCtrl); 

module.exports = router;
  