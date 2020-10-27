function [ server_util, Q, P, status, count ] = getServerParamGP( rt_tc, se_tc )
% solve GP and get server parameters

gpvar Q P;

dellS = 0;
for i=1:rt_tc.ntask
    dellS = dellS + (P/rt_tc.periods(i) + 1) * rt_tc.wcets(i);
end

%obj = Q * P^(-1);
obj = Q^(-1) * P;
%constr = [ Q  * P^(-1) <= 1];
x0 = 1;
%for i=1:5

gpthreshold = 0.001;
obj_old = 100000000; % initialize to a maximum number
count = 1;

while 1



constr = [ (Q + dellS) * P^(-1) <= 1];
for i=1:se_tc.ntask
    
    dj = se_tc.periods(i);
    aj = x0/(x0 + dj);
    bj = dj/(x0 + dj);
    
    ghat = ((Q/aj)^aj ) * ((dj/bj)^bj);
    
    Ij = getInterference( i, se_tc.wcets, se_tc.periods );
    constr = [constr; ( P * (Q+Ij) + dellS * Q ) * (Q * ghat )^(-1)  <= 1];
    
end






[obj_value, solution, status] = gpsolve(obj, constr);

% no solution found; break the loop
if strcmp(status,'Solved')==0
    
   fprintf('No solution found, GP iter: %d.\n',count);
    break;
end


diff = abs(obj_value - obj_old);

if diff<=gpthreshold
    break;
end
count = count+1; % just a counter to see how many iterations required;
obj_old = obj_value;
x0 = solution{2,2}; % update x0 with current budget
end


if strcmp(status,'Solved')
    
server_util = 1/obj_value;
Q =  solution{2, 2};
P =  solution{1, 2};


else
    
server_util = -1;
Q = -1;
P = -1;


end


end

