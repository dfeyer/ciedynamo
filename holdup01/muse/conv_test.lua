dofile('match.lua')

mat = Match:new()
mat.bounds[1]       = {30,127}

i = i or 0

mat.scale[1] = {0,0}
mat.count[1] = 0
mat.convergence = 0.25
function bang()
  i = i + 1
  v = math.sin(math.pi * i / 10) * math.sin(math.pi * i / 100)
  
  mat:auto_scale(1, v)
  scale = mat.scale[1]
  
  send(1, {scale[1], v, scale[2]})
end

