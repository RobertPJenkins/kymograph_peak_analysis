function multiple_cell_protrusion_analysis(input_directory,...
                                           output_directory,...
                                           input_file_type,...
                                           compiled_matlab_data_name,...
                                           compiled_csv_data_name,...
                                           time_scale,...
                                           pixel_scale,...
                                           threshold,...
                                           y_limit)
% MULTIPLE_CELL_PROTRUSION_ANALYSIS runs peak and trough analysis for 
% multiple input cell  and records compiled output.
%
% multiple_cell_protrusion_analysis(input_directory,output_directory,
% input_file_type, compiled_matlab_data_name, compiled_csv_data_name,
% time_scale, pixel_scale, threshold, y_limit) runs the 
% single_cell_protrusion_analysis function for each cell and  compiles the 
% output for all cells. data is saved in a .mat file and a .csv file.  
%
%   Input:
%   input_directory: directory for input data.
%   output_directory: Directory to save output data and figures.
%   input_file_type: File type to be input e.g. .txt
%   compiled_matlab_data_name: Name of output compiled data .mat file
%   compiled_csv_data_name: Name of output compiled data .csv file
%   pixel_scale: Spatial scaling applied to input data
%   time_scale: Temporal scaling applied to input data
%   threshold: Threshold value for amplitude to define peaks and troughs
%   y_limit: Maximum y-value for plots on y-axis (i.e. maximum protrusion
%   distance to present).
%   threshold_analysis_flag: set to one if analysing pthresholded peaks and
%   troughs and zero otherwise.
%
%
%   Class support for input threshold, pixel_scale, time_scale, y_limit:
%      single, double
%   Class support for input_directory, output_directory, input_file_type,
%   compiled_matlab_data_name, compiled_csv_data_name:
%      str
%
%   This work is licensed under a Creative Commons Attribution 4.0 
%   International License.

if input_file_type(1)~='.'
     input_file_type=['.',input_file_type];
end

if ~exist(output_directory, 'dir')
   mkdir(output_directory);
end

file_names=[input_directory '*' input_file_type];
files=dir(file_names);
all_data_matlab_file = fullfile(output_directory, compiled_matlab_data_name);
all_data_csv_file = fullfile(output_directory, compiled_csv_data_name);

WAVELENGTH_DERIVATIVE_THRESHOLD=[];
AMPLITUDE_DERIVATIVE_THRESHOLD=[];
WAVELENGTH_DERIVATIVE_STANDARD=[];
AMPLITUDE_DERIVATIVE_STANDARD=[];

variable_names={'cell_name',...
                'speed_mean',...
                'speed_median',...
                'speed_std',...
                'acceleration_mean',...
                'acceleration_median',...
                'acceleration_std',...
                'crossings',...
                'var_protrusion_x',...
                'total_distance',...
                'gradient_protrusion',...
                'no_events_threshold',...
                'wavelength_mean_threshold',...
                'wavelength_median_threshold',...
                'wavelength_var_threshold',...
                'wavelength_iqr_threshold',...
                'amplitude_mean_threshold',...
                'amplitude_median_threshold',...
                'amplitude_var_threshold',...
                'amplitude_iqr_threshold',...
                'amplitude_wavelength_ratio_mean_threshold',...
                'amplitude_wavelength_ratio_median_threshold',...
                'amplitude_wavelength_ratio_std_threshold',...
                'oscillation_proportion_threshold',...
                'no_events_standard',...
                'wavelength_mean_standard',...
                'wavelength_median_standard',...
                'wavelength_var_standard',...
                'wavelength_iqr_standard',...
                'amplitude_mean_standard',...
                'amplitude_median_standard',...
                'amplitude_var_standard',...
                'amplitude_iqr_standard',...
                'amplitude_wavelength_ratio_mean_standard',...
                'amplitude_wavelength_ratio_median_standard',...
                'amplitude_wavelength_ratio_std_standard',...
                'oscillation_proportion_standard'...
                };

