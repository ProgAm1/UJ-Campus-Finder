const express = require("express");
const path = require("path");
const cors = require("cors");
require("dotenv").config();

const app = express();
const PORT = process.env.PORT || 5000;

// 1) Static routing
app.use(express.static(path.join(__dirname, "..", "html")));
app.use("/css", express.static(path.join(__dirname, "..", "css")));
app.use("/js", express.static(path.join(__dirname, "..", "js")));
app.use("/media", express.static(path.join(__dirname, "..", "media")));

// 2) Middleware to parse form and JSON data
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(cors());

// 3) Simple root route
app.get("/", (req, res) => {
    res.sendFile(path.join(__dirname, "..", "html", "index.html"));
});

// 4) Test route
app.get("/api/test", (req, res) => {
    res.json({ message: "Server is running successfully" });
});

// 5) Start server
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});