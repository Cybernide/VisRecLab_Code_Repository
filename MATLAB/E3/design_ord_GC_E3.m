function design_ord_GC_E3(subj_k) %[trial_ord_orig, trial_code_list, trial_list, lr_ind]

RandStream.setGlobalStream ...
    (RandStream('mt19937ar','seed',sum(100*clock)))

if nargin==0
    subj_k=0; %enter subject number
end

run_n=2;

%%%pseudorandomize stimulus order
%%%cnd1: no more than 4 faces of the same gender in a row
%%%cnd2: no image is repeated twice in a row
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%perm here so set of id pairs in a run is random

ord_mat=single(zeros(120, run_n));

for run_k=1:run_n
    
    cnd2=1;
    k=0;
    % while condition 1 or condition 2
    while cnd2

        k=k+1;
        
        ord=single(randperm(120));
        ord_id=ord.*single(ord<61) + (ord-60).*single(ord>60);

        cnd2_n=sum(single(ord_id(1:end-1)==ord_id(2:end)))
        cnd2=cnd2_n>0;

    end

    k=k;
    %[ord_gend' ord_id']
    ord_mat(:, run_k)=ord_id';

end


ord_fold=['stims_ord_E3/'];
fl=[ord_fold, 's', sprintf('%02.0f', subj_k), '_ord_mat.txt']; 
dlmwrite(fl, ord_mat, 'precision', '%03.0f'); %'precision', '%03.0f'
        
  
