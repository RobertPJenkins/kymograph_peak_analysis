function [motility,...
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
          threshold_peak_extrema_time,...
          extrema_time_threshold,...
          extrema_x_threshold] = ...
          single_cell_protrusion_analysis(output_directory,...
                                          file_input,...
                                          cell_name,...
                                          threshold,...
                                          pixel_scale,...
                                          time_scale,...
                                          y_limit)


% SINGLE_CELL_PROTRUSION_ANALYSIS finds the peaks and troughs of a single 
% input cell and analyses the output data based 
% on wavelength and amplitude of resulting peaks.
%
% [motility,crossings,var_protrusion_x,total_distance,gradient_protrusion,
% wavelength_derivative,amplitude_derivative,signal_statistic,protrusion_x,
% peak_time,peak_x,trough_time,trough_x,threshold_trough_extrema_time,
% threshold_peak_extrema_time,extrema_time_threshold,extrema_x_threshold] 
% = single_cell_protrusion_analysis(output_directory,file_input,cell_name,
% threshold,pixel_scale,time_scale,y_limit) reads in the input data and 
% rescales accordingly. It finds the peaks and troughs by calling 
% standard_extrema_function and threshold_extrema_function. Output data is
% analysed by calling motility_function, crossing_function, generating 
% statistics based on wavelength and amplitude of resulting thresholded 
% peaks alongside a small number of additional statistics including 
% total_distance covered by the protrusions and the gradient of protrusions
% over time. It records wavelength and amplitude derivatives and generates 
% figures of signal with peaks (red) and troughs (green) overlaid for both 
% standard peak detection and thresholded peak detection.
%
%   Input:
%   output_directory: Directory to save output data and figures.
%   file_input: File address for data to be input
%   max_flag: Identify whether to search for maximum (peak) or minimum
%   (trough)
%   cell_name: Name of input file
%   threshold: Threshold value for amplitude to define peaks and troughs
%   pixel_scale: Spatial scaling applied to input data
%   time_scale: Temporal scaling applied to input data
%   y_limit: Maximum y-value for plots on y-axis (i.e. maximum protrusion
%   distance to present).
%
%
%   Output:
%   motility: A structure array containing speed_mean, speed_median,
%   speed_std (standard deviation). acceleration_mean, acceleration_median
%   and acceleration_std.
%   crossings: Number of crossings
%   var_protrusion_x: variance in protusion distance.
%   total_distance: total distance moved by protusion
%   gradient_protrusion: time dependent gradient of line of best fit
%   wavelength_derivative: Derivative of wavelengths over time
%   amplitude_derivative: Derivative of wamplitudes over time
%   signal_statistic: Structure array of 
%   protrusion_x: Vector of cell displacements
%   peak_time: Time of each recorded peak
%   peak_x: Displacement of each peak
%   trough_time: Time of each recorded trough
%   trough_x: Displacement of each trough
%   threshold_trough_extrema_time: Time of each recorded thresholded trough
%   threshold_peak_extrema_time: Time of each recorded thresholded peak
%
%
%   Class support for input threshold, pixel_scale, time_scale, y_limit:
%      single, double
%   Class support for input output_directory, file_input, cell_name:
%      str
%
%   This work is licensed under a Creative Commons Attribution 4.0 
%   International License.


num=readmatrix(file_input);
protrusion_x=pixel_scale*num(:,1);
time=time_scale*num(:,2);
time=time-min(time);
index=find(diff(time)==0);
time(index)=[];
protrusion_x(index)=[];
protrusion_x=protrusion_x-min(protrusion_x);


