# advent-of-code
My Advent of Code puzzle solutions.

I will use a different programming language for each year, beginning with 2015.

## AoC 2015
Let's learn some Go! Why? Because a simple C-like native language with modern tooling, fast iteration time, a sensible standard library, and performant GC is very nice.

Day 1 - This problem introduced me to many of the basics of Go. I learned variables, functions, maps, and unit testing. On my first attempt, I used a function to map parentheses to increment or decrement the floor. This somehow led to an off-by-1 error. I suspect this is due to a newline or EOF rune resulting in a -1 since I did not explicitly map the else if case. Easy fix was to use a hash map which is better anyway.
