init_b1b = func {
setprop("/sim/current-view/field-of-view", 60);
#setprop("/sim/panel-hotspots", 1);
#fuelflowlb();
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
