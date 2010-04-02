--[[
Helper for movement match. Helps define precise match levels for each class of movements/vectors.
--]]

Match = {}

function Match:new()
  local t = {}
  
  --- public
  t.dist = {}
  t.bounds     = {}
  t.wait       = {} -- repetition interval in [ms]
  t.scale      = {} -- computed scale
  t.count      = {} -- number of values encountered
  t.convergence= 0.25
  
  --- private
  t._last      = nil -- last matched value
  t._last_time = 0
  
  function t:match(v, dist)
    if (v == nil or (v == self._last and (current_time - self._last_time) < self.wait[v]) or dist > self.dist[v]) then
      return nil
    end
    self._last_time = current_time
    self._last      = v
    return v
  end
  
  function t:set_default_bounds(b)
    local mt = {__index = function () return b end}
    setmetatable(t.bounds, mt)
  end
  
  function t:set_default_dist(d)
    local mt = {__index = function () return d end}
    setmetatable(t.dist, mt)
  end
  
  function t:set_default_wait(d)
    local mt = {__index = function () return d end}
    setmetatable(t.wait, mt)
  end
  
  t:set_default_bounds({60,127})
  t:set_default_dist(-1)
  t:set_default_wait(200)
  
  -- automatic scaling of random variable v (learns from input)
  function t:auto_scale(k, v)
    local scale  = self.scale[k] or {0,3.001}
    local avg    = (scale[1] + scale[2]) / 2
    local count  = self.count[k] or 0
    
    -- stupid scaling algorithm
    count = count + 1
    if (v > scale[2]) then
      -- maximal value is too small
      scale[2] = scale[2] + (v - scale[2]) / 2
    else
      -- maximal value is ok, but we shrink to make sure it is
      -- not too far away from our 'real' maximal values.
      scale[2] = scale[2] - self.convergence * (scale[2] - v) / count
    end
    
    if (v < scale[1]) then
      -- minimal value is too big
      scale[1] = scale[1] - (scale[1] - v) / 2
    else
      -- maximal value is ok, but we shrink to make sure it is
      -- not too far away from our 'real' maximal values.
      scale[1] = scale[1] + self.convergence * (v - scale[1]) / count
    end
    
    self.count[k] = count
    self.scale[k] = scale
    
    return t:scale_value(k, v)
  end
  
  function t:scale_value(k, v)
    local bounds = self.bounds[k] or {0,1}
    local scale  = self.scale[k] or {0,3.001}
    local new_v  = 0
    
    new_v  = bounds[1] + (v - scale[1]) * (bounds[2] - bounds[1]) / (scale[2] - scale[1])
    
    if (new_v > bounds[2]) then
      new_v = bounds[2]
    elseif (new_v < bounds[1]) then
      new_v = bounds[1]
    end
    return new_v
  end
  
  function t:print_scale(k)
    local scale = self.scale[k] or {0,0,001}
    print('scale for ', k, scale[1], scale[2])
  end
  
  return t
end

--- translate token ascii value to number

asc2num = {}
local mt = {__index = function () return 0 end}
setmetatable(asc2num, mt)

asc2num[46]  = 0 -- .
asc2num[49]  = 1
asc2num[50]  = 2
asc2num[51]  = 3
asc2num[52]  = 4
asc2num[53]  = 5
asc2num[54]  = 6
asc2num[55]  = 7
asc2num[56]  = 8
asc2num[57]  = 9
asc2num[97]  = 10 -- a
asc2num[98]  = 11 -- b
asc2num[99]  = 12 -- c
asc2num[100] = 13 -- d
asc2num[101] = 14 -- e
asc2num[102] = 15 -- f
asc2num[103] = 16 -- g
asc2num[104] = 17 -- h
asc2num[105] = 18 -- i
asc2num[106] = 19 -- j
asc2num[107] = 20 -- k
asc2num[108] = 21 -- l
asc2num[109] = 22 -- m
asc2num[110] = 23 -- n
asc2num[111] = 24 -- o
asc2num[112] = 25 -- p
asc2num[113] = 26 -- q
asc2num[114] = 27 -- r
asc2num[115] = 28 -- s
asc2num[116] = 29 -- t
asc2num[117] = 30 -- u
asc2num[118] = 31 -- v
asc2num[119] = 32 -- w
asc2num[120] = 33 -- x
asc2num[121] = 34 -- y
asc2num[122] = 35 -- z


num2asc = {}
local mt = {__index = function () return 0 end}
setmetatable(num2asc, mt)

num2asc[0  ] = 46  -- .
num2asc[1  ] = 49  
num2asc[2  ] = 50  
num2asc[3  ] = 51  
num2asc[4  ] = 52  
num2asc[5  ] = 53  
num2asc[6  ] = 54  
num2asc[7  ] = 55  
num2asc[8  ] = 56  
num2asc[9  ] = 57  
num2asc[10 ] = 97  -- a
num2asc[11 ] = 98  -- b
num2asc[12 ] = 99  -- c
num2asc[13 ] = 100 -- d
num2asc[14 ] = 101 -- e
num2asc[15 ] = 102 -- f
num2asc[16 ] = 103 -- g
num2asc[17 ] = 104 -- h
num2asc[18 ] = 105 -- i
num2asc[19 ] = 106 -- j
num2asc[20 ] = 107 -- k
num2asc[21 ] = 108 -- l