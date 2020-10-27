
% Get the server budget for security task (using Rajkumar paper)

Q = 12;
P = 40;

a = 3 - Q/P;
b = 3-  2* (Q/P);

for n=1:10

budget(n) = n * ( (a/b)^(1/n) - 1 );
end


plot(budget)
