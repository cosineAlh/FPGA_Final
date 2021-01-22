--------------------------------------------

-- key generator for 128 bits(encryption)

--------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Key128 is
    Port(
        CLK:in STD_LOGIC;
        RST:in STD_LOGIC;
        KEY:in STD_LOGIC_VECTOR(127 downto 0);
        ROUND_CONST: in STD_LOGIC_VECTOR(7 downto 0);
        ROUND_KEY: out STD_LOGIC_VECTOR(127 downto 0)
    );
end Key128;

architecture Behavioral of Key128 is
    component Reg
        GENERIC(SIZE:positive);
        Port(
            CLK: in STD_LOGIC;
            D: in STD_LOGIC_VECTOR(SIZE-1 downto 0);
            Q: out STD_LOGIC_VECTOR(SIZE-1 downto 0)
        );
    end component;
    
    component KeyRound128
        Port(
        subkey: in STD_LOGIC_VECTOR(127 downto 0);
        round_const: in STD_LOGIC_VECTOR(7 downto 0);
        next_subkey: out STD_LOGIC_VECTOR(127 downto 0)
    );
    end component;
    
    signal feedback:STD_LOGIC_VECTOR(127 downto 0);
    signal reg_in:STD_LOGIC_VECTOR(127 downto 0);
    signal reg_out:STD_LOGIC_VECTOR(127 downto 0);
begin
    -------pipeline registers----------
    reg_in <= KEY when RST = '0' else feedback;

    reg_inst:Reg generic map(SIZE=>128)
    port map(CLK=>CLK,D=>reg_in,Q=>reg_out);
    
    --------get keys--------
    key_round:KeyRound128
    port map(subkey=>reg_out,round_const=>ROUND_CONST,next_subkey=>feedback);

    ROUND_KEY<=reg_out;
end Behavioral;
