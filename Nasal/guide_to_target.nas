#####  Guides objects to preselected targets, creates impact report and shows models
# Usage:
# 1.) click somewhere in the landscape to get target coordinates
# 2.) confirm/load coordinates by launching target_des() - (I bound the t key to launch the function)
#     first click/target_des() stores coordinates for bomb0, next click/target_des() for bomb1 (up to 3)
# 3.) Then launch this script (function: launch()) (requires the B-1B(cvs) and Vulcan to be installed)
# The script will guide up to 4 models to preselected targets (for each model the script has to be 
# called) (by mouseclick/target_des()) and scan for impact;
# If an impact is detected, an impact report is created (compatible with submodels) 
# and crater models placed (from vulcan)
# In case you want to change the objects model, change file/path "Aircraft/B-1B/Models/gbu-31i.xml"
# in the script below (block bomb model placing)
# At the end there is an exp script that calculates if the target is in range/then releases the model
##### by glazmax 2008

var launch = func(n) {

# aircraft parameters = initial bomb position
var calt_m = getprop("position/altitude-ft") / 3.28084;
var chdg = getprop("orientation/heading-deg");
var cpitch = getprop("orientation/pitch-deg");
var clat = getprop("position/latitude-deg") + 0.00000000;
var clong = getprop("position/longitude-deg") + 0.00000000;
var cspeed_mps = getprop("velocities/groundspeed-kt") * 0.51444;

#setprop("ai/guided/id-number", n);

setprop("ai/guided/bomb[" ~ n ~ "]/prop-latitude-deg",clat);
setprop("ai/guided/bomb[" ~ n ~ "]/prop-longitude-deg",clong);
setprop("ai/guided/bomb[" ~ n ~ "]/prop-altitude-ft",calt_m * 3.28084);
setprop("ai/guided/bomb[" ~ n ~ "]/prop-heading-deg",chdg);

#first 2 seconds free falling
var cpos = geo.Coord.new().set_latlon(clat, clong, calt_m);
var adist = cspeed_mps * 2;
var apos = cpos.apply_course_distance(chdg, adist);
var alat = apos.lat();
var along = apos.lon();
var aalt_m = calt_m - 40;
setprop("ai/guided/bomb[" ~ n ~ "]/alat",alat);
setprop("ai/guided/bomb[" ~ n ~ "]/along",along);
setprop("ai/guided/bomb[" ~ n ~ "]/aalt_m",aalt_m);
setprop("ai/guided/bomb[" ~ n ~ "]/ahdg",chdg);

#interpolation to activation point
interpolate("ai/guided/bomb[" ~ n ~ "]/prop-latitude-deg",alat,2);
interpolate("ai/guided/bomb[" ~ n ~ "]/prop-longitude-deg",along,2);
interpolate("ai/guided/bomb[" ~ n ~ "]/prop-altitude-ft",aalt_m * 3.28084,2);

#bomb model placing

aircraft.makeNode("models/model[" ~ n ~ "]/path");
aircraft.makeNode("models/model[" ~ n ~ "]/longitude-deg-prop");
aircraft.makeNode("models/model[" ~ n ~ "]/latitude-deg-prop");
aircraft.makeNode("models/model[" ~ n ~ "]/elevation-ft-prop");
aircraft.makeNode("models/model[" ~ n ~ "]/heading-deg-prop");
setprop ("models/model[" ~ n ~ "]/path", "Aircraft/B-1B/Models/gbu-31i.xml");
setprop ("models/model[" ~ n ~ "]/longitude-deg-prop", "ai/guided/bomb[" ~ n ~ "]/prop-longitude-deg");
setprop ("models/model[" ~ n ~ "]/latitude-deg-prop", "ai/guided/bomb[" ~ n ~ "]/prop-latitude-deg");
setprop ("models/model[" ~ n ~ "]/elevation-ft-prop", "ai/guided/bomb[" ~ n ~ "]/prop-altitude-ft");
setprop ("models/model[" ~ n ~ "]/heading-deg-prop", "ai/guided/bomb[" ~ n ~ "]/prop-heading-deg");
aircraft.makeNode("models/model[" ~ n ~ "]/load");

settimer(func{target_guide(n);}, 2);
}

