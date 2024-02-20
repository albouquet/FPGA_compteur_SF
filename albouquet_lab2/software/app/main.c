#include "sys/alt_stdio.h"
#include <stdio.h>
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_timer_regs.h"
#include "altera_avalon_timer.h"
#include "system.h"
#include "sys/alt_irq.h"
#include "io.h"

volatile char sig_timer;


static void interrupt_handler(void* context, alt_u32 id)
{
	sig_timer=1;
	
	// Replace l'interruption à l'état "prêt"
	IOWR_ALTERA_AVALON_TIMER_STATUS(TIMER_0_BASE, 0);
}


int main() {

	__uint16_t compteur=0;
	sig_timer=0;

	__uint8_t centaine=0;
	__uint8_t dizaine=0;
	__uint8_t unite=0;

	IOWR_ALTERA_AVALON_PIO_DATA(PIO_0_BASE, 0x0);
	IOWR_ALTERA_AVALON_PIO_DATA(PIO_1_BASE, 0x0);
	IOWR_ALTERA_AVALON_PIO_DATA(PIO_2_BASE, 0x0);



	// Initialisation timer
	IOWR_ALTERA_AVALON_TIMER_CONTROL(TIMER_0_BASE, ALTERA_AVALON_TIMER_CONTROL_CONT_MSK | ALTERA_AVALON_TIMER_CONTROL_START_MSK | ALTERA_AVALON_TIMER_CONTROL_ITO_MSK);
	alt_irq_register(TIMER_0_IRQ, NULL, interrupt_handler);

	while(1)
	{
		
		if (sig_timer == 1)
		{
			sig_timer=0;
			compteur+=1;
			if (compteur == 1000) compteur = 0;
			
			// Decomposition des unités, dizaines, centaines
			unite=compteur % 10;
			dizaine=((compteur % 100)-unite)/10;
			centaine=(compteur - (compteur%100)) / 100;

			// Envoie des unités, dizaines, centaines 
			IOWR_ALTERA_AVALON_PIO_DATA(PIO_0_BASE, centaine);
			IOWR_ALTERA_AVALON_PIO_DATA(PIO_1_BASE, dizaine);
			IOWR_ALTERA_AVALON_PIO_DATA(PIO_2_BASE, unite);

		}

	}
	return 0;
}