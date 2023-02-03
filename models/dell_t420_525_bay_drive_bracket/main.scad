use <../../lib/ddscad/circular.scad>
use <../../lib/ddscad/rounding.scad>
use <../../lib/ddscad/screw_holes.scad>

include <../../lib/ddscad/drive.scad>

$fn = $preview? 32 : 128;

MODEL_NAME = "Dell T420 5.25\" Bay Drive Bracket";
MODEL_VERSION = "0.1.1";

// NOTE: Unless specified otherwise, width -> x, depth -> y, height -> z
BRACKET_DEPTH = 127;
BRACKET_HEIGHT = 38;
BRACKET_WIDTH = 145;

BRACKET_BASE_PLATE_CUTOUT_DIAMETER = 9.9;
BRACKET_BASE_PLATE_CUTOUT_DEPTH_OFFSET = 9;
BRACKET_BASE_PLATE_HEIGHT = 2;

BRACKET_BASE_PLATE_DEPTH_CUTOUT_DEPTH = 105;
BRACKET_BASE_PLATE_DEPTH_CUTOUT_WIDTH = 55;
BRACKET_BASE_PLATE_WIDTH_CUTOUT_DEPTH = 10;
BRACKET_BASE_PLATE_WIDTH_CUTOUT_WIDTH = 125;

BRACKET_MOUNTING_WALL_DEPTH = SATA_SSD_25_DEPTH;
BRACKET_MOUNTING_WALL_HEIGHT = BRACKET_HEIGHT - BRACKET_BASE_PLATE_HEIGHT;
BRACKET_MOUNTING_WALL_WIDTH = 4;

// Distance between the drives when mounted in the bracket
BRACKET_MOUNTING_WALL_DRIVE_HEIGHT_OFFSET = 5;

// Distance between drive mounting walls, additional 2mm are necessary and were added on v0.1.1
BRACKET_MOUNTING_WALLS_OFFSET = SATA_SSD_25_WIDTH + 2;

BRACKET_SIDE_WALL_HEIGHT = 12;
BRACKET_SIDE_WALL_WIDTH = 4;

BRACKET_SIDE_WALL_SCREW_HOLE_COUNTERBORE_DEPTH = 1;
BRACKET_SIDE_WALL_SCREW_HOLE_COUNTERBORE_DIAMETER = 4;

BRACKET_SIDE_WALL_SCREW_HOLE_DEPTH = 4;
BRACKET_SIDE_WALL_SCREW_HOLE_DIAMETER = 3;

BRACKET_SIDE_WALL_MOUNTING_SCREW_HOLE_HEIGHT_OFFSET = 7;
BRACKET_SIDE_WALL_MOUNTING_SCREW_HOLE_1_DEPTH_OFFSET = 1;
BRACKET_SIDE_WALL_MOUNTING_SCREW_HOLE_2_DEPTH_OFFSET = 80;


module bracket_base_depth_cutout() {
    inner_corner_rounder(radius=BRACKET_BASE_PLATE_CUTOUT_DIAMETER, corner_position="bottom_right");

    translate(v=[BRACKET_BASE_PLATE_CUTOUT_DIAMETER, 0, 0]) {
        square(size=[
            BRACKET_BASE_PLATE_DEPTH_CUTOUT_WIDTH - BRACKET_BASE_PLATE_CUTOUT_DIAMETER,
            BRACKET_BASE_PLATE_DEPTH_CUTOUT_DEPTH - BRACKET_BASE_PLATE_CUTOUT_DIAMETER
        ]);
    }

    translate(v=[BRACKET_BASE_PLATE_DEPTH_CUTOUT_WIDTH, 0, 0]) {
        inner_corner_rounder(radius=BRACKET_BASE_PLATE_CUTOUT_DIAMETER, corner_position="bottom_left");
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

                        depth_cutout_width_offset = (
                            (BRACKET_BASE_PLATE_WIDTH_CUTOUT_WIDTH - BRACKET_BASE_PLATE_DEPTH_CUTOUT_WIDTH) / 2 -
                            BRACKET_BASE_PLATE_CUTOUT_DIAMETER
                        );

                        translate(v=[depth_cutout_width_offset, 0, 0]) bracket_base_depth_cutout();
                    };
                    circle(d=BRACKET_BASE_PLATE_CUTOUT_DIAMETER);
                }
            }
        }
    }
}


