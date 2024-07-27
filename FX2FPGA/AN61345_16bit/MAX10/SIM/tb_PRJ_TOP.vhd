--	------------------------------------------------------------------	--
--	Copyright (C) 2012 NDR co.,LTD All Rights Reserved. 				--
--	------------------------------------------------------------------	--
--		i :	Module to Module Signal										--
--		w :	Module Internal Signal & Resister							--
--		k :	Constant													--
--		s :	State														--
--		v :	variable													--
--																		--
--	------------------------------------------------------------------	--
----	Note		:	test bench
--																		--
--	------------------------------------------------------------------	--
	library		ieee;
	use			ieee.std_logic_1164.all	;
	use			ieee.std_logic_unsigned.all;
	use			ieee.std_logic_arith.all;
	
	use			std.textio.all;
	use			ieee.std_logic_textio.all;
	use			std.env.all;
	
	--use			work.SIM_PKG.all;
	
	entity	tb_PRJ_TOP	is
	end	tb_PRJ_TOP;

	architecture	arctb_PRJ_TOP	of	tb_PRJ_TOP	is
----------------------------------------------------------
----Component
----------------------------------------------------------
	component PRJ_TOP is
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
	end component;
	
	
	component SIM_FIFO IS
	PORT
	(
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		rdreq		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		empty		: OUT STD_LOGIC ;
		full		: OUT STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		usedw		: OUT STD_LOGIC_VECTOR (8 DOWNTO 0)
	);
	END component;
	
----------------------------------------------------------
----Signal
----------------------------------------------------------
	-----------------------------------------------------------------------------------------
	--	-->> simulation parameter
	-----------------------------------------------------------------------------------------
	
	
	-----------------------------------------------------------------------------------------
	--	<<-- simulation parameter
	-----------------------------------------------------------------------------------------
	constant		kCLK_50M					:	time									:=20 ns;
	signal			iCLK_50M					:	std_logic								;
	
	signal			CLK							:	std_logic								;
	
	-- CPU interface
	subtype			tTestItem					is	string(1 to 32)			;
	signal			wTestItem					:	tTestItem				:=	"                                ";
	
	signal			FD							:	std_logic_vector(15 downto 0)				;
	signal			FLAGA						:	std_logic									;
	signal			FLAGB						:	std_logic									;
	signal			FLAGC						:	std_logic									;
	signal			FLAGD						:	std_logic									;
	signal			SLRD_L						:	std_logic									;
	signal			SLWR_L						:	std_logic									;
	signal			SLOE_L						:	std_logic									;
	signal			ADR0						:	std_logic									;
	signal			ADR1						:	std_logic									;
	signal			CLKOUT						:	std_logic									;
	signal			IFCLK						:	std_logic									;
	signal			PKTEND						:	std_logic									;
	signal			UART_TXD					:	std_logic									;
	signal			UART_RXD					:	std_logic									;
	signal			LED							:	std_logic_vector(1 downto 0)				;
	signal			SW_TACT						:	std_logic_vector(1 downto 0)				;
	
	
	alias			RST_L						:	std_logic			is	SW_TACT(0)		;
	
	signal			FIFO_q						:	std_logic_vector(15 downto 0)				;
	signal			rdreq						:	std_logic									;
	signal			wrreq						:	std_logic									;
	
----------------------------------------------------------
----Function
----------------------------------------------------------
	
