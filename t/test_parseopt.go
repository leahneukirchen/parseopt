package main

import (
	".."
	"fmt"
	"reflect"
	"runtime"
)

func test(flags string, in_args []string, exp_opt map[string]string, exp_args []string) {
	opt, args, err := parseopt.Parseopt(flags, in_args)

	if (err != nil && exp_opt == nil) ||
		(reflect.DeepEqual(opt, exp_opt) && reflect.DeepEqual(args, exp_args)) {
		fmt.Printf("ok\n")
	} else {
		_, file, line, _ := runtime.Caller(1)
		fmt.Printf("not ok - %s:%d, got %v/%v\n", file, line, opt, args)
	}
}

type S []string
type M map[string]string

func main() {
	fmt.Printf("1..20\n")
	
	test("", S{"a", "b", "c"}, M{}, S{"a", "b", "c"})
	test("", S{"a", "--", "b", "c"}, M{}, S{"a", "--", "b", "c"})
	test("", S{"--", "a", "b", "c"}, M{}, S{"a", "b", "c"})
	test("", S{"--", "--", "a", "b", "c"}, M{}, S{"--", "a", "b", "c"})
	test("", S{"--", "-a", "-bc"}, M{}, S{"-a", "-bc"})

	test("", S{"-v"}, nil, nil)
	test("v", S{"-v"}, M{"v": "-v"}, S{})
	test("v", S{"-vv"}, M{"v": "-vv"}, S{})
	test("v", S{"-vv", "-v"}, M{"v": "-vvv"}, S{})

	test("vwx", S{"-v", "-w", "-x"}, M{"v": "-v", "w": "-w", "x": "-x"}, S{})
	test("vwx", S{"-vw", "-x"}, M{"v": "-v", "w": "-w", "x": "-x"}, S{})
	test("vwx", S{"-wxv"}, M{"v": "-v", "w": "-w", "x": "-x"}, S{})
	test("vwx", S{"-v", "-w", "a", "b", "-x"}, M{"v": "-v", "w": "-w"}, S{"a", "b", "-x"})
	test("vwx", S{"-v", "-w", "--", "-x", "a", "b"}, M{"v": "-v", "w": "-w"}, S{"-x", "a", "b"})

	test("va:b:", S{"-a", "AAA", "-b", "BBB", "CCC"}, M{"a": "AAA", "b": "BBB"}, S{"CCC"})
	test("va:b:", S{"-aAAA", "-bBBB", "CCC"}, M{"a": "AAA", "b": "BBB"}, S{"CCC"})
	test("va:b:", S{"-vaAAA", "-bBBB", "CCC"}, M{"a": "AAA", "b": "BBB", "v": "-v"}, S{"CCC"})
	test("a:", S{"-a"}, nil, nil)
	test("va:", S{"-a", "--", "-v"}, M{"a": "--", "v": "-v"}, S{})
	test("va:", S{"-a", "--", "--", "-v"}, M{"a": "--"}, S{"-v"})
}
