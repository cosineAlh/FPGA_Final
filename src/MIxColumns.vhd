--------------------------------------------

-- mix columns

--------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library work;
use work.functions.ALL;

entity MixColumns is
    Port(
        STATE_IN: in STD_LOGIC_VECTOR(127 downto 0);
        STATE_OUT: out STD_LOGIC_VECTOR(127 downto 0)
    );
end MixColumns;

architecture Behavioral of MixColumns is
    type state is array(3 downto 0,3 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
    signal STATE_IN_REG: state;
    signal STATE_OUT_REG: state;
begin
-- Generate
    in_x: for i in 3 downto 0 generate
        in_y: for j in 3 downto 0 generate
            STATE_IN_REG(i,j)<=STATE_IN(((3-j)*4+(4-i))*8-1 downto ((3-j)*4+(3-i))*8);
        end generate;
    end generate;

    out_x: for i in 3 downto 0 generate
        out_y: for j in 3 downto 0 generate
        STATE_OUT(((3-j)*4+(4-i))*8-1 downto ((3-j)*4+(3-i))*8)<=STATE_OUT_REG(i,j);
        end generate;
    end generate;

    STATE_OUT_REG(0,0)<=mul_2(STATE_IN_REG(0,0)) xor (mul_2(STATE_IN_REG(1,0)) xor STATE_IN_REG(1,0)) xor STATE_IN_REG(2,0) xor STATE_IN_REG(3,0);
    STATE_OUT_REG(0,1)<=mul_2(STATE_IN_REG(0,1)) xor (mul_2(STATE_IN_REG(1,1)) xor STATE_IN_REG(1,1)) xor STATE_IN_REG(2,1) xor STATE_IN_REG(3,1);
    STATE_OUT_REG(0,2)<=mul_2(STATE_IN_REG(0,2)) xor (mul_2(STATE_IN_REG(1,2)) xor STATE_IN_REG(1,2)) xor STATE_IN_REG(2,2) xor STATE_IN_REG(3,2);
    STATE_OUT_REG(0,3)<=mul_2(STATE_IN_REG(0,3)) xor (mul_2(STATE_IN_REG(1,3)) xor STATE_IN_REG(1,3)) xor STATE_IN_REG(2,3) xor STATE_IN_REG(3,3);

    STATE_OUT_REG(1,0)<=STATE_IN_REG(0,0) xor mul_2(STATE_IN_REG(1,0)) xor (mul_2(STATE_IN_REG(2,0)) xor STATE_IN_REG(2,0)) xor STATE_IN_REG(3,0);
    STATE_OUT_REG(1,1)<=STATE_IN_REG(0,1) xor mul_2(STATE_IN_REG(1,1)) xor (mul_2(STATE_IN_REG(2,1)) xor STATE_IN_REG(2,1)) xor STATE_IN_REG(3,1);
    STATE_OUT_REG(1,2)<=STATE_IN_REG(0,2) xor mul_2(STATE_IN_REG(1,2)) xor (mul_2(STATE_IN_REG(2,2)) xor STATE_IN_REG(2,2)) xor STATE_IN_REG(3,2);
    STATE_OUT_REG(1,3)<=STATE_IN_REG(0,3) xor mul_2(STATE_IN_REG(1,3)) xor (mul_2(STATE_IN_REG(2,3)) xor STATE_IN_REG(2,3)) xor STATE_IN_REG(3,3);

    STATE_OUT_REG(2,0)<=STATE_IN_REG(0,0) xor STATE_IN_REG(1,0) xor mul_2(STATE_IN_REG(2,0)) xor (mul_2(STATE_IN_REG(3,0)) xor STATE_IN_REG(3,0));
    STATE_OUT_REG(2,1)<=STATE_IN_REG(0,1) xor STATE_IN_REG(1,1) xor mul_2(STATE_IN_REG(2,1)) xor (mul_2(STATE_IN_REG(3,1)) xor STATE_IN_REG(3,1));
    STATE_OUT_REG(2,2)<=STATE_IN_REG(0,2) xor STATE_IN_REG(1,2) xor mul_2(STATE_IN_REG(2,2)) xor (mul_2(STATE_IN_REG(3,2)) xor STATE_IN_REG(3,2));
    STATE_OUT_REG(2,3)<=STATE_IN_REG(0,3) xor STATE_IN_REG(1,3) xor mul_2(STATE_IN_REG(2,3)) xor (mul_2(STATE_IN_REG(3,3)) xor STATE_IN_REG(3,3));

    STATE_OUT_REG(3,0)<=(mul_2(STATE_IN_REG(0,0)) xor STATE_IN_REG(0,0)) xor STATE_IN_REG(1,0) xor STATE_IN_REG(2,0) xor mul_2(STATE_IN_REG(3,0));
    STATE_OUT_REG(3,1)<=(mul_2(STATE_IN_REG(0,1)) xor STATE_IN_REG(0,1)) xor STATE_IN_REG(1,1) xor STATE_IN_REG(2,1) xor mul_2(STATE_IN_REG(3,1));
    STATE_OUT_REG(3,2)<=(mul_2(STATE_IN_REG(0,2)) xor STATE_IN_REG(0,2)) xor STATE_IN_REG(1,2) xor STATE_IN_REG(2,2) xor mul_2(STATE_IN_REG(3,2));
    STATE_OUT_REG(3,3)<=(mul_2(STATE_IN_REG(0,3)) xor STATE_IN_REG(0,3)) xor STATE_IN_REG(1,3) xor STATE_IN_REG(2,3) xor mul_2(STATE_IN_REG(3,3));
end Behavioral;