--------------------------------------------

-- add round key

--------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity AddRoundKey is
    Port(
        STATE_IN: in STD_LOGIC_VECTOR(127 downto 0);
        STATE_OUT: out STD_LOGIC_VECTOR(127 downto 0);
        KEY: in STD_LOGIC_VECTOR(127 downto 0)
    );
end AddRoundKey;

architecture Behavioral of AddRoundKey is
begin
    STATE_OUT<=STATE_IN xor KEY;
end Behavioral;