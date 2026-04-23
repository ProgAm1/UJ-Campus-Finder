const express = require("express");
const router = express.Router();
// const db = require("../db");  // uncomment when implementing routes

// GET /api/reports — fetch all reports (to be implemented)
router.get("/", (req, res) => {
    res.json({ message: "Reports route placeholder — not yet implemented" });
});

// POST /api/reports — submit a new report (to be implemented)
router.post("/", (req, res) => {
    res.json({ message: "Report submission placeholder — not yet implemented" });
});

module.exports = router;
