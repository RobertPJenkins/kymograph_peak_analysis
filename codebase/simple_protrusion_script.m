clear
input_directory = 'X:\working\Rob\David\kymograph_analysis\kymograph_data\dataset_1\input\';
output_directory = 'X:\working\Rob\David\kymograph_analysis\kymograph_data\dataset_1\output\';
time_scale=16;
pixel_scale=0.2;
threshold=0.25;
y_limit=6;
input_file_type= '.txt';

compiled_matlab_data_name = 'compiled_data.mat';
compiled_csv_data_name = 'compiled_data.csv';

multiple_cell_protrusion_analysis(input_directory,...
                                  output_directory,...
                                  input_file_type,...
                                  compiled_matlab_data_name,...
                                  compiled_csv_data_name,...
                                  time_scale,...
                                  pixel_scale,...
                                  threshold,...
                                  y_limit)


