module screw_hole(depth, diameter, counterbore_diameter=undef, counterbore_depth=undef) {
    assert(diameter != undef, "Screw hole diameter must be specified");
    assert(depth != undef, "Screw hole depth must be specified");

    assert(
        counterbore_diameter == undef || counterbore_diameter > diameter,
        "Counterbore diameter must be larger than screw hole diameter"
    );

    assert(
        counterbore_depth == undef || counterbore_depth > 0,
        "Counterbore depth must be larger than zero"
    );

    translate(v=[max(diameter, counterbore_diameter) / 2, max(diameter, counterbore_diameter) / 2, 0]) {
        union() {
            if (counterbore_diameter != undef && counterbore_depth != undef) {
                translate(v=[0, 0, depth - counterbore_depth]) {
                    linear_extrude(height=counterbore_depth) {
                        circle(d=counterbore_diameter);
                    }
                }
            }

            linear_extrude(height=depth) {
                circle(d=diameter);
            }
        }
    }
}