module bracket_drive_mounting_wall() {
    difference() {
        rounding_radius = (
            SATA_SSD_25_DEPTH - SATA_SSD_25_BOTTOM_MOUNTING_SCREW_HOLE_2_DEPTH_OFFSET -
            SATA_SSD_25_SIDE_MOUNTING_SCREW_HOLE_DIAMETER - 2
        );

        rounding_height_offset = BRACKET_MOUNTING_WALL_HEIGHT - rounding_radius;
        screwhole_counterbore_diameter = SATA_SSD_25_SIDE_MOUNTING_SCREW_HOLE_DIAMETER + 2;

        translate(v=[BRACKET_MOUNTING_WALL_WIDTH, 0, 0]) {
            rotate(a=[0, -90, 0]) {
                linear_extrude(height=BRACKET_MOUNTING_WALL_WIDTH) {
                    for (offset=[
                        SATA_SSD_25_BOTTOM_MOUNTING_SCREW_HOLE_1_DEPTH_OFFSET,
                        SATA_SSD_25_BOTTOM_MOUNTING_SCREW_HOLE_2_DEPTH_OFFSET
                    ]) {
                        translate(v=[0, offset - 2, 0]) {
                            square([BRACKET_MOUNTING_WALL_HEIGHT, screwhole_counterbore_diameter + 2]);
                        }

                        translate(v=[0, offset - 2 - rounding_radius, 0]) {
                            square([rounding_height_offset, rounding_radius]);
                        }

                        translate(v=[rounding_height_offset, offset - 2, 0]) {
                            sector(radius=rounding_radius, start_degree=-90, end_degree=0);
                        }

                        translate(v=[0, offset + screwhole_counterbore_diameter, 0]) {
                            square([rounding_height_offset, rounding_radius]);
                        }

                        translate(v=[rounding_height_offset, offset + screwhole_counterbore_diameter, 0]) {
                            sector(radius=rounding_radius, start_degree=0, end_degree=90);
                        }
                    }
                }
            }
        }

        for (drive_number=[0 : 2]) {
            for (offset=[
                SATA_SSD_25_BOTTOM_MOUNTING_SCREW_HOLE_1_DEPTH_OFFSET,
                SATA_SSD_25_BOTTOM_MOUNTING_SCREW_HOLE_2_DEPTH_OFFSET
            ]) {
                translate(v=[
                    BRACKET_MOUNTING_WALL_WIDTH,
                    offset - 1,
                    BRACKET_MOUNTING_WALL_DRIVE_HEIGHT_OFFSET * (drive_number + 1) + SATA_SSD_25_HEIGHT * drive_number
                ]) {
                    rotate(a=[0, -90, 0]) {
                        screw_hole(
                            depth=BRACKET_MOUNTING_WALL_WIDTH,
                            diameter=SATA_SSD_25_SIDE_MOUNTING_SCREW_HOLE_DIAMETER + 0.5,
                            counterbore_diameter=screwhole_counterbore_diameter,
                            counterbore_depth=2
                        );
                    }
                }
            }
        }
    }
}


module bracket_side_wall() {
    side_wall_fragment_depth = (
        BRACKET_SIDE_WALL_SCREW_HOLE_COUNTERBORE_DIAMETER +
        BRACKET_SIDE_WALL_MOUNTING_SCREW_HOLE_1_DEPTH_OFFSET * 2
    );

    translate(v=[BRACKET_SIDE_WALL_WIDTH, 0, 0]) {
        rotate(a=[0, -90, 0]) {
            for (offset=[
                BRACKET_SIDE_WALL_MOUNTING_SCREW_HOLE_1_DEPTH_OFFSET,
                BRACKET_SIDE_WALL_MOUNTING_SCREW_HOLE_2_DEPTH_OFFSET
            ]) {
                difference() {
                    translate(v=[0, offset - 1, 0]) {
                        linear_extrude(height=BRACKET_SIDE_WALL_WIDTH) {
                            square(size=[BRACKET_SIDE_WALL_HEIGHT, side_wall_fragment_depth]);

                            if (offset == BRACKET_SIDE_WALL_MOUNTING_SCREW_HOLE_2_DEPTH_OFFSET) {
                                translate(v=[BRACKET_BASE_PLATE_HEIGHT, 0, 0]) {
                                    sector(
                                        radius=BRACKET_SIDE_WALL_HEIGHT - BRACKET_BASE_PLATE_HEIGHT,
                                        start_degree=-90,
                                        end_degree=0
                                    );
                                }
                            }

                            translate(v=[BRACKET_BASE_PLATE_HEIGHT, side_wall_fragment_depth, 0]) {
                                sector(
                                    radius=BRACKET_SIDE_WALL_HEIGHT - BRACKET_BASE_PLATE_HEIGHT,
                                    start_degree=0,
                                    end_degree=90
                                );
                            }
                        }
                    }

                    translate(v=[
                        BRACKET_SIDE_WALL_MOUNTING_SCREW_HOLE_HEIGHT_OFFSET,
                        offset,
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
}


module main() {
    bracket_base_plate();

    bracket_mounting_walls_offset_width = BRACKET_MOUNTING_WALLS_OFFSET + BRACKET_MOUNTING_WALL_WIDTH * 2;

    translate(v=[
        (BRACKET_WIDTH - bracket_mounting_walls_offset_width) / 2,
        BRACKET_DEPTH - BRACKET_MOUNTING_WALL_DEPTH,
        BRACKET_BASE_PLATE_HEIGHT
    ]) {
        bracket_drive_mounting_wall();

        translate(v=[bracket_mounting_walls_offset_width, 0, 0]) {
            mirror([1, 0, 0]) bracket_drive_mounting_wall();
        }
    }

    bracket_side_wall();

    translate(v=[BRACKET_WIDTH, 0, 0]) mirror([1, 0, 0]) bracket_side_wall();
}


main();
