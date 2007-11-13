setlistener("/sim/signals/fdm-initialized", func {
	init_b1b();
});

init_b1b = func {
setprop("sim/current-view/field-of-view", 60);
setprop("autopilot/settings/target-pitch-deg", 2);
setprop("controls/switches/terra-report", 0);
setprop("controls/switches/fltdir", 0.25);
setprop("controls/switches/radar-range", 0.25);
setprop("controls/switches/terrain-avoid-clrpln", 0);
setprop("controls/switches/terrain-avoid-rng", 0);
setprop("controls/switches/terrain-avoid-clr1000", 0);
setprop("instrumentation/teravd/target-vfpm", 0);
setprop("instrumentation/teravd/target-alt", 0);
setprop("controls/switches/terrain-avoid-rng-25", 0);
setprop("controls/switches/terrain-avoid-rng-50", 0);
setprop("controls/switches/terrain-follow-map", 0);
setprop("controls/switches/terrain-follow-clr", 0);
setprop("sim/panel-hotspots", 1);
wingSweep(1);
wingSweep(1);
wingSweep(1);
wingSweep(1);
#fuel_syst();
settimer(eng_state, 3);
print ("B-1B warming up!");
}

aftburn_on = func {

#if (on > 0) {

setprop("controls/engines/engine[0]/afterburner", 1);
setprop("controls/engines/engine[1]/afterburner", 1);
setprop("controls/engines/engine[2]/afterburner", 1);
setprop("controls/engines/engine[3]/afterburner", 1);

#  } else {
#   setprop("controls/engines/engine[0]/afterburner", 0);
#   setprop("controls/engines/engine[1]/afterburner", 0);
#   setprop("controls/engines/engine[2]/afterburner", 0);
#   setprop("controls/engines/engine[3]/afterburner", 0);

#     }

}

aftburn_off = func {

setprop("controls/engines/engine[0]/afterburner", 0);
setprop("controls/engines/engine[1]/afterburner", 0);
setprop("controls/engines/engine[2]/afterburner", 0);
setprop("controls/engines/engine[3]/afterburner", 0);
}

##
# Wrapper around stepProps() which emulates the "old" wing sweep behavior for
# configurations that aren't using the new mechanism.
#
wingSweep = func {
    if(arg[0] == 0) { return; }
    if(props.globals.getNode("/sim/wing-sweep") != nil) {
        stepProps("/controls/flight/wing-sweep", "/sim/wing-sweep", arg[0]);
        return;
    }
    # Hard-coded flaps movement in 3 equal steps:
    val = 0.25 * arg[0] + getprop("/controls/flight/wing-sweep");
    if(val > 1) { val = 1 } elsif(val < 0) { val = 0 }
    setprop("/controls/flight/wing-sweep", val);
}

stepProps = func {
    dst = props.globals.getNode(arg[0]);
    array = props.globals.getNode(arg[1]);
    delta = arg[2];
    if(dst == nil or array == nil) { return; }

    sets = array.getChildren("setting");

    curr = array.getNode("current-setting", 1).getValue();
    if(curr == nil) { curr = 0; }
    curr = curr + delta;
    if   (curr < 0)           { curr = 0; }
    elsif(curr >= size(sets)) { curr = size(sets) - 1; }

    array.getNode("current-setting").setIntValue(curr);
    dst.setValue(sets[curr].getValue());
}
#
##### Terrain Follow Switch and Prty toggle switch
#
ter_follow = func(number){

terflw = getprop("controls/switches/terrain-follow");
terflwmap = getprop("controls/switches/terrain-follow-map");

if(terflw == 1) {
	if(terflwmap == 0) {
	setprop("autopilot/locks/altitude", "agl-hold");
        setprop("controls/switches/terrain-follow-map-enabled", 0);#triggers the submodels radarpulse off

} elsif (terflwmap == 1) {
	setprop("autopilot/locks/altitude", "vertical-speed-hold");
        setprop("controls/switches/terrain-follow-map-enabled", 1);#triggers the submodels radarpulse on
}
} elsif(terflw == 0) {
	setprop("autopilot/locks/altitude", "");
        setprop("controls/switches/terrain-follow-map-enabled", 0);
}
} # End Function

