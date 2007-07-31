init_b1b = func {
setprop("/sim/current-view/field-of-view", 60);
setprop("/autopilot/settings/target-pitch-deg", 2);
setprop("controls/switches/terra-report", 0);
#setprop("/sim/panel-hotspots", 1);
#setprop("/engines/engine[0]/running", 0);
#setprop("/engines/engine[1]/running", 0);
setprop("sim/multiplay/chat_display", 1);
setprop("sim/user/callsign", 'BONE');
#setprop("/consumables/fuel/tank[4]/level-gal_us", 1000);
#fuel_syst();

#static fuel distribution
#setprop("/controls/fuel/tank[0]/fuel_selector", 1);
#setprop("/controls/fuel/tank[0]/to_tank", 6);
#setprop("/controls/fuel/tank[1]/fuel_selector", 1);
#setprop("/controls/fuel/tank[1]/to_tank", 7);
#setprop("/controls/fuel/tank[6]/fuel_selector", 1);
#setprop("/controls/fuel/tank[6]/to_engine", 1);
#setprop("/controls/fuel/tank[7]/fuel_selector", 1);
#setprop("/controls/fuel/tank[7]/to_engine", 2);

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
   setprop("controls/switches/terrain-avoid-rng-s", 0);
#   ter_avoid();
} else {
   setprop("controls/switches/terrain-avoid-rng-m", 0);
   setprop("controls/switches/terrain-avoid-rng-s", 1);
}
} else {
   setprop("controls/switches/terrain-avoid-rng-m", 0);
   setprop("controls/switches/terrain-avoid-rng-s", 0);
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
} else {
   setprop("controls/switches/terrain-avoid-rng-m", 0);
   setprop("controls/switches/terrain-avoid-rng-s", 1);
}
}
}

#
##### Terrain Avoid Toggle Radar Clearance
#
radar_clrpln = func {

var rcs = getprop("controls/switches/terrain-avoid-clrpln");
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
#
##### Terrain Avoidance Radar Pulse (inspired from vulcanb2)
#
#ter_avoid = func {

settimer(func {

  # Add listener for radar pulse impact
  setlistener("sim/armament/weapons/impact", func {
    var impact = cmdarg().getValue();
    var solid = getprop(impact ~ "/material/solid");
    
    if (solid)
    {
      var long = getprop(impact ~ "/impact/longitude-deg");
      var lat = getprop(impact ~ "/impact/latitude-deg");
#      terflw = getprop("controls/switches/terrain-follow");
#      var malt = getprop(impact ~ "/impact/altitude-m");

# pitch clearance with alt mod
      var pitch = getprop("/autopilot/settings/target-pitch-deg");
      setprop("/autopilot/settings/target-pitch-deg", (pitch + 1));
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

# simple alt clearance
#       falt = getprop("/position/altitude-ft");
#       setprop("/autopilot/settings/target-altitude-ft", falt + 1000);
#       setprop("/autopilot/locks/altitude", "altitude-hold");

# simle fpm clearance
#       setprop("/autopilot/settings/vertical-speed-fpm", 3000);
#       setprop("/autopilot/locks/altitude", "vertical-speed-hold");

      
#      geo.put_model("Aircraft/vulcanb2/Models/crater.ac", lat, long);
    }
  });

}, 0);
#}

# control alt while climb and trigger end of climb
teravd_alt = func {
calt = getprop("/position/altitude-ft");
salt = getprop("/autopilot/settings/target-altitude-ft");
pitch = getprop("/autopilot/settings/target-pitch-deg");

if(calt >= salt) {
#       setprop("/autopilot/settings/target-altitude-ft", salt + 300);
       setprop("/autopilot/settings/target-pitch-deg", (pitch - 1));
       if(pitch >= 5) {
         setprop("/autopilot/settings/target-pitch-deg", 5);
       }
       aglreinit();
} else {
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