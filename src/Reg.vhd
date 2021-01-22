--------------------------------------------

-- Register

--------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Reg is
    generic(SIZE:positive);
    Port(
        CLK: in STD_LOGIC;
        D: in STD_LOGIC_VECTOR(SIZE-1 downto 0);
        Q: out STD_LOGIC_VECTOR(SIZE-1 downto 0)
    );
end Reg;

architecture Behavioral of Reg is
    signal current_state, next_state:STD_LOGIC_VECTOR(SIZE-1 downto 0);
begin
    ----standard register
    next_state<=D;
    Process(CLK)
    begin
        if(rising_edge(CLK))then
            current_state<=next_state;
        end if;
    end process;
    Q<=current_state;
end Behavioral;
