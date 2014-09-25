----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:27:23 03/19/2014 
-- Design Name: 
-- Module Name:    FSM - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSM is
    Port ( PATTERN : in  STD_LOGIC_VECTOR(7 DOWNTO 0);
           RST_N : in  STD_LOGIC;
           SDI : in  STD_LOGIC;
           SCK : in  STD_LOGIC;
           SEQ_DETECTED : out  STD_LOGIC);
end FSM;

architecture FSM of FSM is
type state_type is(state0, state1, state2, state3, state4, state5, state6, state7, state8);

signal pr_state: state_type;

signal nx_state: state_type; 

signal pr_next: STD_LOGIC_Vector(7 downto 0);
--signal SEQ_DETECTED : state_type :=0;

 -- enter your statements here --

begin

process (RST_N, SCK)

begin

if (RST_N = '0') then

pr_state <= state0;

elsif (rising_edge(SCK)) then

pr_state <= nx_state; 

end if;

end process;

process(RST_N)

begin

if(RST_N = '1' and RST_N'event) then

pr_next <= pattern;

end if;

end process;

process(pr_state, SDI,pr_next)

begin

nx_state <= pr_state;

SEQ_DETECTED <= '0';

case pr_state is

when state0 => if( SDI = pr_next(7)) then 

nx_state <= state1;

end if;

when state1 => if( SDI = pr_next(6)) then 

nx_state <= state2;

 elsif (SDI = pr_next(7)) then 

nx_state <= state1;

 else

nx_state <= state0; 

 end if; 

 when state2 => if( SDI = pr_next(5)) then 

nx_state <= state3;

 elsif (SDI = pr_next(7)) then 

nx_state <= state1;

 else

nx_state <= state0; 

end if;

 when state3 => if( SDI = pr_next(4)) then 

nx_state <= state4;

 elsif (SDI = pr_next(7)) then 

nx_state <= state1;

 else

nx_state <= state0; 

 end if;

 when state4 => if( SDI = pr_next(3)) then 

nx_state <= state5;

 elsif (SDI = pr_next(7)) then 

nx_state <= state1;

 else

nx_state <= state0; 

 end if;

 when state5 => if( SDI <= pr_next(2)) then 

nx_state <= state6;

 elsif (SDI <= pr_next(7)) then 

nx_state <= state1;

 else

nx_state <= state0; 

 end if; 

 when state6 => if( SDI = pr_next(1)) then 

nx_state <= state7;

 elsif (SDI = pr_next(7)) then 

nx_state <= state1;

 else

nx_state <= state0; 

 end if;

 when state7 => if( SDI = pr_next(0)) then 

nx_state <= state8;

 elsif (SDI = pr_next(7)) then 

nx_state <= state1;

 else

nx_state <= state0; 

end if;

 when state8 => if (SDI = pr_next(7)) then 

nx_state <= state1;

 else nx_state <= state0; 

end if;

SEQ_DETECTED <= '1'; 

 end case;

 end process;

end FSM;