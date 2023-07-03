function new_people = step(people,T)

%A function that moves every person in a given grid

% Inputs:
% people: The same people matrix containing every information about each
% person in its rows.
% T: Grid size

% Outputs:
% new_people: Updated people matrix containing updated coordinates of 
% each person

%Permutation of these give all possible directions
isolated_moves = [0 0; 0 -1; 0 1; -1 0; -1 -1; -1 1; 1 0; 1 -1; 1 1];
healthy_moves = [0 -1; 0 1; -1 0; -1 -1; -1 1; 1 0; 1 -1; 1 1];

edge = floor(T/2);

for p = 1:length(people)
    if people(p,8) == 0 %If the person is dead
        continue
    end

    if people(p,5) %If the person is isolated
        mask = (abs(people(p,6) + isolated_moves(:,1)) <= edge) .* (abs(people(p,7) + isolated_moves(:,2)) <= edge);
        valid_moves = isolated_moves(logical(mask),:);
        step = rand();
        probs = 1/length(valid_moves);
        for m = 1:length(valid_moves)
            if step < m * probs
                people(p,1:2) = people(p,6:7) + valid_moves(m,1:2);
                break %To not make multiple moves in 1 step
            end
        end
    else
        mask = (abs(people(p,1) + healthy_moves(:,1)) <= edge) .* (abs(people(p,2) + healthy_moves(:,2)) <= edge);
        valid_moves = healthy_moves(logical(mask),:);
        step = rand();
        probs = 1/length(valid_moves);
        for m = 1:length(valid_moves)
            if step < m * probs
                len = randi([0,3]); %If the chosen length leads to out of grid, decrease the length to the largest possible value
                while (abs(people(p,2) + valid_moves(m,2) * len) > edge) || (abs(people(p,1) + valid_moves(m,1) * len) > edge)
                    len = len - 1;
                end
                people(p,1:2) = people(p,1:2) + valid_moves(m,1:2) * len;
                break %To not make multiple moves in 1 step
            end
        end
    end
end
new_people = people;