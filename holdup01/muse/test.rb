
if "   end" =~ /^\s*(elseif|else|end)\s*$/
  puts $~.to_a.inspect
end