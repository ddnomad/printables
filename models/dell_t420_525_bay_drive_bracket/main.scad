use <../../lib/ddscad/rounding.scad>
use <../../lib/ddscad/screw_holes.scad>

include <../../lib/ddscad/drive.scad>

$fn = $preview? 64 : 128;

MODEL_NAME = "Dell T420 5.25\" Bay Drive Bracket";
MODEL_VERSION = "0.1.0";

BRACKET_DEPTH = 127; // Y axis
BRACKET_HEIGHT = 28; // Z axis
BRACKET_WIDTH = 143; // X axis

BRACKET_MAXIMUM_HEIGHT = 39; // Z axis

BRACKET_BASE_PLATE_CUTOUT_DIAMETER = 10;
BRACKET_BASE_PLATE_CUTOUT_DEPTH_OFFSET = 8; // Y axis
BRACKET_BASE_PLATE_HEIGHT = 2; // Z axis

BRACKET_BASE_PLATE_DEPTH_CUTOUT_DEPTH = 107; // Y axis
BRACKET_BASE_PLATE_DEPTH_CUTOUT_WIDTH = 12; // Y axis
BRACKET_BASE_PLATE_DEPTH_CUTOUT_WIDTH_OFFSET = 35; // Y axis

BRACKET_BASE_PLATE_WIDTH_CUTOUT_DEPTH = 12; // Y axis
BRACKET_BASE_PLATE_WIDTH_CUTOUT_WIDTH = 125; // X axis

BRACKET_MOUNTING_WALL_WIDTH = 4; // X axis

BRACKET_SIDE_WALL_DEPTH = 115; // Y axis
BRACKET_SIDE_WALL_HEIGHT = 12; // Z axis
BRACKET_SIDE_WALL_WIDTH = 4; // X axis

BRACKET_SIDE_WALL_SCREW_HOLE_DIAMETER = 3;
BRACKET_SIDE_WALL_SCREW_HOLE_COUNTERBORE_DIAMETER = 4;

BRACKET_SIDE_WALL_SCREW_HOLE_DEPTH = 4; // Y axis
BRACKET_SIDE_WALL_SCREW_HOLE_COUNTERBORE_DEPTH = 1;  // Y axis

BRACKET_SIDE_WALL_MOUNTING_SCREW_HOLE_HEIGHT_OFFSET = 7; // Z axis
BRACKET_SIDE_WALL_MOUNTING_SCREW_HOLE_1_DEPTH_OFFSET = 1; // Y axis
BRACKET_SIDE_WALL_MOUNTING_SCREW_HOLE_2_DEPTH_OFFSET = 80; // Y axis


module bracket_base_depth_cutout() {
    union() {
        inner_corner_rounder(radius=BRACKET_BASE_PLATE_CUTOUT_DIAMETER, corner_position="bottom_right");

        translate(v=[BRACKET_BASE_PLATE_CUTOUT_DIAMETER, 0, 0]) {
            square(size=[
                BRACKET_BASE_PLATE_DEPTH_CUTOUT_WIDTH - BRACKET_BASE_PLATE_CUTOUT_DIAMETER,
                BRACKET_BASE_PLATE_DEPTH_CUTOUT_DEPTH - BRACKET_BASE_PLATE_CUTOUT_DIAMETER
            ]);
        }

        translate(v=[
            BRACKET_BASE_PLATE_CUTOUT_DIAMETER + BRACKET_BASE_PLATE_DEPTH_CUTOUT_WIDTH - BRACKET_BASE_PLATE_CUTOUT_DIAMETER,
            0,
            0
        ]) {
            inner_corner_rounder(radius=BRACKET_BASE_PLATE_CUTOUT_DIAMETER, corner_position="bottom_left");
        }
    }
}


