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
