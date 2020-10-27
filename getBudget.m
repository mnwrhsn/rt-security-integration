function [ bueget ] = getBudget( n, Q, P )
% Get the server budget for security task (using Rajkumar paper)

a = 3 - Q/P;
b = 3-  2* (Q/P);

bueget = n * ( (a/b)^(1/n) - 1 );


end

