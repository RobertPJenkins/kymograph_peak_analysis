function [trough_time,trough_x,peak_time,peak_x,extrema_time,extrema_x] ...
    = standard_extrema_function(time,protrusion_x,peakprom)
% STANDARD_EXTREMA_FUNCTION uses MATLAB's findpeaks function and 
% records peaks and troughs in separate vectors.
%
%   [trough_time,trough_x,peak_time,peak_x] = ...
%    standard_extrema_function(time,protrusion_x,peakprom)
%   finds the peaks and troughs using MATLAB's inbuilt findpeaks function,
%   identifies each extrema as a peak or trough and pads data such that 
%   the first and final points are recorded as peak or trough.
%   Input:
%   time: Vector of time points
%   protrusion_x: Vector of cell displacements
%   peakprom: return only those peaks that have a relative importance of 
%   at least 'peakprom'. See findpeaks documentation for more information.
%   Output:
%   trough_time: Time of each recorded trough
%   trough_x: Displacement of each trough
%   peak_time: Time of each recorded peak
%   peak_x: Displacement of each peak
%   extrema_time: Time of each recorded extrema
%   extrema_x: Displacement of each extrema
%
%   Class support for input time, protrusion_x, peakprom: single, double
%   
%
%   This work is licensed under a Creative Commons Attribution 4.0 
%   International License.

%peakprom=0.0;
[peak_x,peak_time] = findpeaks(protrusion_x,...
                               time,...
                               'MinPeakProminence',...
                               peakprom...
                               );
[trough_x,trough_time] = findpeaks(max(protrusion_x)-protrusion_x,...
                                   time,...
                                   'MinPeakProminence',...
                                   peakprom...
                                   );
trough_x=max(protrusion_x)-trough_x;
if length(trough_time)>0 && length(peak_time)>0
    
    if peak_time(1)<trough_time(1)
        trough_time=[0;trough_time];
        trough_x=[protrusion_x(1);trough_x];
    elseif trough_time(1)<=peak_time(1)
        peak_time=[0;peak_time];
        peak_x=[protrusion_x(1);peak_x];
    end
    
    if peak_time(end)>trough_time(end)
        trough_time=[trough_time;time(end)];
        trough_x=[trough_x;protrusion_x(end)];
    elseif trough_time(end)>=peak_time(end)
        peak_time=[peak_time;time(end)];
        peak_x=[peak_x;protrusion_x(end)];
    end

elseif length(trough_time)==0 && length(peak_time)>0

    trough_time=[0;trough_time];
    trough_x=[protrusion_x(1);trough_x];
    trough_time=[trough_time;time(end)];
    trough_x=[trough_x;protrusion_x(end)];

elseif length(peak_time)==0 && length(trough_time)>0

    peak_time=[0;peak_time];
    peak_x=[protrusion_x(1);peak_x];
    peak_time=[peak_time;time(end)];
    peak_x=[peak_x;protrusion_x(end)];

end

extrema_time=[peak_time;trough_time];
extrema_x=[peak_x;trough_x];
[extrema_time,sorted_time] = sort(extrema_time);
extrema_x=extrema_x(sorted_time);

end