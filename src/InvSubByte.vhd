--------------------------------------------

-- inverse of subbytes

--------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity InvSubByte is
    Port(
        STATE_IN: in STD_LOGIC_VECTOR(127 downto 0);
        STATE_OUT: out STD_LOGIC_VECTOR(127 downto 0)
    );
end InvSubByte;

architecture Behavioral of InvSubByte is
   component InvSbox
	Port(
		INPUT_BYTE: in STD_LOGIC_VECTOR(7 downto 0);
		OUTPUT_BYTE: out STD_LOGIC_VECTOR(7 downto 0)
	);
   end component;
begin
    generator:for i in 0 to 15 generate
        sbox_inst:InvSbox port map(
            INPUT_BYTE=>STATE_IN((i + 1)*8 - 1 downto i*8),
            OUTPUT_BYTE=>STATE_OUT((i + 1)*8 - 1 downto i*8)
        );
    end generate;

end Behavioral;
