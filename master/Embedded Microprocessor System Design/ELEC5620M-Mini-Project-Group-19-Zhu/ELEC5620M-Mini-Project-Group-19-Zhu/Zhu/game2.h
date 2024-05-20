/*
 * game2.h
 *
 * Created on: 13/05/2024
 * Author: Zhu Zhu
 */

#ifndef GAME2_H_
#define GAME2_H_

#include "DE1SoC_Addresses/DE1SoC_Addresses.h"
#include "DE1SoC_LT24/DE1SoC_LT24.h"
#include "HPS_Watchdog/HPS_Watchdog.h"
#include "HPS_usleep/HPS_usleep.h"
#include "Util/macros.h"
#include "LCD.h"
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <time.h>
#include "Interrupts.h"
#include "bitmap.h"

/**
 * @brief Initializes the game state and sets up the display.
 *
 * This function sets the initial values for the game variables,
 * initializes the player's car and other cars, and sets up the background
 * and initial screen.
 */
void game2_init(void);

/**
 * @brief Starts the game and handles button presses.
 *
 * This function resets the watchdog timer, detects button presses,
 * draws the initial game state, and sets up interrupts for button presses.
 */
void game2_start(void);

#endif /* GAME2_H_ */
