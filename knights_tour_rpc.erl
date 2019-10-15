%%% Knight’s tour problem (5x5, simple backtracking with rpc)

%%% compile:
%%% erlc knights_tour_rpc.erl

%%% run:
%%% erl -pa ebin -eval "knights_tour_rpc:main()" -noshell

-module(knights_tour_rpc).
-compile(export_all).

-define(WX, 5).
-define(WY, 5).
-define(NMAX, (?WX*?WY)).

main() -> 
	process_flag(trap_exit, true),
	BPinterPid = spawn_link(?MODULE, board_printer, [1]),
	register(bprinter, BPinterPid),
	Board = [],
	Plist = [
		{1, 1},
		{2, 1}, %% - 5x5
		{3, 1},
		{2, 2},
		{3, 2}, %% - 5x5
		{3, 3}
		],
	rpc:pmap( { ?MODULE, 'pstep' }, [Board], Plist),
	BPinterPid ! {terminate, self()},
	receive
		ok -> ok
	end,
	halt().

pstep(Pos, Board) ->
	step(1, Board, Pos, false).

step(?NMAX, Board, {X, Y}, false) when (1=<X) and (X=<?WX) and (1=<Y) and (Y=<?WY) ->
	print_board([{X, Y} | Board]);
step(N, Board, {X, Y}, false) when (1=<X) and (X=<?WX) and (1=<Y) and (Y=<?WY) ->
	Plist = [{X+1, Y+2},
		{X+1, Y-2},
		{X-1, Y+2},
		{X-1, Y-2},
		{X+2, Y+1},
		{X+2, Y-1},
		{X-2, Y+1},
		{X-2, Y-1}],
	[Pos || Pos <- Plist, step(N+1, [{X, Y} | Board], Pos, lists:member(Pos, Board)) == ok],
	ok;
step(_, _, _, _) ->
	outOfBoard.

print_board(Board) ->
	BPinterPid = whereis(bprinter),
	BPinterPid ! {board, self(), Board},
	receive
		ok -> ok
	end.

board_printer(N) ->	
	receive
		{board, From, Board} ->
			io:format("N:~p~n", [N]),
			bdraw(Board),
			From ! ok,
			board_printer(N+1);
		{terminate, From} ->
			From ! ok
	end.

bdraw(Board) ->
	[X || X <- lists:seq(1,?WX), bdraw(Board, X)],
	io:format("~n").
bdraw(Board, X) ->
	[Y || Y <- lists:seq(1,?WY), bdraw(Board, X, Y)],
	io:format("~n"),
	true.
bdraw(Board, X, Y) ->
	io:format("~2.. B ", [((?WX*?WY)+1) - find(Board, {X, Y}, 1)]),
	true.

find([], _, _) ->
	nomatch;
find([F | _], Item, N) when F == Item->
	N;
find([_ | Board], Item, N) ->
	find(Board, Item, N + 1).


