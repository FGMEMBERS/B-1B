###arms delivery system

### weapon dialog
var weapon_select = gui.Dialog.new("dialog","Aircraft/B-1B/Dialogs/weapons.xml");

###set global vars
var wpn_info = [
    { position: 1, armed: 0, type: "", guidable: 1, active: 0, released: 0, lon: 0, lat: 0, talt_m: 0, distance: "9999", timer: 9999},
    { position: 2, armed: 0, type: "", guidable: 1, active: 0, released: 0, lon: 0, lat: 0, talt_m: 0, distance: "9999", timer: 9999},
    { position: 3, armed: 0, type: "", guidable: 1, active: 0, released: 0, lon: 0, lat: 0, talt_m: 0, distance: "9999", timer: 9999},
    { position: 4, armed: 0, type: "", guidable: 1, active: 0, released: 0, lon: 0, lat: 0, talt_m: 0, distance: "9999", timer: 9999},
    { position: 5, armed: 0, type: "", guidable: 1, active: 0, released: 0, lon: 0, lat: 0, talt_m: 0, distance: "9999", timer: 9999},
    { position: 6, armed: 0, type: "", guidable: 1, active: 0, released: 0, lon: 0, lat: 0, talt_m: 0, distance: "9999", timer: 9999},
    { position: 7, armed: 0, type: "", guidable: 1, active: 0, released: 0, lon: 0, lat: 0, talt_m: 0, distance: "9999", timer: 9999},
    { position: 8, armed: 0, type: "", guidable: 1, active: 0, released: 0, lon: 0, lat: 0, talt_m: 0, distance: "9999", timer: 9999}
];
var rot_launch_seq = [0,0,0,0,0,0,0,0];
setprop("armament/bay1/launcher-pos", 0);
setprop("ai/guided/target-number", 0);

#####
###weapon load
#####
var wpn_load = func (n) {

  var wow = getprop("gear/gear[0]/wow");
  var roll = getprop("gear/gear[0]/rollspeed-ms");
  if ((wow == 1) and (roll < 1)) {
    var weight_intmd = 0;
    for (var i = 0; i < 8; i += 1) {
      wpn_info[i].type = "gbu-31";
      wpn_info[i].armed = 0;
      wpn_info[i].active = 0;
      wpn_info[i].released = 0;
      setprop("armament/bay"~ n ~"/rack"~ i ~"-armed",0);
      setprop("armament/bay"~ n ~"/rack"~ i ~"",1);
      setprop("ai/guided/bomb["~ i ~"]/target-distance",9999);
      setprop("ai/guided/bomb["~ i ~"]/target-distance-sec",9999);
      setprop("ai/guided/bomb["~ i ~"]/target-latitude-deg",0);
      setprop("ai/guided/bomb["~ i ~"]/target-longitude-deg",0);
      weight_intmd += 2000;#2000lb for gbu-31
    }
    var bw = 4 + n;
    setprop("sim/weight["~ bw ~"]/weight-lb", weight_intmd);
    var ltext = "Weapons loaded!";
    screen.log.write(ltext);
      #some geo stuff tryout
      var clat = getprop("position/latitude-deg");
      var clon = getprop("position/longitude-deg");
      var geo_info = geodinfo(clat,clon);
      var solid = geo_info[1]["solid"];
      var material_name = geo_info[1]["names"][0];
      #debug.dump(geo_info);#dumps the whole info
      print("Current landcover:");
      print(solid);#1 if solid, 0 if not
      print(material_name);

  }  else {
       var ltext = "You have to stop at an airfield to be able to onload weapons!";
       screen.log.write(ltext);
     }
}

#####
###weapon status update main
#####
var wpn_update = func(){

  var n = getprop("armament/oso/bay-selected");

  ## calculate distance and timer to targets
  ##

  var on = getprop("armament/oso/x-to-target");
if (on){
  # our position
  var calt_m = getprop("position/altitude-ft") / 3.28084;
  var clat = getprop("position/latitude-deg");
  var clong = getprop("position/longitude-deg");
  var cpos = geo.Coord.new().set_latlon(clat, clong, calt_m);

  # target parameters
  for (var i = 0; i < 8; i += 1) {
    # target parameters
    var tpos = geo.Coord.new().set_latlon(wpn_info[i]["lat"], wpn_info[i]["lon"], wpn_info[i]["talt_m"]);

    var tdist = cpos.distance_to(tpos);#in m
    var tdist_nm = (tdist / 1000) * 0.539956;#m to nm
    wpn_info[i].distance = tdist_nm;
    setprop("ai/guided/bomb["~ i ~"]/target-distance",tdist_nm);

    var tdalt = calt_m - wpn_info[i]["talt_m"];
    var range_max = tdalt * 3;#30000m downrange for 10000m alt

    #new: calc sec to in range
    var tdist_range = tdist - range_max;
    var c_speed = getprop("velocities/groundspeed-kt");
    var tdist_range_time = tdist_range / (c_speed * 0.51444);#conversions and calc of sec
    wpn_info[i].timer = tdist_range_time;
    setprop("ai/guided/bomb["~ i ~"]/target-distance-sec",tdist_range_time);
    if (tdist_range_time < 4){
      b1b.bay_intmd(1);
    }

    var tdeg = cpos.course_to(tpos);
    setprop("ai/guided/bomb["~ i ~"]/target-bearing", tdeg);
    var chdg = getprop("orientation/heading-deg");
    var rel_tdeg = tdeg - chdg;
    
    #wpn check and release if in range
    if ((range_max > tdist) and (rel_tdeg > -45) and (rel_tdeg < 45)){
      setprop("ai/guided/bomb["~ i ~"]/target-in_range", 1);
      #print("targetinrange" ~ i ~ "");
      if ((wpn_info[i]["armed"] == 1) and (wpn_info[i]["active"] == 0)){
        wpn_info[i].active = 1;
        #prepare rot launcher for release
        rot_launch_seq[i] = 1;
        print("target_in_range");
      }
    } else {
        rot_launch_seq[i] = 0;
        #print("target_out_of_range");
      }

    }#for end
  settimer(wpn_update, 1);
  weapons.wso_mfd_draw();
  }#on end
}#end

