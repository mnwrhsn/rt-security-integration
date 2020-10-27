function [ obj_value, Tstar, status ] = getOptimalPeriodGP_addCon( n, C, Tdes, Tmax, budget, Q, P )
% get the task period given the server parameters


gpvar T(n);

% for i=1:n
%     Q = T(i) + Tdes(i);
% end

%w = rand(n,1);

obj = sum(Tdes.^(-1) .* T);
constr = [ sum(C./T)/budget <= 1];

for i=1:n
 constr = [constr; T(i)^(-1)*Tdes(i) <= 1];
 constr = [constr; T(i)^(-1)*(3*P- 2*Q) <= 1];
 constr = [constr; T(i)/Tmax(i) <= 1];
end
%constr = [constr; T.^(-1).*Tdes <= 1; T./Tmax <= 1];

[obj_value, solution, status] = gpsolve(obj, constr);


if strcmp(status,'Solved')
    Tstar = solution{2};
else
  Tstar = -1;
  obj_value = -100;
end


 

end

