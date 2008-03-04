Rockwell B-1B Lancer "The Bone"


XXXXXX  Version Nr: 0012 03032008 XXXXXX



This aircraft model represents a hack of the B-1B variable wingsweep bomber. The available sweep angles are 15 (takeoff) 25 (slow flight) 45 (high altitude flight) 55/67 (low and high altitude fast flight). The wingsweep is simulated by adding lift/drag to the inner wing part. The outer wing part always stays at 67 degrees and represents the most accurate hack ;-). Afterburner is used for takeoff and for rapid climb/acceleration maneuvers.
The bone is limited to 3g at wartime (currently warning light flashes at 4g), so turning radius is huge at high speeds.


XXXX INSTRUCTIONS XXXX

Takeoff:

- swing wing to most forward position (15) --> button D/d (present at start)
- apply 1/2 flaps
- apply full throttle
- apply afterburners
- rotate at 160 - takeoff at 170/180 with full fuel weight

Flight:

- dependent on your altitude and speed choose 15/25/45/55/67 degrees wingweep (d/D)
- max speed at sea level is mach 1.2, at altitude mach 1.3, at altitude short periods 
  at mach 1.5 are possible, but you put the wings on danger to twist
- typical performance speed is around mach 0.8 - 0.95 @sea level and mach 0.9 - 1.2 at altitude.

- 15 degrees ws: used for takeoff/landing <290 knots @ sealevel
- 25 degrees ws: used for slow flight/refuelling < 350 knots @sealevel
- 45 degrees ws: used for cruise at high altitude (mach 0.6 - 0.75)
- 55 degrees ws: used for high/low alt flight (above mach 0.7)
- 67 degrees ws: used for high/low alt flight (above mach 0.8)


Landing:

- ws 15 degrees
- use 1/2 flaps (on short final put full flaps)
- touchdown speed is <175 knots with full fuel load, or 135 nearly empty



XXXX TERRAIN AVOIDANCE / FOLLOWING SYSTEMS XXXX

It's OSG baby!

Terrain Avoidance System (TAS)

Master switch activates terrain avoidance system (tas) (ON/OFF), range knob(RNG) setting for short distance terrain recognition setting (2.5)nm used for slow flying or a hard ride or switch to the medium setting (5)nm thats is used when flying faster (above 400kts @sl) and/or u want a more comfortably ride.
The CLR PLN settings are important as it clears terrain below the aircraft. The settings are 0, 100ft, 300ft, 500ft and 1000ft.
When the terrain avoid system gets active, it adds the desired clearance distance (CLR PLN) to your altitude and guides u over an obstacle. Afterwards it stays in horizontal flying mode, if you want e.g.:altitude hold mode you have to enable it manually again.

Terrain Following System (TFS)

There is a basic terrain following system (TFS) present. You have to enable the master switch ON/OFF, then the PRTY switch to TERRAIN FOLLOW. The PRTY switch toggles the build in tfs from flightgear named MAP(doesn't work very well with with tas) or enables the new tfs, native to the bone, by switching to TERRAIN FOLLOW especially when using the tas. The advantage of the new TFS system is its ability to look forward to scan the terrain in front of the plane.

The native tfs and the build in flightgear tfs(MAP) use the clearance settings from SET CLR.
The clearance settings start from 0ft and increase in 200ft increments up to 2000ft. A=0ft, B=200ft, C=400ft,..., F=1000ft,..., K=2000ft.

XXXX FCGMS Center of Gravity System XXXX

This system sets the Center of Gravity (CG) in % of MAC, and lets you manipulate it in a destinct range. Enable the system by switching on SET on the FCGMS panel and choose your desired CG position. The display to the right shows your current CG position. This is done by using shifting fuel between 2 tanks, so the system works only within a certain margin.


XXXX BLAST, FLARES, STROBE, SPOT XXXX

Based on preexisting osg files some eyecandy for engine blast, strobe and flares was added.
An experimental landing light can be activated by uncommenting the link in Models/b1b-trans.xml, and you have to recompile flightgear cvs with the following additions in /src/main/renderer.cxx.
In the class SGPuDrawable block after 
stateSet->setTextureAttribute(0, new osg::TexEnv(osg::TexEnv::MODULATE));
I added:
    // Test for more light sources
    stateSet->setMode(GL_LIGHTING, osg::StateAttribute::ON);
    stateSet->setMode(GL_LIGHT0, osg::StateAttribute::ON);
    stateSet->setMode(GL_LIGHT1, osg::StateAttribute::ON);

recompile current fgfs cvs and it should work.

It's OSG baby!

XXXX FEATURES XXXX

serial: none
name: none

j/k 	decrease/increase spoilers
o 	afterburner on
O	afterburner off
d	sweep wing backw
D	sweep wing fwd



XXXX PROGRESS XXXX


FDM:	 	alpha - in use / needs tuning		90%complete
3D model:	alpha - in use / refinements ..		70%complete
Textures:	alpha - in use / too few		30%complete
Animations:	alpha - in use / more to come		80%complete
Autopilot:	alpha - in use / needs finetuning	85%complete
3Dcockpit:	alpha - in use / needs completion	85%complete

XXXX AUTHORS XXXX

Main 3D model done by Paul Jay Schrenker.

Terms of usage: Released under terms of GPL v2. Falls under the term of "other work" in part 0. Source is the readable text of the .obj & .mtl files themselves.

This model was created via use of Wings3D. Wings3D is an open source 3D modeler and may be found at www.wings3d.com

FDM/Instruments/Animations/3D modelling by Markus Zojer

Terms of usage: Released under terms of GPL v2.


Have Fun! Good Luck!

Markus Zojer,  03/03/2008