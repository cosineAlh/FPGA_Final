--------------------------------------------

-- Common Round

--------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FirstRound is
    Port ( round_in : in STD_LOGIC_VECTOR (127 downto 0);
           round_key: in std_logic_vector(127 downto 0);
           round_out : out STD_LOGIC_VECTOR (127 downto 0)
           );
end FirstRound;

architecture Behavioral of FirstRound is
    component InvSubByte
        Port(
            STATE_IN: in STD_LOGIC_VECTOR(127 downto 0);
            STATE_OUT: out STD_LOGIC_VECTOR(127 downto 0)
        );
    end component;

    component InvShiftRows
        Port(
            STATE_IN: in STD_LOGIC_VECTOR(127 downto 0);
            STATE_OUT: out STD_LOGIC_VECTOR(127 downto 0)
        );
    end component;

    component InvMixColumns
        Port(
            STATE_IN: in STD_LOGIC_VECTOR(127 downto 0);
            STATE_OUT: out STD_LOGIC_VECTOR(127 downto 0)
        );
    end component;

    component AddRoundKey
        Port(
            STATE_IN: in STD_LOGIC_VECTOR(127 downto 0);
            STATE_OUT: out STD_LOGIC_VECTOR(127 downto 0);
            KEY: in STD_LOGIC_VECTOR(127 downto 0)
        );
    end component;
    
    signal s1,s2,s3:std_logic_vector(127 downto 0);
begin
    Sft:InvShiftRows port map(STATE_IN=>round_in,STATE_OUT=>s1);
    Sub:InvSubByte port map(STATE_IN=>s1,STATE_OUT=>s2);
    Adk:AddRoundKey port map(STATE_IN=>s2,STATE_OUT=>s3,KEY=>round_key);
    Mx:InvMixColumns port map(STATE_IN=>s3,STATE_OUT=>round_out);    
end Behavioral;