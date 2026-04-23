const express = require("express");
const router = express.Router();
// const db = require("../db");  // uncomment when implementing routes

// GET /api/claims — fetch all claim requests (to be implemented)
router.get("/", (req, res) => {
    res.json({ message: "Claims route placeholder — not yet implemented" });
});

// POST /api/claims — submit a claim request (to be implemented)
router.post("/", (req, res) => {
    res.json({ message: "Claim submission placeholder — not yet implemented" });
});

module.exports = router;
