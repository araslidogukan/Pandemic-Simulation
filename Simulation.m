clear
clc

% Inputs to the model
T = 25; %Grid size
N = 150; %Number of people initally [150 - 500]
p = 0.5; %infection probability [0.1 - 0.7]
isolation_flag = true; %true or false indicating the availibility of isolation
M = 30; %Number of days required to be healed (or dead) [10 - 50]
heal_prob = 0.95; %Healing chance
r_s = 0.05;%Just for a function to work (not used in this Case)
delta_2 = 5; %Percentage of isolated people over initally infecteds
q_s = 0.5; %Isolation probability of newly infected person
t_s = 20; %Iterations until vaccine is found
t_sec = 4; %Iterations between two vaccines
k = 1.5; %Indicator of acceptance towards 1st vaccine
delta_1 = 4; %Percentage of people initially infected
w = 0.8; %Acceptance of 2nd vaccine

% Placeholders to add up to the averages
infected_no = zeros(1,200);
healthy_no = zeros(1,200);
dead_no = zeros(1,200);
vaccinated_no = zeros(1,200);
inf_vacc_no = zeros(1,200);

% Outputs of the model (dependent variables)
% These will be used to comparing performances of different policies
% Any benchmark is of the form:
% criterion_no_avg(i,j) is number of 'criterion' (dead people, infected
% people etc.) of the i'th scenario (from the lowest to the highest
% in terms of values of the dependent variables) in the j'th iteration 
infected_no_avg = zeros(1,200);
healthy_no_avg = zeros(1,200);
dead_no_avg = zeros(1,200);
vaccinated_no_avg = zeros(1,200);
inf_vacc_no_avg = zeros(1,200);

% Taking average over sample_size to be more confident in results
sample_size = 50;

for x = 1:sample_size
    count = 1;
    people = initializer(T,N,delta_1,p,isolation_flag,delta_2);
    for n = 1:200
        [people,healthy_no(count,n)] = kill(people,p,heal_prob,M);
        people = step(people,T);
        people = infection(people,q_s,r_s);
        people = vaccinate(people,n,t_s,p,r_s,t_sec,w,k);
    
        infected_no(count,n) = length(people(people(:,3)~=0));
        dead_no(count,n) = length(people(people(:,8)==0));
        if n >= 20
            vaccinated_no(count,n) = size(people(people(:,4)<=r_s),1);
            mask = (people(:,4) <= r_s) .* (people(:,3) > 0);
            inf_vacc_no(count,n) = size(people(logical(mask),:),1);
        end
    end
infected_no_avg = infected_no_avg + infected_no / sample_size;
dead_no_avg = dead_no_avg + dead_no / sample_size;
healthy_no_avg = healthy_no_avg + healthy_no / sample_size;
vaccinated_no_avg = vaccinated_no_avg + vaccinated_no / sample_size;
inf_vacc_no_avg = inf_vacc_no_avg + inf_vacc_no / sample_size;
end

% Plotting line graph results to check whether required criteria is met
figure
hold("on")
plot(infected_no_avg(1,:))
title("Number of infected people")

figure
hold("on")
plot(dead_no_avg(1,:))
title("Number of dead people")

figure
hold("on")
plot(healthy_no_avg(1,:))
title("Number of healed people")

figure
hold("on")
plot(vaccinated_no_avg(1,:))
title("Number of people who got vaccinated")

figure
hold("on")
plot(inf_vacc_no_avg(1,:))
title("Number of infected people who were protected by vaccine")