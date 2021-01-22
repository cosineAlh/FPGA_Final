--------------------------------------------

-- AES decryptor (not pipe)

--------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity AESDecryptor is
    generic(N:integer:=128);
    Port(
        CLK:in STD_LOGIC;
        RST:in STD_LOGIC;
        INPUT_TEX:in STD_LOGIC_VECTOR(127 downto 0);
        KEY:in STD_LOGIC_VECTOR(N-1 downto 0);
        OUTPUT_TEX:out STD_LOGIC_VECTOR(127 downto 0);
        DONE:out STD_LOGIC
    );
end AESDecryptor;

architecture Behavioral of AESDecryptor is
-----------components----------------------
    component FirstRound
        Port ( round_in : in STD_LOGIC_VECTOR (127 downto 0);
           round_key: in std_logic_vector(127 downto 0);
           round_out : out STD_LOGIC_VECTOR (127 downto 0)
           );
    end component;
    
    component LastRound
        Port ( round_in : in STD_LOGIC_VECTOR (127 downto 0);
               round_key : in STD_LOGIC_VECTOR (127 downto 0);
               round_out : out STD_LOGIC_VECTOR (127 downto 0)
               );
    end component;
    
    component kexp128
        port(
            key:in std_logic_vector(127 downto 0);
            k0,k1,k2,k3,k4,k5,k6,k7,k8,k9,k10: out std_logic_vector(127 downto 0)
            );
    end component;
    
    component kexp192
        port(
            key:in std_logic_vector(191 downto 0);
            k0,k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12:out std_logic_vector(127 downto 0)
            );
    end component;
    
    component kexp256
        port(
            key:in std_logic_vector(255 downto 0);
            k0,k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,k14:out std_logic_vector(127 downto 0)
            );
    end component;
    
------------signals--------------------
    signal cnt:integer:=0;
    signal s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14:std_logic_vector(127 downto 0);--states
    signal k0,k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,k14:std_logic_vector(127 downto 0);--keys
    
begin
-----------decryption for 128 bits--------------
--------need to set keys in the inverse order of encryption-----
    aes128:if N=128 generate
        s0<=INPUT_TEX xor k10;
        Round1:FirstRound port map(round_in=>s0,round_out=>s1,round_key=>k9);
        Round2:FirstRound port map(round_in=>s1,round_out=>s2,round_key=>k8);
        Round3:FirstRound port map(round_in=>s2,round_out=>s3,round_key=>k7);
        Round4:FirstRound port map(round_in=>s3,round_out=>s4,round_key=>k6);
        Round5:FirstRound port map(round_in=>s4,round_out=>s5,round_key=>k5);
        Round6:FirstRound port map(round_in=>s5,round_out=>s6,round_key=>k4);
        Round7:FirstRound port map(round_in=>s6,round_out=>s7,round_key=>k3);
        Round8:FirstRound port map(round_in=>s7,round_out=>s8,round_key=>k2);
        Round9:FirstRound port map(round_in=>s8,round_out=>s9,round_key=>k1);
        Round10:LastRound port map(round_in=>s9,round_out=>s10,round_key=>k0);--the last round is different from others
        Key128:kexp128 port map(key=>key,k0=>k0,k1=>k1,k2=>k2,k3=>k3,k4=>k4,k5=>k5,k6=>k6,k7=>k7,k8=>k8,k9=>k9,k10=>k10);
        process(CLK,RST)
        begin
            if RST='0' then
                OUTPUT_TEX<=(others=>'0');
                DONE<='0';
                cnt<=0;
            elsif rising_edge(CLK) then
                cnt<=cnt+1;
                if cnt=1 then
                    DONE<='1';
                    cnt<=0;
                    OUTPUT_TEX<=s10;
                end if;
            end if;
        end process;
    end generate;
    