#
##### Terrain Avoid Switch
#
ter_avoid_switch = func {
   tas = getprop("controls/switches/terrain-avoid");
   rs = getprop("controls/switches/terrain-avoid-rng");

if (tas == 1) {
    if (rs == 0) {
    setprop("controls/switches/terrain-avoid-rng-25", 1);
    setprop("controls/switches/terrain-avoid-rng-50", 0);
  } elsif (rs == 1) {
    setprop("controls/switches/terrain-avoid-rng-25", 0);
    setprop("controls/switches/terrain-avoid-rng-50", 1);
     }
} else {
   setprop("controls/switches/terrain-avoid-rng-25", 0);
   setprop("controls/switches/terrain-avoid-rng-50", 0);
}
}
#
##### Terrain Avoid Toggle Radar Dist Switch
#
radar_switch = func {
   rs = getprop("controls/switches/terrain-avoid-rng");
   tas = getprop("controls/switches/terrain-avoid");
   if(tas == 1) {
   if(rs == 0) {
   setprop("controls/switches/terrain-avoid-rng-25", 1);
   setprop("controls/switches/terrain-avoid-rng-50", 0);
} elsif (rs == 1) {
   setprop("controls/switches/terrain-avoid-rng-50", 1);
   setprop("controls/switches/terrain-avoid-rng-25", 0);
}
}
}

#
##### Terrain Avoid Toggle Radar Clearance
#
radar_clrpln = func {

var rcs = getprop("controls/switches/terrain-avoid-clrpln");

if(rcs == 0) {
setprop("controls/switches/terrain-avoid-clr1000", 0);
}
if(rcs == 0.25) {
setprop("controls/switches/terrain-avoid-clr1000", 100);
}
if(rcs == 0.5) {
setprop("controls/switches/terrain-avoid-clr1000", 300);
}
if(rcs == 0.75) {
setprop("controls/switches/terrain-avoid-clr1000", 500);
}
if(rcs == 1.0) {
setprop("controls/switches/terrain-avoid-clr1000", 1000);
}

}

#
##### Terrain Follow Radar Clearance
#
radar_setclr = func(number) {

var sclr = getprop("controls/switches/terrain-follow-setclr");
oldclr = getprop("controls/switches/terrain-follow-clr");
if((number == 1) and (oldclr < 2000)) {
newclr = (oldclr + 200);
setprop("controls/switches/terrain-follow-clr", newclr);
setprop("autopilot/settings/target-agl-ft", newclr);
} elsif((number == 0) and (oldclr > 0)) {
newclr = (oldclr - 200);
setprop("controls/switches/terrain-follow-clr", newclr);
setprop("autopilot/settings/target-agl-ft", newclr);
}
}
#
##### Terrain Avoidance Radar Pulse (inspired from vulcanb2)
#

settimer(func {

  # Add listener for radar pulse contactm0d
  setlistener("sim/radar/teravd/contactm0d", func {
    var contactm0d = cmdarg().getValue();
    var solid = getprop(contactm0d ~ "/material/solid");
    
    if (solid)
    {
      var long = getprop(contactm0d ~ "/impact/longitude-deg");
      var lat = getprop(contactm0d ~ "/impact/latitude-deg");
      var elev_m = getprop(contactm0d ~ "/impact/elevation-m");
      var spd = getprop(contactm0d ~ "/impact/speed-mps");
      var time = getprop(contactm0d ~ "/sim/time/elapsed-sec");
      var elev_ft = int(elev_m * 3.28);
      var dist_ft = int(spd * time * 3.28);
      setprop("instrumentation/teravd/elevationm0d", elev_ft);
      setprop("instrumentation/teravd/distancem0d", dist_ft);

    settimer(teravd_m0d, 0);

    }
  });
}, 0);

