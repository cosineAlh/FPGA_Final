--------------------------------------------

-- key round for 128 bits(encryption)

--------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity KeyRound128 is
    Port(
        subkey: in STD_LOGIC_VECTOR(127 downto 0);
        round_const: in STD_LOGIC_VECTOR(7 downto 0);
        next_subkey: out STD_LOGIC_VECTOR(127 downto 0)
    );
end KeyRound128;

architecture Behavioral of KeyRound128 is
    component sbox
        Port(
		INPUT_BYTE: in STD_LOGIC_VECTOR(7 downto 0);
		OUTPUT_BYTE: out STD_LOGIC_VECTOR(7 downto 0)
	);
    end component;
    
    signal sub:STD_LOGIC_VECTOR(31 downto 0);--store subbyte result
    signal shift:STD_LOGIC_VECTOR(31 downto 0);--store shift result 
    signal w0,w1,w2,w3,w4:STD_LOGIC_VECTOR(31 downto 0);
begin
    box_gen:for i in 0 to 3 generate--transform for word at lowest position
        box_inst:sbox
        port map(
            INPUT_BYTE=>subkey((i + 1)*8 - 1 downto i*8),
            OUTPUT_BYTE=>sub((i + 1)*8 - 1 downto (i)*8)
        );
    end generate;

    shift<=sub(23 downto 0) & sub(31 downto 24);
    w3(23 downto 0)<=shift(23 downto 0);
    w3(31 downto 24)<=round_const xor shift(31 downto 24);
    w0<=subkey(127 downto 96) xor w3;
    w1<=subkey(95 downto 64) xor w0;
    w2<=subkey(63 downto 32) xor w1;
    w4<=subkey(31 downto 0) xor w2;--in fact it is word 3
    
    next_subkey<=w0 & w1 & w2 & w4;

end Behavioral;
