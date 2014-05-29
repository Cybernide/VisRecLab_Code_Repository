function [RT_mn]=anl_acc_consist_GC_E3(dt_mat)
% Old function signature below:
% function [RT_mn, consist]=anl_acc_consist_GC_E3(fl_nm_array)
% Given result file obtained from bhv_exp_GC_E2, returns three elem
% vector indices specified to:
% 1 - mean reaction times, 2 - consistency

%% Read input data
%{
% Default values; used for no input arguments
if nargin==0    
    res_fold='bhv_results_E3/'; % results folder
    fl1=[res_fold, '/s00/s00_run1.txt']; % subject number
    fl_nm_array={fl1}; % copy array, maintaining nested levels
end

% read entries of file
for fl_k=1:size(fl_nm_array, 1)
    fl_nm=char(fl_nm_array{1});
    dt=dlmread(fl_nm);
    if fl_k==1
        dt_mat=dt;
    else dt_mat=[dt_mat; dt]; %#ok<AGROW>
    end
end
%}
%{
 Calculate values for output elem
 Indices for input vector as reference
 1 - img id for left hand side 
 2 - img id for right hand side 
 3 - response: 1: left more masculine, 2: right more masculine
 4 - RT_act
trial_id_code1 trial_id_code2 resp RT_act
%}

%% Mean reaction time

%RT_mn=nanmean(dt_mat(:, 4));

%% Consistency calculation
    %{
        For each image, obtain the frequency in which it appears and the
        frequency in which it is rated as being more masculine/feminine.
        Estimate its masculinity/femininity relative to the other images in the
        set. Correlate this with the masculinity/femininity of rankings from
        experiment 2.
    %}
% import data and number the results
rate_data = importdata('../E2/gend_vect_rate.txt');
[base_asc,base_index] = sort(rate_data(1:60,:), 1, 'ascend');

% Find the instances of the image in results file.
results=zeros(60, 1);
for indvd_k=1:60
    leftpos = find(dt_mat(:,1) == indvd_k);
    rightpos = find(dt_mat(:,2) == indvd_k);
    leftvote = dt_mat(leftpos, 3) == 1;
    rightvote = dt_mat(rightpos,3) == 2;
    if  (numel(leftpos) + numel(rightpos)) > 0
        results(indvd_k,:) = (leftvote + rightvote)/(numel(leftpos) + ... 
            numel(rightpos));
    else
        results(indvd_k,:) = NaN;
    end
end

[res_asc, res_index]=sort(results, 1, 'ascend')

%{
resp_mat=[dt_mat(ind_mat(:,1), 4) dt_mat(ind_mat(:,2), 4)]; % resp matrix
ind_nmb=isfinite(resp_mat(:, 1).*resp_mat(:, 2));
resp_mat=resp_mat(ind_nmb,:);
%}
%corr_dt=resp_mat;
RHO = corr(res_index, base_index)
%consist=RHO(1,2)
%PVAL=PVAL
