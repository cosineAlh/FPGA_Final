--------------------------------------------

-- controller for rounds for 256 bits

--------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library work;
use work.functions.ALL;

entity Controller256 is
    Port(
        CLK: in STD_LOGIC;
        RST: in STD_LOGIC;
        RCONST: out STD_LOGIC_VECTOR(7 downto 0);
        FINAL_ROUND: out STD_LOGIC;
        DONE: out STD_LOGIC
    );
end Controller256;

architecture Behavioral of Controller256 is
    component Reg
        GENERIC(SIZE:positive);
        Port(
            CLK: in STD_LOGIC;
            D: in STD_LOGIC_VECTOR(SIZE-1 downto 0);
            Q: out STD_LOGIC_VECTOR(SIZE-1 downto 0)
        );
    end component;
    
    signal reg_in: STD_LOGIC_VECTOR(7 downto 0);
    signal reg_out: STD_LOGIC_VECTOR(7 downto 0);
    signal feedback: STD_LOGIC_VECTOR(7 downto 0);
begin
    reg_in<=x"01" when RST='0' else feedback;
    reg_inst:Reg generic map(SIZE=>8)
            port map(CLK=>CLK,D=>reg_in,Q=>reg_out);

    feedback<=mul_2(reg_out);
    RCONST<=reg_out;
    FINAL_ROUND<='1' when reg_out=x"4d" else '0';
    DONE<='1' when reg_out=x"9a" else '0';
end Behavioral;