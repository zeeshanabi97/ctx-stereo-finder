# Mars CTX Stereo Finder

An interactive tool for finding and evaluating Mars Context Camera (CTX) stereo pairs. This tool helps planetary scientists and students locate suitable image pairs for creating 3D terrain models of the Martian surface.

## Overview

The Mars CTX Stereo Finder allows you to:
- Search for CTX image pairs suitable for stereo reconstruction
- Define search regions by coordinates or drawing on an interactive map
- Filter results based on emission angle and other stereo parameters
- Export results for further processing in DEM generation software
- Visualize the coverage and overlap of potential stereo pairs

## Features

- Interactive map interface with Martian basemaps
- Drawing tools to define search regions
- Customizable search parameters:
  - Emission angle thresholds
  - Stereo angle difference ranges
  - Maximum number of footprints to process
- Automatic caching of CTX footprint data for faster subsequent searches
- Export capabilities for sharing and documentation
- Hover functionality to examine details of each stereo pair

## Installation and Running the Tool

### Prerequisites
- Python 3.6+

### Quick Start

1. Clone or download this repository
2. Make the installation script executable:
```bash
chmod +x install_run_ctx_stereo.sh
```
3. Run the installation script:
```bash
./install_run_ctx_stereo.sh
```

The script will:
- Check if Python 3 is installed and install it if necessary
- Create a virtual environment
- Install all required packages
- Launch a Jupyter notebook with the tool

### Manual Installation

If you prefer to install manually:

1. Create a virtual environment:
```bash
python3 -m venv ctx_stereo_env
source ctx_stereo_env/bin/activate  # On Windows: ctx_stereo_env\Scripts\activate
```

2. Install the required packages:
```bash
pip install geopandas shapely ipyleaflet ipywidgets numpy pandas jupyter
```

3. Run Jupyter Notebook:
```bash
jupyter notebook
```

4. Open the provided notebook or create a new one and run:
```python
%run ctx_stereo_finder.py
stereo_finder = CTXStereoFinder()
```

## Usage Guide

1. **Define Search Region**:
   - Enter coordinates and box size, or
   - Draw a region directly on the map

2. **Load CTX Data**:
   - Click "Load CTX Data" to retrieve the CTX footprint database
   - First-time downloads may take several minutes

3. **Configure Parameters**:
   - Set minimum emission angle for stereo pairs
   - Define acceptable stereo angle difference range
   - Set maximum footprints to process (affects search speed)

4. **Search for Stereo Pairs**:
   - Click "Search Stereo Pairs" to find matching image pairs
   - Results will be displayed in the map and as a table

5. **Export Results**:
   - Click "Export Results" to save findings as GeoJSON and CSV files

## Tips for Finding Good Stereo Pairs

- Ideal stereo angle differences are typically between 15-25°
- Larger overlap areas (>100 km²) provide better stereo reconstruction
- Consider the emission angle of both images; values under 10° for at least one image typically yield better results
- Filter results by overlap area for the most promising candidates

## Credits and Acknowledgments

- Original Mars CTX Stereo Tool by [Andrew Annex](https://github.com/AndrewAnnex/mars_ctx_stereo_tool)
- Modified and enhanced by [Syed Zeeshan Abid](https://github.com/zeeshanabi97)
- Uses data provided by NASA, USGS, and ASU
- Basemaps courtesy of USGS/ESRI/NASA and CalTech/USGS/MSSS/NASA


## Troubleshooting

**Common Issues:**

1. **Data Download Errors**:
   - If downloading CTX data fails, check your internet connection
   - Try using the cached data option if available

2. **No Stereo Pairs Found**:
   - Try increasing the search area
   - Adjust the emission angle threshold
   - Modify the angle difference parameters

3. **Performance Issues**:
   - Reduce the "Max Footprints" value for faster processing
   - Use the cached data option when available
   - Try searching smaller regions if the tool becomes unresponsive

For additional help, please open an issue on the GitHub repository or contact the maintainer.