for I=1:length(files);
    
    file_input=fullfile(input_directory, files(I).name);
    cell_name = files(I).name(1:end-4)
    matdata_name =  [cell_name '.mat'];
    matlab_name=fullfile(output_directory, matdata_name);
    
    [motility,...
        crossings,...
        var_protrusion_x,...
        total_distance,...
        gradient_protrusion,...
        wavelength_derivative_threshold,...
        amplitude_derivative_threshold,...
        wavelength_derivative_standard,...
        amplitude_derivative_standard,...
        signal_statistic,...
        protrusion_x,...
        peak_time,...
        peak_x,...
        trough_time,...
        trough_x,...
        threshold_trough_extrema_time,...
        threshold_peak_extrema_time...
        extrema_time_threshold,...
        extrema_x_threshold] = single_cell_protrusion_analysis(output_directory,...
                                                           file_input,...
                                                           cell_name,...
                                                           threshold,...
                                                           pixel_scale,...
                                                           time_scale,...
                                                           y_limit);

    save(matlab_name);

    WAVELENGTH_DERIVATIVE_THRESHOLD=[WAVELENGTH_DERIVATIVE_THRESHOLD;wavelength_derivative_threshold];
    AMPLITUDE_DERIVATIVE_THRESHOLD=[AMPLITUDE_DERIVATIVE_THRESHOLD;amplitude_derivative_threshold];
    WAVELENGTH_DERIVATIVE_STANDARD=[WAVELENGTH_DERIVATIVE_STANDARD;wavelength_derivative_standard];
    AMPLITUDE_DERIVATIVE_STANDARD=[AMPLITUDE_DERIVATIVE_STANDARD;amplitude_derivative_standard];

    output_stats = [motility.speed_mean,...
                    motility.speed_median,...
                    motility.speed_std,...
                    motility.acceleration_mean,...
                    motility.acceleration_median,...
                    motility.acceleration_std,...
                    crossings,...
                    var_protrusion_x,...
                    total_distance,...
                    gradient_protrusion,...
                    signal_statistic.no_events_threshold,...
                    signal_statistic.wavelength_mean_threshold,...
                    signal_statistic.wavelength_median_threshold,...
                    signal_statistic.wavelength_var_threshold,...
                    signal_statistic.wavelength_iqr_threshold,...
                    signal_statistic.amplitude_mean_threshold,...
                    signal_statistic.amplitude_median_threshold,...
                    signal_statistic.amplitude_var_threshold,...
                    signal_statistic.amplitude_iqr_threshold,...
                    signal_statistic.amplitude_wavelength_ratio_mean_threshold,...
                    signal_statistic.amplitude_wavelength_ratio_median_threshold,...
                    signal_statistic.amplitude_wavelength_ratio_std_threshold,...
                    signal_statistic.oscillation_proportion_threshold,...
                    signal_statistic.no_events_standard,...
                    signal_statistic.wavelength_mean_standard,...
                    signal_statistic.wavelength_median_standard,...
                    signal_statistic.wavelength_var_standard,...
                    signal_statistic.wavelength_iqr_standard,...
                    signal_statistic.amplitude_mean_standard,...
                    signal_statistic.amplitude_median_standard,...
                    signal_statistic.amplitude_var_standard,...
                    signal_statistic.amplitude_iqr_standard,...
                    signal_statistic.amplitude_wavelength_ratio_mean_standard,...
                    signal_statistic.amplitude_wavelength_ratio_median_standard,...
                    signal_statistic.amplitude_wavelength_ratio_std_standard,...
                    signal_statistic.oscillation_proportion_standard...
                    ];

   
  
    row_T=array2table(output_stats);
    row_T=[cell2table({cell_name}) row_T];

    row_T =  renamevars(row_T,row_T.Properties.VariableNames,variable_names);
 

    if I==1
        compiled_data_table = row_T;
    else
        compiled_data_table = [compiled_data_table; row_T];
    end

end
save(all_data_matlab_file)
writetable(compiled_data_table,all_data_csv_file)

end