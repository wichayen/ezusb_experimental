sdcc -c  slave.c -o Release/slave.rel
sdcc -c fw.c -o Release/fw.rel
sdcc -c delay.c -o Release/delay.rel
sdcc -c discon.c -o Release/discon.rel
sdcc -c EZRegs.c -o Release/EZRegs.rel
sdcc -c get_strd.c -o Release/get_strd.rel
sdcc -c i2c.c -o Release/i2c.rel
sdcc -c i2c_rw.c -o Release/i2c_rw.rel
sdcc -c resume.c -o Release/resume.rel
sdas8051 -losg Release/dscr.rel dscr.asm 
sdas8051 -losg Release/susp.rel susp.asm 
sdas8051 -losg Release/delayms.rel delayms.asm 
sdas8051 -losg Release/USBJmpTb.rel USBJmpTb.asm
cd Release
sdcc -o slave.hex fw.rel slave.rel delay.rel delayms.rel discon.rel dscr.rel USBJmpTb.rel EZRegs.rel get_strd.rel i2c.rel i2c_rw.rel resume.rel susp.rel
