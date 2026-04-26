# UJ Campus Finder - Windows Setup Script
# Run: powershell -ExecutionPolicy Bypass -File setup.ps1

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  UJ Campus Finder - Project Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Check Node.js
Write-Host "[1/5] Checking Node.js..." -ForegroundColor Yellow
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "  ERROR: Node.js is not installed." -ForegroundColor Red
    Write-Host "  Download it from https://nodejs.org (LTS version recommended)" -ForegroundColor Red
    exit 1
}
$nodeVersion = node --version
Write-Host "  OK - Node.js $nodeVersion found" -ForegroundColor Green

# 2. Check npm
Write-Host "[2/5] Checking npm..." -ForegroundColor Yellow
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "  ERROR: npm is not installed. It should come with Node.js." -ForegroundColor Red
    exit 1
}
$npmVersion = npm --version
Write-Host "  OK - npm $npmVersion found" -ForegroundColor Green

# 3. Install dependencies
Write-Host "[3/5] Installing npm dependencies..." -ForegroundColor Yellow
npm install
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ERROR: npm install failed. Check the output above." -ForegroundColor Red
    exit 1
}
Write-Host "  OK - Dependencies installed" -ForegroundColor Green

# 4. Create .env from .env.example
Write-Host "[4/5] Setting up environment file..." -ForegroundColor Yellow
if (Test-Path ".env") {
    Write-Host "  SKIP - .env already exists (not overwritten)" -ForegroundColor DarkYellow
}
elseif (Test-Path ".env.example") {
    Copy-Item ".env.example" ".env"
    Write-Host "  OK - .env created from .env.example" -ForegroundColor Green
    Write-Host "  ACTION REQUIRED: Open .env and set your DB_PASSWORD" -ForegroundColor Magenta
}
else {
    Write-Host "  WARNING: .env.example not found. Create .env manually." -ForegroundColor DarkYellow
}

# 5. Ensure media/uploads directory and .gitkeep exist
Write-Host "[5/5] Ensuring media/uploads directory exists..." -ForegroundColor Yellow
if (-not (Test-Path "media\uploads")) {
    New-Item -ItemType Directory -Path "media\uploads" | Out-Null
    Write-Host "  OK - Created media/uploads/" -ForegroundColor Green
}
else {
    Write-Host "  OK - media/uploads/ already exists" -ForegroundColor Green
}
if (-not (Test-Path "media\uploads\.gitkeep")) {
    New-Item -ItemType File -Path "media\uploads\.gitkeep" | Out-Null
    Write-Host "  OK - Created media/uploads/.gitkeep" -ForegroundColor Green
}

# 6. Optional: run database schema
Write-Host ""
Write-Host "[Optional] Checking for MySQL..." -ForegroundColor Yellow
if (Get-Command mysql -ErrorAction SilentlyContinue) {
    Write-Host "  MySQL found." -ForegroundColor Green
    $answer = Read-Host "  Run database/schema.sql now? You will be prompted for your MySQL password. (y/n)"
    if ($answer -eq "y" -or $answer -eq "Y") {
        Write-Host "  Running schema.sql..." -ForegroundColor Yellow
        cmd /c "mysql -u root -p < database\schema.sql"
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  OK - Database schema imported" -ForegroundColor Green
        }
        else {
            Write-Host "  WARNING: Schema import may have failed. Check the output above." -ForegroundColor DarkYellow
            Write-Host "  You can run it manually: mysql -u root -p < database/schema.sql" -ForegroundColor DarkYellow
        }
    }
    else {
        Write-Host "  Skipped. Run manually when ready: mysql -u root -p < database/schema.sql" -ForegroundColor DarkYellow
    }
}
else {
    Write-Host "  MySQL CLI not found in PATH." -ForegroundColor DarkYellow
    Write-Host "  Import the schema manually:" -ForegroundColor DarkYellow
    Write-Host "    Option A: mysql -u root -p < database/schema.sql" -ForegroundColor DarkYellow
    Write-Host "    Option B: Open database/schema.sql in MySQL Workbench and execute it" -ForegroundColor DarkYellow
}

# Done
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Setup complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor White
Write-Host "  1. Open .env and fill in your DB_PASSWORD if not done yet" -ForegroundColor White
Write-Host "  2. Make sure MySQL is running" -ForegroundColor White
Write-Host "  3. Run: npm run dev" -ForegroundColor White
Write-Host ""
