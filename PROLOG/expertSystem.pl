/*

* Part 1 of the project (you can find the first part in the file 'decisionTree.pl')
* Check howToRun.txt file to see how to run the program 
* The program is written in Prolog language by Beyza Acar
* You can see the reqirement of the project in the file named description.pdf (path : ../description.pdf)

*/

% Places (id-name)
place(admin_office).
place(cafeteria).
place(engineering_building).
place(library).
place(social_sciences_building).
place(lecture_hall_a).
place(institute_x).
place(institute_y).

% Edges (start, end, cost(time)))
edge(admin_office, cafeteria, 4).
edge(admin_office, engineering_building, 3).
edge(admin_office, library, 1).
edge(cafeteria, library, 5).
edge(cafeteria, social_sciences_building, 2).
edge(engineering_building, lecture_hall_a, 2).
edge(engineering_building, library, 5).
edge(library, institute_y, 3).
edge(library, social_sciences_building, 2).
edge(social_sciences_building, institute_x, 8).
edge(lecture_hall_a, institute_y, 3).
%% due to the fact that all these edges are bidirectional we need to write them one more time in reverse order
edge(cafeteria, admin_office, 4).
edge(engineering_building, admin_office, 3).
edge(library, admin_office, 1).
edge(library, cafeteria, 5).
edge(social_sciences_building, cafeteria, 2).
edge(lecture_hall_a, engineering_building, 2).
edge(library, engineering_building, 5).
edge(institute_y, library, 3).
edge(social_sciences_building, library, 2).
edge(institute_x, social_sciences_building, 8).
edge(institute_y, lecture_hall_a, 3).



% Delivery Personnel (name, capacity, work_hours, current_delivery_job, current_location)
delivery_personnel(beyza, 10, 50, none, admin_office).
delivery_personnel(buket, 15, 12, none, cafeteria).
delivery_personnel(onur, 20, 160, obj5, engineering_building).

% Objects (id, weight, pick_up_place, drop_off_place, urgency, id_of_the_delivery_person_if_in_transit)
object(obj1, 5, admin_office, institute_x, low, none). % time is 11
object(obj2, 10, cafeteria, institute_y, high, none). % time is 7
object(obj3, 15, engineering_building, institute_x, medium, none). % time is 14
object(obj4, 20, library, institute_y, low, none). % time is 3
object(obj5, 25, social_sciences_building, institute_x, high, onur). % time is 8

% A rule to find a path between two places (Start and End) and its length (Path and Length)
path(Start, End, Path, Length) :-
    dfs(Start, End, [Start], 0, RevPath, Length),
    reverse(RevPath, Path).

% DFS algorithm
dfs(End, End, Path, Length, Path, Length). % if we've reached our goal, we're done
dfs(Start, End, Visited, AccLength, Path, Length) :-
    edge(Start, Next, Dist), % find an adjacent node -- if there is one Next is the next node on the path
    \+ member(Next, Visited),  % if not visited yet
    NewLength is AccLength + Dist,
    dfs(Next, End, [Next|Visited], NewLength, Path, Length).

% Rule to find the shortest path between two places 
shortest_path(Start, End) :-
    shortest_path(Start, End, _, _).
    %write('Shortest Path: '), write(ShortestPath),nl,
    %write('Shortest Length: '), write(ShortestLength), nl.

notInTransit(Object) :-
    object(Object, _ , _ , _ , _ , DeliveryPerson), % find an object
    \+ DeliveryPerson = none. % check if the delivery person of the object is none (if it is none, the object is not in transit)


% Rule to find the shortest path between two places
shortest_path(Start, End, ShortestPath, ShortestLength) :-
    findall([Path, Length], path(Start, End, Path, Length), Paths), % find all paths and their lengths between Start and End places 
    %%findall rule finds all possible paths and lengths between Start and End places and puts them in Paths list
    % write("Paths : "), write(Paths), nl, nl, % print all paths and their lengths to the screen
    find_min(Paths, [ShortestPath, ShortestLength]). % find the shortest path and its length
    % print shortest path and its length to the screen

% Rule to find the minimum of a list of lists
find_min([Min], Min). % if there is only one element, it is the minimum (it is the base case of the recursion (fact to stop the recursion))
find_min([[Path, Length]|T], Min) :- % |T is the tail of the list 
    find_min(T, [Path1, Length1]),
    (Length < Length1 -> Min = [Path, Length] ; Min = [Path1, Length1]). % if the head of the list is smaller than the minimum of the tail, it is the new minimum

% Rule to finf if a delivery person is available to pick and deliver a given object  (all delivery personnel should be scanned and added to the list if they are available)
% availabilty has 3 criteria : the work hours of the delivery person should be less then the time it takes to go to the pick up place + the time it takes to go to the drop off place
                               % the capacity of the delivery person should be greater than the weight of the object   
                               % the delivery person should not be in transit
% no matter what, all delivery personnel should be scanned and added to the list if they are available, even someone found to be available before 

availability(Object, DeliveryPerson, Time) :-
    delivery_personnel(DeliveryPerson, Capacity, WorkHours, none, Location), % find a delivery person that is not in transit (fact includes none as the current delivery job so it is not in transit)
    object(Object, Weight, PickUpPlace, DropOffPlace, _, none), % find an object
    shortest_path(Location, PickUpPlace, _, ShortestLength1), % find the shortest path between the delivery person's location and the pick up place
    shortest_path(PickUpPlace, DropOffPlace, _, ShortestLength2), % find the shortest path between the pick up place and the drop off place
    Time is ShortestLength1 + ShortestLength2, % calculate the time it takes to pick up and deliver the object
    WorkHours >= Time, % check if the delivery person has enough time to pick up and deliver the object
    Capacity >= Weight. % check if the delivery person has enough capacity to carry the object

% do availabilty rule for all delivery personnel and add them to the list if they are available 
availabilityList(Object, DeliveryPersonList, Time) :-
    findall([DeliveryPerson,Time], availability(Object, DeliveryPerson, Time), DeliveryPersonList). % find all delivery personnel that are available to pick up and deliver the object

% Rule to find if a delivery person is available to pick and deliver a given object  (all delivery personnel should be scanned and added to the list if they are available)
isPortable(Object) :-
    object(Object, _, _, _, _, DeliveryPerson), % find an object that is not in transit (fact includes none as the delivery person so it is not in transit)
    ( DeliveryPerson \= none
    ->  write("Object is in transit, it is not portable"), false
    ;
    availabilityList(Object, DeliveryPersonList, _), % find all delivery personnel that are available to pick up and deliver the object
    (DeliveryPersonList = [] -> 
    (write("No delivery personnel available to pick up and deliver the object"), false )
    ; 
    (write("Delivery personnel available to pick up and deliver the object : "), write(DeliveryPersonList) )
    )
).

% Example queries and their results : ((onur is in transit, so onur is not available to pick up and deliver any object))
    % isPortable(obj1). -> [beyza]
    % isPortable(obj2). -> [beyza, buket]
    % isPortable(obj3). -> No delivery personnel available to pick up and deliver the object (the time required to pick up and deliver the object is greater than the work hours of the delivery personnel)
    % isPortable(obj4). -> No delivery personnel available to pick up and deliver the object (the capacity of the delivery personnel is not enough to carry the object except onur but onur is in transit)
    % isPortable(obj5). -> Object is in transit, it is not portable 