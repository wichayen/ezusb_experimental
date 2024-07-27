add wave -divider "CLK_RST"
add wave -noupdate  -expand -group {CLK_RST_IN} -radix hexadecimal -radixshowbase 1  /tb_prj_top/SIM_PRJ_TOP/RST_L
add wave -noupdate  -expand -group {CLK_RST_IN} -radix hexadecimal -radixshowbase 1  /tb_prj_top/SIM_PRJ_TOP/clk_50mhz

add wave -noupdate  -expand -group {CLK_RST_OUT} -radix hexadecimal -radixshowbase 1 /tb_prj_top/SIM_PRJ_TOP/CLK_48M
add wave -noupdate  -expand -group {CLK_RST_OUT} -radix hexadecimal -radixshowbase 1 /tb_prj_top/SIM_PRJ_TOP/CLK_150M

add wave -divider "FX2_FIFO"
add wave -noupdate -expand -group {FIFO_BUS} -radix hexadecimal -radixshowbase 1 /tb_prj_top/SIM_PRJ_TOP/FD			
add wave -noupdate -expand -group {FIFO_BUS} -radix hexadecimal -radixshowbase 1 /tb_prj_top/SIM_PRJ_TOP/FLAGA		
add wave -noupdate -expand -group {FIFO_BUS} -radix hexadecimal -radixshowbase 1 /tb_prj_top/SIM_PRJ_TOP/FLAGB		
add wave -noupdate -expand -group {FIFO_BUS} -radix hexadecimal -radixshowbase 1 /tb_prj_top/SIM_PRJ_TOP/FLAGC		
add wave -noupdate -expand -group {FIFO_BUS} -radix hexadecimal -radixshowbase 1 /tb_prj_top/SIM_PRJ_TOP/FLAGD		
add wave -noupdate -expand -group {FIFO_BUS} -radix hexadecimal -radixshowbase 1 /tb_prj_top/SIM_PRJ_TOP/SLRD_L		
add wave -noupdate -expand -group {FIFO_BUS} -radix hexadecimal -radixshowbase 1 /tb_prj_top/SIM_PRJ_TOP/SLWR_L		
add wave -noupdate -expand -group {FIFO_BUS} -radix hexadecimal -radixshowbase 1 /tb_prj_top/SIM_PRJ_TOP/SLOE_L		
add wave -noupdate -expand -group {FIFO_BUS} -radix hexadecimal -radixshowbase 1 /tb_prj_top/SIM_PRJ_TOP/ADR0		
add wave -noupdate -expand -group {FIFO_BUS} -radix hexadecimal -radixshowbase 1 /tb_prj_top/SIM_PRJ_TOP/ADR1		
add wave -noupdate -expand -group {FIFO_BUS} -radix hexadecimal -radixshowbase 1 /tb_prj_top/SIM_PRJ_TOP/CLKOUT		
add wave -noupdate -expand -group {FIFO_BUS} -radix hexadecimal -radixshowbase 1 /tb_prj_top/SIM_PRJ_TOP/IFCLK		
add wave -noupdate -expand -group {FIFO_BUS} -radix hexadecimal -radixshowbase 1 /tb_prj_top/SIM_PRJ_TOP/PKTEND		



add wave -noupdate -radix hexadecimal -radixshowbase 1 /tb_prj_top/SIM_PRJ_TOP/wPC2DevReq
add wave -noupdate -radix hexadecimal -radixshowbase 1 /tb_prj_top/SIM_PRJ_TOP/wDev2PCReq


add wave -noupdate -expand -group {RAM_IF} -radix hexadecimal -radixshowbase 1 /tb_prj_top/SIM_PRJ_TOP/wRdAddr			
add wave -noupdate -expand -group {RAM_IF} -radix hexadecimal -radixshowbase 1 /tb_prj_top/SIM_PRJ_TOP/wWrAddr			
add wave -noupdate -expand -group {RAM_IF} -radix hexadecimal -radixshowbase 1 /tb_prj_top/SIM_PRJ_TOP/wWr				
add wave -noupdate -expand -group {RAM_IF} -radix hexadecimal -radixshowbase 1 /tb_prj_top/SIM_PRJ_TOP/wRdData			
add wave -noupdate -expand -group {RAM_IF} -radix hexadecimal -radixshowbase 1 /tb_prj_top/SIM_PRJ_TOP/wWrData			