function people = initializer(T,N,delta_1,infection_prob,isolation_flag,delta_2)

%A function initalizing the people with their attributes in the computing
%environment.

% Inputs:
% T: Grid Size, N: Number of people 
% delta_1: percentage of people initially infected
% infection_prob: if two people come across in a coordinate probability of
% healthy to get infected
% isolation_flag: indicator of whether there is isolation policy or not
% (true if there is isolation)
% delta_2: percentage of people who are initally infected and in isolation

% Outputs:
% People: A N by 9 matrix containing attributes of people (Each row is a
% person of type:
% [x_coord y_coord days_after_infection infection_prob isIsolated ...
% Isolation_x Isolation_y isAlive days_after_vaccination]

%it should be noted that isAlive is 1 if the person is alive and 0 if not

edge = floor(T/2);

%Creating the columns of the matrix people (each row is a different person,
%and columns represent attributes)
coordinates = randi([-edge,edge],N,2);
itersAfterInf = zeros(N,1);
InfectionProbs = ones(N,1) * infection_prob;
isIsolated = zeros(N,1);
IsolationCoordinates = zeros(N,2);
isAlive = ones(N,1);
itersAfterVac = zeros(N,1);
person_no = reshape(1:N,N,1); %To later use in a function
%Removing duplicates and generating new coordinates up until there are no
%duplicates
coordinates = unique(coordinates, 'rows');
while size(coordinates,1) < N
    new_coordinates = randi([-edge,edge],N-size(coordinates,1),2);
    coordinates = unique([coordinates; new_coordinates], 'rows');
end
%Note that this also could be done by using a loop structure like in the below
%but using built-in function is slightly faster
%i = 1;

%Checking if two different people have the same coordinates (if so changing one's) 
%while i <= length(coordinates)
    %j = i + 1;
    %while j <= length(coordinates) && i ~= j
        %if coordinates(i,:) == coordinates(j,:)
            %coordinates(i,:) = randi([-edge,edge],1,2);
            %j = 0;
        %end
        %j = j + 1;
    %end
    %i = i + 1;
%end

coordinates = coordinates(randperm(N), :);

%Setting first N_s people infected (doesn't matter since they are
%randomized)
N_s = delta_1*N/100;
infected_number = ceil(N_s);
itersAfterInf(1:infected_number) = 1;

%If there is an isolation policy we are setting delta_2 percentage of
%people isolated initially
if isolation_flag
    isolated_number = ceil(N_s * delta_2 / 100);
    isIsolated(1:isolated_number) = 1;
    IsolationCoordinates(1:infected_number,:) = coordinates(1:infected_number,:);
end

%Concanacating all attributes to a matrix people
people = [coordinates itersAfterInf InfectionProbs isIsolated IsolationCoordinates isAlive itersAfterVac person_no];