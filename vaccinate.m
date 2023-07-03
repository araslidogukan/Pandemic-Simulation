function new_people = vaccinate(people,current_iter,t_s,p,r_s,t_sec,w,k)

%A function updating the vaccination status of the people

% Inputs:
% people: matrix of people
% current_iter: current iteration number
% t_s: Required iterations to have vaccination
% p: probability of infection of non-vaccinated people
% r_s: probability of infection of people who are vaccinated just once
% t_sec: required iterations after first vaccination to have second
% vaccination
% w: probability of a person accepting the second vaccination
% k: a constant representing people's acceptence towards vaccine

% Outputs:
% new_people: Update matrix of people

delta_3 = 1 / (k * (current_iter - 19));
for i = 1:length(people)
    if current_iter < t_s %If there are no vaccinations yet
        break
    end
    if people(i,3) ~= 0 || people(i,4) == 0 || people(i,8) == 0 || people(i,9) > t_sec 
        %If the person is currently infected or vaccinated 2 times or dead
        %or refused to get 2nd vaccination on time
        continue
    end
    if people(i,4) ~= r_s %If the person is never vaccinated (note that only available people are seeing this condition)
        vacc = rand();
        if vacc < delta_3
            people(i,4) = r_s; %Update the person as vaccinated
        end
    else
        if people(i,9) == t_sec %If there have been t_sec days after first vaccination
            vacc = rand();
            if vacc < w
                people(i,4) = 0; %Update the person as 2 time vaccinated
                people(i,9) = 0;
            else
                people(i,4) = p; %Update the person as lost protection of vaccination(note that these people will not be able to get vaccinated)
                people(i,9) = people(i,9) + 1;
            end
        else
            people(i,9) = people(i,9) + 1;
        end
    end
end
new_people = people;