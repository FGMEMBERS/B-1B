#settings for the oso mfd

#header:
#line1 
#line2
#line3 
#line4
#line5 
#line6
#line7 
#line8
#footer:menu selections
setprop("instrumentation/ikb/ikb_none", 0);
setprop("instrumentation/ikb/ikb_input", 0);

var wso_mfd = [
#bay intmd
  [ 
    ["BAY INTMD OVERVIEW", "MENU CHANGE <"],
    ["STAT1", "armament/bay1/rack0-armed", "DIST", "ai/guided/bomb[0]/target-distance"],
    ["STAT2", "armament/bay1/rack1-armed", "DIST", "ai/guided/bomb[1]/target-distance"],
    ["STAT3", "armament/bay1/rack2-armed", "DIST", "ai/guided/bomb[2]/target-distance"],
    ["STAT4", "armament/bay1/rack3-armed", "DIST", "ai/guided/bomb[3]/target-distance"],
    ["STAT5", "armament/bay1/rack4-armed", "DIST", "ai/guided/bomb[4]/target-distance"],
    ["STAT6", "armament/bay1/rack5-armed", "DIST", "ai/guided/bomb[5]/target-distance"],
    ["STAT7", "armament/bay1/rack6-armed", "DIST", "ai/guided/bomb[6]/target-distance"],
    ["STAT8", "armament/bay1/rack7-armed", "DIST", "ai/guided/bomb[7]/target-distance"],
  ],
#station1
  [ 
    ["STATION1", "MENU CHANGE <"],
    ["TYPE", "armament/bay1/rack0", "ARMED", "armament/bay1/rack0-armed"],
    ["LON", "ai/guided/bomb[0]/target-longitude-deg", "LAT", "ai/guided/bomb[0]/target-latitude-deg"],
    ["DIST", "ai/guided/bomb[0]/target-distance", "TIME", "ai/guided/bomb[0]/target-distance-sec"],
    ["-----", "instrumentation/ikb/ikb_none", "-----", "instrumentation/ikb/ikb_none"],
    ["IKB", "instrumentation/ikb/ikb_input", "SET IKB<", "instrumentation/ikb/ikb_none"],
    ["POS", "instrumentation/ikb/coord_pos", "", "instrumentation/ikb/ikb_none"],
    ["", "instrumentation/ikb/ikb_none", "SET LON<", "instrumentation/ikb/ikb_none"],
    ["", "instrumentation/ikb/ikb_none", "SET LAT<", "instrumentation/ikb/ikb_none"]
  ],
#station2
  [ 
    ["STATION2", "MENU CHANGE <"],
    ["TYPE", "armament/bay1/rack1", "ARMED", "armament/bay1/rack1-armed"],
    ["LON", "ai/guided/bomb[1]/target-longitude-deg", "LAT", "ai/guided/bomb[1]/target-latitude-deg"],
    ["DIST", "ai/guided/bomb[1]/target-distance", "TIME", "ai/guided/bomb[1]/target-distance-sec"],
    ["-----", "instrumentation/ikb/ikb_none", "-----", "instrumentation/ikb/ikb_none"],
    ["IKB", "instrumentation/ikb/ikb_input", "SET IKB<", "instrumentation/ikb/ikb_none"],
    ["POS", "instrumentation/ikb/coord_pos", "", "instrumentation/ikb/ikb_none"],
    ["", "instrumentation/ikb/ikb_none", "SET LON<", "instrumentation/ikb/ikb_none"],
    ["", "instrumentation/ikb/ikb_none", "SET LAT<", "instrumentation/ikb/ikb_none"]
  ],
#station3
  [ 
    ["STATION3", "MENU CHANGE <"],
    ["TYPE", "armament/bay1/rack2", "ARMED", "armament/bay1/rack2-armed"],
    ["LON", "ai/guided/bomb[2]/target-longitude-deg", "LAT", "ai/guided/bomb[2]/target-latitude-deg"],
    ["DIST", "ai/guided/bomb[2]/target-distance", "TIME", "ai/guided/bomb[2]/target-distance-sec"],
    ["-----", "instrumentation/ikb/ikb_none", "-----", "instrumentation/ikb/ikb_none"],
    ["IKB", "instrumentation/ikb/ikb_input", "SET IKB<", "instrumentation/ikb/ikb_none"],
    ["POS", "instrumentation/ikb/coord_pos", "", "instrumentation/ikb/ikb_none"],
    ["", "instrumentation/ikb/ikb_none", "SET LON<", "instrumentation/ikb/ikb_none"],
    ["", "instrumentation/ikb/ikb_none", "SET LAT<", "instrumentation/ikb/ikb_none"]
  ],
#station4
  [ 
    ["STATION4", "MENU CHANGE <"],
    ["TYPE", "armament/bay1/rack3", "ARMED", "armament/bay1/rack3-armed"],
    ["LON", "ai/guided/bomb[3]/target-longitude-deg", "LAT", "ai/guided/bomb[3]/target-latitude-deg"],
    ["DIST", "ai/guided/bomb[3]/target-distance", "TIME", "ai/guided/bomb[3]/target-distance-sec"],
    ["-----", "instrumentation/ikb/ikb_none", "-----", "instrumentation/ikb/ikb_none"],
    ["IKB", "instrumentation/ikb/ikb_input", "SET IKB<", "instrumentation/ikb/ikb_none"],
    ["POS", "instrumentation/ikb/coord_pos", "", "instrumentation/ikb/ikb_none"],
    ["", "instrumentation/ikb/ikb_none", "SET LON<", "instrumentation/ikb/ikb_none"],
    ["", "instrumentation/ikb/ikb_none", "SET LAT<", "instrumentation/ikb/ikb_none"]
  ],
#station5
  [ 
    ["STATION5", "MENU CHANGE <"],
    ["TYPE", "armament/bay1/rack4", "ARMED", "armament/bay1/rack4-armed"],
    ["LON", "ai/guided/bomb[4]/target-longitude-deg", "LAT", "ai/guided/bomb[4]/target-latitude-deg"],
    ["DIST", "ai/guided/bomb[4]/target-distance", "TIME", "ai/guided/bomb[4]/target-distance-sec"],
    ["-----", "instrumentation/ikb/ikb_none", "-----", "instrumentation/ikb/ikb_none"],
    ["IKB", "instrumentation/ikb/ikb_input", "SET IKB<", "instrumentation/ikb/ikb_none"],
    ["POS", "instrumentation/ikb/coord_pos", "<", "instrumentation/ikb/ikb_none"],
    ["", "instrumentation/ikb/ikb_none", "SET LON", "instrumentation/ikb/ikb_none"],
    ["", "instrumentation/ikb/ikb_none", "SET LAT<", "instrumentation/ikb/ikb_none"]
  ],
#station6
  [ 
    ["STATION6", "MENU CHANGE <"],
    ["TYPE", "armament/bay1/rack5", "ARMED", "armament/bay1/rack5-armed"],
    ["LON", "ai/guided/bomb[5]/target-longitude-deg", "LAT", "ai/guided/bomb[5]/target-latitude-deg"],
    ["DIST", "ai/guided/bomb[5]/target-distance", "TIME", "ai/guided/bomb[5]/target-distance-sec"],
    ["-----", "instrumentation/ikb/ikb_none", "-----", "instrumentation/ikb/ikb_none"],
    ["IKB", "instrumentation/ikb/ikb_input", "SET IKB<", "instrumentation/ikb/ikb_none"],
    ["POS", "instrumentation/ikb/coord_pos", "", "instrumentation/ikb/ikb_none"],
    ["", "instrumentation/ikb/ikb_none", "SET LON<", "instrumentation/ikb/ikb_none"],
    ["", "instrumentation/ikb/ikb_none", "SET LAT<", "instrumentation/ikb/ikb_none"]
  ],
#station7
  [ 
    ["STATION7", "MENU CHANGE <"],
    ["TYPE", "armament/bay1/rack6", "ARMED", "armament/bay1/rack6-armed"],
    ["LON", "ai/guided/bomb[6]/target-longitude-deg", "LAT", "ai/guided/bomb[6]/target-latitude-deg"],
    ["DIST", "ai/guided/bomb[6]/target-distance", "TIME", "ai/guided/bomb[6]/target-distance-sec"],
    ["-----", "instrumentation/ikb/ikb_none", "-----", "instrumentation/ikb/ikb_none"],
    ["IKB", "instrumentation/ikb/ikb_input", "SET IKB<", "instrumentation/ikb/ikb_none"],
    ["POS", "instrumentation/ikb/coord_pos", "", "instrumentation/ikb/ikb_none"],
    ["", "instrumentation/ikb/ikb_none", "SET LON<", "instrumentation/ikb/ikb_none"],
    ["", "instrumentation/ikb/ikb_none", "SET LAT<", "instrumentation/ikb/ikb_none"]
  ],
#station8
  [ 
    ["STATION8", "MENU CHANGE <"],
    ["TYPE", "armament/bay1/rack7", "ARMED", "armament/bay1/rack7-armed"],
    ["LON", "ai/guided/bomb[7]/target-longitude-deg", "LAT", "ai/guided/bomb[7]/target-latitude-deg"],
    ["DIST", "ai/guided/bomb[7]/target-distance", "TIME", "ai/guided/bomb[7]/target-distance-sec"],
    ["-----", "instrumentation/ikb/ikb_none", "-----", "instrumentation/ikb/ikb_none"],
    ["IKB", "instrumentation/ikb/ikb_input", "SET IKB<", "instrumentation/ikb/ikb_none"],
    ["POS", "instrumentation/ikb/coord_pos", "", "instrumentation/ikb/ikb_none"],
    ["", "instrumentation/ikb/ikb_none", "SET LON<", "instrumentation/ikb/ikb_none"],
    ["", "instrumentation/ikb/ikb_none", "SET LAT<", "instrumentation/ikb/ikb_none"]
  ]

];

