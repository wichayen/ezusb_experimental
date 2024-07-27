	library		ieee;
	use			ieee.std_logic_1164.all	;
	use			ieee.std_logic_unsigned.all;
	use			ieee.std_logic_arith.all;
	use			ieee.std_logic_misc.all;
	
	use			std.textio.all;
	use			std.env.all;
	use			ieee.std_logic_textio.all;
	
	package	SIM_PKG	is
	
	type	tAVS_BUS	is	
		record
			avs_address			:	std_logic_vector(7 downto 0)			;
			avs_read			:	std_logic								;
			avs_readdata		:	std_logic_vector(31 downto 0)			;
			avs_write			:	std_logic								;
			avs_writedata		:	std_logic_vector(31 downto 0)			;
			avs_waitrequest		:	std_logic								;
			avs_chipselect		:	std_logic								;
		end record;
	
	procedure	AVS_Wr	(
				Addr			:	in	std_logic_vector( 7 downto 0 );
				DataIn			:	in	std_logic_vector( 31 downto 0 );
		signal	BUSCLK			:	in	std_logic							;
		signal	iCPUBUS			:	inout	tAVS_BUS							;
				DelayCycle		:	in	integer								
		);
		
	procedure	AVS_Rd	(
				Addr			:	in	std_logic_vector( 7 downto 0 )	;
		signal	DataOut			:	out	std_logic_vector( 31 downto 0 )	;
		signal	BUSCLK			:	in	std_logic							;
		signal	iCPUBUS			:	inout	tAVS_BUS							;
				DelayCycle		:	in	integer								
		);
	
--	--	Avalon bus
--	type	tAVL_BUS	is	
--		record
--			avl_address			:	std_logic_vector(31 downto 0)			;
--			avl_read			:	std_logic								;
--			avl_readdata		:	std_logic_vector(15 downto 0)			;
--			avl_write			:	std_logic								;
--			avl_writedata		:	std_logic_vector(15 downto 0)			;
--			avl_chipselect		:	std_logic								;
--			--avl_byteenable		:	std_logic_vector(3 downto 0)			;
--			avl_waitrequest		:	std_logic								;
--		end record;
--	
--	procedure	AVL_Wr	(
--				Addr			:	in	std_logic_vector( 31 downto 0 )	;
--				DataIn			:	in	std_logic_vector( 15 downto 0 )	;
--				--ByteEn			:	in	std_logic_vector( 3 downto 0 )		;
--		signal	BUSCLK			:	in	std_logic							;
--		signal	iCPUBUS			:	inout	tAVL_BUS						
--		);
--		
--	procedure	AVL_Rd	(
--				Addr			:	in	std_logic_vector( 31 downto 0 )	;
--				--ByteEn			:	in	std_logic_vector( 3 downto 0 )		;
--		signal	DataOut			:	out	std_logic_vector( 15 downto 0 )	;
--		signal	BUSCLK			:	in	std_logic							;
--		signal	iCPUBUS			:	inout	tAVL_BUS						
--		);
		
	
	type	tAVL_BUS32	is	
		record
			avl_address			:	std_logic_vector(31 downto 0)			;
			avl_read			:	std_logic								;
			avl_readdata		:	std_logic_vector(31 downto 0)			;
			avl_write			:	std_logic								;
			avl_writedata		:	std_logic_vector(31 downto 0)			;
			avl_chipselect		:	std_logic								;
			--avl_byteenable		:	std_logic_vector(3 downto 0)			;
			avl_waitrequest		:	std_logic								;
		end record;
	
	procedure	AVL_Wr32	(
				Addr			:	in	std_logic_vector( 31 downto 0 )	;
				DataIn			:	in	std_logic_vector( 31 downto 0 )	;
				--ByteEn			:	in	std_logic_vector( 3 downto 0 )		;
		signal	BUSCLK			:	in	std_logic							;
		signal	iCPUBUS			:	inout	tAVL_BUS32						
		);
		
	procedure	AVL_Rd32	(
				Addr			:	in	std_logic_vector( 31 downto 0 )	;
				--ByteEn			:	in	std_logic_vector( 3 downto 0 )		;
		signal	DataOut			:	out	std_logic_vector( 31 downto 0 )	;
		signal	BUSCLK			:	in	std_logic							;
		signal	iCPUBUS			:	inout	tAVL_BUS32						
		);
	
	
	
	
	type	tFX2_BUS	is	
		record
			FD					:	std_logic_vector(15 downto 0)				;
			SLRD_L				:	std_logic									;
			SLWR_L				:	std_logic									;
			SLOE_L				:	std_logic									;
			IFCLK				:	std_logic									;
		end record;
	
	procedure	FX2_Wr	(
				DataIn			:	in	std_logic_vector( 15 downto 0 )		;
		signal	BUSCLK			:	in	std_logic							;
		signal	iCPUBUS			:	inout	tFX2_BUS						
		);
		
	procedure	FX2_Rd	(
		signal	DataOut			:	out	std_logic_vector( 15 downto 0 )		;
		signal	BUSCLK			:	in	std_logic							;
		signal	iCPUBUS			:	inout	tFX2_BUS						
		);
	
	end	SIM_PKG;
	