settimer(func {

  # Add listener for radar pulse contactm4d
  setlistener("sim/radar/teravd/contactm4d", func {
    var contactm4d = cmdarg().getValue();
    var solid = getprop(contactm4d ~ "/material/solid");
    
    if (solid)
    {
      var long = getprop(contactm4d ~ "/impact/longitude-deg");
      var lat = getprop(contactm4d ~ "/impact/latitude-deg");
      var elev_m = getprop(contactm4d ~ "/impact/elevation-m");
      var spd = getprop(contactm4d ~ "/impact/speed-mps");
      var time = getprop(contactm4d ~ "/sim/time/elapsed-sec");
      var elev_ft = int(elev_m * 3.28);
      var dist_ft = int(spd * time * 3.28);
      setprop("instrumentation/teravd/elevationm4d", elev_ft);
      setprop("instrumentation/teravd/distancem4d", dist_ft);

     settimer(teravd_m4d, 0);

    }
  });
}, 0);

settimer(func {

  # Add listener for radar pulse contactm20d
  setlistener("sim/radar/teravd/contactm20d", func {
    var contactm20d = cmdarg().getValue();
    var solid = getprop(contactm20d ~ "/material/solid");
    
    if (solid)
    {
      var long = getprop(contactm20d ~ "/impact/longitude-deg");
      var lat = getprop(contactm20d ~ "/impact/latitude-deg");
      var elev_m = getprop(contactm20d ~ "/impact/elevation-m");
      var spd = getprop(contactm20d ~ "/impact/speed-mps");
      var time = getprop(contactm20d ~ "/sim/time/elapsed-sec");
      var elev_ft = int(elev_m * 3.28);
      var dist_ft = int(spd * time * 3.28);
      setprop("instrumentation/teravd/elevationm20d", elev_ft);
      setprop("instrumentation/teravd/distancem20d", dist_ft);

     settimer(teravd_m20d, 0);

    }
  });
}, 0);

settimer(func {

  # Add listener for radar pulse contactm20dtf for terrain follow
  setlistener("sim/radar/teravd/contactm20dtf", func {
    var contactm20dtf = cmdarg().getValue();
    var solid = getprop(contactm20dtf ~ "/material/solid");
    
    if (solid)
    {
      var long = getprop(contactm20dtf ~ "/impact/longitude-deg");
      var lat = getprop(contactm20dtf ~ "/impact/latitude-deg");
      var elev_m = getprop(contactm20dtf ~ "/impact/elevation-m");
      var spd = getprop(contactm20dtf ~ "/impact/speed-mps");
      var time = getprop(contactm20dtf ~ "/sim/time/elapsed-sec");
      var elev_ft = int(elev_m * 3.28);
      var dist_ft = int(spd * time * 3.28);
      setprop("instrumentation/teravd/elevationm20dtf", elev_ft);
      setprop("instrumentation/teravd/distancem20dtf", dist_ft);

     settimer(teravd_m20dtf, 0);

    }
  });
}, 0);


# control alt while climb and trigger end of climb

teravd_m0d = func {
calt = getprop("position/altitude-ft");
cspd = getprop("velocities/groundspeed-kt");
talt = getprop("autopilot/settings/target-altitude-ft");
tvfpm = getprop("autopilot/settings/vertical-speed-fpm");
rdist25 = getprop("controls/switches/terrain-avoid-rng-25");
rdist50  = getprop("controls/switches/terrain-avoid-rng-50");

elem0d = getprop("instrumentation/teravd/elevationm0d");
distm0d = getprop("instrumentation/teravd/distancem0d");
clr = getprop("controls/switches/terrain-avoid-clr1000");

if (rdist25 = 1) {
rdist = 15000;
} elsif (rdist50 = 1) {
rdist = 30000;
}
daltm0d = ((elem0d + clr) - calt);

if ((distm0d < rdist) and (daltm0d > 0)) {
talt = calt + daltm0d;
itime = distm0d / (cspd * 1.6878);
tvfpm = int((daltm0d) / (itime / 2)) * 60;
setprop("instrumentation/teravd/target-vfpm", tvfpm);
setprop("instrumentation/teravd/target-alt", talt);
setprop("controls/switches/terra-report", 1);
settimer(setvfpm, 0);
}
}