----====================================================--
	begin
	
	
	process
	begin
		iCLK_50M <= '0';
		wait for kCLK_50M / 2 ;
		iCLK_50M <= '1';
		wait for kCLK_50M - ( kCLK_50M / 2 );
	end process;
	
	CLK			<=	iCLK_50M	;
	
	process
		variable		in_line				:	line											;
		variable		read_buf			:	std_logic_vector(11 downto 0)					;
		
		variable		Line_Buf				:	line					;
		variable		GetText					:	string(32 downto 1)	;
		
		--***************************************************************************
		-- procedure declaration
		--***************************************************************************
		procedure Printf 
			(
				text_Message	: in string
			) is
		begin
			write( Line_Buf, text_Message ); 		writeline(output, Line_Buf);
			report text_Message  severity warning;
		end procedure;
		
		procedure Scanf is 
		begin
			readline(input, Line_Buf);	read(Line_Buf,GetText)		;
		end procedure;
		
		procedure pSIM_ITEM 
			(
				text_Message	: in string
			) is
		begin
			report text_Message  severity warning;
			if(text_Message'length < 32)then
				case	text_Message'length	is
					when	0	=>	wTestItem	<=	"                                "	;
					when	1	=>	wTestItem	<=	text_Message & "                               ";
					when	2	=>	wTestItem	<=	text_Message & "                              ";
					when	3	=>	wTestItem	<=	text_Message & "                             ";
					when	4	=>	wTestItem	<=	text_Message & "                            ";
					when	5	=>	wTestItem	<=	text_Message & "                           ";
					when	6	=>	wTestItem	<=	text_Message & "                          ";
					when	7	=>	wTestItem	<=	text_Message & "                         ";
					when	8	=>	wTestItem	<=	text_Message & "                        ";
					when	9	=>	wTestItem	<=	text_Message & "                       ";
					when	10	=>	wTestItem	<=	text_Message & "                      ";
					when	11	=>	wTestItem	<=	text_Message & "                     ";
					when	12	=>	wTestItem	<=	text_Message & "                    ";
					when	13	=>	wTestItem	<=	text_Message & "                   ";
					when	14	=>	wTestItem	<=	text_Message & "                  ";
					when	15	=>	wTestItem	<=	text_Message & "                 ";
					when	16	=>	wTestItem	<=	text_Message & "                ";
					when	17	=>	wTestItem	<=	text_Message & "               ";
					when	18	=>	wTestItem	<=	text_Message & "              ";
					when	19	=>	wTestItem	<=	text_Message & "             ";
					when	20	=>	wTestItem	<=	text_Message & "            ";
					when	21	=>	wTestItem	<=	text_Message & "           ";
					when	22	=>	wTestItem	<=	text_Message & "          ";
					when	23	=>	wTestItem	<=	text_Message & "         ";
					when	24	=>	wTestItem	<=	text_Message & "        ";
					when	25	=>	wTestItem	<=	text_Message & "       ";
					when	26	=>	wTestItem	<=	text_Message & "      ";
					when	27	=>	wTestItem	<=	text_Message & "     ";
					when	28	=>	wTestItem	<=	text_Message & "    ";
					when	29	=>	wTestItem	<=	text_Message & "   ";
					when	30	=>	wTestItem	<=	text_Message & "  ";
					when	31	=>	wTestItem	<=	text_Message & " ";
					when	others => null;
				end case;
			else
				wTestItem	<=	text_Message(1 to 32)	;
			end if;
		end procedure;
		
		procedure pSTOP_SIMULATION is
		begin
			report "****************************************************r\n" &
				"Simulation Error" &
				"****************************************************\r\n"
			severity error;
			finish(0);
		end procedure;
		
		procedure pWAIT is
		begin
			wait until CLK'event and CLK = '1';
			wait until CLK'event and CLK = '1';
			wait until CLK'event and CLK = '1';
			wait until CLK'event and CLK = '1';
			wait until CLK'event and CLK = '1';
			wait until CLK'event and CLK = '1';
			wait until CLK'event and CLK = '1';
			wait until CLK'event and CLK = '1';
		end procedure;
		
		procedure CompareStd
			(
				StdIn		: in std_logic_vector		;
				ExpectVal	: in std_logic_vector		
			) is
		begin
			if(StdIn /= ExpectVal)then
				report "Compare data errorr\n" severity error;
				write( Line_Buf, string'("read data should be : " ));
				write( Line_Buf, ExpectVal );
				writeline(output, Line_Buf);
				pSTOP_SIMULATION	;
			end if;
		end procedure;
		
		procedure CompareStd
			(
				StdIn		: in std_logic		;
				ExpectVal	: in std_logic		
			) is
		begin
			if(StdIn /= ExpectVal)then
				report "Compare data errorr\n" severity error;
				write( Line_Buf, string'("read data should be : " ));
				write( Line_Buf, ExpectVal );
				writeline(output, Line_Buf);
				pSTOP_SIMULATION	;
			end if;
		end procedure;
		
		procedure pXXX is
		begin
			
		end procedure;
		
	begin
		--***************************************************************************
		-- read_string size and log_file_input.txt size(per one line) should be equal
		--***************************************************************************
		RST_L			<=	'0';
		FLAGA			<=	'0';
		FLAGB			<=	'0';
		FLAGC			<=	'0';
		FLAGD			<=	'0';
		
		wait for kCLK_50M * 100 ;
		wait until iCLK_50M'event and iCLK_50M = '1';
		RST_L			<=	'1';
		wait for 1us;
		
		FLAGA			<=	'1';
		FLAGD			<=	'0';
		wait for 5us;
		FLAGA			<=	'0';
		FLAGD			<=	'1';
		wait for 5us;
		FLAGA			<=	'1';
		FLAGD			<=	'0';
		wait for 5us;
		FLAGA			<=	'0';
		FLAGD			<=	'1';
		wait for 5us;
		FLAGA			<=	'0';
		FLAGB			<=	'0';
		FLAGC			<=	'0';
		FLAGD			<=	'0';
		
		
		
--		FLAGA			<=	'1';
--		FLAGD			<=	'0';
--		wait for 5us;
--		FLAGA			<=	'0';
--		FLAGD			<=	'0';
--		wait for 1us;
--		
--		FLAGA			<=	'0';
--		FLAGD			<=	'1';
--		wait for 5us;
--		FLAGA			<=	'0';
--		FLAGD			<=	'0';
--		wait for 1us;
--		
--		FLAGA			<=	'1';
--		FLAGD			<=	'0';
--		wait for 5us;
--		FLAGA			<=	'0';
--		FLAGD			<=	'0';
--		wait for 1us;
--		
--		FLAGA			<=	'0';
--		FLAGD			<=	'1';
--		wait for 5us;
--		FLAGA			<=	'0';
--		FLAGD			<=	'0';
--		wait for 1us;
--		
--		FLAGA			<=	'0';
--		FLAGB			<=	'0';
--		FLAGC			<=	'0';
--		FLAGD			<=	'0';
		
		wait;
		--wait for 1 us;
		
		
		report "****************************************************r\n" &
				"Simulation Successful : End of simulation time reached" &
				"****************************************************\r\n" severity note;
		finish(0);
		
		wait;
	end process;
	
----------------------------------------------------------
----Port Map
----------------------------------------------------------
	
	SIM_PRJ_TOP	:	PRJ_TOP
		port map(
			clk_50mhz				=>	CLK					,	--	: in  std_logic;		-- input clock 50MHz
			
			FD						=>	FD					,	--	:	inout		std_logic_vector(15 downto 0)				;
			FLAGA					=>	FLAGA				,	--	:	in		std_logic									;
			FLAGB					=>	FLAGB				,	--	:	in		std_logic									;
			FLAGC					=>	FLAGC				,	--	:	in		std_logic									;
			FLAGD					=>	FLAGD				,	--	:	in		std_logic									;
			SLRD_L					=>	SLRD_L				,	--	:	out		std_logic									;
			SLWR_L					=>	SLWR_L				,	--	:	out		std_logic									;
			SLOE_L					=>	SLOE_L				,	--	:	out		std_logic									;
			ADR0					=>	ADR0				,	--	:	out		std_logic									;
			ADR1					=>	ADR1				,	--	:	out		std_logic									;
			CLKOUT					=>	CLKOUT				,	--	:	in		std_logic									;
			IFCLK					=>	IFCLK				,	--	:	out		std_logic									;
			
			PKTEND					=>	PKTEND				,	--	:	out		std_logic									;
			-- UART                 =>						,	--	
			UART_TXD				=>	UART_TXD			,	--	:	out	std_logic							;
			UART_RXD				=>	UART_RXD			,	--	:	in	std_logic							;
														
			LED						=>	LED					,	--	:	out	std_logic_vector(1 downto 0)		;
														
			SW_TACT					=>	SW_TACT					--	:	in	std_logic_vector(1 downto 0)		
			
		);
	
	SIM_SIM_FIFO	:	SIM_FIFO
		PORT map
		(
			clock					=>	IFCLK				,	--	: IN STD_LOGIC ;
			data					=>	FD					,	--	: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			rdreq					=>	rdreq				,	--	: IN STD_LOGIC ;
			wrreq					=>	wrreq				,	--	: IN STD_LOGIC ;
			empty					=>	open				,	--	: OUT STD_LOGIC ;
			full					=>	open				,	--	: OUT STD_LOGIC ;
			q						=>	FIFO_q				,	--	: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
			usedw					=>	open					--	: OUT STD_LOGIC_VECTOR (8 DOWNTO 0)
		);
	
	
--	EP2 as OUT, 512 bytes, 		FLAGA is configured as empty flag for EP2 OUT FIFO 			PC->device
--	EP6 as IN, 512 bytes, 		FLAGD is configured as full flag for EP6 IN FIFO			device->PC

--	FIFOADR[1:0]   Selected FIFO
--	00             EP2				FLAGA
--	01             EP4
--	10             EP6				FLAGD
--	11             EP8
	
	FD		<=	FIFO_q	when(ADR0 = '0' and ADR1 ='0')	else	(others => 'Z')	;
	rdreq	<=	'1'		when(SLRD_L = '0' and SLOE_L ='0')	else	'0'		;
	wrreq	<=	'1'		when(SLWR_L = '0')	else	'0'	;
	
	
	
	end	arctb_PRJ_TOP;
	
	