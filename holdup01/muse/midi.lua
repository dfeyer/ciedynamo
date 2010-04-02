--[[
The MidiIO object eases sending midi events with functions such as 'play', 'legato', etc.

--]]



-- Stack Table
-- Uses a table as stack, use <table>:push(value) and <table>:pop()
-- Lua 5.1 compatible

-- GLOBAL
Midi = {}

-- Create a Table with stack functions
function Midi:new(port, channel)

  -- object table
  local t = {}
  
  --- public
  t.port       = port  -- output port
  t.channel    = channel -- midi channel to send events to
  t.velocity   = 70
  t.transpose  = 0
  t.duration   = 300
  t.ct_enable  = {}
  t.ct_min_wait  = {} -- minimal time between new send of ctrl change
  t.ct_fast_wait = {} -- minimal time when change is big
  
  --- private stuff
  -- current notes playing without a defined end (legato)
  t._last_notes = nil
  t._last_time  = 0 -- last event (used to trigger relative note)
  t._ct_last    = {} -- last ctrl value per ctrl key
  t._ct_last_time = {}
  
  function t:playV(note, velo, duration, when)
    self.play(note, duration, when, velo)
  end

  function t:play(notes, duration, when, velo)
    local d = duration or self.duration
    local v = velo or self.velocity
    local w = when or 0
    local note
    
  	-- note off last note
    if (self._last_notes) then
      t:note_off()
    end

  	-- will play until note off
    if (d == 0) then
  		self._last_notes = notes
  	end
  	
  	if (notes == nil) then
  		return
  	end

    if (type(notes) == 'table') then
  		-- chord
      for k,v in ipairs(notes) do
        if (type(v) == 'string') then
          note = N[v]
        else
          note = v
        end
        if (note) then
          send_note(self.port, note + self.transpose, v, d, self.channel, w) -- port, note, velo, length, channel, time
        end
      end
    else
  		-- note
  		if (type(notes) == 'string') then
        note = N[notes]
      else
        note = notes
      end
      if (note) then
        send_note(self.port, note + self.transpose, v, d, self.channel, w) -- port, note, velo, length, channel, time
      end
    end
  	self._last_time = current_time
  end


  function t:note_off(note_off)
    local note = note_off or self._last_notes
    
    if (type(note) == 'table') then
  		-- chord
      for k,v in ipairs(note) do
        if (type(v) == 'string') then
          note = N[v]
        else
          note = v
        end
        if (note) then
          send_note(self.port, note, 0, 0, self.channel, 0) -- port, note, velo, length, channel, time
        end
      end
    else
  		-- note
  		print('off', note)
  		if (type(note) == 'string') then
        note = N[note]
      end
      print('>>', note)
      if (note) then
        send_note(self.port, note, 0, 0, self.channel, 0) -- port, note, velo, length, channel, time
      end
    end
    
    if (not note) then
    	self._last_notes = nil
  	end
  end
  
  
  -- play until next note
  function t:legato(note, when)
     t:play(note, 0, when)
  end
  
  -- send a control change
  function t:ctrl(id, ctrl_value)
    if (self.ct_enable[id] == nil) then return end
    local ct = math.floor(ctrl_value)
    local ct_last = self._ct_last[id] or 0 -- last ctrl_value
    local ct_wait = (current_time - (self._ct_last_time[id] or 0)) -- time since last ctrl change
    local ct_min_wait  = self.ct_min_wait[id]  or 30
    local ct_fast_wait = self.ct_fast_wait[id] or ct_min_wait
    
    if (ct < 1) then ct = 1 end
    if (ct > 127) then ct = 127 end
    if (ct ~= ct_last and (ct_wait > ct_min_wait or (ct_wait > ct_fast_wait and math.abs(ct - ct_last) > 5))) then
      send_ctrl(self.port, id, ct, self.channel, 0 ) -- port, ctrl, value, channel, time
      self._ct_last[id] = ct
      self._ct_last_time[id] = current_time
    end
  end
  
  return t
end