#####
## guidance to target (bomb nr 0)
#####
var target_guide = func(n) {

# target parameters
var tlat = getprop("ai/guided/bomb["~ n ~"]/target-latitude-deg");
var tlong = getprop("ai/guided/bomb["~ n ~"]/target-longitude-deg");
var talt_m = geo.elevation(tlat, tlong);
setprop("ai/guided/bomb["~ n ~"]/target-altitude-m",talt_m);

#calculation of distance, arrival time and heading
var alat = getprop("ai/guided/bomb["~ n ~"]/alat");
var along = getprop("ai/guided/bomb["~ n ~"]/along");
var aalt_m = getprop("ai/guided/bomb["~ n ~"]/aalt_m");
var apos = geo.Coord.new().set_latlon(alat, along, aalt_m);
var tpos = geo.Coord.new().set_latlon(tlat, tlong, talt_m);
var tdist = apos.direct_distance_to(tpos);
setprop("ai/guided/bomb["~ n ~"]/target-distance",tdist);
var cspeed_mps = getprop("velocities/airspeed-kt") * 0.51444;
var ttime = tdist / cspeed_mps;
var thdg = apos.course_to(tpos);
setprop("ai/guided/bomb["~ n ~"]/target-heading",thdg);

#interpolation to target
interpolate("ai/guided/bomb["~ n ~"]/prop-latitude-deg",tlat,ttime);
interpolate("ai/guided/bomb["~ n ~"]/prop-longitude-deg",tlong,ttime);
interpolate("ai/guided/bomb["~ n ~"]/prop-altitude-ft",talt_m * 3.28084,ttime);
interpolate("ai/guided/bomb["~ n ~"]/prop-heading-deg",thdg,ttime / 4);

weapons.impact_detect(n);
}

#####
## detect impact (bomb n)
#####
var impact_detect = func(n) {
var galt = getprop("ai/guided/bomb["~ n ~"]/prop-altitude-ft");
var talt = getprop("ai/guided/bomb["~ n ~"]/target-altitude-m");
var glat = getprop("ai/guided/bomb["~ n ~"]/prop-latitude-deg");
var glong = getprop("ai/guided/bomb["~ n ~"]/prop-longitude-deg");

if (galt - (talt * 3.28084) <= 3) {
  setprop ("ai/guided/bomb["~ n ~"]/i-latitude-deg", glat);
  setprop ("ai/guided/bomb["~ n ~"]/i-longitude-deg", glong);

  weapons.impact_report(n);
  #props.globals.getNode("/models", 1).removeChild("model", 0);
  } else {
    settimer(func{impact_detect(n);}, 0);
  }
}

#####
## create impact report similar to submodels
#####
var impact_report = func(o) {

var p = o;
setprop("ai/models/guided[" ~ p ~ "]/impact/latitude-deg", getprop("ai/guided/bomb[" ~ p ~ "]/i-latitude-deg"));
setprop("ai/models/guided[" ~ p ~ "]/impact/longitude-deg", getprop("ai/guided/bomb[" ~ p ~ "]/i-longitude-deg"));
var geo_info = geodinfo(getprop("ai/guided/bomb[" ~ p ~ "]/i-latitude-deg"),getprop("ai/guided/bomb[" ~ p ~ "]/i-longitude-deg"));
debug.dump(geo_info);

if (geo_info[1] == nil){
var geo_info = [ geo_info[0], { light_coverage: 2000000, bumpiness: 0.5999999999999999, load_resistance: 1e+30, solid: 1, names: [ 'DirectObjectImpact' ], friction_factor: 0.9, rolling_friction: 0.1 } ];
}

var mat_name = geo_info[1]["names"][0];
if (mat_name == nil) {
var mat_name = nil;
}
setprop("ai/models/guided[" ~ p ~ "]/material/name", mat_name);
var galt_m = geo_info[0];
setprop("ai/models/guided[" ~ p ~ "]/impact/elevation-m", galt_m);
var solid = geo_info[1]["solid"];
setprop("ai/models/guided[" ~ p ~ "]/material/solid", solid);
#debug.dump(mat_name);
#print (solid);

setprop("ai/models/guided[" ~ p ~ "]/id", -1);
setprop("ai/models/guided[" ~ p ~ "]/mass-slug", 62.17);#2000lb/32.17
setprop("ai/models/guided[" ~ p ~ "]/impact/type", 'terrain');
#setprop("ai/models/guided[" ~ p ~ "]/impact/heading-deg", 0);
#setprop("ai/models/guided[" ~ p ~ "]/impact/pitch-deg", 0);
#setprop("ai/models/guided[" ~ p ~ "]/impact/roll-deg", 0);
#setprop("ai/models/guided[" ~ p ~ "]/impact/speed-mps", 0);

setprop("ai/models/model-impact", '/ai/models/guided['"" ~ p ~ ""']');

# place impact crater model

#if (solid){
#geo.put_model("Aircraft/vulcanb2/Models/crater.ac",getprop("ai/guided/bomb[" ~ p ~ "]/i-latitude-deg"), getprop("ai/guided/bomb[" ~ p ~ "]/i-longitude-deg"));
#} else {
#var ltext = "Impact on non solid surface, detonation aborted";
#screen.log.write(ltext);
#}
}

## Add listener for bomb impact (from vulcan b2)
setlistener("ai/models/model-impact", func(n) {
    var impact = n.getValue();
    var solid = getprop(impact ~ "/material/solid");

    if (solid){
      var long = getprop(impact ~ "/impact/longitude-deg");
      var lat = getprop(impact ~ "/impact/latitude-deg");

      geo.put_model("Aircraft/vulcanb2/Models/crater.ac",lat, long);
    }
});

#removing
#props.globals.getNode("/models", 1).removeChild("model", 0);
