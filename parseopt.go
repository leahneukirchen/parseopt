package main

import (
	"errors"
	"fmt"
	"os"
	"strings"
)

func main() {
	opt, args, err := parseopt("n:C:K:P", os.Args[1:])
	fmt.Printf("%v %v %v\n", opt, args, err)
}

func parseopt(flags string, in_args []string) (opts map[string]string, args []string, err error) {
	opts = make(map[string]string)
	args = in_args

	for ; len(args) > 0; args = args[1:] {
		if args[0] == "--" {
			args = args[1:]
			break
		}
		if args[0][0] != '-' {
			break
		}

		arg := args[0][1:]

		for len(arg) > 0 {
			f := arg[0:1]
			arg = arg[1:]
			
			if i := strings.Index(flags, f + ":"); i >= 0 {
				if len(arg) == 0 {
					args = args[1:]
					if len(args) == 0 {
						err = errors.New("parseopt: no argument for -" + f)
						return
					}
					arg = args[0]
				}
				opts[f] = arg
				break
			} else if i := strings.Index(flags, f); i >= 0 {
				opts[f] = "-" + f
			} else {
				err = errors.New("parseopt: invalid option -" + f)
				return
			}
		}
	}
	
	return
}