setprop("instrumentation/wso_mfd/menu", 0);

#m=direct menu select,n= incr/decr current
var wso_mfd_update = func(m,n){
  var cmenu = getprop("instrumentation/wso_mfd/menu");
  var cminu = cmenu - 1;

  if(m == 1){
    #direct select submenu, if we are in topmenu
    if((cmenu == 0) or ((m == 1) and (n == 0))){
      #n = n;
      setprop("instrumentation/wso_mfd/menu", n);
      wso_mfd_draw();
    }

    if((cmenu > 0) and (cmenu < 9)){
      if (n == 5){
        tgt_input(0);
        wso_mfd_draw();
      }
      if (n == 7){
        setprop("ai/guided/bomb["~ cminu ~"]/target-longitude-deg",getprop("instrumentation/ikb/ikb_input"));
        weapons.wpn_info[cminu].lon = getprop("instrumentation/ikb/ikb_input");
        var talt_m = geo.elevation(wpn_info[cminu]["lat"], wpn_info[cminu]["lon"]);
        if ((talt_m == nil) or (talt_m == "")) {
          weapons.wpn_info[cminu].talt_m = -11;
        } else {
            wpn_info[cminu].talt_m = talt_m;
          }
        wso_mfd_draw();
      }
      if (n == 8){
        setprop("ai/guided/bomb["~ cminu ~"]/target-latitude-deg",getprop("instrumentation/ikb/ikb_input"));
        weapons.wpn_info[cminu].lat = getprop("instrumentation/ikb/ikb_input");
        var talt_m = geo.elevation(wpn_info[cminu]["lat"], wpn_info[cminu]["lon"]);
        if ((talt_m == nil) or (talt_m == "")) {
          weapons.wpn_info[cminu].talt_m = -11;
        } else {
            wpn_info[cminu].talt_m = talt_m;
          }
        wso_mfd_draw();
      }
    }
  }

  #incr current menu entry
  if(m == -1){
    n = cmenu + n;
    if ((n > 8) or (n < 0)){
      n = 0;
    }
    setprop("instrumentation/wso_mfd/menu", n);
    wso_mfd_draw();
  }
}

