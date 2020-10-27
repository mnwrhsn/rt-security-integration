function vectU = UUniFast(n, U)
sumU = U; % the sum of n uniform random variables
for i=1:n-1, % i=n-1, n-2,... 1
   nextSumU = sumU.*rand^(1/(n-i)); % the sum of n-i uniform random variables
   vectU(i) = sumU - nextSumU;
   sumU = nextSumU;
end
vectU(n) = sumU;