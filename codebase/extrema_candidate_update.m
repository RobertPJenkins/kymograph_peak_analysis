function candidate_index = extrema_candidate_update(...
    index_start,...
    protrusion_x,...
    candidate_index,...
    threshold,...
    peak_flag...
    )  
% EXTREMA_CANDIDATE_UPDATE checks candidate peaks and troughs by making 
% sure that the peak (trough) is the largest (smallest) value prior to
% finding the next trough (peak) candidate.
%
%   candidate_index = extrema_candidate_update(index_start,
%    protrusion_x,candidate_index,threshold,peak_flag)  
%   iterates through each index in protrusion_x following the candidate 
%   peak (trough) index. If peak (trough) candidate is larger (smaller) by 
%   the threshold than all values up to that index then the candidate peak 
%   (trough) is confirmed. If the peak (trough) finds a larger (smaller)
%   value prior to a given index then the peak (trough) location is 
%   updated.   
%
%   Input:
%   index_start: Index of peak trough
%   protrusion_x: Vector of cell displacements
%   candidate_index: Candidate index of assessed peak (trough)
%   threshold: Minimum distance between peak and trough
%   peak_flag: Set to 1 if assessing a peak and 0 if assessing a trough
%   Output:
%   candidate_index: Updated index for peak (trough)
%
%
%   Class support for input protrusion_x, threshold:
%      single, double
%   Class support for input index_start, candidate_index, peak_flag type:
%      int: uint8, uint16
%
%   This work is licensed under a Creative Commons Attribution 4.0 
%   International License.


for L=index_start+1:length(protrusion_x)
    sub_signal_x=protrusion_x(index_start:L);
    if peak_flag == 1
        if sub_signal_x(candidate_index)-min(sub_signal_x(candidate_index:end))>threshold
            break
        end
        if max(sub_signal_x)>sub_signal_x(candidate_index)
            candidate_x=max(sub_signal_x);
            candidate_index=find(sub_signal_x==candidate_x);
        end
    else
        if max(sub_signal_x(candidate_index:end))-sub_signal_x(candidate_index)>threshold
            break
        end
        if min(sub_signal_x)<sub_signal_x(candidate_index)
            candidate_x=min(sub_signal_x);
            candidate_index=find(sub_signal_x==candidate_x);
        end
    end
end

end