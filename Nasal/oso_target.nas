#####
## target designator (target_number(), mouseclick and target_des())
#####

### sets target coordinates via mouseclick and t button
var target_des = func {
var n = getprop("ai/guided/target-number");
var m = n + 1;

# target parameters
var target = geo.click_position();
var tlat = target.lat();
var tlong = target.lon();
setprop("ai/guided/bomb[" ~ n ~ "]/target-latitude-deg",tlat);
setprop("ai/guided/bomb[" ~ n ~ "]/target-longitude-deg",tlong);
setprop("ai/guided/bomb[" ~ n ~ "]/engaged",0);
setprop("ai/guided/bomb[" ~ n ~ "]/target-in_range", 0);
setprop("armament/bay-intmd/rot-launcher-active",0);
setprop("ai/guided/number_for_release", 0);
setprop("ai/guided/id-release", 0);
var ltext = "Coordinates for target " ~ m ~ " stored";
screen.log.write(ltext);
}

# target param reset called from keyboard/menu input
var target_input = func(n) {

setprop("ai/guided/bomb[" ~ n ~ "]/engaged",0);
setprop("ai/guided/bomb[" ~ n ~ "]/target-in_range", 0);
setprop("armament/bay-intmd/rot-launcher-active",0);
setprop("ai/guided/number_for_release", 0);
setprop("ai/guided/id-release", 0);
}

### switch between 4 ordonance slots and select one
var target_number = func(m) {
var n = getprop("ai/guided/target-number");
var nm = n + m;
if (nm >= 4) {
var nm = 0;
}
if (nm <= 0) {
var nm = 0;
}
setprop("ai/guided/target-number", nm);
var o = nm + 1;
var ltext = "Ordonance " ~ o ~ " selected";
screen.log.write(ltext);
}

#####
## calculator for range/checks of target
#####
var target_data = func {
var on = getprop("armament/x-to-target");
if (on == 1){

### our position
var calt_m = getprop("position/altitude-ft") / 3.28084;
var clat = getprop("position/latitude-deg");
var clong = getprop("position/longitude-deg");
var cpos = geo.Coord.new().set_latlon(clat, clong, calt_m);
### bomb parameters
var n = getprop("ai/guided/id-target");
if(n == nil) {
var n = 0;
}
var m = n + 1;
if (m >= 4) {
var m = 0;
}
setprop("ai/guided/id-target", m);
#debug.dump(n);
var tnil = getprop("ai/guided/bomb[" ~ n ~ "]/target-latitude-deg");
#debug.dump(tnil);
  if ((tnil == nil) or (tnil == '')) {
    settimer(target_data, 0.1);
    return;
    } else {


      # target parameters
      var tlat = getprop("ai/guided/bomb[" ~ n ~ "]/target-latitude-deg");
      var tlong = getprop("ai/guided/bomb[" ~ n ~ "]/target-longitude-deg");
      var talt_m = geo.elevation(tlat, tlong);
      if ((talt_m == nil) or (tnil == '')) {
        settimer(target_data, 0.1);
        return;
        }
      var tpos = geo.Coord.new().set_latlon(tlat, tlong, talt_m);

      var tdist = cpos.distance_to(tpos);#in m
      var tdist_nm = tdist / 1000 * 0.51444;
      setprop("ai/guided/bomb[" ~ n ~ "]/target-distance", tdist_nm);
      var tdalt = calt_m - talt_m;
      var dmax = tdist / tdalt;

      var tdeg = cpos.course_to(tpos);
      setprop("ai/guided/bomb[" ~ n ~ "]/target-bearing", tdeg);

      if (dmax <= 3){
        setprop("ai/guided/bomb[" ~ n ~ "]/target-in_range", 1);
        #print("targetinrange" ~ n ~ "");
        } else {
          setprop("ai/guided/bomb[" ~ n ~ "]/target-in_range", 0);
          }
      }
  settimer(target_data, 0.1);
  }
}

#####
## calculator checks if target is in range/autorelease
#####
var release_timer = func {
#print("release_timer");
var on = getprop("armament/auto-release");
if (on == 1){

  ### get target parameters
  var n = getprop("ai/guided/id-release");
  var m = n + 1;
  if (m >= 4) {
    var m = 0;
    }
  setprop("ai/guided/id-release", m);

  var in_range = getprop("ai/guided/bomb[" ~ n ~ "]/target-in_range");
  if(in_range == nil) {
    var in_range = 0;
    }
  var engaged = getprop("ai/guided/bomb[" ~ n ~ "]/engaged");

    if ((in_range == 1) and (engaged == 0)){
      setprop("ai/guided/bomb[" ~ n ~ "]/engaged", 1);
      weapons.launch_sync();
      print("targetinrange" ~ n ~ "");
    }
  settimer(release_timer, 0.2);
  }
}


#####
### calculate bomb count and launch sequence
### note: sequence is not launched when rot launcher is active
#####
var launch_sync = func {

var nr_rel = getprop("ai/guided/number_for_release");
var nr_rel = nr_rel + 1;
setprop("ai/guided/number_for_release", nr_rel);
debug.dump(nr_rel);
var launch_active = getprop("armament/bay-intmd/rot-launcher-active");
if ((launch_active == nil) or (launch_active == 0)) {
  weapons.auto_launcher();
  print("auto_launch");
  #weapons.check_launch();
  setprop("armament/bay-intmd/rot-launcher-active",1);
  } else {
    weapons.check_launch();
    print("check_launch");
    }
}

###checks for unreleased bombs and tries to release them
var check_launch = func {
var on = getprop("armament/auto-release");
if (on == 1){
var nr_rel = getprop("ai/guided/number_for_release");
var launch_active = getprop("armament/bay-intmd/rot-launcher-active");

  if ((nr_rel >= 1) and (launch_active == 1)){
    settimer(check_launch,0.5);
    print("launcher_active");
    }
  if ((nr_rel >= 1) and (launch_active == 0)){
    weapons.launch_intmd();
    #weapons.auto_launcher();
    setprop("armament/bay-intmd/rot-launcher-active",1);
    #settimer(check_launch,0.5);
    print("launcher_not_active");
    }
  if (nr_rel == 0){
    var ltext = "All weapons released";
    screen.log.write(ltext);
    }
  }
}