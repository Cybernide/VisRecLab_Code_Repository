function design_ord_GC_E3(subj_k) %#ok<INUSD>

RandStream.setGlobalStream ...
    (RandStream('mt19937ar','seed',sum(100*clock)))

if nargin==0
    subj_k=0; %#ok<NASGU> %enter subject number
end

%run_n=2;

%%%pseudorandomize stimulus order
%%%cnd2: no image is repeated twice in a row
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%perm here so set of id pairs in a run is random

tuples_ordered = nchoosek(1:60, 2);
perm_index = randperm(1770);

j = 1;
num_removed = 0;
tuples_random(j,:) = tuples_ordered(perm_index(j),:);  % (*) okay when j=1 :)
tup_accum = [];
for k = 2:1770
    if tuples_random(j,1) ~= tuples_ordered(perm_index(k),1) && ...
       tuples_random(j,1) ~= tuples_ordered(perm_index(k),2) && ...
       tuples_random(j,2) ~= tuples_ordered(perm_index(k),1) && ...
       tuples_random(j,2) ~= tuples_ordered(perm_index(k),2)
        j = j + 1;
        tuples_random(j,:) = tuples_ordered(perm_index(k),:);  % (*) passed
    else
        num_removed = num_removed + 1;                         % (*) failed
        tup_accum = [tup_accum;tuples_ordered(perm_index(k),:)]; %#ok<AGROW>
    end
end


m = size(tuples_random, 1) - 1;
% m is the index at which rejected tuples are inserted to tuples_random

while size(tup_accum, 1) > 0
    %{
    This if block checks for violations of the conditions
    outlined above. Obviously, this can be done far more
    parsimoniously by turning condition checking into a
    separate script but I'm lazy. We'll leave this on a TODO
    given the time constraints and my current mental state.
    -- Cy
    %}
    if tuples_random(m,1) ~= tup_accum(1,1) && ...
        tuples_random(m,1) ~= tup_accum(1,2) && ...
        tuples_random(m,2) ~= tup_accum(1,1) && ...
        tuples_random(m,2) ~= tup_accum(1,2) && ...
        tuples_random(m+1,1) ~= tup_accum(1,1) && ...
        tuples_random(m+1,1) ~= tup_accum(1,2) && ...
        tuples_random(m+1,2) ~= tup_accum(1,1) && ...
        tuples_random(m+1,2) ~= tup_accum(1,2)
    
            % Split tuples_random at index
            t_split1 = tuples_random(1:m,:);
            t_split2 = tuples_random(m+1:end,:);
            
            % Insert entry in tuples_random
            tuples_random = [t_split1; tup_accum(1,:); t_split2];
            
            % Remove entry from tup_accum
            tup_accum=tup_accum(2:end,:);
    else
            % Violation found; get new index
            m=randi(size(tuples_random, 1) - 1);
    end
end


%ord_fold='stims_ord_E3/';
%fl=[ord_fold, 's', sprintf('%02.0f', subj_k), '_ord_mat.txt']; 
%dlmwrite(fl, ord_mat, 'precision', '%03.0f'); %'precision', '%03.0f'
