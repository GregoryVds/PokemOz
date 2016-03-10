# PokemOz Project

This project was graded 16/20.

In this directory, you can find all the .oz files you need to run the
Pokemoz Project.

We give you a makefile to make the compilation way simplier, open a
console from here and type the following command lines :

$ make

If the project is already built, you can just type this command line in
the console :

$ make run

If the project is already built and you want to add parameters to the
program, you can type :

ozengine ./game.oza [options] [params]

The following options are accepted :

-m, --map FILEPATH (a file containing a map - defaults to map.txt)
-p, --probability INT (probability to find a wild pokemoz in tall grass - defaults to 20)
-s, --speed INT (speed of your pokemoz trainer - defaults to 9)
-a, --autofight BOOL (choice of an automatic game or not - defaults to YES)
-h, -?, --help (a help about the arguments)
