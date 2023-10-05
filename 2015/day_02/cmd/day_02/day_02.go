/*
Advent of Code 2015
Jaedin Davasligil

--- Day 2: I Was Told There Would Be No Math ---

The elves are running low on wrapping paper, and so they need to submit and
order for more. They have a list of the dimensions (length l, width w, and
height h) of each present, and only want to order exactly as much as they need.

Fortunately, every present is a box (a perfect right rectangular prism), which
makes calculating the required wrapping paper for each gift a little easier:
find the surface area of the box, which is 2*l*w + 2*w*h + 2*h*l. The elves
also need a little extra paper for each present: the area of the smallest side.

For example:

	A present with dimensions 2x3x4 requires 2*6 + 2*12 + 2*8 = 52 ft^2
	of wrapping paper plus 6 square feet of slack, for a total of 58 ft^2.

	A present with dimensions 1x1x10 requires 2*1 + 2*10 + 2*10 = 42 ft^2
	of wrapping paper plus 1 square foot of slack, for a total of 43 ft^2.

All numbers in the elves' list are in feet. How many total square feet of
wrapping paper should they order?

--- Part Two ---

The elves are also running low on ribbon. Ribbon is all the same width, so they
only have to worry about the length they need to order, which they would again
like to be exact.

The ribbon required to wrap a present is the shortest distance around its
sides, or the smallest perimeter of any one face. Each present also requires a
bow made out of ribbon as well; the feet of ribbon required for the perfect bow
is equal to the cubic feet of volume of the present. Don't ask how they tie the
bow, though; they'll never tell.

For example:

    A present with dimensions 2x3x4 requires 2+2+3+3 = 10 feet of ribbon to
    wrap the present plus 2*3*4 = 24 feet of ribbon for the bow, for a total
    of 34 feet.

    A present with dimensions 1x1x10 requires 1+1+1+1 = 4 feet of ribbon to
    wrap the present plus 1*1*10 = 10 feet of ribbon for the bow, for a total
    of 14 feet.

How many total feet of ribbon should they order?
*/
package main

import (
	"bufio"
	"log"
	"os"
	"strconv"
	"strings"
)

type BoxSize struct {
    l float32
    w float32
    h float32
}

func parseBoxSize(line string) BoxSize {
    var dimensions_float[3] float32

    dimensions := strings.Split(line, "x")

    for i := 0; i < 3; i++ {
        dim, err := strconv.ParseFloat(dimensions[i], 32)
        if err != nil {
            log.Fatal(err)
        }

        dimensions_float[i] = float32(dim)
    }

    return BoxSize {
        dimensions_float[0],
        dimensions_float[1],
        dimensions_float[2],
    }
}

func calculateWrappingPaper(l float32, w float32, h float32) float32 {
    side1 := l * w
    side2 := w * h
    side3 := l * h
    smallestSide := min(side1, side2, side3)

    return 2*side1 + 2*side2 + 2*side3 + smallestSide
}

func calculateRibbonLength(l float32, w float32, h float32) float32 {
    dimArray := [3]float32 {l, w, h}
    var tmp float32 = 0.0

    if dimArray[0] > dimArray[1] {
        tmp = dimArray[0]
        dimArray[0] = dimArray[1]
        dimArray[1] = tmp
    }
    if dimArray[1] > dimArray[2] {
        tmp = dimArray[1]
        dimArray[1] = dimArray[2]
        dimArray[2] = tmp
    }
    if dimArray[0] > dimArray[1] {
        tmp = dimArray[0]
        dimArray[0] = dimArray[1]
        dimArray[1] = tmp
    }

    return 2*dimArray[0] + 2*dimArray[1] + l*w*h
}

func main() {

    // PART 1

    boxSizeFile, err := os.Open("data/box_sizes.dat")
    if err != nil {
        log.Fatal(err)
    }

    fileScanner := bufio.NewScanner(boxSizeFile)

    fileScanner.Split(bufio.ScanLines)

    var totalWrappingPaper float32 = 0.0
    var totalRibbon float32 = 0.0

    for fileScanner.Scan() {
        box := parseBoxSize(fileScanner.Text())
        totalWrappingPaper += calculateWrappingPaper(box.l, box.w, box.h)
        totalRibbon += calculateRibbonLength(box.l, box.w, box.h)
    }

    println("Total Paper = ", int32(totalWrappingPaper))
    println("Total Ribbon = ", int32(totalRibbon))
}
