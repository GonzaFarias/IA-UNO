%% goal
%%        solucionPP([3,3,izquierda], [0,0,derecha], X, 20), write(X).
%%        
%%


movida([MizIzq,CanIzq,izquierda], [MizIzq2,CanIzq,derecha] ):-
/* 2 M de Izq a Der */
MizIzq2 is MizIzq-2, legal([MizIzq2,CanIzq,derecha]).

movida([MizIzq,CanIzq,izquierda], [MizIzq2,CanIzq2,derecha] ):-
/* 1 M y 1 C de Izq a Der */
MizIzq2 is MizIzq-1, CanIzq2 is CanIzq-1,
legal([MizIzq2,CanIzq2,derecha]).

movida([MizIzq,CanIzq,izquierda], [MizIzq,CanIzq2,derecha] ):-
/* 2 C de Izq a Der */
CanIzq2 is CanIzq-2, legal([MizIzq,CanIzq2,derecha]).

movida([MizIzq,CanIzq,izquierda], [MizIzq2,CanIzq,derecha] ):-
/* 1 M de Izq a Der */
MizIzq2 is MizIzq-1, legal([MizIzq2,CanIzq,derecha]).

movida([MizIzq,CanIzq,izquierda], [MizIzq,CanIzq2,derecha] ):-
/* 1 C de Izq a Der */
CanIzq2 is CanIzq-1, legal([MizIzq,CanIzq2,derecha]).

movida([MizIzq,CanIzq,derecha], [MizIzq2,CanIzq,izquierda]) :-
/* 2 M de Der a Izq */
MizIzq2 is MizIzq+2, legal([MizIzq2,CanIzq,izquierda]).

movida([MizIzq,CanIzq,derecha], [MizIzq2,CanIzq2,izquierda] ):-
/* 1 M y 1 C de Der a Izq */
MizIzq2 is MizIzq+1, CanIzq2 is CanIzq+1,
legal([MizIzq2,CanIzq2,izquierda]).

movida([MizIzq,CanIzq,derecha], [MizIzq,CanIzq2,izquierda] ):-
/* 2 C de Der a Izq */
CanIzq2 is CanIzq+2, legal([MizIzq,CanIzq2,izquierda]).

movida([MizIzq,CanIzq,derecha], [MizIzq2,CanIzq,izquierda] ):-
/* 1 M de Der a Izq */
MizIzq2 is MizIzq+1, legal([MizIzq2,CanIzq,izquierda]).

movida([MizIzq,CanIzq,derecha], [MizIzq,CanIzq2,izquierda] ):-
/* 1 C de Der a Izq */
CanIzq2 is CanIzq+1, legal([MizIzq,CanIzq2,izquierda]).


legal([MizIzq,CanIzq,_]) :-
legal1lado(MizIzq, CanIzq), MizDer is 3-MizIzq, CanDer is 3-CanIzq, legal1lado(MizDer, CanDer).

legal1lado(M, C) :- M>=0, C>=0, M>=C,!.
legal1lado(M, C) :- M==0, C>=0,!.

solucionPP(I, F, R, N) :- solucionPP1(I, F, R, N, [I]),!.

solucionPP1(E, E, [E], _, _) :-  !.
solucionPP1(S, F, [S|R], N, V) :- N>0,  movida(S, S2),N1 is N-1,  not(pert(S2, V)), solucionPP1(S2, F, R, N1, [S2|V]).

pert(E, [E|_]):-!.
pert(E, [_|Co]) :- pert(E, Co).







