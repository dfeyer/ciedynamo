dofile('muse/notes.lua')
dofile('muse/midi.lua')

midi = midi or Midi:new(1,1) -- output port, midi channel

scale = {}

-- Jambe (droite)
scale[1]  = {-1.4, 1.4}
scale[2]  = {-1.4, 1.4}
scale[3]  = {-1.4, 1.4}

-- Bras (droit)
scale[4]  = {-1.4, 1.4}
scale[5]  = {-1.4, 1.4}
scale[6]  = {-1.4, 1.4}

-- Jambe (gauche)
scale[7]  = {-1.4, 1.4}
scale[8]  = {-1.4, 1.4}
scale[9]  = {-1.4, 1.4}

-- Bras (gauche)
scale[10]  = {-1.4, 1.4}
scale[11]  = {-1.4, 1.4}
scale[12]  = {-1.4, 1.4}

input = {}

ct_wait_channel = {}
ct_lastvalue_channel = {}
ct_min_wait  = 30

function bang()
	scale_inputs(in1)

--	print(in1[1] .. " " .. in1[2] .. " " .. in1[3])
	
	-- Jambes
	sendToMIDI(input[1], 1) -- Rotation
	sendToMIDI(input[2], 2) -- Bascule
	
end

function sendToMIDI(source, channel)
	local notes = 0
	local velocity = 0
	local ct_wait = (current_time - (ct_wait_channel[channel] or 0)) -- time since last send
	
	notes = math.floor(source / 128)
	velocity = source - ( notes * 128)
	
	if ( ( ct_wait > ct_min_wait ) and ( ct_lastvalue_channel[channel] ~= source ) ) then
		-- print("Send note on channel\t" .. channel)
		midi:playC(notes, 0, 0, velocity, channel)
		ct_wait_channel[channel] = current_time
	end
	
	ct_lastvalue_channel[channel] = source
end

function scale_inputs(matrix)
	for i=1,12 do
		local val = matrix[i]
		local sca = scale[i]
		input[i] = fitToScale(val, sca[1], sca[2])
	end
end

function fitToScale(val, min, max)
	local val = val
	if (val <= min) then
  		local val = min
  	elseif (val >= max) then
  		local val = max
  	end

	return math.floor(16300 * ((val - min) / (max - min)))	
end