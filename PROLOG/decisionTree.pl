% classify(SepalLength, SepalWidth, PetalLength, PetalWidth, Class)
classify(_, _, PetalLength, PetalWidth, Class) :-
    (   PetalLength =< 2.45
    ->  Class = 'Iris-setosa'
    ;   PetalWidth =< 1.75
        ->  (   PetalLength =< 4.95
            ->  (   PetalWidth =< 1.65
                ->  Class = 'Iris-versicolor'
                ;   Class = 'Iris-virginica'
                )
            ;   (   PetalLength =< 4.85
                ->  Class = 'Iris-versicolor'
                ;   Class = 'Iris-virginica'
                )
            )
        ;   Class = 'Iris-virginica'
    ).

classify(SepalLength, SepalWidth, PetalLength, PetalWidth) :-
    classify(SepalLength, SepalWidth, PetalLength, PetalWidth, Class),
    write(Class), nl.


% Example queries
% ?- classify(4.9, 2.4, 3.3, 1.0, Class). --> 'Iris-versicolor'
% ?- classify(5.8, 2.7, 5.1, 1.9, Class). --> 'Iris-virginica'
% ?- classify(5.1, 3.5, 1.4, 0.2, Class). --> 'Iris-setosa'
% ?- classify(5.7, 2.8, 4.1, 1.3, Class). --> 'Iris-versicolor'
