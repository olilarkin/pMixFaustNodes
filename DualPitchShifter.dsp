declare name "Dual Pitch Shifter";
declare description "Dual Channel pitch shifter, based on Faust pitch_shifter.dsp by Grame";
declare author "Oli Larkin (contact@olilarkin.co.uk)";
declare copyright "Oliver Larkin";
declare version "0.1";
declare licence "GPL";

import("stdfaust.lib");

msec = ma.SR/1000.0;
shiftl = hslider("Shift L [unit:semitones] [OWL:PARAMETER_A]", 0, -12, +12, 0.1);
shiftr = hslider("Shift R [unit:semitones] [OWL:PARAMETER_B]", 0, -12, +12, 0.1);
ws = hslider("Window Size [unit:ms] [OWL:PARAMETER_C]", 50, 20, 1000, 1) * msec : si.smooth(ba.tau2pole(0.005));
mix = hslider("Mix[OWL:PARAMETER_D]", 0.5, 0, 1, 0.01) : si.smooth(ba.tau2pole(0.005));

xf = 20 * msec;
	
process(l,r) = l,r <: *(1-mix), *(1-mix), ef.transpose(ws, xf, shiftl, l)*mix, ef.transpose(ws, xf, shiftr, r)*mix :> _,_;