teravd_m4d = func {
#cpitch = getprop("orientation/pitch-deg");
calt = getprop("position/altitude-ft");
cspd = getprop("velocities/groundspeed-kt");
talt = getprop("autopilot/settings/target-altitude-ft");
tvfpm = getprop("autopilot/settings/vertical-speed-fpm");
rdist25 = getprop("controls/switches/terrain-avoid-rng-25");
rdist50  = getprop("controls/switches/terrain-avoid-rng-50");

elem4d = getprop("instrumentation/teravd/elevationm4d");
distm4d = getprop("instrumentation/teravd/distancem4d");
clr = getprop("controls/switches/terrain-avoid-clr1000");

evfpm = getprop("instrumentation/teravd/target-vfpm");
etalt = getprop("instrumentation/teravd/target-alt");

if (rdist25 = 1) {
rdist = 15000;
} elsif (rdist50 = 1) {
rdist = 30000;
}

daltm4d = ((elem4d + clr) - calt);

if ((distm4d < rdist) and (daltm4d > 0)) {
talt = calt + daltm4d;
itime = distm4d / (cspd * 1.6878);
tvfpm = int((daltm4d) / ((itime * 2) / 3)) * 60;

if (etalt < talt) {
setprop("instrumentation/teravd/target-alt", talt);
}
if (evfpm < tvfpm) {
setprop("instrumentation/teravd/target-vfpm", tvfpm);
}
setprop("controls/switches/terra-report", 1);
settimer(setvfpm, 0);
}
}

teravd_m20d = func {
calt = getprop("position/altitude-ft");
cspd = getprop("velocities/groundspeed-kt");
talt = getprop("autopilot/settings/target-altitude-ft");
tvfpm = getprop("autopilot/settings/vertical-speed-fpm");
rdist25 = getprop("controls/switches/terrain-avoid-rng-25");
rdist50  = getprop("controls/switches/terrain-avoid-rng-50");

evfpm = getprop("instrumentation/teravd/target-vfpm");
etalt = getprop("instrumentation/teravd/target-alt");

elem20d = getprop("instrumentation/teravd/elevationm20d");
distm20d = getprop("instrumentation/teravd/distancem20d");
clr = getprop("controls/switches/terrain-avoid-clr1000");
prty = getprop("controls/switches/terrain-follow-map-enabled");

if (rdist25 = 1) {
rdist2 = 15000;
} elsif (rdist50 = 1) {
rdist2 = 30000;
}

daltm20d = ((elem20d + clr) - calt);

if ((distm20d < rdist2) and (daltm20d > 0)) {
talt = calt + daltm20d;
itime = distm20d / (cspd * 1.6878);
tvfpm = int((daltm20d) / (itime / 2)) * 60;

if (etalt < talt) {
setprop("instrumentation/teravd/target-alt", talt);
}
if (evfpm < tvfpm) {
setprop("instrumentation/teravd/target-vfpm", tvfpm);
}
setprop("controls/switches/terra-report", 1);
settimer(setvfpm, 0);
}

}

