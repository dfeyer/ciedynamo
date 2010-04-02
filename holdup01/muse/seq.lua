Seq = {}

function Seq:new(seq, tempo, midi)
  local t = {}
  
  --- public
  t.next_q  = 0 -- next quantized play position
  t.midi    = midi -- midi object for output
  t.tempo   = tempo
  t.seq     = seq
  t.vel     = {}
  t.dur     = {}
  t.rubato  = {}
  t.counter = 0
  t.playing = false
  
  --- private
  -- nothing
  
  function t:sync(ct)
    self.next_q = ct + (60000 / self.tempo)
  end
  
  function t:play()
    local q = self.next_q
    if (current_time > q) then
      local p = 60000 / self.tempo
      
      if (self.playing) then
        local s = self.seq
        local vel = self.vel
        local dur = self.dur
        local i  = (self.counter % #s) + 1
        local vi = (self.counter % #vel) + 1
        local d  = (self.counter % #dur) + 1
        local w  = 0
        
        if (self.rubato) then
          local rub = self.rubato[1]
          local rub_amp = self.rubato[2]
      
          if (rub) then
            w = math.floor(math.random(p * rub_amp * 1.1) / (p * rub) ) * p * rub
          end
        end
      
        self.midi:play(s[i],dur[d],w,vel[vi])
      end
      
      self.next_q = q + math.ceil((current_time - q) / p) * p
      self.counter = self.counter + 1
    end
  end
  
  function t:start()
    self.playing = true
  end
  
  function t:toggle()
    if (self.playing) then
      self:stop()
    else
      self:start()
    end
  end

  function t:stop()
    self.playing = false
  end
  
  return t
end
