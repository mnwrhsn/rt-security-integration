function [ taskset ] = getTaskSetsbyNumber( n, base_util_ngroup, n_tc_eachGrp, periodmin, periodmax )
% Given number of base utilization group, number of task in each taskset, 
% and the number of taskset each group, 
% returns the total task sets

taskset = struct('ntask', {}, 'utilizations',{},'periods',{},'wcets',{});
%rt_tc_array = 

for i =1:base_util_ngroup
    %rt_bu_low(i) = 0.01+0.1*(i-1);
    %rt_bu_high(i) = 0.1+0.1*(i-1);
    ulow = 0.01+0.1*(i-1);
    uhigh = 0.1+0.1*(i-1);
    
    for j=1:n_tc_eachGrp
        u = (uhigh-ulow).*rand(1,1) + ulow; % get a random utilzation in this range
        %n = randi([ntask_min ntask_max],1,1); % decide how many tasks in the task set
        
        
        
            periods = randi([periodmin periodmax],1,n);
            periods = sort(periods); % index 1 has the shortest period (eg, higher RM priority)
    utilizations = UUniFast(n, u); % get utlization of each task
            wcets = utilizations .* periods;

    taskset(i,j).ntask = n;
    taskset(i,j).periods = periods;
    taskset(i,j).utilizations = utilizations;
    taskset(i,j).wcets = wcets;

        
        
    end
end


end

