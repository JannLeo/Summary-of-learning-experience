/*
 * game2.c
 *
 * Created on:13/05/2024
 * Author: Zhu Zhu
 */

#include "game2.h"

// Define movement directions
#define MOVE_NONE    0
#define MOVE_LEFT    1
#define MOVE_RIGHT   2

// Define game constants
#define TOTAL_CARS   2
#define CAR_WIDTH    60
#define CAR_LENGTH   60
#define ROAD_SPEED   50
#define FRAME_WIDTH  240
#define FRAME_HEIGHT 320

bool gameRunning;  // Flag to keep the game running
extern int state;  // Game state
unsigned short frameBuffer[76700];  // Frame buffer

/**
 * Structure representing other cars on the road.
 */
typedef struct {
    int xPos;      ///< X-coordinate of the car
    int yPos;      ///< Y-coordinate of the car
    int speed;     ///< Speed of the car
} OtherCar;

/**
 * Structure representing the player's car.
 */
typedef struct {
    bool isHit;    ///< Indicates if the car has been hit
    int lane;      ///< Current lane of the car
    int xPos;      ///< X-coordinate of the car
} PlayerCar;

static bool handleExitButton(void);  // Function to handle exit button
static bool handleRightButton(void);  // Function to handle right button
static bool handleLeftButton(void);  // Function to handle left button
void drawGame(void);  // Function to draw the game state

// Game variables
static int highScore;  // High score
static int currentScore;  // Current score
static int moveDirection;  // Current movement direction
static int remainingLives;  // Remaining lives
static OtherCar otherCars[TOTAL_CARS];  // Array of other cars
static PlayerCar playerCar;  // Player's car
static bool newHighScore;  // Flag for new high score
static time_t lastHitTime;  // Time of the last hit
unsigned int pressedKey = 0;  // Key press state
extern bool gameRunning;  // Flag to keep the game running

/**
 * Initialize the game state and setup the display.
 */
void game2_init() {
    printf("Game2 initialize\n");

    // Game logic initialization
    moveDirection = MOVE_NONE;
    gameRunning = true;
    srand((unsigned int)time(NULL));
    playerCar.xPos = 20;
    playerCar.lane = 0;
    playerCar.isHit = false;
    remainingLives = 3;
    currentScore = 0;

    // Initialize other cars
    for (int i = 0; i < TOTAL_CARS; i++) {
        otherCars[i].xPos = 20 + i * 70;
        otherCars[i].speed = i * 20 + 50;
        otherCars[i].yPos = rand() % 100;
    }

    // Draw background and initial screen
    Drawbackground(game2ground);
    Drawscreen();

    printf("Game2 initialize successfully\n");
}

/**
 * Start the game and handle button presses.
 */
void game2_start() {
    HPS_ResetWatchdog();

    // Detect button presses and handle accordingly
    if (pressedKey == 0x2) {
        handleRightButton();
    } else if (pressedKey == 0x1) {
        handleLeftButton();
    } else if (pressedKey == 0x8) {
        handleExitButton();
    }

    drawGame();  // Draw the initial game state
    moveDirection = MOVE_NONE;

    // Initialize interrupts for button presses
    FPGA_PIO_initialise(LSC_BASE_KEYS, LSC_CONFIG_KEYS, &drivers.keys);
    HPS_IRQ_registerHandler(IRQ_LSC_KEYS, pushbuttonISR, &drivers);
    FPGA_PIO_setInterruptEnable(drivers.keys, 0xF, 0xF);
    HpsErr_t wasDisabled = HPS_IRQ_globalEnable(false);
    pressedKey = drivers.keyPressed;
    drivers.keyPressed = 0;
    HPS_IRQ_globalEnable(wasDisabled != ERR_SKIPPED);
}

/**
 * Handle the exit button press.
 * @return true if the button press was handled.
 */
static bool handleExitButton() {
    state = 0;  // Set game state to 0
    if (remainingLives == 0) {
        game2_init();  // Reinitialize the game if no lives are left
        game2_start();  // Restart the game
    } else {
        gameRunning = false;  // Stop the game
    }
    return true;
}

/**
 * Handle the right button press.
 * @return true if the button press was handled.
 */
static bool handleRightButton() {
    moveDirection = MOVE_RIGHT;  // Set movement direction to right
    if (playerCar.lane > 0) {
        playerCar.lane--;  // Move to the left lane if possible
    }
    moveDirection = MOVE_NONE;
    return true;
}

/**
 * Handle the left button press.
 * @return true if the button press was handled.
 */
static bool handleLeftButton() {
    moveDirection = MOVE_LEFT;  // Set movement direction to left
    if (playerCar.lane < 2) {
        playerCar.lane++;  // Move to the right lane if possible
    }
    moveDirection = MOVE_NONE;
    return true;
}

