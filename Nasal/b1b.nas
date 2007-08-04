setlistener("/sim/signals/fdm-initialized", func {
	init_b1b();
});

init_b1b = func {
setprop("/sim/current-view/field-of-view", 60);
setprop("/autopilot/settings/target-pitch-deg", 2);
setprop("controls/switches/terra-report", 0);
#setprop("/sim/panel-hotspots", 1);
#fuel_syst();
settimer(eng_state, 3);
print ("B-1B warming up!");
}

aftburn_on = func {

#if (on > 0) {

setprop("/controls/engines/engine[0]/afterburner", 1);
setprop("/controls/engines/engine[1]/afterburner", 1);
setprop("/controls/engines/engine[2]/afterburner", 1);
setprop("/controls/engines/engine[3]/afterburner", 1);

#  } else {
#   setprop("/controls/engines/engine[0]/afterburner", 0);
#   setprop("/controls/engines/engine[1]/afterburner", 0);
#   setprop("/controls/engines/engine[2]/afterburner", 0);
#   setprop("/controls/engines/engine[3]/afterburner", 0);

#     }

}

aftburn_off = func {

setprop("/controls/engines/engine[0]/afterburner", 0);
setprop("/controls/engines/engine[1]/afterburner", 0);
setprop("/controls/engines/engine[2]/afterburner", 0);
setprop("/controls/engines/engine[3]/afterburner", 0);
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
##### Terrain Follow Switch
#
ter_follow = func(number){

terflw = getprop("controls/switches/terrain-follow");

if(terflw == 1) {
	setprop("/autopilot/locks/altitude", "agl-hold");
} elsif(terflw == 0) {
	setprop("/autopilot/locks/altitude", "");
}
} # End Function

#
##### Terrain Avoid Switch
#
ter_avoid_switch = func {
   tas = getprop("controls/switches/terrain-avoid");
   rs = getprop("controls/switches/terrain-avoid-rng");

if(tas == 1) {
if(rs == 1) {
   setprop("controls/switches/terrain-avoid-rng-m", 1);
   setprop("controls/switches/terrain-avoid-rng-mh", 1);
   setprop("controls/switches/terrain-avoid-rng-s", 0);
   setprop("controls/switches/terrain-avoid-rng-sh", 0);
#   ter_avoid();
} else {
   setprop("controls/switches/terrain-avoid-rng-m", 0);
   setprop("controls/switches/terrain-avoid-rng-mh", 0);
   setprop("controls/switches/terrain-avoid-rng-s", 1);
   setprop("controls/switches/terrain-avoid-rng-sh", 1);
}
} else {
   setprop("controls/switches/terrain-avoid-rng-m", 0);
   setprop("controls/switches/terrain-avoid-rng-mh", 0);
   setprop("controls/switches/terrain-avoid-rng-s", 0);
   setprop("controls/switches/terrain-avoid-rng-sh", 0);
}
}
#
##### Terrain Avoid Toggle Radar Dist Switch
#
radar_switch = func {
   rs = getprop("controls/switches/terrain-avoid-rng");
   tas = getprop("controls/switches/terrain-avoid");
   if(tas == 1) {
   if(rs == 1) {
   setprop("controls/switches/terrain-avoid-rng-m", 1);
   setprop("controls/switches/terrain-avoid-rng-s", 0);
   setprop("controls/switches/terrain-avoid-rng-sh", 0);
} else {
   setprop("controls/switches/terrain-avoid-rng-m", 0);
   setprop("controls/switches/terrain-avoid-rng-s", 1);
   setprop("controls/switches/terrain-avoid-rng-sh", 1);
}
}
}

#
##### Terrain Avoid Toggle Radar Clearance
#
radar_clrpln = func {

var rcs = getprop("controls/switches/terrain-avoid-clrpln");
   tas = getprop("controls/switches/terrain-avoid");
   if(tas == 1) {
if(rcs <= 0.1) {
setprop("controls/switches/terrain-avoid-clrpln-1", 0);
setprop("controls/switches/terrain-avoid-clrpln-3", 0);
setprop("controls/switches/terrain-avoid-clrpln-5", 0);
setprop("controls/switches/terrain-avoid-clrpln-9", 0);
}

if(rcs == 0.25) {
setprop("controls/switches/terrain-avoid-clrpln-1", 1);
setprop("controls/switches/terrain-avoid-clrpln-3", 0);
}
if(rcs == 0.5) {
setprop("controls/switches/terrain-avoid-clrpln-1", 0);
setprop("controls/switches/terrain-avoid-clrpln-3", 1);
setprop("controls/switches/terrain-avoid-clrpln-5", 0);
}
if(rcs == 0.75) {
setprop("controls/switches/terrain-avoid-clrpln-3", 0);
setprop("controls/switches/terrain-avoid-clrpln-5", 1);
setprop("controls/switches/terrain-avoid-clrpln-9", 0);
}
if(rcs == 1.0) {
setprop("controls/switches/terrain-avoid-clrpln-5", 0);
setprop("controls/switches/terrain-avoid-clrpln-9", 1);
}

}
}
#
##### Terrain Avoidance Radar Pulse (inspired from vulcanb2)
#
settimer(func {

  # Add listener for radar pulse contacth
  setlistener("sim/radar/teravd/contacth", func {
    var contacth = cmdarg().getValue();
    var solid = getprop(contacth ~ "/material/solid");
    
    if (solid)
    {
      var long = getprop(contacth ~ "/contacth/longitude-deg");
      var lat = getprop(contacth ~ "/contacth/latitude-deg");

# pitch clearance with alt mod for impacth contact
      var cpit = getprop("/orientation/pitch-deg");
#      var pitch = getprop("/autopilot/settings/target-pitch-deg");
      setprop("/autopilot/settings/target-pitch-deg", (cpit + 6));
      setprop("/autopilot/locks/altitude", "pitch-hold");

      falt = getprop("/position/altitude-ft");
      tagl = getprop("autopilot/settings/target-agl-ft");
      if(tagl >= 1000) {
          cl = tagl;
} else {
          cl = 1000;
}
      
      nalt = falt + cl;
      setprop("/autopilot/settings/target-altitude-ft", nalt);
      setprop("controls/switches/terra-report", 1);
      teravd_alt();

    }
  });
}, 0);
settimer(func {

  # Add listener for radar pulse contactm
  setlistener("sim/radar/teravd/contactm", func {
    var contactm = cmdarg().getValue();
    var solid = getprop(contactm ~ "/material/solid");
    
    if (solid)
    {
      var long = getprop(contactm ~ "/contactm/longitude-deg");
      var lat = getprop(contactm ~ "/contactm/latitude-deg");

# pitch clearance with alt mod for impactm contact
      var cpit = getprop("/orientation/pitch-deg");
#      var pitch = getprop("/autopilot/settings/target-pitch-deg");
      setprop("/autopilot/settings/target-pitch-deg", (cpit + 3));
      setprop("/autopilot/locks/altitude", "pitch-hold");

      falt = getprop("/position/altitude-ft");
      tagl = getprop("autopilot/settings/target-agl-ft");
      if(tagl >= 1000) {
          cl = tagl;
} else {
          cl = 500;
}
      
      nalt = falt + cl;
      setprop("/autopilot/settings/target-altitude-ft", nalt);
      setprop("controls/switches/terra-report", 1);
      teravd_alt();

    }
  });
}, 0);
settimer(func {

# Add listener for radar pulse contactl
  setlistener("sim/radar/teravd/contactl", func {
    var contactl = cmdarg().getValue();
    var solid = getprop(contactl ~ "/material/solid");
    
    if (solid)
    {
      var long = getprop(contactl ~ "/contactl/longitude-deg");
      var lat = getprop(contactl ~ "/contactl/latitude-deg");

# pitch clearance with alt mod for impactl contact
      var cpit = getprop("/orientation/pitch-deg");
#      var pitch = getprop("/autopilot/settings/target-pitch-deg");
      setprop("/autopilot/settings/target-pitch-deg", (cpit + 2));
      setprop("/autopilot/locks/altitude", "pitch-hold");

      falt = getprop("/position/altitude-ft");
      tagl = getprop("autopilot/settings/target-agl-ft");
      if(tagl >= 100) {
          cl = tagl / 2;
} else {
          cl = 100;
}
      
      nalt = falt + cl;
      setprop("/autopilot/settings/target-altitude-ft", nalt);
      setprop("controls/switches/terra-report", 1);
      teravd_alt();

    }
  });

}, 0);

settimer(func {

# Add listener for radar pulse contactd which monitors climb behaviour
  setlistener("sim/radar/teravd/contactd", func {
    var contactd = cmdarg().getValue();
    var solid = getprop(contactd ~ "/material/solid");
    
    if (solid)
    {

      var long = getprop(contactd ~ "/contactd/longitude-deg");
      var lat = getprop(contactd ~ "/contactd/latitude-deg");

# pitch clearance with alt mod for impactl contact
      var cpit = getprop("/orientation/pitch-deg");
#      var pitch = getprop("/autopilot/settings/target-pitch-deg");

      falt = getprop("/position/altitude-ft");
      tagl = getprop("autopilot/settings/target-agl-ft");

      if(cpit >= 5) {

      if(tagl >= 1000) {
          cl = tagl;
} else {
          cl = 1000;
}
      
      nalt = falt + cl;
      setprop("/autopilot/settings/target-altitude-ft", nalt);
} else {
}
    }
  });

}, 0);


# control alt while climb and trigger end of climb
teravd_alt = func {
calt = getprop("/position/altitude-ft");
salt = getprop("/autopilot/settings/target-altitude-ft");
pitch = getprop("/autopilot/settings/target-pitch-deg");

if(calt >= salt) {

       setprop("controls/switches/terrain-avoid-rng-d", 0);
#       setprop("/autopilot/settings/target-pitch-deg", (pitch - 1));
       if(pitch >= 5) {
         setprop("/autopilot/settings/target-pitch-deg", 5);
       }
       aglreinit();
} else {
   if(pitch <= 1) {
         setprop("/autopilot/settings/target-pitch-deg", 1.5);
       }
   setprop("controls/switches/terrain-avoid-rng-d", 1);
   settimer(teravd_alt, 1);
}
}

# reinit previous flight params
aglreinit = func {
  terflw = getprop("controls/switches/terrain-follow");
  setprop("controls/switches/terra-report", 0);
  if(terflw == 1) {
     setprop("/autopilot/locks/altitude", "agl-hold");
 } else {
     setprop("/autopilot/locks/altitude", "altitude-hold");
 }
}
### end of terrain avoidance behaviour

### engine on/off workaround adapted from Citation Bravo

eng_state = func {

    if(getprop("/controls/engines/engine[0]/cutoff") == 0){
        setprop("/controls/engines/engine[0]/throttle-lever",getprop("/controls/engines/engine[0]/throttle"));
        setprop("/sim/model/B-1B/n1[0]",getprop("/engines/engine/n1"));
        setprop("/sim/model/B-1B/n2[0]",getprop("/engines/engine/n2"));
    }else{
        setprop("controls/engines/engine[0]/throttle-lever", 0);
        interpolate("/sim/model/B-1B/n1[0]",0,10);
        interpolate("/sim/model/B-1B/n2[0]",0,10);
    }

    if(getprop("/controls/engines/engine[1]/cutoff") == 0){
        setprop("/controls/engines/engine[1]/throttle-lever",getprop("/controls/engines/engine[1]/throttle"));
        setprop("/sim/model/B-1B/n1[1]",getprop("/engines/engine/n1"));
        setprop("/sim/model/B-1B/n2[1]",getprop("/engines/engine/n2"));
    }else{
        setprop("controls/engines/engine[1]/throttle-lever", 0);
        interpolate("/sim/model/B-1B/n1[1]",0,10);
        interpolate("/sim/model/B-1B/n2[1]",0,10);
    }

    if(getprop("/controls/engines/engine[2]/cutoff") == 0){
        setprop("/controls/engines/engine[2]/throttle-lever",getprop("/controls/engines/engine[2]/throttle"));
        setprop("/sim/model/B-1B/n1[2]",getprop("/engines/engine/n1"));
        setprop("/sim/model/B-1B/n2[2]",getprop("/engines/engine/n2"));
    }else{
        setprop("controls/engines/engine[2]/throttle-lever", 0);
        interpolate("/sim/model/B-1B/n1[2]",0,10);
        interpolate("/sim/model/B-1B/n2[2]",0,10);
    }

    if(getprop("/controls/engines/engine[3]/cutoff") == 0){
        setprop("/controls/engines/engine[3]/throttle-lever",getprop("/controls/engines/engine[3]/throttle"));
        setprop("/sim/model/B-1B/n1[3]",getprop("/engines/engine/n1"));
        setprop("/sim/model/B-1B/n2[3]",getprop("/engines/engine/n2"));
    }else{
        setprop("controls/engines/engine[3]/throttle-lever", 0);
        interpolate("/sim/model/B-1B/n1[3]",0,10);
        interpolate("/sim/model/B-1B/n2[3]",0,10);
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

nirvana = func {
}
