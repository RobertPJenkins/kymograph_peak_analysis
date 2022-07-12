function [extrema_x_threshold,extrema_time_threshold] = ...
    threshold_extrema_recorder(...
    lb_index, ...
    ub_index,...
    max_flag,...
    extrema_x_threshold,...
    extrema_time_threshold,...
    protrusion_x,...
    J...
    )

% THRESHOLD_EXTREMA_RECORDER records location and value of verified peaks 
% (troughs) that fall beyond a specified threshold.
%
% [extrema_x_threshold,extrema_time_threshold] = 
% threshold_extrema_recorder(lb_index,ub_index,max_flag,...
% extrema_x_threshold,extrema_time_threshold,protrusion_x,J)
% finds the maximum (minimum) value and corresponding index in the index 
% range [lb_index,ub_index]. This range is determined based on the location
% of candidate peak (trough) and the point in signal where the next trough
% (peak) has been identified to start (i.e. a gap larger than threshold 
% between peak (trough) and following values.   
%
%   Input:
%   lb_index: Index of lower bound to search for maximum (minimum) set
%   according to index of candidate peak (trough)
%   ub_index: Index of upper bound to search for maximum (minimum) set
%   according to index of point where signal guaranteed to turn to trough 
%   (peak) according to threshold
%   max_flag: Identify whether to search for maximum (peak) or minimum
%   (trough)
%   extrema_x_threshold: Stores protrusion location of peaks and troughs
%   extrema_time_threshold: Stores time location of peaks and troughs
%   protrusion_x: Vector of cell displacements
%   J: Index corresponding to location in protrusion_x so relative indexes
%   (lb_index, ub_index etc.) can be correctly placed.
%   Output:
%   extrema_x_threshold: Stores protrusion location of peaks and troughs
%   extrema_time_threshold: Stores time location of peaks and troughs
%   protrusion_x: Vector of cell displacements
%
%
%   Class support for input extrema_x_threshold, extrema_time_threshold,
%   protrusion_x:
%      single, double
%   Class support for input lb_index, ub_index, max_flag, J type:
%      int: uint8, uint16
%
%   This work is licensed under a Creative Commons Attribution 4.0 
%   International License.

if length(extrema_x_threshold)==0
    if max_flag ==1
        extrema_x_threshold(1)=min(protrusion_x(lb_index:ub_index));
        extrema_x_threshold(2)=max(protrusion_x(lb_index:ub_index));
    else
        extrema_x_threshold(1)=max(protrusion_x(lb_index:ub_index));
        extrema_x_threshold(2)=min(protrusion_x(lb_index:ub_index));
    end
        input_index=J-1+find(protrusion_x(lb_index:ub_index)==extrema_x_threshold(1));
        input_index=input_index(end);
        extrema_time_threshold(1)=input_index;
        
        input_index=J-1+find(protrusion_x(lb_index:ub_index)==extrema_x_threshold(2));
        input_index=input_index(end);
        extrema_time_threshold(2)=input_index;
else
    if max_flag == 1
        extrema_x_threshold(end+1)=max(protrusion_x(lb_index:ub_index));
    else
        extrema_x_threshold(end+1)=min(protrusion_x(lb_index:ub_index));
    end
    input_index=J-1+find(protrusion_x(lb_index:ub_index)==extrema_x_threshold(end));
    input_index=input_index(end);
    extrema_time_threshold(end+1)=input_index;
end
end