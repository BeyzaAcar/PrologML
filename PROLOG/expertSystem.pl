/*
Part 1. [60pts] In this part of the homework, you are asked to write a simple expert system in Prolog for 
scheduling pickup and deliveries in a small college campus. In this campus you have the following:
•
Several delivery personnel:
o
A unique ID.
o
Capacity to carry (in kg).
o
Work hours (in 4-hour increments including the entire day). : example : 8-12, 12-16, 16-20, 20-24 
o
Current delivery job (if any).
o
Current location (one of the places as described below).
•
Several places to pick up from and deliver objects to:
o
A unique ID.
•
A set of objects to be delivered:
o
A unique ID.
o
Weight in kg.
o
Pick up place (as described above).
o
Drop of place (as described above).
o
Urgency of the delivery (low, medium, high).
o
ID of the delivery person if in transit.
•
A map showing the routes between any two places:
o
Nodes including a place’s unique ID.
o
An edge showing the connection between two places along with the time it would take to travel.
Your Prolog program will have the given map implemented. It should have three delivery personel and five objects (one of them should be in transit).
The resulting expert system should respond to queries such as:
•
Given the current state, are there any delivery person available to pick and deliver a given object. If the object is already in delivery, return the 
person delivering it. Otherwise, print all the people that could make the delivery along with the total time to complete it.

Places : 

Admin Office 
Cafeteria
Engineering Building
Library
Social Sciences Building
Lecture Hall A
Institute X
Institute Y

Edges : (all are bidirectional)

Admin Office - Cafeteria : 4
Admin Office - Engineering Building : 3
Admin Office - Library : 1
Cafeteria - Library : 5
Cafeteria - Social Sciences Building : 2
Engineering Building - Lecture Hall A : 2
Engineering Building - Library : 5
Library - Institute Y : 3
Library - Social Sciences Building : 2
Social Sciences Building - Institute X : 8
Lecture Hall A - Institute Y : 3

Delivery Personnel :

ID : beyza, Capacity : 10, Work Hours : [8-12, 12-16, 16-20, 20-24], Current Delivery Job : none, Current Location : Admin Office
ID : buket, Capacity : 15, Work Hours : [13-17], Current Delivery Job : none, Current Location : Cafeteria
ID : onur, Capacity : 20, Work Hours : [14-18, 18-22], Current Delivery Job : none, Current Location : Engineering Building


Objects :

ID : obj1, Weight : 5, Pick Up Place : Admin Office, Drop Off Place : Institute X, Urgency : low, ID of the delivery person if in transit : none
ID : obj2, Weight : 10, Pick Up Place : Cafeteria, Drop Off Place : Institute Y, Urgency : high, ID of the delivery person if in transit : none 
ID : obj3, Weight : 15, Pick Up Place : Engineering Building, Drop Off Place : Institute X, Urgency : medium, ID of the delivery person if in transit : none
ID : obj4, Weight : 20, Pick Up Place : Library, Drop Off Place : Institute Y, Urgency : low, ID of the delivery person if in transit : none
ID : obj5, Weight : 25, Pick Up Place : Social Sciences Building, Drop Off Place : Institute X, Urgency : high, ID of the delivery person if in transit : onur




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
delivery_personnel(onur, 20, 16, obj5, engineering_building).

% Objects (id, weight, pick_up_place, drop_off_place, urgency, id_of_the_delivery_person_if_in_transit)
object(obj1, 5, admin_office, institute_x, low, none).
object(obj2, 10, cafeteria, institute_y, high, none).
object(obj3, 15, engineering_building, institute_x, medium, none).
object(obj4, 20, library, institute_y, low, none).
object(obj5, 25, social_sciences_building, institute_x, high, onur).

% A rule to find a path between two places (Start and End) and its length (Path and Length)
path(Start, End, Path, Length) :-
    write("Im in path rule "), nl,
    write("Start : "), write(Start), nl,
    write("End : "), write(End), nl,
    write("Path : "), write(Path), nl,
    write("Length : "), write(Length), nl,

    dfs(Start, End, [Start], 0, RevPath, Length),
    reverse(RevPath, Path).

% DFS algorithm
dfs(End, End, Path, Length, Path, Length). % if we've reached our goal, we're done
dfs(Start, End, Visited, AccLength, Path, Length) :-
    write("Im in dfs rule "), nl,
    edge(Start, Next, Dist), % find an adjacent node -- if there is one Next is the next node on the path
    \+ member(Next, Visited),  % if not visited yet
    NewLength is AccLength + Dist,
    dfs(Next, End, [Next|Visited], NewLength, Path, Length).

% Rule to find the shortest path between two places 
shortest_path(Start, End) :-
    write("Im in 2 parametres shortest_path rule "), nl,
    shortest_path(Start, End, ShortestPath, ShortestLength),
    write('Shortest Path: '),
    write(ShortestPath),
    nl,
    write('Shortest Length: '),
    write(ShortestLength),
    nl.

notInTransit(Object) :-
    write("Im in isInTransit rule "), nl,
    object(Object, _ , _ , _ , _ , DeliveryPerson), % find an object
    write("I created object "), write(Object), nl,
    \+ DeliveryPerson = none, % check if the delivery person of the object is none (if it is none, the object is not in transit)
    write("I checked if the object is in transit "), nl,
    write("DeliveryPerson : "), write(DeliveryPerson), nl, nl.


% Rule to find the shortest path between two places
shortest_path(Start, End, ShortestPath, ShortestLength) :-
    write("Im in shortest_path rule "), nl,
    findall([Path, Length], path(Start, End, Path, Length), Paths), % find all paths and their lengths between Start and End places 
    %%findall rule finds all possible paths and lengths between Start and End places and puts them in Paths list
    write("Paths : "), write(Paths), nl, nl,
    find_min(Paths, [ShortestPath, ShortestLength]), % find the shortest path and its length
    % print shortest path and its length to the screen
    write('Shortest Path: '), write(ShortestPath), nl, nl, 
    write('Shortest Length: '), write(ShortestLength), nl, nl.

% Rule to find the minimum of a list of lists
find_min([Min], Min). % if there is only one element, it is the minimum
find_min([[Path, Length]|T], Min) :- % |T is the tail of the list 
    find_min(T, [Path1, Length1]),
    (Length < Length1 -> Min = [Path, Length] ; Min = [Path1, Length1]). % if the head of the list is smaller than the minimum of the tail, it is the new minimum

% Rule to finf if a delivery person is available to pick and deliver a given object  (all delivery personnel should be scanned and added to the list if they are available)
% availabilty has 3 criteria : the work hours of the delivery person should be less then the time it takes to go to the pick up place + the time it takes to go to the drop off place
                               % the capacity of the delivery person should be greater than the weight of the object   
                               % the delivery person should not be in transit
% no matter what, all delivery personnel should be scanned and added to the list if they are available, even someone found to be available before 

availability(Object, DeliveryPerson, Time) :-
    write("Im in availabilty rule "), nl,
    delivery_personnel(DeliveryPerson, Capacity, WorkHours, none, Location), % find a delivery person
    write("I created delivery person "), write(DeliveryPerson), nl,
    object(Object, Weight, PickUpPlace, DropOffPlace, Urgency, none), % find an object
    write("I created object "), write(Object), nl,
    shortest_path(Location, PickUpPlace, ShortestPath1, ShortestLength1), % find the shortest path between the delivery person's location and the pick up place
    shortest_path(PickUpPlace, DropOffPlace, ShortestPath2, ShortestLength2), % find the shortest path between the pick up place and the drop off place
    Time is ShortestLength1 + ShortestLength2, % calculate the time it takes to pick up and deliver the object
    write("I created time : "), write(Time), nl,
    write("WorkHours : "), write(WorkHours), nl,
    WorkHours >= Time, % check if the delivery person has enough time to pick up and deliver the object
    write("I checked work hours "), nl,
    Capacity >= Weight, % check if the delivery person has enough capacity to carry the object
    write("I checked capacity "), nl.

% do availabilty rule for all delivery personnel and add them to the list if they are available 
availabilityList(Object, DeliveryPersonList, Time) :-
    write("Im in availabiltyList rule "), nl,
    findall(DeliveryPerson, availability(Object, DeliveryPerson, Time), DeliveryPersonList), % find all delivery personnel that are available to pick up and deliver the object
    write("DeliveryPersonList : "), write(DeliveryPersonList), nl, nl.

% Rule to find if a delivery person is available to pick and deliver a given object  (all delivery personnel should be scanned and added to the list if they are available)
isPortable(Object) :-
    write("Im in isPortable rule "), nl, 
    object(Object, Weight, PickUpPlace, DropOffPlace, Urgency, none), % find an object that is not in transit (fact includes none as the delivery person so it is not in transit)
    write("I created object "), write(Object), nl, 
    write("I checked if the object is in transit "), nl,
    availabilityList(Object, DeliveryPersonList, Time), % find all delivery personnel that are available to pick up and deliver the object
    write("I created DeliveryPersonList "), nl,
    write("DeliveryPersonList : "), write(DeliveryPersonList), nl, nl,
    write("Time : "), write(Time), nl, nl, 
    (DeliveryPersonList = [] -> 
    (write("No delivery personnel available to pick up and deliver the object"), false )
    ; 
    (write("Delivery personnel available to pick up and deliver the object : "), write(DeliveryPersonList) )
    ).

% Example queries : 
    % isPortable(obj1).
    % isPortable(obj2).
    % ... (for all objects)