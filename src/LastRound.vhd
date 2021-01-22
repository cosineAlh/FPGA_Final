--------------------------------------------

-- Last Round(decryption)

--------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LastRound is
    Port ( round_in : in STD_LOGIC_VECTOR (127 downto 0);
           round_key : in STD_LOGIC_VECTOR (127 downto 0);
           round_out : out STD_LOGIC_VECTOR (127 downto 0)
           );
end LastRound;

architecture Behavioral of LastRound is
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
    --do not have mixcolumn part
    Sub:InvSubByte port map(STATE_IN=>round_in,STATE_OUT=>s1);
    Sft:InvShiftRows port map(STATE_IN=>s1,STATE_OUT=>s2);
    Adk:AddRoundKey port map(STATE_IN=>s2,STATE_OUT=>round_out,KEY=>round_key);
end Behavioral;
