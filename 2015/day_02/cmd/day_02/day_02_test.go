package main

import "testing"

type wrapTest struct {
    arg1     float32
    arg2     float32
    arg3     float32
    expected float32
}

var wrapTests = []wrapTest {
    {2.0, 3.0, 4.0, 58.0},
    {1.0, 1.0, 10.0, 43.0},
}

func TestCalculateWrappingPaper(t *testing.T) {
    for _, test := range wrapTests {
        if output := calculateWrappingPaper(test.arg1, test.arg2, test.arg3); output != test.expected {
            t.Errorf("Area %f is not equal to expected %f", output, test.expected)
        }
    }
}

type parseBoxTest struct {
    arg1     string
    expected BoxSize
}

var parseBoxTests = []parseBoxTest {
    {"11x12x2", BoxSize{11.0, 12.0, 2.0}},
    {"1x1x1", BoxSize{1.0, 1.0, 1.0}},
}

func TestParseBoxSize(t *testing.T) {
    for _, test := range parseBoxTests {
        if output := parseBoxSize(test.arg1); output != test.expected {
            t.Errorf("Dimensions %q are not equal to expected %f, %f, %f", test.arg1, output.l, output.w, output.h)
        }
    }
}
