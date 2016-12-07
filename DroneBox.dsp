declare name "DroneBox";
declare description "Stereo Sympathetic Resonance Generator";
declare author "Oli Larkin (contact@olilarkin.co.uk)";
declare copyright "Oliver Larkin";
declare version "0.1";
declare licence "GPL";

import("stdfaust.lib");

smooth_time = 0.005; // secs

coarse_pitch = hslider("Coarse Pitch [unit:semitones] [OWL:PARAMETER_A]", 48, 36, 60, 1);
fine_pitch = hslider("Fine Pitch [unit:cents] [OWL:PARAMETER_B]", 0., -1., 1., 0.001);
t60 = hslider("Decay [unit:seconds] [OWL:PARAMETER_C]", 4, 0.1, 120, 0.01) : si.smooth(ba.tau2pole(smooth_time));
mix = hslider("Mix [OWL:PARAMETER_D]", 0.5, 0, 1, 0.01) : si.smooth(ba.tau2pole(smooth_time));
damp = 0.3;

dtmax = 4096;
NStrings = 4;

ratios(0) = 1.;
ratios(1) = 1.5;
ratios(2) = 2.;
ratios(3) = 3.;

f = ba.midikey2hz(coarse_pitch+fine_pitch) : si.smooth(ba.tau2pole(smooth_time));

string(x, s) = (+ : de.fdelay(dtmax, dtsamples)) ~ (*(fbk))
//string(x, s) = (+ : de.fdelay(dtmax, dtsamples)) ~ (dampingfilter : *(fbk))
with {
	thisFreq = f * ratios(s);
	dtsamples = (ma.SR/thisFreq) - 2;
	fbk = pow(0.001,1.0/(thisFreq*t60));
	h0 = (1. + damp)/2; 
	h1 = (1. - damp)/4;
	dampingfilter(x) = (h0 * x' + h1*(x+x''));
};

dronebox(l, r) = l, r <: par(s, NStrings, string(l, s), string(r, s)) :> _,_;
process(l, r) = l, r <: *(1-mix), *(1-mix), (dronebox(l, r) : *(mix*0.25), *(mix*0.25)) :> _,_;