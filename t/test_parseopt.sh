#!/bin/sh

T() {
    opt=$(./parseopt "$@" 2>/dev/null) || set -- ERR
    eval "$opt"
    parsedargs="$*"
}

E() {
    for arg; do
        name=${arg%=*}
        exp=${arg#*=}
        eval value=\$$name
        test "$value" = "$exp" || return 1
    done
    return 0
}

A() {
    test "$parsedargs" = "$*"
}

R() {
    case $? in
        0) echo ok;;
        *) echo not ok
    esac
}    

echo 1..20

T '' a b c                && E                           && A a b c    ; R
T '' a -- b c             && E                           && A a -- b c ; R
T '' -- a b c             && E                           && A a b c    ; R
T '' -- -- a b c          && E                           && A -- a b c ; R
T '' -- -a b c            && E                           && A -a b c   ; R
T '' -v                                                  && A ERR      ; R
T v -v                    && E optv=-v                   && A          ; R
T v -vv                   && E optv=-vv                  && A          ; R
T v -vv -v                && E optv=-vvv                 && A          ; R
T vwx -v -w -x            && E optv=-v optw=-w optx=-x   && A          ; R
T vwx -vw -x              && E optv=-v optw=-w optx=-x   && A          ; R
T vwx -wxv                && E optv=-v optw=-w optx=-x   && A          ; R
T vwx -vw a b -x          && E optv=-v optw=-w           && A a b -x   ; R
T vwx -vw -- -x a b       && E optv=-v optw=-w           && A -x a b   ; R
T va:b: -a AAA -b BBB CCC && E opta=AAA optb=BBB         && A CCC      ; R
T va:b: -aAAA -bBBB CCC   && E opta=AAA optb=BBB         && A CCC      ; R
T va:b: -vaAAA -bBBB CCC  && E opta=AAA optb=BBB optv=-v && A CCC      ; R
T a: -a                                                  && A ERR      ; R
T va: -a -- -v            && E opta=-- optv=-v           && A          ; R
T va: -a -- -- -v         && E opta=--                   && A -v       ; R
