--------------------------------------------

-- key round for 256 bits(encry)

--------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity KeyRound256 is
    Port(
        subkey: in STD_LOGIC_VECTOR(255 downto 0);
        round_const: in STD_LOGIC_VECTOR(7 downto 0);
        next_subkey: out STD_LOGIC_VECTOR(255 downto 0)
    );
end KeyRound256;

architecture Behavioral of KeyRound256 is
    component sbox
        Port(
		INPUT_BYTE: in STD_LOGIC_VECTOR(7 downto 0);
		OUTPUT_BYTE: out STD_LOGIC_VECTOR(7 downto 0)
	);
    end component;
    
    signal sub:STD_LOGIC_VECTOR(31 downto 0);
    signal shift:STD_LOGIC_VECTOR(31 downto 0);
    signal w0,w1,w2,w3,w3_temp,w4,w5,w6,w7,w8:STD_LOGIC_VECTOR(31 downto 0);
begin
    box_gen:for i in 0 to 3 generate--transform
        box_inst:sbox
        port map(
            INPUT_BYTE=>subkey((i + 1)*8 - 1 downto i*8),
            OUTPUT_BYTE=>sub((i + 1)*8 - 1 downto (i)*8)
        );
    end generate;

    shift<=sub(23 downto 0) & sub(31 downto 24);
    w7(23 downto 0)<=shift(23 downto 0);
    w7(31 downto 24)<=round_const xor shift(31 downto 24);
    
    w0<=subkey(255 downto 224) xor w7;
    w1<=subkey(223 downto 192) xor w0;
    w2<=subkey(191 downto 160) xor w1;
    w3<=subkey(159 downto 128) xor w2;
    
    box_w3:for i in 0 to 3 generate
        w3_inst:sbox
        port map(
            INPUT_BYTE=>w3((i + 1)*8 - 1 downto i*8),
            OUTPUT_BYTE=>w3_temp((i + 1)*8 - 1 downto (i)*8)
        );
    end generate;
    
    w4<=subkey(127 downto 96) xor w3_temp;
    w5<=subkey(95 downto 64) xor w4;
    w6<=subkey(63 downto 32) xor w5;
    w8<=subkey(31 downto 0) xor w6;
    
    next_subkey<=w0 & w1 & w2 & w3 & w4 & w5 & w6 & w8;

end Behavioral;
