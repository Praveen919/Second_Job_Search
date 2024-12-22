const express = require('express');
const { getAllPlans, getPlanByUserId, purchasePlan, purchaseByWalletPoint } = require('../controllers/planController');
const router = express.Router();

router.get('', getAllPlans);
router.get('/user/:id', getPlanByUserId);
router.post('/purchase', purchasePlan);
router.post('/purchase-by-walletpoint', purchaseByWalletPoint);

module.exports = router;
