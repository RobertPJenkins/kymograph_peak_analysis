function motility = motility_function(time,protrusion_x)     
% MOTILITY_FUNCTION calculates protrusion speed and acceleration statistics 
% for a cell.
%
%
%   Input:
%   time: Vector of time points
%   protrusion_x: Vector of cell displacements
%
%   motility: A structure array containing speed_mean, speed_median,
%   speed_std (standard deviation). acceleration_mean, acceleration_median
%   and acceleration_std.
%
%
%   Class support for input time, protrusion_x: single, double
%   
%
%   This work is licensed under a Creative Commons Attribution 4.0 
%   International License.


speed=diff(protrusion_x)./diff(time);
motility.speed_mean=mean(abs(speed));
motility.speed_median=median(abs(speed));
motility.speed_std=std(abs(speed));
tv = (time(1:end-1)+time(2:end))/2;
acceleration=diff(speed)./diff(tv);
motility.acceleration_mean=mean(abs(acceleration));
motility.acceleration_median=median(abs(acceleration));
motility.acceleration_std=std(abs(acceleration));

end
