def parseopt(param, argv=ARGV)
  opts={}
  while a = argv.first
    z = a.chars
    break  if z.shift != "-" || a == "-" || argv.shift == "--"

    while (f = z.shift) && (param =~ /#{f}(:?)/ or abort "invalid flag -#{f}")
      if $1.empty?
        opts[f] = (opts[f] ||= 0) + 1
      else
        opts[f] = (z.empty? ? argv.shift : z.join) or
          abort "missing parameter for -#{f}"
        break
      end
    end
  end
  opts
end
