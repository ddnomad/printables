module inner_corner_rounder(radius, corner_position) {
    assert(
        search(["top_left", "top_right", "bottom_left", "bottom_right"], corner_position),
        "Invalid corner position: choose from top_left, top_right, bottom_left, bottom_right"
    );

    difference() {
        square(radius);

        translate(v=[
            (corner_position == "top_left" || corner_position == "bottom_left")? radius : 0,
            (corner_position == "bottom_left" || corner_position == "bottom_right")? radius : 0,
            0
        ]) {
            circle(r=radius);
        }
    }
}
