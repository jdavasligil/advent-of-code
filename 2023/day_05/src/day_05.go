/*
Advent of Code 2023
Jaedin Davasligil

--- Day 5: If You Give A Seed A Fertilizer ---

https://adventofcode.com/2023/day/5

*/
package main

import (
	"bufio"
	"log"
	"os"
)


func main() {

    // PART 1

    inFile, err := os.Open("data/input.dat")
    if err != nil {
        log.Fatal(err)
    }

    fileScanner := bufio.NewScanner(inFile)

    fileScanner.Split(bufio.ScanLines)

    for fileScanner.Scan() {
        println(fileScanner.Text())
    }
}