--------------------------------------------------------
	package	body SIM_PKG	is
--------------------------------------------------------

--------------------------------------------------------

--------------------------------------------------------
	procedure	AVS_Wr	(
				Addr			:	in	std_logic_vector( 7 downto 0 );
				DataIn			:	in	std_logic_vector( 31 downto 0 );
		signal	BUSCLK			:	in	std_logic							;
		signal	iCPUBUS			:	inout	tAVS_BUS							;
				DelayCycle		:	in	integer								
		)	is
		
		variable	vDelayCycle	:	integer								;
	begin
		wait until BUSCLK'event and BUSCLK = '1';
		iCPUBUS.avs_address		<=	Addr	;
		iCPUBUS.avs_writedata	<=	DataIn	;
		iCPUBUS.avs_write		<=	'1'		;
		iCPUBUS.avs_chipselect	<=	'1'	;
		wait until BUSCLK'event and BUSCLK = '1';
		iCPUBUS.avs_write		<=	'0'		;
		iCPUBUS.avs_chipselect	<=	'0'		;
		wait until BUSCLK'event and BUSCLK = '1';
	end AVS_Wr	;
	
	
	procedure	AVS_Rd	(
				Addr			:	in	std_logic_vector( 7 downto 0 )	;
		signal	DataOut			:	out	std_logic_vector( 31 downto 0 )	;
		signal	BUSCLK			:	in	std_logic							;
		signal	iCPUBUS			:	inout	tAVS_BUS							;
				DelayCycle		:	in	integer								
		)	is
		
		variable	vDelayCycle	:	integer								;
	begin
		wait until BUSCLK'event and BUSCLK = '1';
		iCPUBUS.avs_address			<=	Addr	;
		iCPUBUS.avs_read			<=	'1'		;
		iCPUBUS.avs_chipselect		<=	'1'		;
		wait until BUSCLK'event and BUSCLK = '1';
		iCPUBUS.avs_read			<=	'0'		;
		iCPUBUS.avs_chipselect		<=	'0'		;
		wait until BUSCLK'event and BUSCLK = '1';
		DataOut						<=	iCPUBUS.avs_readdata	;
	end AVS_Rd	;
	
	
	
	
