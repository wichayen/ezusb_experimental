
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_misc.all;


--	EP2 as OUT, 512 bytes, 		FLAGA is configured as empty flag for EP2 OUT FIFO 			PC->device
--	EP6 as IN, 512 bytes, 		FLAGD is configured as full flag for EP6 IN FIFO			device->PC

--	FIFOADR[1:0]   Selected FIFO
--	00             EP2				FLAGA
--	01             EP4
--	10             EP6				FLAGD
--	11             EP8

--	FLAG is active hihg signal

entity PRJ_TOP is
	
	port (
		clk_50mhz		: in  std_logic;		-- input clock 50MHz
		
		FD				:	inout		std_logic_vector(15 downto 0)				;
		FLAGA			:	in		std_logic									;
		FLAGB			:	in		std_logic									;
		FLAGC			:	in		std_logic									;
		FLAGD			:	in		std_logic									;
		SLRD_L			:	out		std_logic									;
		SLWR_L			:	out		std_logic									;
		SLOE_L			:	out		std_logic									;
		ADR0			:	out		std_logic									;
		ADR1			:	out		std_logic									;
		CLKOUT			:	in		std_logic									;
		IFCLK			:	out		std_logic									;
		
		PKTEND			:	out		std_logic									;
		-- UART
		UART_TXD					:	out	std_logic							;
		UART_RXD					:	in	std_logic							;
		
		LED							:	out	std_logic_vector(1 downto 0)		;
		
		SW_TACT						:	in	std_logic_vector(1 downto 0)		
		
	);
end PRJ_TOP;

