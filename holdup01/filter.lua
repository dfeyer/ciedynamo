dofile('muse/notes.lua')
dofile('muse/midi.lua')

midi = midi or Midi:new(1,1) -- output port, midi channel

to_scale = 16380

scale = {}

-- Jambe (droite)
scale[1]  = {-1.65, 1.65}
scale[2]  = {-1.65, 1.65}
scale[3]  = {-1.65, 1.65}

-- Bras (droit)
scale[4]  = {-1.65, 1.65}
scale[5]  = {-1.65, 1.65}
scale[6]  = {-1.65, 1.65}

-- Jambe (gauche)
scale[7]  = {-1.65, 1.65}
scale[8]  = {-1.65, 1.65}
scale[9]  = {-1.65, 1.65}

-- Bras (gauche)
scale[10]  = {-1.65, 1.65}
scale[11]  = {-1.65, 1.65}
scale[12]  = {-1.65, 1.65}

input = {}

ct_wait_channel = {}
ct_lastvalue_channel = {}
ct_min_wait  = 12
ct_diff_min = 2

function bang()
	scale_inputs(in2)
	
	local bascule = input[4] or 0
	local rotation = input[5] or 0
	
--	print(in2)
--	print(input[1] .. "\t" .. input[2] .. "\t" .. input[3])
	
	sendToMIDI(bascule, 1) -- Rotation	
	sendToMIDI(rotation, 2) -- Bascule
	
end

function sendToMIDI(source, channel)
	local notes = math.floor(source / 128)
	local velocity = source - ( notes * 128)
	local ct_wait = (current_time - (ct_wait_channel[channel] or 0)) -- time since last send
	local ct_diff = source - (ct_lastvalue_channel[channel] or 0)
	
	if (ct_diff < 0) then
		ct_diff = ct_diff * -1
	end
	
	if ( ( ct_wait > ct_min_wait ) and ( ct_diff > ct_diff_min ) ) then
--		print("Send note on channel\t" .. channel)
		midi.channel = channel
		midi:play(notes, 0, 0, velocity)
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
	return math.floor(to_scale * ((val - min) / (max - min)))	
end