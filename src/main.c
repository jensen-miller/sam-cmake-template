/*  Copyright (c) 2020 Jensen Miller. */

/*  Licensed under the GNU GPLv3 license. See LICENSE in the project root. */

/**
 *  \file main.c
 *  \author Jensen Miller <jensen_miller.dev@outlook.com>
 *
 *  This program targets a SAMD51 architecture. Specifically the
 *      samd51j20a package. This program is provided to demonstrate
 *      a basic blink program leveraging the DFP packs Atmel provides.
 */
#include <sam.h>


#define SAMD51J20A_LED  (PORT_PA17)



/**
 *  \brief Configure the LED pin as an output.
 */
void
LED_config_output(void)
{    
    REG_PORT_DIRSET0 = SAMD51J20A_LED;
    REG_PORT_OUTSET0 = SAMD51J20A_LED;
}



/**
 *  \brief Set the LED pin HIGH.
 */
void
LED_toggle_output(void)
{
    REG_PORT_OUTTGL0 = SAMD51J20A_LED;
}



/**
 *  \brief Main program.
 */
int
main(void)
{
    SystemInit();   /*< sets the system core clock variable. */

    LED_config_output();

    for (;;)
    {
        for (unsigned i = 0; i < (SystemCoreClock / 4U); i++)
        {
            /* Delay. . . */
        }
        LED_toggle_output();
    }

    return 0;
}