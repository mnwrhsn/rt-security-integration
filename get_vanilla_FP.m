function [ isSched ] = get_vanilla_FP( se_tc, rt_tc)
% returns 1 if RM bound satisfied, 0 otherwise

%isSched = 0;

n = se_tc.ntask +  rt_tc.ntask;

U = sum(se_tc.utilizations)  + sum(rt_tc.utilizations);

UB = n * (2^(1/n) - 1);

if U <= UB
	isSched = 1;
else
	isSched = 0;
end


end

