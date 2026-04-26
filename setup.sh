#!/usr/bin/env bash
# UJ Campus Finder - Mac/Linux Setup Script
# Run: bash setup.sh

set -e

echo ""
echo "========================================"
echo "  UJ Campus Finder - Project Setup"
echo "========================================"
echo ""

# 1. Check Node.js
echo "[1/5] Checking Node.js..."
if ! command -v node &>/dev/null; then
    echo "  ERROR: Node.js is not installed."
    echo "  Download it from https://nodejs.org (LTS version recommended)"
    exit 1
fi
NODE_VERSION=$(node --version)
echo "  OK - Node.js $NODE_VERSION found"

# 2. Check npm
echo "[2/5] Checking npm..."
if ! command -v npm &>/dev/null; then
    echo "  ERROR: npm is not installed. It should come with Node.js."
    exit 1
fi
NPM_VERSION=$(npm --version)
echo "  OK - npm $NPM_VERSION found"

# 3. Install dependencies
echo "[3/5] Installing npm dependencies..."
npm install
echo "  OK - Dependencies installed"

# 4. Create .env from .env.example
echo "[4/5] Setting up environment file..."
if [ -f ".env" ]; then
    echo "  SKIP - .env already exists (not overwritten)"
elif [ -f ".env.example" ]; then
    cp .env.example .env
    echo "  OK - .env created from .env.example"
    echo "  ACTION REQUIRED: Open .env and set your DB_PASSWORD"
else
    echo "  WARNING: .env.example not found. Create .env manually."
fi

# 5. Ensure media/uploads directory and .gitkeep exist
echo "[5/5] Ensuring media/uploads directory exists..."
mkdir -p media/uploads
echo "  OK - media/uploads/ ready"
if [ ! -f "media/uploads/.gitkeep" ]; then
    touch media/uploads/.gitkeep
    echo "  OK - Created media/uploads/.gitkeep"
fi

# 6. Optional: run database schema
echo ""
echo "[Optional] Checking for MySQL..."
if command -v mysql &>/dev/null; then
    echo "  MySQL found."
    printf "  Run database/schema.sql now? You will be prompted for your MySQL password. (y/n): "
    read -r ANSWER
    if [ "$ANSWER" = "y" ] || [ "$ANSWER" = "Y" ]; then
        echo "  Running schema.sql..."
        mysql -u root -p < database/schema.sql
        echo "  OK - Database schema imported"
    else
        echo "  Skipped. Run manually when ready: mysql -u root -p < database/schema.sql"
    fi
else
    echo "  MySQL CLI not found in PATH."
    echo "  Import the schema manually:"
    echo "    Option A: mysql -u root -p < database/schema.sql"
    echo "    Option B: Open database/schema.sql in MySQL Workbench and execute it"
fi

# Done
echo ""
echo "========================================"
echo "  Setup complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "  1. Open .env and fill in your DB_PASSWORD if not done yet"
echo "  2. Make sure MySQL is running"
echo "  3. Run: npm run dev"
echo ""
