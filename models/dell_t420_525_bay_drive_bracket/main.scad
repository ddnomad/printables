MODEL_NAME = "Dell T420 5.25\" Bay Drive Bracket";
MODEL_VERSION = "0.1.0";

BRACKET_DEPTH = 125;
BRACKET_WIDTH = 144;

BRACKET_BOTTOM_THICKNESS = 4;

BRACKET_SIDE_HEIGHT = 20;
BRACKET_SIDE_THICKNESS = 4;

union() {
    color("green") linear_extrude(height=BRACKET_BOTTOM_THICKNESS) square(size=[BRACKET_WIDTH, BRACKET_DEPTH], center=false);
    color("blue") linear_extrude(height=BRACKET_SIDE_HEIGHT) translate(v=[0,0,0]) square(size=[BRACKET_SIDE_THICKNESS, BRACKET_DEPTH]);
    color("blue") linear_extrude(height=BRACKET_SIDE_HEIGHT) translate(v=[BRACKET_WIDTH - BRACKET_SIDE_THICKNESS,0,0]) square(size=[BRACKET_SIDE_THICKNESS, BRACKET_DEPTH]);
}
