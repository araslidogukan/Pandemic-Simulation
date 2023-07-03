function new_people = infection(people,q_s,r_s)

%A function adjusting the attributes of being infected, isolated and
%vaccination protection(infection probability) according to infection.

% Inputs:
% people: people matrix
% q_s: probability of accepting the isolation after being infected (0 if no
% isolation policy)
% r_s: probability of getting infected after first vaccination (which is
% also the indicator of a person vaccination status)

% Outputs:
% new_people: people matrix with updated attributes

for i = 1:length(people)
    if people(i,8) == 0 %If the person is dead
        continue
    end
    mask = logical((people(:,1) == people(i,1)) .* (people(:,2) == people(i,2)) ...
        .* (people(:,10) > people(i,10) .* (people(:,8))));
    %mask becomes 1 for the people that have higher indice than the person
    %i and have the same coordinates that are also alive
    intersects = people(mask , :);
    if isempty(intersects) %If no intersection with another person
        continue
    end
    for j = 1:length(size(intersects,1))
        if people(i,3) > 0 && people(intersects(j,10),3) == 0 %If the i'th person is sick and j'th person is healthy 
            infect = rand();
            if infect < people(intersects(j,10),4)
                people(intersects(j,10),3) = 1; %Make the j'th person sick
                if people(intersects(j,10),4) == r_s
                    people(intersects(j,10),4) = 0; %If j'th person was vaccinated once increase protection
                end
                isolation = rand();
                if isolation < q_s
                    people(intersects(j,10),5) = 1; %Make the j'th person isolated
                    people(intersects(j,10),6:7) = people(intersects(j,10),1:2); %Update the isolation center of j
                end
            end
        elseif people(intersects(j,10),3) > 0 && people(i,3) == 0 %If the i'th person is healthy and j'th person is sick
            infect = rand();
            if infect < people(i,4)
                people(i,3) = 1; %Make the i'th person sick
                if people(i,4) == r_s
                    people(i,4) = 0; %If i'th person was vaccinated once increase protection
                end
                isolation = rand();
                if isolation < q_s
                    people(i,5) = 1; %Make the i'th person isolated
                    people(i,6:7) = people(i,1:2); %Update the isolation center of i
                end
            end
        end
    end
end
new_people = people;