teravd_m20dtf = func {

terrep = getprop("controls/switches/terra-report");
#if (terrep == 0) {

calt = getprop("position/altitude-ft");
cspd = getprop("velocities/groundspeed-kt");
talt = getprop("autopilot/settings/target-altitude-ft");
tvfpm = getprop("autopilot/settings/vertical-speed-fpm");
rdist25 = getprop("controls/switches/terrain-avoid-rng-25");
rdist50  = getprop("controls/switches/terrain-avoid-rng-50");

evfpm = getprop("instrumentation/teravd/target-vfpm");
etalt = getprop("instrumentation/teravd/target-alt");

elem20dtf = getprop("instrumentation/teravd/elevationm20dtf");
distm20dtf = getprop("instrumentation/teravd/distancem20dtf");
tfclr = getprop("controls/switches/terrain-follow-clr");
prty = getprop("controls/switches/terrain-follow-map-enabled");


if (rdist25 = 1) {
rdist2 = 60000;
} elsif (rdist50 = 1) {
rdist2 = 60000;
}

daltm20dtf = ((elem20dtf + tfclr) - calt);

if ((distm20dtf < rdist2) and (daltm20dtf > 0)) {
talt = calt + daltm20dtf;
itime = distm20dtf / (cspd * 1.6878);
tvfpm = int((daltm20dtf) / itime) * 60;

if (etalt < talt) {
setprop("instrumentation/teravd/target-alt", talt);
}
if (evfpm < tvfpm) {
setprop("instrumentation/teravd/target-vfpm", tvfpm);
}
#setprop("controls/switches/terra-report", 1);
settimer(setvfpmplus, 0);
}
# this is the terrain following part, terrain is lower than clr limit
if ((distm20dtf < rdist2) and (daltm20dtf < 0)) {
talt = calt + daltm20dtf;
itime = (distm20dtf / (cspd * 1.6878)) * (-1);
tvfpm = (int((daltm20dtf) / (itime * 2)) * 60) * (-1);


if ((evfpm <= 0) and (prty == 1)) {
setprop("instrumentation/teravd/target-alt", talt);
setprop("instrumentation/teravd/target-vfpm", tvfpm);
settimer(setvfpmminus, 0);
}
}

#}
}

setvfpm = func {
calt = getprop("position/altitude-ft");
talt = getprop("instrumentation/teravd/target-alt");
tvfpm = getprop("instrumentation/teravd/target-vfpm");

setprop("controls/switches/apmode/alt-hold", 0);
setprop("controls/switches/apmode/ptch-hold", 0);
setprop("controls/switches/apmode/vfpm-hold", 0);
setprop("autopilot/settings/vertical-speed-fpm", tvfpm);
setprop("autopilot/locks/altitude", "vertical-speed-hold");
if (calt > talt) {
setprop("autopilot/settings/vertical-speed-fpm", 0);
setprop("controls/switches/terra-report", 0);
setprop("instrumentation/teravd/target-vfpm", 0);
setprop("instrumentation/teravd/target-alt", 0);
#settimer(aglreinit, 0);
} else {
settimer(setvfpm, 0.5);
}
}

setvfpmplus = func {
terflw = getprop("controls/switches/terrain-follow");
if (terflw == 1) {
calt = getprop("position/altitude-ft");
talt = getprop("instrumentation/teravd/target-alt");
tvfpm = getprop("instrumentation/teravd/target-vfpm");

setprop("autopilot/settings/vertical-speed-fpm", tvfpm);
setprop("autopilot/locks/altitude", "vertical-speed-hold");
if (calt > talt) {
setprop("autopilot/settings/vertical-speed-fpm", 0);

setprop("instrumentation/teravd/target-vfpm", 0);
setprop("instrumentation/teravd/target-alt", 0);
#settimer(aglreinit, 0);
} else {
settimer(setvfpmplus, 0.5);
}
}
}

setvfpmminus = func {
tvfpm = getprop("instrumentation/teravd/target-vfpm");
setprop("autopilot/settings/vertical-speed-fpm", tvfpm);
setprop("autopilot/locks/altitude", "vertical-speed-hold");

}

# reinit previous flight params
aglreinit = func {
  terflw = getprop("controls/switches/terrain-follow");
  setprop("controls/switches/terra-report", 0);
  if(terflw == 1) {
     setprop("autopilot/locks/altitude", "agl-hold");
 } else {
setprop("autopilot/locks/altitude", "vertical-speed-hold");
#     setprop("autopilot/locks/altitude", "altitude-hold");
 }
}
### end of terrain avoidance behaviour #########################

### engine on/off workaround adapted from Citation Bravo