--	procedure	AVL_Wr	(
--				Addr			:	in	std_logic_vector( 31 downto 0 );
--				DataIn			:	in	std_logic_vector( 15 downto 0 );
--				--ByteEn			:	in	std_logic_vector( 3 downto 0 );
--		signal	BUSCLK			:	in	std_logic							;
--		signal	iCPUBUS			:	inout	tavl_BUS						
--		)	is
--		
--	begin
--		wait until BUSCLK'event and BUSCLK = '1';
--		iCPUBUS.avl_address			<=	Addr	;
--		iCPUBUS.avl_writedata		<=	DataIn	;
--		iCPUBUS.avl_write			<=	'1'		;
--		iCPUBUS.avl_read			<=	'0'		;
--		--iCPUBUS.avl_byteenable		<=	ByteEn	;
--		iCPUBUS.avl_chipselect		<=	'1'		;
--		
--		wait until BUSCLK'event and BUSCLK = '0';
--		if(iCPUBUS.avl_waitrequest = '1')then
--			wait until BUSCLK'event and BUSCLK = '1';
--			while(iCPUBUS.avl_waitrequest = '1')loop
--				wait until BUSCLK'event and BUSCLK = '1';
--			end loop;
--		else
--			wait until BUSCLK'event and BUSCLK = '1';
--		end if;
--		
--		iCPUBUS.avl_address			<=	(others => '0')	;
--		iCPUBUS.avl_writedata		<=	(others => '0')	;
--		iCPUBUS.avl_write			<=	'0'		;
--		iCPUBUS.avl_read			<=	'0'		;
--		--iCPUBUS.avl_byteenable		<=	(others => '0')	;
--		iCPUBUS.avl_chipselect		<=	'0'		;
--		wait until BUSCLK'event and BUSCLK = '1';
--	end avl_Wr	;
--	
--	
--	procedure	AVL_Rd	(
--				Addr			:	in	std_logic_vector( 31 downto 0 )	;
--				--ByteEn			:	in	std_logic_vector( 3 downto 0 );
--		signal	DataOut			:	out	std_logic_vector( 15 downto 0 )	;
--		signal	BUSCLK			:	in	std_logic							;
--		signal	iCPUBUS			:	inout	tavl_BUS						
--		)	is
--		
--	begin
--		
--		wait until BUSCLK'event and BUSCLK = '1';
--		iCPUBUS.avl_address			<=	Addr	;
--		iCPUBUS.avl_write			<=	'0'		;
--		iCPUBUS.avl_read			<=	'1'		;
--		--iCPUBUS.avl_byteenable		<=	ByteEn	;
--		iCPUBUS.avl_chipselect		<=	'1'		;
--		
--		wait until BUSCLK'event and BUSCLK = '0';
--		if(iCPUBUS.avl_waitrequest = '1')then
--			wait until BUSCLK'event and BUSCLK = '1';
--			while(iCPUBUS.avl_waitrequest = '1')loop
--				wait until BUSCLK'event and BUSCLK = '1';
--			end loop;
--		end if;
--		iCPUBUS.avl_read			<=	'0'		;
--		DataOut						<=	iCPUBUS.avl_readdata	;
--		wait until BUSCLK'event and BUSCLK = '1';
--		iCPUBUS.avl_address			<=	(others => '0')	;
--		iCPUBUS.avl_write			<=	'0'		;
--		--iCPUBUS.avl_byteenable		<=	(others => '0')	;
--		iCPUBUS.avl_chipselect		<=	'0'		;
--		wait until BUSCLK'event and BUSCLK = '1';
--	end avl_Rd	;
	
	
	
	
	
	
	procedure	AVL_Wr32	(
				Addr			:	in	std_logic_vector( 31 downto 0 );
				DataIn			:	in	std_logic_vector( 31 downto 0 );
				--ByteEn			:	in	std_logic_vector( 3 downto 0 );
		signal	BUSCLK			:	in	std_logic							;
		signal	iCPUBUS			:	inout	tAVL_BUS32						
		)	is
		
	begin
		wait until BUSCLK'event and BUSCLK = '1';
		iCPUBUS.avl_address			<=	Addr	;
		iCPUBUS.avl_writedata		<=	DataIn	;
		iCPUBUS.avl_write			<=	'1'		;
		iCPUBUS.avl_read			<=	'0'		;
		--iCPUBUS.avl_byteenable		<=	ByteEn	;
		iCPUBUS.avl_chipselect		<=	'1'		;
		
		wait until BUSCLK'event and BUSCLK = '0';
		if(iCPUBUS.avl_waitrequest = '1')then
			wait until BUSCLK'event and BUSCLK = '1';
			while(iCPUBUS.avl_waitrequest = '1')loop
				wait until BUSCLK'event and BUSCLK = '1';
			end loop;
		else
			wait until BUSCLK'event and BUSCLK = '1';
		end if;
		
		iCPUBUS.avl_address			<=	(others => '0')	;
		iCPUBUS.avl_writedata		<=	(others => '0')	;
		iCPUBUS.avl_write			<=	'0'		;
		iCPUBUS.avl_read			<=	'0'		;
		--iCPUBUS.avl_byteenable		<=	(others => '0')	;
		iCPUBUS.avl_chipselect		<=	'0'		;
		wait until BUSCLK'event and BUSCLK = '1';
	end AVL_Wr32	;
	
	
	procedure	AVL_Rd32	(
				Addr			:	in	std_logic_vector( 31 downto 0 )	;
				--ByteEn			:	in	std_logic_vector( 3 downto 0 );
		signal	DataOut			:	out	std_logic_vector( 31 downto 0 )	;
		signal	BUSCLK			:	in	std_logic							;
		signal	iCPUBUS			:	inout	tAVL_BUS32						
		)	is
		
	begin
		
		wait until BUSCLK'event and BUSCLK = '1';
		iCPUBUS.avl_address			<=	Addr	;
		iCPUBUS.avl_write			<=	'0'		;
		iCPUBUS.avl_read			<=	'1'		;
		--iCPUBUS.avl_byteenable		<=	ByteEn	;
		iCPUBUS.avl_chipselect		<=	'1'		;
		
		wait until BUSCLK'event and BUSCLK = '0';
		if(iCPUBUS.avl_waitrequest = '1')then
			wait until BUSCLK'event and BUSCLK = '1';
			while(iCPUBUS.avl_waitrequest = '1')loop
				wait until BUSCLK'event and BUSCLK = '1';
			end loop;
		end if;
		iCPUBUS.avl_read			<=	'0'		;
		DataOut						<=	iCPUBUS.avl_readdata	;
		wait until BUSCLK'event and BUSCLK = '1';
		iCPUBUS.avl_address			<=	(others => '0')	;
		iCPUBUS.avl_write			<=	'0'		;
		--iCPUBUS.avl_byteenable		<=	(others => '0')	;
		iCPUBUS.avl_chipselect		<=	'0'		;
		wait until BUSCLK'event and BUSCLK = '1';
	end AVL_Rd32	;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	procedure	FX2_Wr	(
				DataIn			:	in	std_logic_vector( 15 downto 0 )		;
		signal	BUSCLK			:	in	std_logic							;
		signal	iCPUBUS			:	inout	tFX2_BUS						
		)	is
	begin
		wait until BUSCLK'event and BUSCLK = '1';
		iCPUBUS.avl_address			<=	Addr	;
		iCPUBUS.avl_writedata		<=	DataIn	;
		iCPUBUS.avl_write			<=	'1'		;
		iCPUBUS.avl_read			<=	'0'		;
		--iCPUBUS.avl_byteenable		<=	ByteEn	;
		iCPUBUS.avl_chipselect		<=	'1'		;
		
		wait until BUSCLK'event and BUSCLK = '0';
		if(iCPUBUS.avl_waitrequest = '1')then
			wait until BUSCLK'event and BUSCLK = '1';
			while(iCPUBUS.avl_waitrequest = '1')loop
				wait until BUSCLK'event and BUSCLK = '1';
			end loop;
		else
			wait until BUSCLK'event and BUSCLK = '1';
		end if;
		
		iCPUBUS.avl_address			<=	(others => '0')	;
		iCPUBUS.avl_writedata		<=	(others => '0')	;
		iCPUBUS.avl_write			<=	'0'		;
		iCPUBUS.avl_read			<=	'0'		;
		--iCPUBUS.avl_byteenable		<=	(others => '0')	;
		iCPUBUS.avl_chipselect		<=	'0'		;
		wait until BUSCLK'event and BUSCLK = '1';
	end AVL_Wr32	;
	
	
	procedure	FX2_Rd	(
		signal	DataOut			:	out	std_logic_vector( 15 downto 0 )		;
		signal	BUSCLK			:	in	std_logic							;
		signal	iCPUBUS			:	inout	tFX2_BUS						
		)	is
	begin
		
		wait until BUSCLK'event and BUSCLK = '1';
		iCPUBUS.avl_address			<=	Addr	;
		iCPUBUS.avl_write			<=	'0'		;
		iCPUBUS.avl_read			<=	'1'		;
		--iCPUBUS.avl_byteenable		<=	ByteEn	;
		iCPUBUS.avl_chipselect		<=	'1'		;
		
		wait until BUSCLK'event and BUSCLK = '0';
		if(iCPUBUS.avl_waitrequest = '1')then
			wait until BUSCLK'event and BUSCLK = '1';
			while(iCPUBUS.avl_waitrequest = '1')loop
				wait until BUSCLK'event and BUSCLK = '1';
			end loop;
		end if;
		iCPUBUS.avl_read			<=	'0'		;
		DataOut						<=	iCPUBUS.avl_readdata	;
		wait until BUSCLK'event and BUSCLK = '1';
		iCPUBUS.avl_address			<=	(others => '0')	;
		iCPUBUS.avl_write			<=	'0'		;
		--iCPUBUS.avl_byteenable		<=	(others => '0')	;
		iCPUBUS.avl_chipselect		<=	'0'		;
		wait until BUSCLK'event and BUSCLK = '1';
	end AVL_Rd32	;
	
	
	
	
	
	
	
	
	
	end	SIM_PKG;
