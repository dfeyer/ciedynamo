dofile('muse/notes.lua')
dofile('muse/midi.lua')

midi = midi or Midi:new(1, 1) -- output port, midi channel

scale = {}
--
scale[1]  = {-0.5, 0.5}
scale[2]  = {-1, 1}
scale[3]  = {-1, 1}
scale[4]  = {-1, 1}
scale[5]  = {-1, 1}
scale[6]  = {-1, 1}
scale[7]  = {-1, 1}
scale[8]  = {-1, 1}
scale[9]  = {-1, 1}
scale[10] = {-1, 1}
scale[11] = {-1, 1}
scale[12] = {-1, 1}
input = {}

midi.ct_enable[19] = true

function bang()
	scale_inputs(in2)
--	print(in3)
--	print(input[1])
	x = compute_dist(input[1])
	print(x, input[1])
	midi:ctrl(19, input[1])
end

function scale_inputs(matrix)
	for i=1,12 do
		local val = matrix[i]
		local sca = scale[i]
		input[i] = math.floor(128 * (val - sca[1]) / (sca[2] - sca[1]))
	end
end

speed = 0 --speed or 0
pos   = 0 --pos or 0

function compute_dist(ctrl_value)
	local acc = (ctrl_value - 64) / 12800
	local delta_t = 1
	speed = speed + acc
	pos = pos + speed + acc * delta_t
	return pos
end