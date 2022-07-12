function [crossings,var_protrusion_x] = crossing_function(time,protrusion_x)
% CROSSING_FUNCTION counts the number of times the cell protudes or retracts 
% from its initial starting point.
%
%   [crossings,var_protrusion_x] = crossing_function(time,protrusion_x)
%   interpolates data to be evenly distributed in time 
%   and normalises so at time zero the position is 0. It then counts the
%   number of times the initial point is crossed (either retracted to a
%   negative value or protruded to a positive value. Also gives variance in
%   protusion distance (var_protrusion_x).
%
%   Input:
%   time: Vector of time points
%   protrusion_x: Vector of cell displacements
%
%   crossings: Number of crossings
%   var_protrusion_x: variance in protusion distance.
%
%   Class support for input time, protrusion_x: single, double
%   
%
%   This work is licensed under a Creative Commons Attribution 4.0 
%   International License.

time_continuous=0:0.01:max(time);
continuous_x=interp1(time,protrusion_x,time_continuous);

continuous_x=continuous_x-mean(continuous_x);
crossings=0;
for J=1:length(continuous_x)-1
   if (continuous_x(J)<0 && continuous_x(J+1)>0)
       crossings=crossings+1;
   end
   if (continuous_x(J)>0 && continuous_x(J+1)<0)
       crossings=crossings+1;
   end
end

var_protrusion_x=var(continuous_x);
end