module bracket_base_plate() {
    linear_extrude(height=BRACKET_BASE_PLATE_HEIGHT) {
        difference() {
            square(size=[BRACKET_WIDTH, BRACKET_DEPTH]);

            translate(v=[
                (BRACKET_WIDTH - BRACKET_BASE_PLATE_WIDTH_CUTOUT_WIDTH + BRACKET_BASE_PLATE_CUTOUT_DIAMETER) / 2,
                BRACKET_BASE_PLATE_CUTOUT_DEPTH_OFFSET + BRACKET_BASE_PLATE_CUTOUT_DIAMETER / 2,
                0
            ]) {
                minkowski() {
                    union() {
                        square(size=[
                            BRACKET_BASE_PLATE_WIDTH_CUTOUT_WIDTH - BRACKET_BASE_PLATE_CUTOUT_DIAMETER,
                            BRACKET_BASE_PLATE_WIDTH_CUTOUT_DEPTH - BRACKET_BASE_PLATE_CUTOUT_DIAMETER
                        ]);

                        translate(v=[
                            BRACKET_BASE_PLATE_DEPTH_CUTOUT_WIDTH_OFFSET - BRACKET_BASE_PLATE_CUTOUT_DIAMETER,
                            BRACKET_BASE_PLATE_WIDTH_CUTOUT_DEPTH - BRACKET_BASE_PLATE_CUTOUT_DIAMETER,
                            0
                        ]) {
                            bracket_base_depth_cutout();
                        }

                        translate(v=[
                            (
                                BRACKET_BASE_PLATE_WIDTH_CUTOUT_WIDTH - BRACKET_BASE_PLATE_DEPTH_CUTOUT_WIDTH -
                                BRACKET_BASE_PLATE_DEPTH_CUTOUT_WIDTH_OFFSET - BRACKET_BASE_PLATE_CUTOUT_DIAMETER
                            ),
                            BRACKET_BASE_PLATE_WIDTH_CUTOUT_DEPTH - BRACKET_BASE_PLATE_CUTOUT_DIAMETER,
                            0
                        ]) {
                            bracket_base_depth_cutout();
                        }
                    };
                    circle(d=BRACKET_BASE_PLATE_CUTOUT_DIAMETER);
                }
            }
        }
    }
}


module bracket_drive_mounting_wall() {
    linear_extrude(height=BRACKET_MAXIMUM_HEIGHT - BRACKET_BASE_PLATE_HEIGHT) {
        square([BRACKET_MOUNTING_WALL_WIDTH, SATA_SSD_25_DEPTH]);
    }
}


module bracket_side_wall() {
    translate(v=[BRACKET_SIDE_WALL_WIDTH, 0, 0]) {
        rotate(a=[0, -90, 0]) {
            difference() {
                linear_extrude(height=BRACKET_SIDE_WALL_WIDTH) {
                    square(size=[BRACKET_SIDE_WALL_HEIGHT, BRACKET_SIDE_WALL_DEPTH]);
                }

                translate(v=[
                    BRACKET_SIDE_WALL_MOUNTING_SCREW_HOLE_HEIGHT_OFFSET,
                    BRACKET_SIDE_WALL_MOUNTING_SCREW_HOLE_1_DEPTH_OFFSET,
                    0
                ]) {
                    screw_hole(
                        depth=BRACKET_SIDE_WALL_SCREW_HOLE_DEPTH,
                        diameter=BRACKET_SIDE_WALL_SCREW_HOLE_DIAMETER,
                        counterbore_diameter=BRACKET_SIDE_WALL_SCREW_HOLE_COUNTERBORE_DIAMETER,
                        counterbore_depth=BRACKET_SIDE_WALL_SCREW_HOLE_COUNTERBORE_DEPTH
                    );
                }

                translate(v=[
                    BRACKET_SIDE_WALL_MOUNTING_SCREW_HOLE_HEIGHT_OFFSET,
                    BRACKET_SIDE_WALL_MOUNTING_SCREW_HOLE_2_DEPTH_OFFSET,
                    0
                ]) {
                    screw_hole(
                        depth=BRACKET_SIDE_WALL_SCREW_HOLE_DEPTH,
                        diameter=BRACKET_SIDE_WALL_SCREW_HOLE_DIAMETER,
                        counterbore_diameter=BRACKET_SIDE_WALL_SCREW_HOLE_COUNTERBORE_DIAMETER,
                        counterbore_depth=BRACKET_SIDE_WALL_SCREW_HOLE_COUNTERBORE_DEPTH
                    );
                }
            }
        }
    }
}


module main() {
    union() {
        bracket_base_plate();

        translate(v=[
            (BRACKET_WIDTH - (SATA_SSD_25_WIDTH + BRACKET_MOUNTING_WALL_WIDTH * 2)) / 2,
            0,
            BRACKET_BASE_PLATE_HEIGHT
        ]) {
            bracket_drive_mounting_wall();

            translate(v=[SATA_SSD_25_WIDTH, 0, 0]) {
                bracket_drive_mounting_wall();
            }
        }

        bracket_side_wall();

        translate(v=[BRACKET_WIDTH, 0, 0]) {
            mirror([1, 0, 0]) {
                bracket_side_wall(); 
            }
        }


    }
}


main();
