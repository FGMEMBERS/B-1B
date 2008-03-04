##### Radar properties for display of multiplayer aircraft

setlistener("/sim/signals/fdm-initialized", func {
setprop("controls/switches/radar_init", 0);
radar.mplayer();
});

#setlistener("controls/switches/terrain-follow", func {
#settimer(mplayer,1, 0);
#});

### calculates the correct mp distance for radar display
#var 10 = 0.0080;
#var 20 = 0.0040;
#var 40 = 0.0020;
#var 80 = 0.0010;
#var 160 = 0.0005;
#var 320 = 0.00025;
#var 640 = 0.000125;

var mplayer = func {
var r_init = getprop("controls/switches/radar_init");

 if (r_init == 0) {
#   print("init1");
   setprop("controls/switches/radar_init", 1);
   setprop("controls/switches/radar_i", 0);
 }
 if (r_init == 1) {
#print("init2");
    var i = getprop("controls/switches/radar_i");
    var range_mp = getprop("ai/models/multiplayer[" ~ i ~ "]/radar/range-nm[0]");
    var range_radar = getprop("instrumentation/radar/range[0]");
      if (range_mp == nil) {
        range_mp = 0;
        #setprop("ai/models/multiplayer[" ~ i ~ "]/radar/in-range", 0);
      }
    var factor_range_radar = 0.08 / range_radar;
    var draw_radar = factor_range_radar * range_mp;
    setprop("ai/models/multiplayer[" ~ i ~ "]/radar/draw-range-nm[0]", draw_radar);
      ###calculates the relative altitude compared to the user
      var mp_alt = getprop("ai/models/multiplayer[" ~ i ~ "]/position/altitude-ft");
      var my_alt = getprop("position/altitude-ft");
       if (mp_alt == nil) {
         mp_alt = 0;
         }
      var rel_alt_mp = mp_alt - my_alt;
      setprop("ai/models/multiplayer[" ~ i ~ "]/position/rel-altitude-ft", rel_alt_mp);
    var i = i + 1;
      if (i == 13) {
       var i = 0;
      }
    setprop("controls/switches/radar_i", i);
  }
settimer(mplayer, 0.1);
}

