clear;
clc;

% Define parameters
iterations = 50;
population_size = 50;
mutation_rate = 0.02;
crossover_rate = 0.3;
population = zeros(population_size,3);
values = zeros(population_size,2);
quality = zeros(100);
effort = zeros(100);

fid = fopen('Results.txt', 'rt');
i=1;
val = zeros(2);
while feof(fid) == 0
tline = fgetl(fid);
val=str2num(tline);
quality(i)=val(1);
effort(i)=val(2);
disp(quality(i));
disp(effort(i));
i=i+1;
%matches = findstr(tline, "$GPGGA");
%num = length(matches);
%if num > 0
% cette ligne t'interresse
end
end
fclose(fid); 

% Initialize population within constraints
for i = 1 : 20
    x1 = abs(rand); % x1 value for individual i within range
    x2 = (rand*10); % x2 value for individual i within range
    population(i,1) = quality(i);
    population(i,2) = effort(i);
    population(i,3) = quality(i); % f1 value for individual i
    population(i,4) = effort(i); % f2 value for individual i    
end


% Iterations
for iter = 1 : iterations
    pool = population;
        
    temp_pop = [];
    % select non dominated individuals to start next iteration with
    for i = 1 : size(pool,1)
        dominated = false;
        for j = 1 : size(pool,1)
            if (pool(i,3)<pool(j,3) && pool(i,4)>pool(j,4)) % if individual i is dominated by individual j
                dominated = true;
                break; % break and go to next individual
            end
        end
        if (~dominated) % if individual not dominated
            temp_pop = [temp_pop; pool(i,:)]; % add it to the pool
            if (size(temp_pop,1) == population_size) % Have enough individuals to fill populatino array?
                break;
            end
        end
    end
    population = temp_pop;
end


% visualization of the results
disp('x1 and x2 values for non-dominated solutions:')
disp(population(:,[1,2]))
%disp('x1 and x2 values ------------------------------------------:')
%disp(population(:,[3,4]))
f = population(:,[3,4]); % store f1 and f2 values for the population in f
plot(f(:,1), f(:,2), 'x'); % plot the Pareto front
title({'Pareto front of : Maximize Quality and Minimize Effort'});
xlabel('Quality');
ylabel('Effort');

fid = fopen('Pareto.txt','w');
%�crit dans ce fichier, fid est sa reference pour matlab
%for i = 1 : 5
i=1;
while(population(i,1)>0)
%fprintf(fid,'%s\n',num2str(population(:,[3,4])));
fprintf(fid,'%i\t %i\n',(population(i,[1,2])));
i=i+1;
end
%fprintf(fid,'%s\n','vecteur y');
%fprintf(fid,'%i\t %i\t %i\n',y);
%n'oublie pas de fermer le fichier sinon tu ,ne peux pas le lire
fclose(fid)

disp(population(1,[1,2]))