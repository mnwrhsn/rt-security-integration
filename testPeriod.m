
n = 10;
periodmin=10;
periodmax=100;
base_u = 0.8;



Tmax = randi([periodmin periodmax],n,1); % decide how many tasks in the task set
Tdes = 0.6 .* Tmax;

U = UUniFast(n, base_u); % get utlization of each task
U = U'; % make transpose to match direction
C = U .* Tmax;

gpvar T(n);

% for i=1:n
%     Q = T(i) + Tdes(i);
% end

%w = rand(n,1);

obj = sum(Tdes.^(-1) .* T);
constr = [ sum(C./T) <= 1];

for i=1:n
 constr = [constr; T(i)^(-1)*Tdes(i) <= 1];
 constr = [constr; T(i)/Tmax(i) <= 1];
end
%constr = [constr; T.^(-1).*Tdes <= 1; T./Tmax <= 1];

[obj_value, solution, status] = gpsolve(obj, constr);

 Tstar = solution{2};
 
 Tmax
 Tstar
 Tdes

