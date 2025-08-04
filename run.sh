#!/bin/bash
# LDaCA Ecosystem Startup Script
# This script sets up and runs the complete LDaCA stack:
# 1. docframe (document analysis library)
# 2. docworkspace (workspace management library) 
# 3. ldaca_web_app (full-stack web application)

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[LDaCA]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[LDaCA]${NC} ✅ $1"
}

print_warning() {
    echo -e "${YELLOW}[LDaCA]${NC} ⚠️  $1"
}

print_error() {
    echo -e "${RED}[LDaCA]${NC} ❌ $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if port is in use
port_in_use() {
    lsof -i :$1 >/dev/null 2>&1
}

# Function to cleanup background processes on exit
cleanup() {
    print_status "Cleaning up background processes..."
    if [ ! -z "$BACKEND_PID" ]; then
        kill $BACKEND_PID 2>/dev/null || true
    fi
    if [ ! -z "$FRONTEND_PID" ]; then
        kill $FRONTEND_PID 2>/dev/null || true
    fi
    print_success "Cleanup complete"
}

# Set up cleanup on script exit
trap cleanup EXIT INT TERM

# Check prerequisites
print_status "Checking prerequisites..."

# Initialize submodules if needed
print_status "Checking git submodules..."
if [ ! -f "docframe/pyproject.toml" ] || [ ! -f "docworkspace/pyproject.toml" ] || [ ! -f "ldaca_web_app/backend/main.py" ]; then
    print_status "Initializing git submodules..."
    git submodule update --init --recursive
    print_success "Git submodules initialized"
else
    print_success "Git submodules already initialized"
fi

if ! command_exists uv; then
    print_error "uv is not installed. Please install it first:"
    print_error "curl -LsSf https://astral.sh/uv/install.sh | sh"
    exit 1
fi

if ! command_exists node; then
    print_error "Node.js is not installed. Please install it first."
    exit 1
fi

if ! command_exists npm; then
    print_error "npm is not installed. Please install it first."
    exit 1
fi

print_success "Prerequisites check passed"

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
DOCFRAME_DIR="$SCRIPT_DIR/docframe"
DOCWORKSPACE_DIR="$SCRIPT_DIR/docworkspace"
WEB_APP_DIR="$SCRIPT_DIR/ldaca_web_app"
BACKEND_DIR="$WEB_APP_DIR/backend"
FRONTEND_DIR="$WEB_APP_DIR/frontend"

# Step 1: Install all workspace dependencies using uv workspace
print_status "Installing LDaCA workspace dependencies..."
cd "$SCRIPT_DIR"
if [ -f "pyproject.toml" ]; then
    uv sync
    uv pip install -e docframe
    uv pip install -e docworkspace
    print_success "All workspace dependencies installed"
else
    print_error "No pyproject.toml found in root directory"
    exit 1
fi

# Step 2: Install frontend dependencies
print_status "Installing frontend dependencies..."
cd "$FRONTEND_DIR"
if [ -f "package.json" ]; then
    npm install
    print_success "Frontend dependencies installed"
else
    print_error "No package.json found in frontend directory"
    exit 1
fi

# Step 3: Check if ports are available
print_status "Checking port availability..."
if port_in_use 8001; then
    print_warning "Port 8001 (backend) is already in use"
    read -p "Do you want to continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

if port_in_use 3000; then
    print_warning "Port 3000 (frontend) is already in use"
    read -p "Do you want to continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Step 4: Check environment configuration
print_status "Checking backend environment configuration..."

# Check if .env exists, if not prompt to copy from .env.example
if [ ! -f "$BACKEND_DIR/.env" ]; then
    if [ -f "$BACKEND_DIR/.env.example" ]; then
        print_warning ".env file not found in backend directory"
        echo -e "${YELLOW}A .env.example file is available with default configuration.${NC}"
        read -p "Would you like to copy .env.example to .env? (Y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            print_error "Backend requires .env file to run. Please create one manually."
            exit 1
        else
            cp "$BACKEND_DIR/.env.example" "$BACKEND_DIR/.env"
            print_success ".env file created from .env.example"
            print_status "You may want to review and modify $BACKEND_DIR/.env for your environment"
        fi
    else
        print_error "No .env or .env.example file found in backend directory"
        print_error "Backend requires environment configuration to run"
        exit 1
    fi
else
    print_success "Environment configuration found"
fi

# Step 5: Start the backend server
print_status "Starting backend server on port 8001..."

# Check if main.py exists
if [ ! -f "$BACKEND_DIR/main.py" ]; then
    print_error "main.py not found in backend directory"
    exit 1
fi

# Start backend in background using the project's virtual environment
cd "$BACKEND_DIR"
uv run --package ldaca-backend fastapi dev main.py --port 8001 > backend.log 2>&1 &
BACKEND_PID=$!

# Wait a moment for backend to start
sleep 3

# Check if backend is running
if kill -0 $BACKEND_PID 2>/dev/null; then
    print_success "Backend server started (PID: $BACKEND_PID)"
    print_status "Backend logs: $BACKEND_DIR/backend.log"
else
    print_error "Failed to start backend server"
    exit 1
fi

# Step 6: Start the frontend development server
print_status "Starting frontend development server on port 3000..."
cd "$FRONTEND_DIR"

# Start frontend in background
npm start > "$FRONTEND_DIR/frontend.log" 2>&1 &
FRONTEND_PID=$!

# Wait a moment for frontend to start
sleep 5

# Check if frontend is running
if kill -0 $FRONTEND_PID 2>/dev/null; then
    print_success "Frontend server started (PID: $FRONTEND_PID)"
    print_status "Frontend logs: $FRONTEND_DIR/frontend.log"
else
    print_error "Failed to start frontend server"
    exit 1
fi

# Step 7: Display status and URLs
echo
print_success "🚀 LDaCA ecosystem is now running!"
echo
echo -e "${BLUE}📊 Service Status:${NC}"
echo -e "   Backend:  ${GREEN}✅ Running${NC} on http://localhost:8001"
echo -e "   Frontend: ${GREEN}✅ Running${NC} on http://localhost:3000"
echo
echo -e "${BLUE}📝 Logs:${NC}"
echo -e "   Backend:  ${BACKEND_DIR}/backend.log"
echo -e "   Frontend: ${FRONTEND_DIR}/frontend.log"
echo
echo -e "${BLUE}🔗 Quick Links:${NC}"
echo -e "   Web App:    ${YELLOW}http://localhost:3000${NC}"
echo -e "   API Docs:   ${YELLOW}http://localhost:8001/docs${NC}"
echo -e "   Health:     ${YELLOW}http://localhost:8001/health${NC}"
echo
echo -e "${BLUE}⌨️  Commands:${NC}"
echo -e "   View backend logs:  ${YELLOW}tail -f $BACKEND_DIR/backend.log${NC}"
echo -e "   View frontend logs: ${YELLOW}tail -f $FRONTEND_DIR/frontend.log${NC}"
echo -e "   Stop services:      ${YELLOW}Ctrl+C${NC}"
echo

# Step 8: Wait for user to stop
print_status "Press Ctrl+C to stop all services..."

# Keep script running and monitor processes
while true; do
    # Check if backend is still running
    if ! kill -0 $BACKEND_PID 2>/dev/null; then
        print_error "Backend process has stopped unexpectedly"
        break
    fi
    
    # Check if frontend is still running
    if ! kill -0 $FRONTEND_PID 2>/dev/null; then
        print_error "Frontend process has stopped unexpectedly"
        break
    fi
    
    sleep 5
done
