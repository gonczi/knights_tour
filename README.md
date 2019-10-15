# knights_tour

Erlang practicing - Knight's tour problem

The purpose of the project is to find all paths on a 5X5 board in the shortest time, written in erlang.

## Simple backtracking - knights_tour.erl

```sh
time erl -pa ebin -eval "knights_tour:main()" -noshell

 ...

real	0m11,962s
user	0m11,969s
sys	0m0,040s
```

## Simple backtracking with rpc - knights_tour_rpc.erl

Using 4 processors.

```sh
time erl -pa ebin -eval "knights_tour_rpc:main()" -noshell

 ...

real	0m6,777s
user	0m23,133s
sys	0m0,144s
```
