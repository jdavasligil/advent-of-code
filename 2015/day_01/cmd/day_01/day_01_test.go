package main

import "testing"

type floorTest struct {
    arg1     string
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
        if output := getFloor(test.arg1); output != test.expected {
            t.Errorf("Floor %q not equal to expected %q", output, test.expected)
        }
    }
}

type getFirstFloorPositionTest struct {
    arg1     string
    arg2     int
    expected int
}

var getFirstFloorPositionTests = []getFirstFloorPositionTest {
    {")", -1, 1},
    {"()())", -1, 5},
}

func TestGetFirstFloorPosition(t *testing.T) {
    for _, test := range getFirstFloorPositionTests {
        if output := getFirstFloorPosition(test.arg1, test.arg2); output != test.expected {
            t.Errorf("Floor %q not equal to expected %q", output, test.expected)
        }
    }
}
