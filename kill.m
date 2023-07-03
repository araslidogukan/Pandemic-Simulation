function [new_people,healed_no] = kill(people,p,heal_prob,M)

%A function that updates the people based on their iterations after infection as
%either dead or healed

% Inputs:
% people: A matrix containing information about people
% heal_prob: Probability of infected person healing after M iterations of
% infection
% M: Number of iterations needed to be either dead or to be healed.

% Outputs:
% new_people: Updated people matrix
% healed_no: Number of people healed in this iteration

healed_no = 0;
for i = 1:length(people)
    if people(i,3) > 0 %If the person is infected
        if people(i,3) == M %If it has been M days after the infection
            health = rand();
            if health > heal_prob
                people(i,8) = 0; %Update the person as dead
                people(i,3) = 0; %Update the dead person as non-infected (for plotting purposes)
                people(i,4) = p; %Update the dead person as non-vaccinated (for plotting porposes)
            else
                people(i,3) = 0; %Update person as healed
                healed_no = healed_no + 1;
            end
        else
            people(i,3) = people(i,3) + 1; %Increment the days after infection
        end
    end
end
new_people = people;