/**
 * Draw the game state to the screen.
 */
void drawGame() {
    int targetX = playerCar.lane * 70 + 20;  // Calculate target X position based on lane

    // Move the player's car to the target lane
    if (playerCar.xPos > targetX) {
        playerCar.xPos -= 70;
    } else if (playerCar.xPos < targetX) {
        playerCar.xPos += 70;
    }

    if (remainingLives != 0) {
        // Move other cars
        for (int i = 0; i < TOTAL_CARS; i++) {
            otherCars[i].yPos += otherCars[i].speed;
            if (otherCars[i].yPos > 320) {
                otherCars[i].yPos = 0;
                otherCars[i].xPos = (rand() % 3) * 70 + 20;
                currentScore++;
            }
        }

        // Prevent cars from overlapping
        for (int i = 0; i < TOTAL_CARS; i++) {
            for (int j = 0; j < TOTAL_CARS; j++) {
                if (i != j && otherCars[i].xPos == otherCars[j].xPos && otherCars[i].yPos > otherCars[j].yPos && otherCars[i].yPos < otherCars[j].yPos + CAR_LENGTH) {
                    otherCars[i].yPos = otherCars[j].yPos + 20;
                }
            }
        }

        // Handle collisions
        if (!playerCar.isHit) {
            for (int i = 0; i < TOTAL_CARS; i++) {
                if (otherCars[i].yPos > 320 - 2 * CAR_LENGTH) {
                    int carX = otherCars[i].xPos + 90;
                    int playerCarX = playerCar.xPos + 90;
                    if ((carX >= playerCarX && carX <= playerCarX + CAR_WIDTH) ||
                        (carX + CAR_WIDTH >= playerCarX && carX + CAR_WIDTH <= playerCarX + CAR_WIDTH)) {
                        playerCar.isHit = true;
                        lastHitTime = time(NULL);
                        remainingLives--;
                        if (remainingLives == 0) {
                            if (currentScore > highScore) {
                                newHighScore = true;
                                highScore = currentScore;
                            } else {
                                newHighScore = false;
                            }
                        }
                    }
                }
            }
        }
    }

    time_t now = time(NULL);
    if (playerCar.isHit && now - lastHitTime >= 5) {
        playerCar.isHit = false;
    }

    // Quake effect when hit
    static int8_t quakeX;
    if (playerCar.isHit && now - lastHitTime < 3) {
        quakeX = (quakeX == 70) ? -70 : 70;
    } else {
        quakeX = 0;
    }

    // Draw the player's car
    if (!playerCar.isHit || (playerCar.isHit && (now & 1))) {
        FrameBuffer_mapmycar(car, playerCar.xPos + quakeX, 270, 60, 60);
    }

    char scoreBuffer[6];
    if (remainingLives != 0) {
        // Draw other cars
        for (int i = TOTAL_CARS - 1; i >= 0; i--) {
            FrameBuffer_mapcar(othercar, otherCars[i].xPos + quakeX, otherCars[i].yPos, 60, 60, i);
        }

        // Draw road markings
        /*
        DrawLine(0,15,320,20,2,LT24_BLACK);
        DrawLine(0,90, 320,00,2,LT24_BLACK);
        DrawLine(0,160, 320,160,2,LT24_BLACK);
        DrawLine(0,225, 320,220,2,LT24_BLACK);
        */

        // Draw score
        heartback(15, 0);
        sprintf(scoreBuffer, "%u", currentScore);
        DrawString(1, 1, scoreBuffer, LT24_BLACK);
        printf("lives=%i", remainingLives);

        // Draw lives
        if (remainingLives == 2) {
            heartback(20, 32);
        } else if (remainingLives == 1) {
            heartback(40, 32);
        } else if (remainingLives == 3) {
            for (int i = 0; i < remainingLives; i++) {
                FrameBuffer_map(heart, 1, 32 + (20 * i), 20, 20);
            }
        }

        /*
        for (int i = 0; i < remainingLives; i++) {
            FrameBuffer_map(heart, 1, 32 + (20 * i), 20, 20);
        }
        */
    } else {
        // Draw end game screen
        Drawbackground(game2ground);
        DrawString(70, 20, "GAME OVER!", LT24_BLACK);
        DrawString(50, 70, "Score:", LT24_BLACK);
        DrawString(70, 110, "Highscore:", LT24_BLACK);

        if (newHighScore) {
            DrawString(50, 150, "!NEW HIGHSCORE!", LT24_BLACK);
        }

        sprintf(scoreBuffer, "%i", currentScore);
        DrawString(130, 70, scoreBuffer, LT24_BLACK);

        sprintf(scoreBuffer, "%i", highScore);
        DrawString(200, 110, scoreBuffer, LT24_BLACK);
        Drawscreen();
    }
}