--------------------------------------------

-- key generator for 256 bits(encryption)

--------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Key256 is
    Port(
        CLK:in STD_LOGIC;
        RST:in STD_LOGIC;
        KEY:in STD_LOGIC_VECTOR(255 downto 0);
        ROUND_CONST: in STD_LOGIC_VECTOR(7 downto 0);
        ROUND_KEY: out STD_LOGIC_VECTOR(127 downto 0)
    );
end Key256;

architecture Behavioral of Key256 is
    component Reg
        GENERIC(SIZE:positive);
        Port(
            CLK: in STD_LOGIC;
            D: in STD_LOGIC_VECTOR(SIZE-1 downto 0);
            Q: out STD_LOGIC_VECTOR(SIZE-1 downto 0)
        );
    end component;
    
    component KeyRound256
        Port(
        subkey: in STD_LOGIC_VECTOR(255 downto 0);
        round_const: in STD_LOGIC_VECTOR(7 downto 0);
        next_subkey: out STD_LOGIC_VECTOR(255 downto 0)
    );
    end component;
    
    signal feedback:STD_LOGIC_VECTOR(255 downto 0);
    signal reg_in:STD_LOGIC_VECTOR(255 downto 0);
    signal reg_out:STD_LOGIC_VECTOR(255 downto 0);
    signal temp:STD_LOGIC_VECTOR(255 downto 0);
    signal word_temp:STD_LOGIC_VECTOR(256*17-1 downto 0);
    signal kreg_in:STD_LOGIC_VECTOR(127 downto 0);
    signal kreg_out:STD_LOGIC_VECTOR(127 downto 0);
    signal counter:integer:=0;
begin
    process(CLK,RST)--counter
    begin
        if RST='0' then
            counter<=0;
        end if;
        if(rising_edge(CLK)and RST='1')then
            counter<=counter+1;
        end if;
    end process;
    
    reg_in <= KEY when RST = '0' else feedback;
    temp<=KEY when RST = '0' else feedback;
    word_temp(256*(17-counter)-1 downto 256*(17-counter-1))<=temp;-- a shift register
    
    reg_inst:Reg generic map(SIZE=>256)
    port map(CLK=>CLK,D=>reg_in,Q=>reg_out);--register for next key
    
    kreg_in<=word_temp(256*17-1-128*(counter) downto 256*17-128*(counter+1));
    
    kreg_inst:Reg generic map(SIZE=>128)
    port map(CLK=>CLK,D=>kreg_in,Q=>kreg_out);--register for round key

    key_round:KeyRound256
    port map(subkey=>reg_out,round_const=>ROUND_CONST,next_subkey=>feedback);
    
    ROUND_KEY<=kreg_out;
end Behavioral;
