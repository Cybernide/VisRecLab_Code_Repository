function [RT_mn]=anl_acc_consist_GC_E3(fl_nm_array)
% function [RT_mn, consist]=anl_acc_consist_GC_E3(fl_nm_array)
% Given result file obtained from bhv_exp_GC_E2, returns three elem
% vector indices specified to:
% 1 - mean reaction times, 2 - consistency

% Default values; used for no input arguments
if nargin==0    
    res_fold='bhv_results_E3/'; % results folder
    fl1=[res_fold, '/s01/s01_run2.txt']; % subject number
    fl_nm_array={fl1}; % copy array, maintaining nested levels
end

% read entries of file
for fl_k=1:size(fl_nm_array, 1)
    fl_nm=char(fl_nm_array{1});
    dt=dlmread(fl_nm);
    if fl_k==1
        dt_mat=dt;
    else dt_mat=[dt_mat; dt];
    end
end

%{
 Calculate values for output elem
 Indices for input vector as reference
 1 - img id for left hand side 
 2 - img id for right hand side 
 3 - response: 1: left more masculine, 2: right more masculine
 4 - RT_act
trial_id_code1 trial_id_code2 resp RT_act
%}

RT_mn=nanmean(dt_mat(:, 4))

%{
ind_mat=zeros(60, 2);
for indvd_k=1:60
    pos=find(dt_mat(:, 2)'==indvd_k, 2, 'first');
    ind_mat(indvd_k, :)=pos;
end

resp_mat=[dt_mat(ind_mat(:,1), 4) dt_mat(ind_mat(:,2), 4)]; % resp matrix
ind_nmb=isfinite(resp_mat(:, 1).*resp_mat(:, 2));
resp_mat=resp_mat(ind_nmb,:);

corr_dt=resp_mat;
[RHO,PVAL] = corr(corr_dt);
consist=RHO(1,2)
 PVAL=PVAL
%}