architecture RTL of PRJ_TOP is
	
	component PLL IS
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		c1		: OUT STD_LOGIC ;
		c2		: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
	END component;
	
	component RAM_2PORT IS
	PORT
	(
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		rdaddress		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		wraddress		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		wren		: IN STD_LOGIC  := '0';
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
	END component;
	
	alias		CLK					:	std_logic			is	clk_50mhz		;
	alias		RST_L				:	std_logic			is	SW_TACT(0)		;
	
	--	GPIO0-7 : PB0-7
	--	GPIO8-10 : CTL0-2 (FLAGA,B,C)
	--	GPIO11 : PA7 (FLAGD)
	--	GPIO12 : RDY0 (SLRD#)
	--	GPIO13 : RDY1 (SLWR#)
	--	GPIO14 : PA2 (SLOE#)
	--	GPIO15 : PA4 (ADR0)
	--	GPIO16 : PA5 (ADR1)
	--	GPIO17 : CLKOUT
	--	GPIO18 : IFCLK
	--	GPIO19 : PD6	(FD14)		???
	--	GPIO20 : PD7	(FD15)		???
	--	GPIO21 : PD0	(FD8)		???
	--	GPIO22 : PD1	(FD9)		???
	--	GPIO23 : PD2	(FD10)		???
	--	GPIO24 : PD3	(FD11)		???
	--	GPIO25 : PA6			?    ??
	--	GPIO26 : PD4	(FD12)		???
	--	GPIO27 : PD5	(FD13)		???
	
	signal		CLK_10M				:	std_logic								;
	signal		CLK_150M			:	std_logic								;
	signal		CLK_48M				:	std_logic								;
	signal		wRST				:	std_logic								;
	
	signal		wCounter			:	integer range 0 to 100000000			;
	signal		w1SecToggle			:	std_logic								;
	
	signal		wCounter_150M		:	integer range 0 to 200000000			;
	signal		w1SecToggle_150M	:	std_logic								;
	
	
	signal		wADR				:	std_logic_vector(7 downto 0)			;
	signal		wSLRD_L				:	std_logic								;
	signal		wSLOE_L				:	std_logic								;
	signal		wSLWR_L				:	std_logic								;
	signal		wSLRD_DL_L			:	std_logic								;
	signal		wSLOE_DL_L			:	std_logic								;
	signal		wSLWR_DL_L			:	std_logic								;
			
	signal		wFD_Out_En			:	std_logic								;
	
	signal		wDev2PCData			:	std_logic_vector(15 downto 0)			;
	signal		wDev2PCData_temp	:	std_logic_vector(15 downto 0)			;
	
	signal		wCounterDebounce	:	integer range 0 to 100000000			;
	signal		wpDebounce			:	std_logic								;
	
	signal		wSW_TACT1			:	std_logic								;
	signal		wSW_TACT1_STD		:	std_logic_vector(7 downto 0)			;
	
	signal		wFLAGC_En			:	std_logic								;
	
	
	signal		wFLAGA				:	std_logic								;
	signal		wFLAGA_DL			:	std_logic								;
	
	signal		wFLAGD				:	std_logic								;
	signal		wFLAGD_DL			:	std_logic								;
	
	
	signal		wFirstByteGetData	:	std_logic_vector(15 downto 0)			;
	signal		wDev2PCReq			:	std_logic								;
	signal		wPC2DevReq			:	std_logic								;
	signal		wFD					:	std_logic_vector(15 downto 0)			;
	signal		wReadFinish			:	std_logic								;
	
	signal		wUSBTransferEn		:	std_logic								;
	
	signal		wRdAddr				:	std_logic_vector(9 downto 0)			;
	signal		wWrAddr				:	std_logic_vector(9 downto 0)			;
	signal		wWr					:	std_logic								;
	
	signal		wRdData				:	std_logic_vector(15 downto 0)			;
	signal		wWrData				:	std_logic_vector(15 downto 0)			;
	
begin
	
	PLL_M	:	PLL
	port map
	(
		areset		=>	wRST										,
		inclk0		=>	CLK											,
		c0			=>	CLK_150M									,
		c1			=>	CLK_48M										,
		locked		=>	open										
	);
	
	RAM_2PORT_M	:	RAM_2PORT
	PORT map
	(
		clock			=>	CLK_48M					,	--	: IN STD_LOGIC  := '1';
		data			=>	wWrData					,	--	: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		rdaddress		=>	wRdAddr					,	--	: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		wraddress		=>	wWrAddr					,	--	: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		wren			=>	wWr						,	--	: IN STD_LOGIC  := '0';
		q				=>	wRdData						--	: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
	
	--IFCLK		<=	CLKOUT	;
	IFCLK		<=	CLK_48M		;
	PKTEND		<=	'1'		;
	
	UART_TXD	<=	FLAGA		or
					FLAGB		or
					FLAGC		or
					FLAGD		or
					CLKOUT		;
	
	process( CLK_48M , RST_L )
	begin
		if ( RST_L = '0' ) then
			wFLAGA		<=	'0'	;
			wFLAGA_DL	<=	'0'	;
			wFLAGD		<=	'0'	;
			wFLAGD_DL	<=	'0'	;
		elsif ( CLK_48M'event and CLK_48M = '1' ) then
			wFLAGA		<=	FLAGA		;
			wFLAGA_DL	<=	wFLAGA		;
			wFLAGD		<=	FLAGD		;
			wFLAGD_DL	<=	wFLAGD		;
		end if;
	end process;
	
	process( CLK_48M , RST_L )
	begin
		if ( RST_L = '0' ) then
			wSLRD_DL_L	<=	'1'	;
			wSLOE_DL_L	<=	'1'	;
			wSLWR_DL_L	<=	'1'	;
		elsif ( CLK_48M'event and CLK_48M = '1' ) then
			wSLRD_DL_L	<=	wSLRD_L		;
			wSLOE_DL_L	<=	wSLOE_L		;
			wSLWR_DL_L	<=	wSLWR_L		;
		end if;
	end process;
	
	process( CLK_48M , RST_L )
	begin
		if ( RST_L = '0' ) then
			wSLRD_L	<=	'1'	;
			wSLOE_L	<=	'1'	;
			wSLWR_L	<=	'1'	;
		elsif ( CLK_48M'event and CLK_48M = '1' ) then
			if(wFLAGA = '1')then
				wSLRD_L	<=	'0'	;
				wSLOE_L	<=	'0'	;
				wSLWR_L	<=	'1'	;
			elsif(wFLAGD = '1')then
				wSLRD_L	<=	'1'	;
				wSLOE_L	<=	'1'	;
				wSLWR_L	<=	'0'	;
			else
				if(wFLAGA = '0' and wFLAGD = '0')then
					wSLRD_L	<=	'1'	;
					wSLOE_L	<=	'1'	;
					wSLWR_L	<=	'1'	;
				end if;
			end if;
		end if;
	end process;
	
	-->>	EP2 : PC->device
	process( CLK_48M , RST_L )
	begin
		if ( RST_L = '0' ) then
			wPC2DevReq	<=	'0'	;
		elsif ( CLK_48M'event and CLK_48M = '1' ) then
			if(wFLAGA = '1')then
				wPC2DevReq	<=	'1'	;
			else
				if(wSLRD_L = '1')then
					wPC2DevReq	<=	'0'	;
				end if;
			end if;
		end if;
	end process;
	
	process( CLK_48M , RST_L )
	begin
		if ( RST_L = '0' ) then
			wWrAddr	<=	(others => '0')	;
		elsif ( CLK_48M'event and CLK_48M = '1' ) then
			if(wPC2DevReq = '1')then
				wWrAddr	<=	wWrAddr + 1;
			else
				wWrAddr	<=	(others => '0')	;
			end if;
		end if;
	end process;
	
	process( CLK_48M , RST_L )
	begin
		if ( RST_L = '0' ) then
			wWr		<=	'0'	;
		elsif ( CLK_48M'event and CLK_48M = '1' ) then
			wWr		<=	wPC2DevReq	;
		end if;
	end process;
	
	process( CLK_48M , RST_L )
	begin
		if ( RST_L = '0' ) then
			wWrData		<=	(others => '0')	;
		elsif ( CLK_48M'event and CLK_48M = '1' ) then
			wWrData		<=	wFD	;
			--wWrData			<=	"000000" & wWrAddr	;	-- for test
		end if;
	end process;
	
	-->>	EP6 : device->PC
	process( CLK_48M , RST_L )
	begin
		if ( RST_L = '0' ) then
			wDev2PCReq	<=	'0'	;
		elsif ( CLK_48M'event and CLK_48M = '1' ) then
			if(wFLAGD = '1')then
				wDev2PCReq	<=	'1'	;
			else
				if(wSLWR_L = '1')then
					wDev2PCReq	<=	'0'	;
				end if;
			end if;
		end if;
	end process;
	
	process( CLK_48M , RST_L )
	begin
		if ( RST_L = '0' ) then
			wRdAddr	<=	(others => '0')	;
		elsif ( CLK_48M'event and CLK_48M = '1' ) then
			if(wDev2PCReq = '1')then
				wRdAddr	<=	wRdAddr + 1;
			else
				wRdAddr	<=	(others => '0')	;
			end if;
		end if;
	end process;
	
	FD		<=	wRdData	when (wSLWR_L = '0')	else	(others => 'Z')	;
	wFD		<=	FD		;
	SLRD_L	<=	wSLRD_L	;
	SLOE_L	<=	wSLOE_L	;
	SLWR_L	<=	wSLWR_L	;
	
	process( CLK_48M , RST_L )
	begin
		if ( RST_L = '0' ) then
			ADR1		<=	'0'	;
			ADR0		<=	'0'	;
		elsif ( CLK_48M'event and CLK_48M = '1' ) then
			if (FLAGA = '1')then
				ADR1		<=	'0'	;
				ADR0		<=	'0'	;
			--elsif(FLAGB = '1')then
			--	ADR1		<=	'0'	;
			--	ADR0		<=	'1'	;
			--elsif(FLAGC = '1')then
			--	ADR1		<=	'1'	;
			--	ADR0		<=	'1'	;
			elsif(FLAGD = '1')then
				ADR1		<=	'1'	;
				ADR0		<=	'0'	;
			end if;
		end if;
	end process;
	
	
	
	
	
	process( CLK_48M , RST_L )
	begin
		if ( RST_L = '0' ) then
			wSW_TACT1	<=	'0'	;
		elsif ( CLK_48M'event and CLK_48M = '1' ) then
			wSW_TACT1	<=	not SW_TACT(1)	;
		end if;
	end process;
	
	process( CLK_48M , RST_L )
	begin
		if ( RST_L = '0' ) then
			wCounterDebounce	<=	0	;
		elsif ( CLK_48M'event and CLK_48M = '1' ) then
			if(wCounterDebounce /= 4800000)then
				wCounterDebounce	<=	wCounterDebounce + 1;
			else
				wCounterDebounce	<=	0	;
			end if;
		end if;
	end process;
	
	process( CLK_48M , RST_L )
	begin
		if ( RST_L = '0' ) then
			wpDebounce	<=	'0'	;
		elsif ( CLK_48M'event and CLK_48M = '1' ) then
			if(wCounterDebounce = 4800000)then
				wpDebounce	<=	'1'	;
			else
				wpDebounce	<=	'0'	;
			end if;
		end if;
	end process;
	
	process( CLK_48M , RST_L )
	begin
		if ( RST_L = '0' ) then
			wSW_TACT1_STD	<=	(others => '0')	;
		elsif ( CLK_48M'event and CLK_48M = '1' ) then
			if(wpDebounce = '1')then
				wSW_TACT1_STD	<=	wSW_TACT1_STD(6 downto 0) & wSW_TACT1	;
			end if;
		end if;
	end process;
	
	
	
	
	
	-- for test
	
	wRST		<=	not	RST_L	;
	
	process( CLK , RST_L )
	begin
		if ( RST_L = '0' ) then
			wCounter	<=	0	;
		elsif ( CLK'event and CLK = '1' ) then
			if(wCounter /= 50000000)then
				wCounter	<=	wCounter + 1	;
			else
				wCounter	<=	0	;
			end if;
		end if;
	end process;
	
	process( CLK , RST_L )
	begin
		if ( RST_L = '0' ) then
			w1SecToggle	<=	'0'	;
		elsif ( CLK'event and CLK = '1' ) then
			if(wCounter = 50000000)then
				w1SecToggle	<=	not	w1SecToggle	;
			end if;
		end if;
	end process;
	
	process( CLK_150M , RST_L )
	begin
		if ( RST_L = '0' ) then
			wCounter_150M	<=	0	;
		elsif ( CLK_150M'event and CLK_150M = '1' ) then
			if(wCounter_150M /= 150000000)then
				wCounter_150M	<=	wCounter_150M + 1	;
			else
				wCounter_150M	<=	0	;
			end if;
		end if;
	end process;
	
	process( CLK_150M , RST_L )
	begin
		if ( RST_L = '0' ) then
			w1SecToggle_150M	<=	'0'	;
		elsif ( CLK_150M'event and CLK_150M = '1' ) then
			if(wCounter_150M = 150000000)then
				w1SecToggle_150M	<=	not	w1SecToggle_150M	;
			end if;
		end if;
	end process;
	
	
	LED(0)	<=	w1SecToggle			;
	LED(1)	<=	w1SecToggle_150M	;
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
	
	--DIGITAL_IO(30 downto 19)	<=	(others => '1')	;
	
	
	
	
end RTL;



----------------------------------------------------------------------
--   Copyright (C)2010-2013 J-7SYSTEM Works.  All rights Reserved.  --
----------------------------------------------------------------------