var wso_mfd_draw = func(){

  var n = getprop("instrumentation/wso_mfd/menu");
  #header
  setprop("instrumentation/wso_mfd/line00", wso_mfd[n][0][0]);
  #line1
  setprop("instrumentation/wso_mfd/line10", wso_mfd[n][1][0]);
  setprop("instrumentation/wso_mfd/line11", getprop(""~ wso_mfd[n][1][1] ~""));
  setprop("instrumentation/wso_mfd/line12", wso_mfd[n][1][2]);
  setprop("instrumentation/wso_mfd/line13", getprop(""~ wso_mfd[n][1][3] ~""));
  #line2
  setprop("instrumentation/wso_mfd/line20", wso_mfd[n][2][0]);
  setprop("instrumentation/wso_mfd/line21", getprop(""~ wso_mfd[n][2][1] ~""));
  setprop("instrumentation/wso_mfd/line22", wso_mfd[n][2][2]);
  setprop("instrumentation/wso_mfd/line23", getprop(""~ wso_mfd[n][2][3] ~""));
  #line3
  setprop("instrumentation/wso_mfd/line30", wso_mfd[n][3][0]);
  setprop("instrumentation/wso_mfd/line31", getprop(""~ wso_mfd[n][3][1] ~""));
  setprop("instrumentation/wso_mfd/line32", wso_mfd[n][3][2]);
  setprop("instrumentation/wso_mfd/line33", getprop(""~ wso_mfd[n][3][3] ~""));
  #line4
  setprop("instrumentation/wso_mfd/line40", wso_mfd[n][4][0]);
  setprop("instrumentation/wso_mfd/line41", getprop(""~ wso_mfd[n][4][1] ~""));
  setprop("instrumentation/wso_mfd/line42", wso_mfd[n][4][2]);
  setprop("instrumentation/wso_mfd/line43", getprop(""~ wso_mfd[n][4][3] ~""));
  #line5
  setprop("instrumentation/wso_mfd/line50", wso_mfd[n][5][0]);
  setprop("instrumentation/wso_mfd/line51", getprop(""~ wso_mfd[n][5][1] ~""));
  setprop("instrumentation/wso_mfd/line52", wso_mfd[n][5][2]);
  setprop("instrumentation/wso_mfd/line53", getprop(""~ wso_mfd[n][5][3] ~""));
  #line6
  setprop("instrumentation/wso_mfd/line60", wso_mfd[n][6][0]);
  setprop("instrumentation/wso_mfd/line61", getprop(""~ wso_mfd[n][6][1] ~""));
  setprop("instrumentation/wso_mfd/line62", wso_mfd[n][6][2]);
  setprop("instrumentation/wso_mfd/line63", getprop(""~ wso_mfd[n][6][3] ~""));
  #line7
  setprop("instrumentation/wso_mfd/line70", wso_mfd[n][7][0]);
  setprop("instrumentation/wso_mfd/line71", getprop(""~ wso_mfd[n][7][1] ~""));
  setprop("instrumentation/wso_mfd/line72", wso_mfd[n][7][2]);
  setprop("instrumentation/wso_mfd/line73", getprop(""~ wso_mfd[n][7][3] ~""));
  #line8
  setprop("instrumentation/wso_mfd/line80", wso_mfd[n][8][0]);
  setprop("instrumentation/wso_mfd/line81", getprop(""~ wso_mfd[n][8][1] ~""));
  setprop("instrumentation/wso_mfd/line82", wso_mfd[n][8][2]);
  setprop("instrumentation/wso_mfd/line83", getprop(""~ wso_mfd[n][8][3] ~""));
  #footer
  setprop("instrumentation/wso_mfd/line01", wso_mfd[n][0][1]);

}