-----------decryption for 192 bits--------------
    aes192:if N=192 generate
        s0<=INPUT_TEX xor k12;
        Round1:FirstRound port map(round_in=>s0,round_out=>s1,round_key=>k11);
        Round2:FirstRound port map(round_in=>s1,round_out=>s2,round_key=>k10);
        Round3:FirstRound port map(round_in=>s2,round_out=>s3,round_key=>k9);
        Round4:FirstRound port map(round_in=>s3,round_out=>s4,round_key=>k8);
        Round5:FirstRound port map(round_in=>s4,round_out=>s5,round_key=>k7);
        Round6:FirstRound port map(round_in=>s5,round_out=>s6,round_key=>k6);
        Round7:FirstRound port map(round_in=>s6,round_out=>s7,round_key=>k5);
        Round8:FirstRound port map(round_in=>s7,round_out=>s8,round_key=>k4);
        Round9:FirstRound port map(round_in=>s8,round_out=>s9,round_key=>k3);
        Round10:FirstRound port map(round_in=>s9,round_out=>s10,round_key=>k2);
        Round11:FirstRound port map(round_in=>s10,round_out=>s11,round_key=>k1);
        Round12:LastRound port map(round_in=>s11,round_out=>s12,round_key=>k0);
        Key192:kexp192 port map(key=>key,k0=>k0,k1=>k1,k2=>k2,k3=>k3,k4=>k4,k5=>k5,
                k6=>k6,k7=>k7,k8=>k8,k9=>k9,k10=>k10,k11=>k11,k12=>k12);
        process(CLK,RST)
        begin
            if RST='0' then
                OUTPUT_TEX<=(others=>'0');
                DONE<='0';
                cnt<=0;
            elsif rising_edge(CLK) then
                cnt<=cnt+1;
                if cnt=1 then
                    DONE<='1';
                    cnt<=0;
                    OUTPUT_TEX<=s12;
                end if;
            end if;
        end process;
    end generate;
    
-----------decryption for 256 bits--------------
    aes256:if N=256 generate
        s0<=INPUT_TEX xor k14;
        Round1:FirstRound port map(round_in=>s0,round_out=>s1,round_key=>k13);
        Round2:FirstRound port map(round_in=>s1,round_out=>s2,round_key=>k12);
        Round3:FirstRound port map(round_in=>s2,round_out=>s3,round_key=>k11);
        Round4:FirstRound port map(round_in=>s3,round_out=>s4,round_key=>k10);
        Round5:FirstRound port map(round_in=>s4,round_out=>s5,round_key=>k9);
        Round6:FirstRound port map(round_in=>s5,round_out=>s6,round_key=>k8);
        Round7:FirstRound port map(round_in=>s6,round_out=>s7,round_key=>k7);
        Round8:FirstRound port map(round_in=>s7,round_out=>s8,round_key=>k6);
        Round9:FirstRound port map(round_in=>s8,round_out=>s9,round_key=>k5);
        Round10:FirstRound port map(round_in=>s9,round_out=>s10,round_key=>k4);
        Round11:FirstRound port map(round_in=>s10,round_out=>s11,round_key=>k3);
        Round12:FirstRound port map(round_in=>s11,round_out=>s12,round_key=>k2);
        Round13:FirstRound port map(round_in=>s12,round_out=>s13,round_key=>k1);
        Round14:LastRound port map(round_in=>s13,round_out=>s14,round_key=>k0);
        Key256:kexp256 port map(key=>key,k0=>k0,k1=>k1,k2=>k2,k3=>k3,k4=>k4,k5=>k5,
            k6=>k6,k7=>k7,k8=>k8,k9=>k9,k10=>k10,k11=>k11,k12=>k12,k13=>k13,k14=>k14);
        process(CLK,RST)
        begin
            if RST='0' then
                OUTPUT_TEX<=(others=>'0');
                DONE<='0';
                cnt<=0;
            elsif rising_edge(CLK) then
                cnt<=cnt+1;
                if cnt=1 then
                    DONE<='1';
                    cnt<=0;
                    OUTPUT_TEX<=s14;
                end if;
            end if;
        end process;
    end generate;
    
end Behavioral;