#####
###launch weapons from rot launcher
#####
var rot_launch_rel = func() {
  
  # calc how many bombs are in target range
  var in_range = 0;
  for (var i = 0; i < 8; i += 1) {
    if (rot_launch_seq[i] == 1){
      in_range += 1;
    }
  }
  if (in_range > 0) {
    var bay = getprop("armament/oso/bay-selected");
    var launcher_pos = getprop("armament/bay"~ bay ~"/launcher-pos");
    if (rot_launch_seq[launcher_pos] == 1){
      weapons.launch(launcher_pos);
      rot_launch_seq[launcher_pos] = 0;
      wpn_info[launcher_pos].released = 1;
      wpn_info[launcher_pos].type = "";
      wpn_info[launcher_pos].armed = 0;
      setprop("armament/bay"~ bay ~"/rack"~ launcher_pos ~"-armed",0);
      setprop("armament/bay"~ bay ~"/rack"~ launcher_pos ~"",0);
      setprop("armament/bay"~ bay ~"/rack"~ launcher_pos ~"-released",1);
      #weight adjust
      var bw = 4 + bay;
      var weight_intmd = getprop("sim/weight["~ bw ~"]/weight-lb");
      weight_intmd -= 2000;
      setprop("sim/weight["~ bw ~"]/weight-lb", weight_intmd);
      #set released
      print("weapon_released");
    }
    launcher_pos += 1;
    if (launcher_pos >= 8) {
      launcher_pos = 0;
    } 
    interpolate("armament/bay"~ bay ~"/launcher-pos",launcher_pos,1);
    interpolate("armament/bay"~ bay ~"/launcher-pos-anim",launcher_pos,1);
  }
  var on = getprop("armament/oso/auto-release");
  if (on){
    settimer(rot_launch_rel, 1.1);
  }
}

#####
###OSO SMS buttons and functions
#####
var oso_sms_select = func (m, n){
  #m: 1=bay,2=buttons - n: 0-9
  if (m == 1){
    setprop("armament/oso/bay-selected",n);
  }
  if (m == 2){
    setprop("armament/oso/number-selected",n);
  }
}
#arm selected bay and number if weapon is present
var oso_arm = func(n){
  var bay = getprop("armament/oso/bay-selected");
  var nr = getprop("armament/oso/number-selected");
  if (wpn_info[nr]["type"] == "gbu-31"){
    wpn_info[nr].armed = n;
    setprop("armament/bay"~ bay ~"/rack"~ nr ~"-armed",n);
  } 
}

#rotate bay launcher, n determines racks to rotate
var launcher_rot = func(n) {
  var bay = getprop("armament/oso/bay-selected");
  var launcher_pos = getprop("armament/bay"~ bay ~"/launcher-pos");
  launcher_pos += n;
  if (launcher_pos >= 8) {
    launcher_pos = int(launcher_pos - 8);
  }
  interpolate("armament/bay"~ bay ~"/launcher-pos",launcher_pos,n);
  interpolate("armament/bay"~ bay ~"/launcher-pos-anim",launcher_pos,n);
}

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
  var tlon = target.lon();
  setprop("ai/guided/bomb["~ n ~"]/target-latitude-deg",tlat);
  setprop("ai/guided/bomb["~ n ~"]/target-longitude-deg",tlon);
  wpn_info[n].lon = tlon;
  wpn_info[n].lat = tlat;
  var talt_m = geo.elevation(wpn_info[n]["lat"], wpn_info[n]["lon"]);
  if ((talt_m == "nil") or (talt_m == '')) {
    return;
  }
  wpn_info[n].talt_m = talt_m;

  var ltext = "Coordinates for target " ~ m ~ " stored";
  screen.log.write(ltext);
}

var target_number = func(n){
  var m = getprop("ai/guided/target-number");
  m = m + n;
  if ((m > 7) or (m < 0)) {
    m = 0;
  }
  var mpl = m + 1;
  setprop("ai/guided/target-number", m);
  var ltext = "Rack " ~ mpl ~ " selected";
  screen.log.write(ltext);
}

### adjust sniper pod
var sniper_pod = func(n) {
var pod_pos = getprop("armament/sniper-pod/position-norm");
  if ((pod_pos <= 4) and (n == 1)) {
    var pod_pos_new = pod_pos + n;
    interpolate("armament/sniper-pod/position-norm",pod_pos_new,1);
  }
  if ((pod_pos >= 1) and (n == -1)) {
    var pod_pos_new = pod_pos + n;
    interpolate("armament/sniper-pod/position-norm",pod_pos_new,1);
  }
# to reset
  if ((pod_pos >= 0.01) and (pod_pos <= 0.99)) {
    interpolate("armament/sniper-pod/position-norm",0,1);
  }
}
##
#var type = wpn_info[0]["type"];
#wpn_info[0].type = "gbu-31";# set type to gbu-31