eng_state = func {

    if(getprop("controls/engines/engine[0]/cutoff") == 0){
        setprop("controls/engines/engine[0]/throttle-lever",getprop("/controls/engines/engine[0]/throttle"));
        setprop("sim/model/B-1B/n1[0]",getprop("/engines/engine/n1"));
        setprop("sim/model/B-1B/n2[0]",getprop("/engines/engine/n2"));
    }else{
        setprop("controls/engines/engine[0]/throttle-lever", 0);
        interpolate("sim/model/B-1B/n1[0]",0,10);
        interpolate("sim/model/B-1B/n2[0]",0,10);
    }

    if(getprop("controls/engines/engine[1]/cutoff") == 0){
        setprop("controls/engines/engine[1]/throttle-lever",getprop("/controls/engines/engine[1]/throttle"));
        setprop("sim/model/B-1B/n1[1]",getprop("/engines/engine/n1"));
        setprop("sim/model/B-1B/n2[1]",getprop("/engines/engine/n2"));
    }else{
        setprop("controls/engines/engine[1]/throttle-lever", 0);
        interpolate("sim/model/B-1B/n1[1]",0,10);
        interpolate("sim/model/B-1B/n2[1]",0,10);
    }

    if(getprop("controls/engines/engine[2]/cutoff") == 0){
        setprop("controls/engines/engine[2]/throttle-lever",getprop("/controls/engines/engine[2]/throttle"));
        setprop("sim/model/B-1B/n1[2]",getprop("/engines/engine/n1"));
        setprop("sim/model/B-1B/n2[2]",getprop("/engines/engine/n2"));
    }else{
        setprop("controls/engines/engine[2]/throttle-lever", 0);
        interpolate("sim/model/B-1B/n1[2]",0,10);
        interpolate("sim/model/B-1B/n2[2]",0,10);
    }

    if(getprop("controls/engines/engine[3]/cutoff") == 0){
        setprop("controls/engines/engine[3]/throttle-lever",getprop("/controls/engines/engine[3]/throttle"));
        setprop("sim/model/B-1B/n1[3]",getprop("/engines/engine/n1"));
        setprop("sim/model/B-1B/n2[3]",getprop("/engines/engine/n2"));
    }else{
        setprop("controls/engines/engine[3]/throttle-lever", 0);
        interpolate("sim/model/B-1B/n1[3]",0,10);
        interpolate("sim/model/B-1B/n2[3]",0,10);
    }
settimer(eng_state, 0);
}

#fuel distribution system
#fuel_syst = func {

#var tank0 = getprop("consumables/fuel/tank[0]/level-gal_us");#wing left
#var tank1 = props.globals.getNode("consumables/fuel/tank[1]/level-gal_us", 1);#wing right
#var tank6 = getprop("consumables/fuel/tank[6]/level-gal_us");#collector left
#var tank7 = props.globals.getNode("consumables/fuel/tank[7]/level-gal_us", 1);#collector right

#if(tank6 < 1500){
#        setprop("consumables/fuel/tank[6]/level-gal_us", tank6 + 80);
#        setprop("consumables/fuel/tank[0]/level-gal_us", tank0 - 80);
#    }
#settimer(fuel_syst, 0);
#}

# checks wing sweep/flaps and allow flaps only to be extended at minimum sweep - adopted from limits.nas

checkFlaps = func {
  flapsetting = cmdarg().getValue();
  if (flapsetting == 0)
    return;
sweep = getprop("controls/flight/wing-sweep");

if ((flapsetting != 0) and (sweep != 1)) {

  controls.flapsDown(-1);
  ltext = "Flaps can only be exteded at minimum wingsweep!";
  screen.log.write(ltext);
}
}
setlistener("controls/flight/flaps", checkFlaps);

checkSweep = func {
  sweepsetting = cmdarg().getValue();
  if (sweepsetting == 1)
    return;
flaps = getprop("controls/flight/flaps");

if ((sweepsetting != 1) and (flaps != 0)) {

  b1b.wingSweep(1);
  ltext = "Wings can only be swept with retracted flaps!";
  screen.log.write(ltext);
}
}
setlistener("controls/flight/wing-sweep", checkSweep);

