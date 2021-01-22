--------------------------------------------

-- shift rows

--------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ShiftRows is
    Port(
        STATE_IN: in STD_LOGIC_VECTOR(127 downto 0);
        STATE_OUT: out STD_LOGIC_VECTOR(127 downto 0)
    );
end ShiftRows;

architecture Behavioral of ShiftRows is

begin   
    STATE_OUT(8*16 - 1 downto 8*15) <= STATE_IN(8*16 - 1 downto 8*15);
	STATE_OUT(8*15 - 1 downto 8*14) <= STATE_IN(8*11 - 1 downto 8*10);
	STATE_OUT(8*14 - 1 downto 8*13) <= STATE_IN(8*6 - 1 downto 8*5); 
	STATE_OUT(8*13 - 1 downto 8*12) <= STATE_IN(8*1 - 1 downto 8*0);
	STATE_OUT(8*12 - 1 downto 8*11) <= STATE_IN(8*12 - 1 downto 8*11);
	STATE_OUT(8*11 - 1 downto 8*10) <= STATE_IN(8*7 - 1 downto 8*6); 
	STATE_OUT(8*10 - 1 downto 8*9) <= STATE_IN(8*2 - 1 downto 8*1);
	STATE_OUT(8*9 - 1 downto 8*8) <= STATE_IN(8*13 - 1 downto 8*12);
	STATE_OUT(8*8 - 1 downto 8*7) <= STATE_IN(8*8 - 1 downto 8*7);
	STATE_OUT(8*7 - 1 downto 8*6) <= STATE_IN(8*3 - 1 downto 8*2);
	STATE_OUT(8*6 - 1 downto 8*5) <= STATE_IN(8*14 - 1 downto 8*13);
	STATE_OUT(8*5 - 1 downto 8*4) <= STATE_IN(8*9 - 1 downto 8*8);
	STATE_OUT(8*4 - 1 downto 8*3) <= STATE_IN(8*4 - 1 downto 8*3);
	STATE_OUT(8*3 - 1 downto 8*2) <= STATE_IN(8*15 - 1 downto 8*14);
	STATE_OUT(8*2 - 1 downto 8*1) <= STATE_IN(8*10 - 1 downto 8*9);
	STATE_OUT(8*1 - 1 downto 8*0) <= STATE_IN(8*5 - 1 downto 8*4); 	
end Behavioral;