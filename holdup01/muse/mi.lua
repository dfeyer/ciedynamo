dofile('notes.lua')
dofile('midi.lua')
dofile('seq.lua')

noise_nicho    = noise_nicho    or Midi:new(1,7)
arturia_sarah  = arturia_sarah  or Midi:new(1,2)
proph_caroline = proph_caroline or Midi:new(1,5)
prophb_m       = prophb_m       or Midi:new(1,5)
piano_m        = piano_m        or Midi:new(1,7)

noises  = noises  or Seq:new({'G2', 'F2', 'F2', 'F2'},480, noise_nicho)
beat    = beat    or Seq:new({'C2'},180, noise_nicho)
arturia = arturia or Seq:new({}, 120, arturia_sarah)
proph   = proph   or Seq:new({}, 120, proph_caroline)
prophb  = prophb  or Seq:new({}, 120, prophb_m)
piano   = piano   or Seq:new({}, 120, piano_m)

noises.seq  = {'F2', '-', 'G2', '-'}
noises.vel  = {30  ,  30 , 127 ,  30,  30 }
noises.dur  = {50  ,  50 ,  50 ,  50,   50, 2000 }


beat.seq    = {'E1', 'Ab1', 'E1', 'Ab1', 'C0',
               'E1', 'Ab1', 'E1', 'Ab1', 'F0',
               'E1', 'Ab1', 'E1', 'Ab1', 'C0',
               'E1', 'Ab1', 'E1', 'Ab1', 'D0'
}
beat.vel    = {120, 30}

arturia.seq = {'C3', '-', 'Eb3', '-', 'G3',
               'C3', '-', 'Eb3', '-', 'G3',
               'C3', '-', 'Eb3', '-', 'Ab3',
               'B2', 'D3', 'Eb3', '-', 'G3'
}
arturia.dur = {200, 500, 200, 200, 200, 200, 200}

proph_sequences = {
{ 'Eb3',  '-',  'G3', 'Ab3',  '-', '-', 
  'Eb3',  '-',  'G3',  'C3',  '-', '-',  
  'Eb3',  '-', 'Ab3',  'B2', 'D3', 'Eb3',
    '-', 'G3',  'B2',  'C3',  '-', '-'},
  
{ 'C3',  '-',  'Ab2', '-', 'C3',  '-',
  '-', 'F3' ,'Gb3', 'D3', 'Eb3', '-',  
  '-', 'Eb3',  '-', 'Ab3', 'B2', 'D3', 
  'Eb3',  '-', 'G3', 'Db3', 'C3', 'Db3',},
  
{ 'C3',  '-',  'D3', '-', 'Eb3',  '-',
  '-', 'F3' ,'Gb3', 'D3', 'Eb3', '-',  
  '-', 'Eb3',  '-', 'Ab3', 'B2', 'D3', 
  'Eb3',  '-', 'G3', 'Gb3', 'Ab3', 'C4',},

{ 'Eb4',  'F4',  'Gb4', '-', '-',  '-',
  '-', 'Ab4' ,'-', 'Bb4', '-', 'C5',  
  'B4', 'Eb4',  '-', 'D5', 'Eb5', 'Gb4', 
  'Eb4',  '-', 'G3', '-', 'Bb3', '-',}

}

proph_phases = {1,1,1,1, 3,3,3,3, 2,2,2,3, 4,4,3,4}
proph_caroline.transpose = 0 -- -7

proph.dur    = {300, 500, 300, 300, 300, 300, 300}
proph.vel    = {30, 80, 30, 90}
proph.rubato = {1/32, 1/20} -- quantize rubato to 1/32 of period..., max distance 1/20



prophb.seq = {'Eb2','-','D2','-','D2','Eb2','Eb2','-',
              'Eb2','-','D2','-','D2','Gb2','-'}
prophb.dur = {200}
prophb.vel = {20}
prophb_m.channel   = 5
prophb_m.transpose = -36

piano.seq = proph_sequences[1]
piano_m.channel = 6
piano.dur = {1500}
piano.vel = {30,40,50}
piano.rubato = {1/32, 1/20} -- quantize rubato to 1/32 of period..., max distance 1/20

if (not j) then
  noises:start()
  beat:start()
  arturia:start()
  proph:start()
  prophb:start()
  piano:start()
end

noises.tempo  = 240
beat.tempo    = 120
arturia.tempo = 90
proph.tempo   = 240
prophb.tempo   = 240
piano.tempo   = 120

i = i or 0
j = j or 0
proph_i = proph_i or 0
piano_i = piano_i or 0
v = {0,0,0}

function bang()
  i = i + 1
  noises:play()
  beat:play()
  arturia:play()
  
  prophb:play()
  if (v[1] > 0) then
    if (i % 5 ==0 ) then proph:play() end
  elseif (v[2] > 0) then
    proph:play()
  else
    piano:play()
  end
  
  if (piano.counter % 48 == 0) then
    piano_i = piano_i + 1
    local s = proph_phases[(piano_i % #proph_phases) + 1]
    piano.seq = proph_sequences[s]
  end
  
  if (proph.counter % 48 == 0) then
    proph_i = proph_i + 1
    local s = proph_phases[(proph_i % #proph_phases) + 1]
    proph.seq = proph_sequences[s]
  end
  
  if (i % 48 == 0) then
    j = j + 1
    print(j)
    if (j % 4 == 0 and math.random(10) > 5) then
      noises:toggle()
      beat:toggle()
    end
    
    if (j % 5 == 0 and math.random(10) > 4) then
      prophb:toggle()
    end
  end
end

