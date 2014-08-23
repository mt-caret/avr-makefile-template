# AVR Makefileテンプレート

["Make: AVR Programming"にのってるMakefile](https://github.com/hexagon5un/AVR-Programming)をベースに機能を減らして
コメントを日本語化したテンプレートMakefileです。

##使い方

```
$ git clone https://github.com/mt-caret/avr-makefile-template
$ mv avr-makefile-template projectname && cd projectname
$ make #コンパイル等
$ sudo make flash #書き込み
```

##必要なもの

- avr-gcc
- avr-libc
- avrdude

##TODO

- Rakeで書き直す
- eepromへの書き込み・ヒューズ対応
- Ubuntu等で動作確認

##Issues

avrdudeの-pオブションに$MCUを使っていいのか?

