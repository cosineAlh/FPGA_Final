--------------------------------------------

-- inverse of mix columns

--------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library work;
use work.functions.ALL;

entity InvMixColumns is
    Port(
        STATE_IN: in STD_LOGIC_VECTOR(127 downto 0);
        STATE_OUT: out STD_LOGIC_VECTOR(127 downto 0)
    );
end InvMixColumns;

architecture Behavioral of InvMixColumns is
    type state is array(3 downto 0,3 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
    signal STATE_IN_REG: state;
    signal STATE_OUT_REG: state;
begin
-- Generate state registers
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

    STATE_OUT_REG(0,0)<=mtpe(STATE_IN_REG(0,0)) xor mtpb(STATE_IN_REG(1,0)) xor mtpd(STATE_IN_REG(2,0)) xor mtp9(STATE_IN_REG(3,0));
    STATE_OUT_REG(0,1)<=mtpe(STATE_IN_REG(0,1)) xor mtpb(STATE_IN_REG(1,1)) xor mtpd(STATE_IN_REG(2,1)) xor mtp9(STATE_IN_REG(3,1));
    STATE_OUT_REG(0,2)<=mtpe(STATE_IN_REG(0,2)) xor mtpb(STATE_IN_REG(1,2)) xor mtpd(STATE_IN_REG(2,2)) xor mtp9(STATE_IN_REG(3,2));
    STATE_OUT_REG(0,3)<=mtpe(STATE_IN_REG(0,3)) xor mtpb(STATE_IN_REG(1,3)) xor mtpd(STATE_IN_REG(2,3)) xor mtp9(STATE_IN_REG(3,3));

    STATE_OUT_REG(1,0)<=mtp9(STATE_IN_REG(0,0)) xor mtpe(STATE_IN_REG(1,0)) xor mtpb(STATE_IN_REG(2,0)) xor mtpd(STATE_IN_REG(3,0));
    STATE_OUT_REG(1,1)<=mtp9(STATE_IN_REG(0,1)) xor mtpe(STATE_IN_REG(1,1)) xor mtpb(STATE_IN_REG(2,1)) xor mtpd(STATE_IN_REG(3,1));
    STATE_OUT_REG(1,2)<=mtp9(STATE_IN_REG(0,2)) xor mtpe(STATE_IN_REG(1,2)) xor mtpb(STATE_IN_REG(2,2)) xor mtpd(STATE_IN_REG(3,2));
    STATE_OUT_REG(1,3)<=mtp9(STATE_IN_REG(0,3)) xor mtpe(STATE_IN_REG(1,3)) xor mtpb(STATE_IN_REG(2,3)) xor mtpd(STATE_IN_REG(3,3));

    STATE_OUT_REG(2,0)<=mtpd(STATE_IN_REG(0,0)) xor mtp9(STATE_IN_REG(1,0)) xor mtpe(STATE_IN_REG(2,0)) xor mtpb(STATE_IN_REG(3,0));
    STATE_OUT_REG(2,1)<=mtpd(STATE_IN_REG(0,1)) xor mtp9(STATE_IN_REG(1,1)) xor mtpe(STATE_IN_REG(2,1)) xor mtpb(STATE_IN_REG(3,1));
    STATE_OUT_REG(2,2)<=mtpd(STATE_IN_REG(0,2)) xor mtp9(STATE_IN_REG(1,2)) xor mtpe(STATE_IN_REG(2,2)) xor mtpb(STATE_IN_REG(3,2));
    STATE_OUT_REG(2,3)<=mtpd(STATE_IN_REG(0,3)) xor mtp9(STATE_IN_REG(1,3)) xor mtpe(STATE_IN_REG(2,3)) xor mtpb(STATE_IN_REG(3,3));

    STATE_OUT_REG(3,0)<=mtpb(STATE_IN_REG(0,0)) xor mtpd(STATE_IN_REG(1,0)) xor mtp9(STATE_IN_REG(2,0)) xor mtpe(STATE_IN_REG(3,0));
    STATE_OUT_REG(3,1)<=mtpb(STATE_IN_REG(0,1)) xor mtpd(STATE_IN_REG(1,1)) xor mtp9(STATE_IN_REG(2,1)) xor mtpe(STATE_IN_REG(3,1));
    STATE_OUT_REG(3,2)<=mtpb(STATE_IN_REG(0,2)) xor mtpd(STATE_IN_REG(1,2)) xor mtp9(STATE_IN_REG(2,2)) xor mtpe(STATE_IN_REG(3,2));
    STATE_OUT_REG(3,3)<=mtpb(STATE_IN_REG(0,3)) xor mtpd(STATE_IN_REG(1,3)) xor mtp9(STATE_IN_REG(2,3)) xor mtpe(STATE_IN_REG(3,3));
end Behavioral;
