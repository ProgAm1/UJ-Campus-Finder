const express = require("express");
const router = express.Router();
// const db = require("../db");  // uncomment when implementing routes

// POST /api/contact — submit a contact/help message (to be implemented)
router.post("/", (req, res) => {
    res.json({ message: "Contact route placeholder — not yet implemented" });
});

module.exports = router;
