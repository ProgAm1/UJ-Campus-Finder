# Project Setup Guide

## Required Tools

Install these before starting:

| Tool | Version | Download |
|------|---------|----------|
| Node.js | v18+ (LTS) | https://nodejs.org |
| MySQL | v8.0+ | https://dev.mysql.com/downloads/mysql/ |
| Git | Latest | https://git-scm.com |

> Optional but recommended: use **VS Code** as your editor.

---

## Installation Steps

### 1. Clone the repository

```bash
git clone <repo-url>
cd lost-and-found-project
```

### 2. Install npm dependencies

```bash
npm install
```

This reads `package.json` and installs all required packages:
- `express` — web server framework
- `mysql2` — MySQL database driver
- `cors` — Cross-Origin Resource Sharing
- `dotenv` — environment variable loader
- `multer` — file uploads handler
- `nodemon` *(dev only)* — auto-restarts server on file changes

### 3. Set up environment variables

Copy the example file and fill in your local values:

```bash
cp .env.example .env
```

Then open `.env` and update:

```
PORT=5000

DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=lost_found_db
```

### 4. Set up the database

Open MySQL and run the schema file:

```bash
mysql -u root -p < database/schema.sql
```

Or open `database/schema.sql` in MySQL Workbench and execute it.

### 5. Start the server

For development (auto-restart on changes):

```bash
npm run dev
```

For production:

```bash
npm start
```

The server will run at `http://localhost:5000`.

---

## Project Structure

```
lost-and-found-project/
├── backend/
│   ├── server.js       # Entry point
│   ├── db.js           # Database connection
│   └── routes/
│       ├── reports.js
│       ├── claims.js
│       └── contact.js
├── css/
├── html/
├── js/
├── database/
│   └── schema.sql      # Run this to create the DB
├── media/
│   └── uploads/        # Uploaded images go here
├── .env.example        # Copy this to .env
└── package.json        # All npm dependencies listed here
```

---

## Common Issues

**`Error: Cannot connect to database`**
- Make sure MySQL is running
- Check your `.env` credentials match your local MySQL setup

**`Port already in use`**
- Change `PORT` in your `.env` file to another value (e.g. 3000)

**`node_modules not found`**
- Run `npm install` first