motility = motility_function(time,protrusion_x);
[crossings,var_protrusion_x] = crossing_function(time,protrusion_x);
total_distance=trapz(time,protrusion_x);
mdl=fitlm(time,protrusion_x);
mdl.Coefficients;
coeffs=table2array(mdl.Coefficients);
gradient_protrusion=coeffs(2,1);
[trough_time,trough_x,peak_time,peak_x,extrema_time,extrema_x] = ...
standard_extrema_function(time,protrusion_x,0);
[threshold_trough_extrema_time,...
threshold_peak_extrema_time...
extrema_time_threshold,...
extrema_x_threshold] = threshold_extrema_function(...
                                                  time,...
                                                  protrusion_x,...
                                                  threshold...
                                                  );
    wavelength_derivative_threshold=diff(time(extrema_time_threshold));
    amplitude_derivative_threshold=abs(diff(protrusion_x(extrema_time_threshold)));
    signal_statistic.wavelength_mean_threshold=2*mean(wavelength_derivative_threshold);
    signal_statistic.wavelength_median_threshold=2*median(wavelength_derivative_threshold);
    signal_statistic.wavelength_var_threshold=var(2*wavelength_derivative_threshold);
    signal_statistic.wavelength_iqr_threshold=prctile(wavelength_derivative_threshold,75)-prctile(wavelength_derivative_threshold,25);
    signal_statistic.amplitude_mean_threshold=mean(amplitude_derivative_threshold);
    signal_statistic.amplitude_median_threshold=median(amplitude_derivative_threshold);
    signal_statistic.amplitude_var_threshold=var(amplitude_derivative_threshold);
    signal_statistic.amplitude_iqr_threshold=prctile(amplitude_derivative_threshold,75)-prctile(amplitude_derivative_threshold,25);
    signal_statistic.no_events_threshold=length(extrema_time_threshold)-1;
    signal_statistic.amplitude_wavelength_ratio_mean_threshold = mean(amplitude_derivative_threshold./(2*wavelength_derivative_threshold));
    signal_statistic.amplitude_wavelength_ratio_median_threshold = median(amplitude_derivative_threshold./(2*wavelength_derivative_threshold));
    signal_statistic.amplitude_wavelength_ratio_std_threshold = std(amplitude_derivative_threshold./(2*wavelength_derivative_threshold));
    signal_statistic.oscillation_proportion_threshold = (time(extrema_time_threshold(end))-time(extrema_time_threshold(1)))/time(end);

    wavelength_derivative_standard=diff(extrema_time);
    amplitude_derivative_standard=abs(diff(extrema_x));
    signal_statistic.wavelength_mean_standard=2*mean(wavelength_derivative_standard);
    signal_statistic.wavelength_median_standard=2*median(wavelength_derivative_standard);
    signal_statistic.wavelength_var_standard=var(2*wavelength_derivative_standard);
    signal_statistic.wavelength_iqr_standard=prctile(wavelength_derivative_standard,75)-prctile(wavelength_derivative_standard,25);
    signal_statistic.amplitude_mean_standard=mean(amplitude_derivative_standard);
    signal_statistic.amplitude_median_standard=median(amplitude_derivative_standard);
    signal_statistic.amplitude_var_standard=var(amplitude_derivative_standard);
    signal_statistic.amplitude_iqr_standard=prctile(amplitude_derivative_standard,75)-prctile(amplitude_derivative_standard,25);
    signal_statistic.no_events_standard=length(extrema_time)-1;
    signal_statistic.amplitude_wavelength_ratio_mean_standard = mean(amplitude_derivative_standard./(2*wavelength_derivative_standard));
    signal_statistic.amplitude_wavelength_ratio_median_standard = median(amplitude_derivative_standard./(2*wavelength_derivative_standard));
    signal_statistic.amplitude_wavelength_ratio_std_standard = std(amplitude_derivative_standard./(2*wavelength_derivative_standard));
    signal_statistic.oscillation_proportion_standard = (extrema_time(end)-extrema_time(1))/time(end);

h=figure;
plot(time,protrusion_x,'k','LineWidth',2);
hold on   
plot(peak_time,peak_x,'ro','LineWidth',4);
plot(trough_time,trough_x,'go','LineWidth',4);
ylim([0,y_limit]);
set(gca,'LineWidth',4.5);
set(gca,'FontSize',20);
xlabel('Time (s)','fontsize',24,'fontweight','b');
ylabel('Distance (microns)','fontsize',24,'fontweight','b');
output_image =  [cell_name '_all_peaks_trough_x_plot.tif'];
outputname=fullfile(output_directory, output_image);
print(h,outputname, '-dtiff'); 
close(h);

h=figure;
plot(time,protrusion_x,'k','LineWidth',2);
hold on   
plot(time(threshold_peak_extrema_time),protrusion_x(threshold_peak_extrema_time),'ro','LineWidth',4);
plot(time(threshold_trough_extrema_time),protrusion_x(threshold_trough_extrema_time),'go','LineWidth',4);
ylim([0,y_limit]);
set(gca,'LineWidth',4.5);
set(gca,'FontSize',20);
xlabel('Time (s)','fontsize',24,'fontweight','b');
ylabel('Distance (microns)','fontsize',24,'fontweight','b');
output_image =  [cell_name '_threshold_peaks_trough_x_plot.tif'];
outputname=fullfile(output_directory, output_image);
print(h,outputname, '-dtiff'); 
close(h);

end



  