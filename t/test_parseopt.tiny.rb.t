#!/usr/bin/env ruby
require './parseopt.tiny'

def test(str, argv, exp_opt, exp_argv)
  begin
    ARGV.replace argv
    opt = parseopt(str)
  rescue Exception
    opt = nil
  end

  if opt == exp_opt && ARGV == exp_argv
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
test "", %w{-v},                     {}, %w{}   # NB!
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
test "a:", %w{-a},                   {"a"=>nil}, []   # NB!
test "va:", %w{-a -- -v},            {"a"=>"--", "v"=>"-v"}, %w{}
test "va:", %w{-a -- -- -v},         {"a"=>"--"}, %w{-v}
