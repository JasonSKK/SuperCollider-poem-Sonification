/*
Jason_SK
042420
"Guldhornene" [1803] by Adam Oehlenschläger.
Sonification
*/

/////////////////// PATH TO Guldhornene.txt \\\\\\\\\\\\\\\\\\
x = FileReader.read("PATH...PATH...PATH.../Guldhornene.txt",true, true ).postcs

//OPTIONAL
s.options.memSize;
s.quit;
s.options.memSize = 65536;
s.boot;


(
~r = {
    var i, c,  ss, f, b, b1;
    //INITIALIZATION
    i = 0;
    c = 0;
    ss = x[c][i];
    //WAVETABLE
    b = Buffer.alloc(s, 512/8, 1, {
        |buf| var ar = Array.fill(8, {1.0.rand.round(0.001)});
        buf.sine1Msg(ar)});//El.Guitar

    b1 = Buffer.alloc(s, 512, 1, {
        |buf| var ar = Array.fill(10, {654.rand});
        buf.sine2Msg(ar,[1,0,1,0,1,1])});//Bellish

    166.do{
        //Abort NIL Values --> Next Line
        if(ss.isNil, {c = c + 1; i = 0});
        ss = x[c][i];

        //NOT NIL VALUES
       if (ss.notNil,{
            ss.postln; //POST POEM WORDS
            ss = x[c][i].ascii;
            ss = ss.choose;

            f = ss;
            //IF NEGATIVE
            if (f.isNegative, {f = f * (-1)});
            //f.postln; //NEG VALUES POST

            //SOUND
            SynthDef("guldhornene",{
                |amp = 0.5|
                var env, env0, env1, envcl, out, out0, out1, outcl, sig, sig0, sig1, sig2, fionian, pangtr;
                pangtr = -0.5;
                //AMBIENT
                if (f <= 100, {
                    //f =  f.explin(0, 100, 40, 4000);
                    sig = LFTri.ar(Gendy1.kr(1, 5, 0.1, 1.0,  20, 2000, ampscale: 0.2, durscale: 0.12)) *
                    (3*SinOsc.ar(f, SinOsc.kr(1000).range(0.01, 0.999)));
                    sig = (sig * 0.666) + FreeVerb.ar(sig, 1.0, 0.777, 0.666);
                    env = Env.new([0, 1, 0.4, 0.6, 0.0],[4.1, 1.1, 0.5, 2.6] ).kr(doneAction:2);//AmpEnvelope
                    out = sig * env * amp * 0.03 * 0.1;
                    out = LPF.ar(out, 1200);
                    //f.postln; //VALUE AS FREQ POSTLN
                });

                //AMBIENT&&GUITAR
                if ( f <= 300, {

                    //f =  f.explin(0, 100, 40, 400);
                    sig = Array.fill(5, {SinOsc.ar(f* Rand(0.333, 1.0), Rand(0.1, 1.0), Rand(0.0, 0.4))*8});
                    sig  = sig + Array.fill(2, {VarSaw.ar(f* Rand(0.888, 0.333), Rand(0.0, 1.0), Rand(0.0 , 1.0),Rand(0.1, 0.25))*8});
                    sig = sig + (Dust.ar(3, 0.8)) *0.3;
                    sig = sig + SinOsc.ar(f, mul: 0.5);
                    env = EnvGen.ar(Env.new([0.0, 1.0, 0.666, 0.8, 0.0],[5, 1, 0.5, 5]), Line.kr(1.0, 0.0, 15.0, doneAction:2));
                    out = sig * env * 0.05 ;
                    out = FreeVerb.ar(out, 0.33, 1.0, 1.0);
                    out = sig * env * 0.1;
                    out = HPF.ar(out, 150);

                    if ((f >= 75) && (f <= 116), {
                    //GTR MEL
                    //GUIDE    IONIAN -->> "KEY C" ////// 264   297   330   352    396    440   495 \\\\\\\\
                    if(f < 80, {fionian = 264; pangtr = -0.9});
                    if ((f >= 80) && (f < 90), { fionian = 297; pangtr = -0.75});
                    if ((f >= 90) && (f < 100), { fionian = 330; pangtr = -0.7});
                    if ((f >= 100) && (f < 104), { fionian = 352; pangtr = -0.2});

                        //BELL&&NOTE_GTR
                        if ((f >= 104) && (f < 110), { fionian = 396; pangtr = 0.4;
                            sig1 = Shaper.ar(b1.bufnum, LFSaw.ar(f, LFNoise2.kr(1).range(0.0, 1.0), /*SinOsc.kr(Line.kr(1, 12, 1, 0.1))*/));
                            env1 = Env.perc(0.003, pi/2).kr(doneAction:0);//Amp_Env
                            out1 = sig;
                            out1 = (out1 * 0.5) + DelayC.ar(out1, 1, Rand(0.11, 0.2), 0.4, out1);//SomeDelay
                            out1 = (out1) + FreeVerb.ar(out1, 1.0, 0.8, 0.666, 0.766) * env * 0.01;
                            Out.ar(0, Pan2.ar(out1, pangtr));
                    });

                    if ((f >= 110) && (f < 115), { fionian = 440; pangtr = -0.4});
                    if ((f >= 115), { fionian = 352});
                    sig0 = Shaper.ar(b.bufnum, LFSaw.ar(fionian, LFNoise2.kr(1).range(0.0, 1.0), /*SinOsc.kr(Line.kr(1, 12, 1, 0.1))*/));
                    env0 = Env.perc(2.5, pi).kr(doneAction:0);//Amp_Env
                    out0 = sig0  * 0.05 ;
                    out0 = (out0 * 0.5) + DelayC.ar(out0, 0.2, Rand(0.05, 0.3), 2*pi.reciprocal, out0);//SomeDelay
                    out0 = ((out0 * 0.1) + FreeVerb.ar(out0 , 1.0, 1.0, 0.666))* env0 * 0.5;

                    //out = out + out0;
                        Out.ar(0, Pan2.ar(out0, pangtr))

                    });
                    //f.postln; //VALUE AS FREQ POSTLN
                });

                //GLING SOUND
                if ((f >116) && (f <= 126), {
                    sig = Shaper.ar(b1.bufnum, LFSaw.ar(f, LFNoise2.kr(1).range(0.0, 1.0), /*SinOsc.kr(Line.kr(1, 12, 1, 0.1))*/));
                    env = Env.perc(0.003, pi/2).kr(doneAction:2);//Amp_Env
                    out = sig  * amp * 0.1;
                    out = (out * 0.5) + DelayC.ar(out, 1, Rand(0.11, 0.2), 0.4, out);//SomeDelay
                    Out.ar(1, GVerb.ar(out, 100, pi*pi, 0.28 , 0.5, pi**2.5, pi.reciprocal, 0.5, 0.3) * env * 0.5);
                   // f.postln; //VAL AS FREQ POSTLN
                });

                //CLICKING
                if((f < 100) && (f >= 69), {
                    sig2 = ClipNoise.ar(0.5) + BrownNoise.ar(0.7);
                    envcl = Env.circle([0, 1, 0.001, 0], [0.001, 0.015, 1], -8).kr(doneAction:2);
                    sig2 = BPF.ar(sig2, 2000, 0.5);
                    outcl = sig2 + FreeVerb.ar(sig2, 1.0, 0.666,0.666);
                    outcl = sig2 * envcl * 0.6;
                    Out.ar(0, Pan2.ar(outcl, Rand(0.666, 0.777)))
                });

                //OUTPUT
                Out.ar([0,1], out);

            }).play
        }
        );

        i = i + 1;
        (f/90).wait;
    };
}.fork
)

