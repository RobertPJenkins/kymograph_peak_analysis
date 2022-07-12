# kymograph_peak_analysis

MATLAB code to extract features describing kymographs generated in the Tumour Cell Biology lab. Features primarily describe amplitude and wavelength of extracted peaks. Peak extraction occurs using either MATLAB's findpeaks function or a bespoke peak finder based on a threshold amplitude.

## Usage
Each kymograph should be stored as a separate .txt file in a single folder with the first column being spatial coordinates of the leading edge of the cell and the second column being time. 

The script simple_protrusion_script is all that is needed to run all the functions.

input_directory : directory where .txt files are located
output_directory : directory where output should be saved
time_scale: factor to multiply time by to transform to seconds 
pixel_scale: factor to multiply spatial coordinates by to transform to microns
threshold: minimum distance between peak and trough used to define where extrema are in bespoke peak finding code
y_limit: Maximum y-coordinate in microns to plot output kymographs
input_file_type: .txt file. No other file type has been tested for input values
compiled_matlab_data_name: Name of output MATLAB file
compiled_csv_data_name: Name of output csv file

Functionality has been tested on Windows only.


## Contributing

In the first instance please contact robert.jenkins@crick.ac.uk with coding errors or suggestions on making the code better or more suitable to your work.

## Author

Robert P Jenkins (robert.jenkins@crick.ac.uk)
