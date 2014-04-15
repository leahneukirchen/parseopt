#!/usr/bin/env ruby
require './parseopt'

def test(str, argv, exp_opt, exp_argv)
  begin
    STDERR.reopen("/dev/null")
    opt = parseopt(str, argv)
  rescue Exception
    opt = nil
  end

  if opt == exp_opt && argv == exp_argv
    puts "ok"
  else
    puts "not ok - #{caller.first}, got #{opt}/#{argv}"
  end
end

puts "1..20"
test "", %w{a b c},                  {}, %w{a b c}
test "", %w{a -- b c},               {}, %w{a -- b c}
test "", %w{-- a b c},               {}, %w{a b c}
test "", %w{-- -- a b c},            {}, %w{-- a b c}
test "", %w{-- -a -bc},              {}, %w{-a -bc}
test "", %w{-v},                     nil, []
test "v", %w{-v},                    {"v"=>"-v"}, %w{}
test "v", %w{-vv},                   {"v"=>"-vv"}, %w{}
test "v", %w{-vv -v},                {"v"=>"-vvv"}, %w{}
test "vwx", %w{-v -w -x},            {"v"=>"-v","w"=>"-w","x"=>"-x"}, %w{}
test "vwx", %w{-vw -x},              {"v"=>"-v","w"=>"-w","x"=>"-x"}, %w{}
test "vwx", %w{-wxv},                {"v"=>"-v","w"=>"-w","x"=>"-x"}, %w{}
test "vwx", %w{-vw a b -x},          {"v"=>"-v","w"=>"-w"}, %w{a b -x}
test "vwx", %w{-vw -- -x a b},       {"v"=>"-v","w"=>"-w"}, %w{-x a b}
test "va:b:", %w{-a AAA -b BBB CCC}, {"a"=>"AAA", "b"=>"BBB"}, %w{CCC}
test "va:b:", %w{-aAAA -bBBB CCC},   {"a"=>"AAA", "b"=>"BBB"}, %w{CCC}
test "va:b:", %w{-vaAAA -bBBB CCC},  {"a"=>"AAA", "b"=>"BBB", "v"=>"-v"}, %w{CCC}
test "a:", %w{-a},                   nil, []
test "va:", %w{-a -- -v},            {"a"=>"--", "v"=>"-v"}, %w{}
test "va:", %w{-a -- -- -v},         {"a"=>"--"}, %w{-v}
