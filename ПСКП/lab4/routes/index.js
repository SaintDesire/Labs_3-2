const express = require('express');
const router = express.Router();
const {
    getIndex,
    getAddForm,
    postAddForm,
    getUpdateForm,
    postUpdateForm,
    postDelete,
} = require('../controllers');

router.get('/', getIndex);
router.get('/Add', getAddForm);
router.post('/Add', postAddForm);
router.get('/Update', getUpdateForm);
router.post('/Update', postUpdateForm);
router.post('/Delete', postDelete);

module.exports = router;
