declare name "Risset Tone";
declare description "Jean Claude Risset's endless glissando";
declare author "Oli Larkin (contact@olilarkin.co.uk)";
declare copyright "Oliver Larkin";
declare version "0.1";
declare licence "GPL";

import("oscillator.lib");
import("effect.lib");

rate = hslider("rate", 0.01, -1, 1, 0.001);
Npartials = 10;//hslider("Npartials", 10, 4, 20, 1);

thin_env = exp(-4.8283*(1.-cos((2.0*PI)*(float(time) - (tablesize/2.))/tablesize)));
wide_env = 0.5 + 5. * cos((2.0*PI)*((float(time)-(tablesize/2.))/tablesize)) / 10.;

lookup(phase, env)=ss1+d*(ss2-ss1)
with {
  idx = int(phase * tablesize); 
  d = decimal(phase * tablesize);
  ss1 = rdtable(tablesize+1,env,idx);
  ss2 = rdtable(tablesize+1,env,idx+1);
};

rissetTone(freq, N) = phasor(freq) <: par(i, N, modphase(_, i) : partial) :> _
with {
  phasor(freq) = (freq/float(SR) : (+ : decimal) ~ _);

  modphase(x, i) = fmod(x+phaseDiff, 1.)
  with {
    phaseDiff = (1. / float(N)) * i;
  };
  
  partial(pos) = pos : *(120) : +(7) : midikey2hz : osc * lookup(pos, wide_env);
};

process = rissetTone(rate, Npartials) : *(1/Npartials) <: _,_;