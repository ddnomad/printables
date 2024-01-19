$fn = $preview? 32 : 128;

MODEL_NAME = "5ml Test Tubes Tray";
MODEL_VERSION = "0.1.0";

TEST_TUBE_HEIGHT = 42;
TEST_TUBE_CAP_DIAMETER = 20;
TEST_TUBE_DIAMETER = 16;

// Distance between neighbouring test tube caps in the tray
TEST_TUBE_GRID_COLUMNS_NUM = 1;
TEST_TUBE_GRID_ROWS_NUM = 1;
TEST_TUBE_GRID_SPACING = 3;

// Width of a single test tube cell in a grid
TEST_TUBE_CELL_WIDTH = TEST_TUBE_CAP_DIAMETER + 2 * TEST_TUBE_GRID_SPACING;
TEST_TUBE_CELL_HEIGHT = TEST_TUBE_HEIGHT;

TEST_TUBE_CELL_CUTOUT_PADDING = 2;
TEST_TUBE_CELL_CUTOUT_DIAMETER = TEST_TUBE_DIAMETER + TEST_TUBE_CELL_CUTOUT_PADDING;


module main() {
    linear_extrude(height=TEST_TUBE_CELL_HEIGHT) {
        translate(v=[TEST_TUBE_CELL_WIDTH / 2, TEST_TUBE_CELL_WIDTH / 2]) {
            for (row=[0 : TEST_TUBE_GRID_ROWS_NUM - 1]) {
                for (column=[0 : TEST_TUBE_GRID_COLUMNS_NUM - 1]) {
                    translate(v=[TEST_TUBE_CELL_WIDTH * column, TEST_TUBE_CELL_WIDTH * row]) {
                        difference() {
                            square(size=[TEST_TUBE_CELL_WIDTH, TEST_TUBE_CELL_WIDTH], center=true);
                            circle(d=TEST_TUBE_CELL_CUTOUT_DIAMETER);
                        }
                    }
                }
            }
        }
    }
}


main();
