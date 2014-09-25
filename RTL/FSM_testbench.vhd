
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:48:30 03/19/2014
-- Design Name:   FSM
-- Module Name:   C:/Xilinx91i/hw_5_avlsi/FSM_testbench.vhd
-- Project Name:  hw_5_avlsi
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FSM
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends 
-- that these types always be used for the top-level I/O of a design in order 
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY FSM_testbench_vhd IS
END FSM_testbench_vhd;

ARCHITECTURE behavior OF FSM_testbench_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT FSM
	PORT(
		PATTERN : IN std_logic_vector(7 downto 0);
		RST_N : IN std_logic;
		SDI : IN std_logic;
		SCK : IN std_logic;          
		SEQ_DETECTED : OUT std_logic
		);
	END COMPONENT;

	--Inputs
	SIGNAL RST_N :  std_logic := '0';
	SIGNAL SDI :  std_logic := '0';
	SIGNAL SCK :  std_logic := '0';
	SIGNAL PATTERN :  std_logic_vector(7 downto 0) := (others=>'0');

	--Outputs
	SIGNAL SEQ_DETECTED :  std_logic;
	--Variables
	SIGNAL seq_input:std_logic_vector(24 downto 0):="1111100000111110000011111";

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: FSM PORT MAP(
		PATTERN => PATTERN,
		RST_N => RST_N,
		SDI => SDI,
		SCK => SCK,
		SEQ_DETECTED => SEQ_DETECTED
	);
   SCK <= not SCK after 10 ns;
	tb : PROCESS
	BEGIN
	 wait until SCK'event and SCK = '1';
    wait until SCK'event and SCK = '1';
				RST_N <= '1';
				pattern <= "11111000"; 
				
		wait for 10 ns;
				RST_N <= '0';
		wait for 80 ns;				
				RST_N <= '1'; 
				pattern <="11111011"; 
				
		wait for 20 ns;				
				RST_N <='1' ;				
				wait;
	END PROCESS;
   PROCESS
	BEGIN
		for i in 24 downto 0 loop
		SDI <= seq_input(i);
		wait until SCK'event and SCK='1';
		end loop;
	END PROCESS;
	END;
