package main

import "testing"

type floorTest struct {
    dirs     string
    expected int
}

var floorTests = []floorTest {
    {"(())", 0},
    {"()()", 0},
    {"(((", 3},
    {"(()(()(", 3},
    {"))(((((", 3},
    {"())", -1},
    {"))(", -1},
    {")))", -3},
    {")())())", -3},
}

func TestGetFloor(t *testing.T) {
    for _, test := range floorTests {
        if output := getFloor(test.dirs); output != test.expected {
            t.Errorf("Floor %q not equal to expected %q", output, test.expected)
        }
    }
}
