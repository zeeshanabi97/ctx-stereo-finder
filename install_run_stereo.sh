#!/bin/bash

echo "======================================="
echo "CTX Stereo Finder - Installation Setup"
echo "======================================="

# Function to prompt user for Y/N
confirm() {
    read -p "$1 [y/N]: " response
    case "$response" in
        [yY][eE][sS]|[yY]) return 0 ;;
        *) return 1 ;;
    esac
}

# --- Check Python Installation ---
PYTHON_CMD=""
if command -v python3 &>/dev/null; then
    echo "Python 3 is already installed."
    PYTHON_CMD="python3"
elif command -v python &>/dev/null && [ "$(python -c 'import sys; print(sys.version_info.major)')" -eq 3 ]; then
    echo "Python 3 is already installed."
    PYTHON_CMD="python"
else
    echo "Python 3 is not installed."
    if confirm "Do you want to install Python 3?"; then
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            if command -v apt-get &>/dev/null; then
                sudo apt-get update
                sudo apt-get install -y python3 python3-pip python3-venv
            elif command -v dnf &>/dev/null; then
                sudo dnf install -y python3 python3-pip
            elif command -v yum &>/dev/null; then
                sudo yum install -y python3 python3-pip
            else
                echo "Unsupported Linux distribution. Install Python 3 manually."
                exit 1
            fi
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            if command -v brew &>/dev/null; then
                brew install python3
            else
                echo "Homebrew not found. Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                brew install python3
            fi
        else
            echo "Unsupported OS. Please install Python 3 manually."
            exit 1
        fi
        PYTHON_CMD="python3"
    else
        echo "Python 3 is required. Exiting."
        exit 1
    fi
fi

# --- Create virtual environment ---
echo "Creating a virtual environment..."
$PYTHON_CMD -m venv ctx_stereo_env

# Activate virtual environment
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    source ctx_stereo_env/Scripts/activate
else
    source ctx_stereo_env/bin/activate
fi

# --- Check for dependencies ---
REQUIRED_PKGS=(geopandas shapely ipyleaflet ipywidgets numpy pandas jupyter)

echo "Checking required Python packages..."
for pkg in "${REQUIRED_PKGS[@]}"; do
    if ! pip show "$pkg" &>/dev/null; then
        echo "Missing: $pkg"
        MISSING_PKGS+=("$pkg")
    fi
done

if [ "${#MISSING_PKGS[@]}" -ne 0 ]; then
    echo "Some packages are missing: ${MISSING_PKGS[*]}"
    if confirm "Do you want to install them now?"; then
        pip install --upgrade pip
        pip install "${MISSING_PKGS[@]}"
    else
        echo "Cannot proceed without required packages. Exiting."
        exit 1
    fi
fi

# --- Check for ctx_stereo_finder.py ---
if [ ! -f "ctx_stereo_finder.py" ]; then
    echo "Error: ctx_stereo_finder.py not found in the current directory!"
    exit 1
fi

# --- Check for browser and install if needed ---
BROWSER=""
if command -v firefox &>/dev/null; then
    BROWSER="firefox"
elif command -v google-chrome &>/dev/null; then
    BROWSER="google-chrome"
elif command -v chromium-browser &>/dev/null; then
    BROWSER="chromium-browser"
else
    echo "No browser found."
    if confirm "Do you want to install Firefox?"; then
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            if command -v apt-get &>/dev/null; then
                sudo apt-get update
                sudo apt-get install -y firefox
                BROWSER="firefox"
            elif command -v dnf &>/dev/null; then
                sudo dnf install -y firefox
                BROWSER="firefox"
            elif command -v yum &>/dev/null; then
                sudo yum install -y firefox
                BROWSER="firefox"
            else
                echo "Unsupported Linux distribution. Please install a browser manually."
            fi
        else
            echo "Automatic browser installation not supported for this OS. Please install one manually."
        fi
    else
        echo "A browser is required to launch Jupyter. Exiting."
        exit 1
    fi
fi

# --- Convert and run in Jupyter ---
echo "======================================="
echo "Opening CTX Stereo Finder in Jupyter..."
echo "======================================="

# Convert script to notebook if not already converted
if [ ! -f "ctx_stereo_finder.ipynb" ]; then
    jupyter nbconvert --to notebook --execute --inplace ctx_stereo_finder.py --output ctx_stereo_finder.ipynb || \
    jupyter nbconvert --to notebook ctx_stereo_finder.py --output ctx_stereo_finder.ipynb
fi

# Launch Jupyter Notebook with specified browser
if [ -n "$BROWSER" ]; then
    jupyter notebook ctx_stereo_finder.ipynb --browser="$BROWSER"
else
    jupyter notebook ctx_stereo_finder.ipynb
fi
