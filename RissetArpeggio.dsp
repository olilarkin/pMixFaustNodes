declare name "Risset Arpeggio";
declare description "Jean Claude Risset's Harmonic Arpeggio Effect";
declare author "Oli Larkin (contact@olilarkin.co.uk)";
declare copyright "Oliver Larkin";
declare version "0.1";
declare licence "GPL";

import("oscillator.lib");
import("music.lib");

fd = hslider("detune amount [unit:%]", 5., 0., 100., 0.01) : smooth(0.999) : *(0.01);
f = hslider("f0", 100, 40, 500, 1) : smooth(0.999);
spread = hslider("spread", 1., 0., 1., 0.01) : smooth(0.999);
l(i) = hslider("harmonic levels%3i", 1., 0., 1., 0.01) : smooth(0.999);
vol = hslider("main volume", 0., -70., 0., 0.01) : db2linear : smooth(tau2pole(1)) : *(0.2);
N = 8;

rissetarp = par(i, N, gen(i)) :> _,_
with {
  gen(idx) = osc(thisFreq) : chebychevpoly((1., l(1), l(2), l(3), l(4), l(5))) : *(vol) : pan(idx)
  with {
    thisFreq = f + ((idx-4) * fd);
  };
  
  pan(s) = _ <: *(v), *(1-v)
  with {
    spreadScale = (1/(N-1));
    v = 0.5 + ((spreadScale * s) - 0.5) * spread;
  };
};

process = rissetarp <: _,_;