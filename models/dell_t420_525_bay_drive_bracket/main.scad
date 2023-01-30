use <../../lib/ddscad/screw_holes.scad>

$fn = $preview? 64 : 128;

MODEL_NAME = "Dell T420 5.25\" Bay Drive Bracket";
MODEL_VERSION = "0.1.0";

BRACKET_DEPTH = 115;
BRACKET_WIDTH = 143;
BRACKET_HEIGHT = 28;

BRACKET_BASE_PLATE_THICKNESS = 2;
BRACKET_BASE_PLATE_CUTOUT_DEPTH_OFFSET = 8;
BRACKET_BASE_PLATE_CUTOUT_DEPTH = 12;
BRACKET_BASE_PLATE_CUTOUT_WIDTH = 124;
BRACKET_BASE_PLATE_CUTOUT_WIDTH_OFFSET = 9.5;

BRACKET_SIDE_WALL_HEIGHT = 15;
BRACKET_SIDE_WALL_THICKNESS = 4;

BRACKET_SIDE_WALL_SCREW_HOLE_DIAMETER = 3;
BRACKET_SIDE_WALL_SCREW_HOLE_DEPTH = 4;

BRACKET_SIDE_WALL_MOUNTING_SCREW_HOLE_HIGHT_OFFSET = 7;
BRACKET_SIDE_WALL_MOUNTING_SCREW_HOLE_2_DEPTH_OFFSET = 80;
BRACKET_SIDE_WALL_MOUNTING_SCREW_HOLE_1_DEPTH_OFFSET = 1;


module bracket_base_plate() {
    linear_extrude(height=BRACKET_BASE_PLATE_THICKNESS) {
        difference() {
            square(size=[BRACKET_WIDTH, BRACKET_DEPTH]);

            translate(v=[
                BRACKET_BASE_PLATE_CUTOUT_WIDTH_OFFSET + 10/2,
                BRACKET_BASE_PLATE_CUTOUT_DEPTH_OFFSET + 10/2,
                0
            ]) {
                minkowski() {
                    square(size=[BRACKET_BASE_PLATE_CUTOUT_WIDTH - 10, BRACKET_BASE_PLATE_CUTOUT_DEPTH - 10]);
                    circle(d=10);
                }
            }
        }
    }
}


module bracket_side_wall() {
    translate(v=[BRACKET_SIDE_WALL_THICKNESS, 0, 0]) {
        rotate(a=[0, -90, 0]) {
            difference() {
                linear_extrude(height=BRACKET_SIDE_WALL_THICKNESS) {
                    square(size=[BRACKET_SIDE_WALL_HEIGHT, BRACKET_DEPTH]);
                }

                translate(v=[
                    BRACKET_SIDE_WALL_MOUNTING_SCREW_HOLE_HIGHT_OFFSET,
                    BRACKET_SIDE_WALL_MOUNTING_SCREW_HOLE_1_DEPTH_OFFSET,
                    0
                ]) {
                    screw_hole(
                        depth=BRACKET_SIDE_WALL_SCREW_HOLE_DEPTH,
                        diameter=BRACKET_SIDE_WALL_SCREW_HOLE_DIAMETER,
                        counterbore_diameter=4,
                        counterbore_depth=1
                    );
                }

                translate(v=[
                    BRACKET_SIDE_WALL_MOUNTING_SCREW_HOLE_HIGHT_OFFSET,
                    BRACKET_SIDE_WALL_MOUNTING_SCREW_HOLE_2_DEPTH_OFFSET,
                    0
                ]) {
                    screw_hole(
                        depth=BRACKET_SIDE_WALL_SCREW_HOLE_DEPTH,
                        diameter=BRACKET_SIDE_WALL_SCREW_HOLE_DIAMETER,
                        counterbore_diameter=4,
                        counterbore_depth=1
                    );
                }
            }
        }
    }
}


module main() {
    union() {
        bracket_base_plate();

        bracket_side_wall();

        translate(v=[BRACKET_WIDTH, 0, 0]) {
            mirror([1, 0, 0]) {
                bracket_side_wall(); 
            }
        }
    }
}


main();
