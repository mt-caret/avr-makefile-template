#include<avr/io.h>
#include<util/delay.h>

int main(void)
{
  DDRD = 0xff;
  PORTD = 0;

  while(1)
  {
    _delay_ms(1000);
    PORTD = 0;
    _delay_ms(1000);
    PORTD = 0x01;
  }
}
