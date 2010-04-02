bell   = bell   or Midi:new(1, 15)

function pnoises(n, d)
  noises:play(n, d)
end

function lnoises(n, w)
  noises:legato(n, w)
end

function pminimoog(n, d)
  minimoog:play(n, d)
end

function lminimoog(n, d)
  minimoog:legato(n, d)
end

function pminimoo(n, d)
  minimoo:play(n, d)
end

function lminimoo(n, d)
  minimoo:legato(n, d)
end

function ppercu(n, d)
  percu:play(n, d)
end

function lpercu(n, d)
  percu:legato(n, d)
end

function pmoog(n, d, w, v)
  moog:play(n, d, w, v)
end

function lmoog(n, d)
  moog:legato(n, d)
end

function phorns(n, d)
  horns:play(n, d)
end

function lhorns(n, d)
  horns:legato(n, d)
end

function parturia(n, d)
  arturia:play(n, d)
end

function larturia(n, d)
  arturia:legato(n, d)
end

function pcbspizz(n, d)
  cbspizz:play(n, d)
end

function lcbspizz(n, d)
  cbspizz:legato(n, d)
end


function pproph(n, d)
  proph:play(n, d)
end
  
function lproph(n, d)
  proph:legato(n, d)
end

function ppiano(n, d)
  piano:play(n, d)
end

function lpiano(n, d)
  piano:legato(n, d)
end

function pbell(n, d)
  bell:play(n, d)
end

function lbell(n, d)
  bell:legato(n, d)
end

