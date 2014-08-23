#
# template Makefile
# based on Makefile from code examples in "Make: AVR Programming"
# https://github.com/hexagon5un/AVR-Programming
#

MCU   = atmega88
F_CPU = 1000000
BAUD = 9600

## main()がある.cを置く 
MAIN = main.c

## 他ソースファイル
LOCAL_SOURCE = 

## includeディレクトリの追加
EXTRA_SOURCE_DIR = 
EXTRA_SOURCE_FILES =

PROGRAMMER_TYPE = avrisp2
## avrdudeの追加引数
PROGRAMMER_ARGS = 	

#
# source -> .elf -> .hex
#

## 各プログラム
CC = avr-gcc
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump
AVRDUDE = avrdude

## コンパイラ引数
CFLAGS = -mmcu=$(MCU) -DF_CPU=$(F_CPU)UL -DBAUD=$(BAUD) -Os -I. -I$(EXTRA_SOURCE_DIR)
CFLAGS += -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums 
CFLAGS += -Wall -Wstrict-prototypes
CFLAGS += -g -ggdb
CFLAGS += -ffunction-sections -fdata-sections -Wl,--gc-sections -Wl,--relax
CFLAGS += -std=gnu99
## CFLAGS += -Wl,-u,vfprintf -lprintf_flt -lm  ## for floating-point printf
## CFLAGS += -Wl,-u,vfprintf -lprintf_min      ## for smaller printf

## targetと追加ソースの統合
TARGET = $(strip $(basename $(MAIN)))
SRC = $(TARGET).c
EXTRA_SOURCE = $(addprefix $(EXTRA_SOURCE_DIR), $(EXTRA_SOURCE_FILES))
SRC += $(EXTRA_SOURCE) 
SRC += $(LOCAL_SOURCE) 

## ヘッダファイルの一覧
HEADERS = $(SRC:.c=.h) 

## .cファイルと対応する.oファイル
OBJ = $(SRC:.c=.o) 

## Generic Makefile targets.  (Only .hex file is necessary)
all: $(TARGET).hex

%.hex: %.elf
	$(OBJCOPY) -R .eeprom -O ihex $< $@

%.elf: $(SRC)
	$(CC) $(CFLAGS) $(SRC) --output $@ 

%.eeprom: %.elf
	$(OBJCOPY) -j .eeprom --change-section-lma .eeprom=0 -O ihex $< $@ 

debug:
	@echo
	@echo "Source files:"   $(SRC)
	@echo "MCU, F_CPU, BAUD:"  $(MCU), $(F_CPU), $(BAUD)
	@echo	

clean:
	rm -f $(TARGET).elf $(TARGET).hex $(TARGET).obj \
	$(TARGET).o $(TARGET).d $(TARGET).eep $(TARGET).lst \
	$(TARGET).lss $(TARGET).sym $(TARGET).map $(TARGET)~ \
	$(TARGET).eeprom

#
# avrdudeによる書き込み
#

flash: $(TARGET).hex 
	$(AVRDUDE) -c $(PROGRAMMER_TYPE) -p $(MCU) $(PROGRAMMER_ARGS) -U flash:w:$<

## An alias
program: flash

flash_eeprom: $(TARGET).eeprom
	$(AVRDUDE) -c $(PROGRAMMER_TYPE) -p $(MCU) $(PROGRAMMER_ARGS) -U eeprom:w:$<

avrdude_terminal:
	$(AVRDUDE) -c $(PROGRAMMER_TYPE) -p $(MCU) $(PROGRAMMER_ARGS) -nt