###
# apmode listeners to controls switches apmode
###
checkapmode = func {

althold = getprop("controls/switches/apmode/alt-hold");
vfpmhold = getprop("controls/switches/apmode/vfpm-hold");
ptchhold = getprop("controls/switches/apmode/ptch-hold");
bhdghold = getprop("controls/switches/apmode/bhdg-hold");
thdghold = getprop("controls/switches/apmode/thdg-hold");
spdhold = getprop("controls/switches/apmode/spd-hold");
spdptchhold = getprop("controls/switches/apmode/spdptch-hold");
aglhold = getprop("controls/switches/terrain-follow");

if (althold == 1) {
        setprop("autopilot/locks/altitude", "altitude-hold");
} elsif (vfpmhold == 1) {
 setprop("autopilot/locks/altitude", "vertical-speed-hold");
} elsif (ptchhold == 1) {
 setprop("autopilot/locks/altitude", "pitch-hold");
} elsif ((ptchhold != 1) and (vfpmhold != 1) and (althold != 1) and (aglhold != 1)) {
 setprop("autopilot/locks/altitude", "");
}
if (bhdghold == 1) {
        setprop("autopilot/locks/heading", "dg-heading-hold");
} elsif (thdghold == 1) {
 setprop("autopilot/locks/heading", "true-heading-hold");
} elsif ((bhdghold != 1) and (thdghold != 1)) {
 setprop("autopilot/locks/heading", "");
}
if (spdhold == 1) {
        setprop("autopilot/locks/speed", "speed-with-throttle");
} elsif (spdptchhold == 1) {
 setprop("autopilot/locks/speed", "speed-with-pitch-trim");
} elsif ((spdhold != 1) and (spdptchhold != 1)) {
 setprop("autopilot/locks/speed", "");
}

}
setlistener("controls/switches/apmode/", checkapmode);

###
# flight director modes selector
###
fltdir = func {

var fltd = getprop("controls/switches/fltdir");

if (fltd == 0.00) {
  setprop("instrumentation/adf/serviceable", "0");
  setprop("instrumentation/nav/serviceable", "0");
  setprop("instrumentation/tacan/serviceable", "0");
} elsif (fltd == 0.25) {
  setprop("instrumentation/adf/serviceable", "1");
  setprop("instrumentation/nav/serviceable", "1");
  setprop("instrumentation/tacan/serviceable", "1");
} elsif (fltd == 0.50) {
  setprop("instrumentation/adf/serviceable", "1");
  setprop("instrumentation/nav/serviceable", "1");
  setprop("instrumentation/tacan/serviceable", "0");
} elsif (fltd == 0.75) {
  setprop("instrumentation/adf/serviceable", "1");
  setprop("instrumentation/nav/serviceable", "0");
  setprop("instrumentation/tacan/serviceable", "0");
} elsif (fltd == 1.00) {
  setprop("instrumentation/adf/serviceable", "0");
#  setprop("instrumentation/nav/serviceable", "0");
  setprop("instrumentation/tacan/serviceable", "1");
}

}

radar_range = func {

var radran = getprop("controls/switches/radar-range");

if (radran == 0.00) {
  setprop("instrumentation/radar/range[0]", "20");
} elsif (radran == 0.25) {
  setprop("instrumentation/radar/range[0]", "40");
} elsif (radran == 0.50) {
  setprop("instrumentation/radar/range[0]", "80");
} elsif (radran == 0.75) {
  setprop("instrumentation/radar/range[0]", "160");
} elsif (radran == 1.00) {
  setprop("instrumentation/radar/range[0]", "320");
}
}

nuc = func {
if (getprop("controls/switches/nuc") == 1) {
ltext = "Sorry, Duke Nukem not available yet on this plane(t)!";
  screen.log.write(ltext);
}
}