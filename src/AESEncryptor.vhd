--------------------------------------------

-- AES encryptor(pipeline)

--------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity AESEncryptor is
    generic(N:integer);
    Port(
        CLK:in STD_LOGIC;
        RST:in STD_LOGIC;
        INPUT_TEX:in STD_LOGIC_VECTOR(127 downto 0);
        KEY:in STD_LOGIC_VECTOR(N-1 downto 0);
        OUTPUT_TEX:out STD_LOGIC_VECTOR(127 downto 0);
        DONE:out STD_LOGIC
    );
end AESEncryptor;

architecture Behavioral of AESEncryptor is
------------components-----------------
    component SubByte
        Port(
            STATE_IN: in STD_LOGIC_VECTOR(127 downto 0);
            STATE_OUT: out STD_LOGIC_VECTOR(127 downto 0)
        );
    end component;

    component ShiftRows
        Port(
            STATE_IN: in STD_LOGIC_VECTOR(127 downto 0);
            STATE_OUT: out STD_LOGIC_VECTOR(127 downto 0)
        );
    end component;

    component MixColumns
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

    component Reg
        GENERIC(SIZE:positive);
        Port(
            CLK: in STD_LOGIC;
            D: in STD_LOGIC_VECTOR(SIZE-1 downto 0);
            Q: out STD_LOGIC_VECTOR(SIZE-1 downto 0)
        );
    end component;

    component Key128
        Port(
            CLK:in STD_LOGIC;
            RST:in STD_LOGIC;
            KEY:in STD_LOGIC_VECTOR(127 downto 0);
            ROUND_CONST: in STD_LOGIC_VECTOR(7 downto 0);
            ROUND_KEY: out STD_LOGIC_VECTOR(127 downto 0)
        );
    end component;
    
    component Key192
        Port(
            CLK:in STD_LOGIC;
            RST:in STD_LOGIC;
            KEY:in STD_LOGIC_VECTOR(191 downto 0);
            ROUND_CONST: in STD_LOGIC_VECTOR(7 downto 0);
            ROUND_KEY: out STD_LOGIC_VECTOR(127 downto 0)
        );
    end component;
    
    component Key256
        Port(
            CLK:in STD_LOGIC;
            RST:in STD_LOGIC;
            KEY:in STD_LOGIC_VECTOR(255 downto 0);
            ROUND_CONST: in STD_LOGIC_VECTOR(7 downto 0);
            ROUND_KEY: out STD_LOGIC_VECTOR(127 downto 0)
        );
    end component;
    
    component Controller
        Port(
        CLK: in STD_LOGIC;
        RST: in STD_LOGIC;
        RCONST: out STD_LOGIC_VECTOR(7 downto 0);
        FINAL_ROUND: out STD_LOGIC;
        DONE: out STD_LOGIC
        );
    end component;
    
    component Controller192
        Port(
        CLK: in STD_LOGIC;
        RST: in STD_LOGIC;
        RCONST: out STD_LOGIC_VECTOR(7 downto 0);
        FINAL_ROUND: out STD_LOGIC;
        DONE: out STD_LOGIC
        );
    end component;
    
    component Controller256
        Port(
        CLK: in STD_LOGIC;
        RST: in STD_LOGIC;
        RCONST: out STD_LOGIC_VECTOR(7 downto 0);
        FINAL_ROUND: out STD_LOGIC;
        DONE: out STD_LOGIC
        );
    end component;

-------------signals-----------------
    signal reg_in:STD_LOGIC_VECTOR(127 downto 0);--input of register
    signal reg_out:STD_LOGIC_VECTOR(127 downto 0);--output of register
    signal feedback:STD_LOGIC_VECTOR(127 downto 0);--feedback to the register
    signal round_key:STD_LOGIC_VECTOR(127 downto 0);--round keys
    signal sub_in:STD_LOGIC_VECTOR(127 downto 0);--input of subbyte also the output text
    signal sub_out:STD_LOGIC_VECTOR(127 downto 0);--output of subbyte
    signal mix_out:STD_LOGIC_VECTOR(127 downto 0);--output of mixcolumn
    signal shift_out:STD_LOGIC_VECTOR(127 downto 0);--output of shiftrows
    signal round_const:STD_LOGIC_VECTOR(7 downto 0);--round const
    signal sel:STD_LOGIC;--determind if it is the last round
begin
    ----- plaintext read in
    reg_in <= INPUT_TEX when RST = '0' else feedback;
    reg_inst:Reg generic map(SIZE=>128)
            port map(CLK=>CLK,D=>reg_in,Q=>reg_out);

    ----- Encryption
    addroundkey_inst:AddRoundKey port map(STATE_IN=>reg_out,KEY=>round_key,STATE_OUT=>sub_in);
    subbyte_inst:SubByte port map(STATE_IN=>sub_in,STATE_OUT=>sub_out);
    shift_inst:ShiftRows port map(STATE_IN=>sub_out,STATE_OUT=>shift_out);
    mix_inst:MixColumns port map(STATE_IN=>shift_out,STATE_OUT=>mix_out);

    feedback<=mix_out when sel='0' else shift_out;
    OUTPUT_TEX<=sub_in;
    
    ----- Key expansion for 128 bits
    key_expan128:if N=128 generate
        contro128:Controller port map(CLK=>CLK,RST=>RST,RCONST=>round_const,FINAL_ROUND=>sel,DONE=>DONE);
        key_sche_128:key128 port map(CLK=>CLK,RST=>RST,KEY=>KEY,ROUND_CONST=>round_const,ROUND_KEY=>round_key);
    end generate;
    
    key_expan192:if N=192 generate
        control192:Controller192 port map(CLK=>CLK,RST=>RST,RCONST=>round_const,FINAL_ROUND=>sel,DONE=>DONE);
        key_sche_192:Key192 port map(CLK=>CLK,RST=>RST,KEY=>KEY,ROUND_CONST=>round_const,ROUND_KEY=>round_key);
    end generate;
    
    key_expan256:if N=256 generate
        control256:Controller256 port map(CLK=>CLK,RST=>RST,RCONST=>round_const,FINAL_ROUND=>sel,DONE=>DONE);
        key_sche_256:Key256 port map(CLK=>CLK,RST=>RST,KEY=>KEY,ROUND_CONST=>round_const,ROUND_KEY=>round_key);
    end generate;
    
end Behavioral;
