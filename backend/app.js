// Express application — imported by server.js (to start) and by tests (without listening).

const express = require("express");
const path    = require("path");
const cors    = require("cors");
const db      = require("./db");
require("dotenv").config();

const app  = express();
const ROOT = path.join(__dirname, "..");

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(cors());

// Static assets — only safe public folders are exposed
app.use(express.static(path.join(ROOT, "html")));
app.use("/html",  express.static(path.join(ROOT, "html")));
app.use("/css",   express.static(path.join(ROOT, "css")));
app.use("/js",    express.static(path.join(ROOT, "js")));
app.use("/media", express.static(path.join(ROOT, "media")));

// Home page served at both / and /index.html
const indexFile = path.join(ROOT, "index.html");
app.get("/",          (_req, res) => res.sendFile(indexFile));
app.get("/index.html", (_req, res) => res.sendFile(indexFile));

// API routes
app.use("/api/reports", require("./routes/reports"));
app.use("/api/contact", require("./routes/contact"));
app.use("/api/claims",  require("./routes/claims"));

// Simple API liveness check — confirms the Express server is responding.
app.get("/api/test", (_req, res) =>
    res.json({ success: true, message: "API is working" })
);

// Health check — confirms both the server AND the database connection.
// Returns 200 when the DB answers a trivial query, 503 otherwise.
// The app never crashes here: a DB outage is reported, not thrown.
app.get("/api/health", async (_req, res) => {
    try {
        await db.query("SELECT 1");
        res.json({ success: true, server: "up", database: "up" });
    } catch (err) {
        console.error("GET /api/health DB error:", err.message);
        res.status(503).json({ success: false, server: "up", database: "down" });
    }
});

// 404 handler for any unknown route — returns JSON for /api/*, a short message otherwise.
app.use((req, res) => {
    if (req.path.startsWith("/api/")) {
        return res.status(404).json({ success: false, message: "Not found" });
    }
    res.status(404).send("404 — Page not found");
});

module.exports = app;
