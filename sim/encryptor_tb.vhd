--------------------------------------------

-- testbench of encryptor

--------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

entity encryptor_tb is
    generic(
            N128:integer:=128;
            N192:integer:=192;
            N256:integer:=256);
end encryptor_tb;

architecture Behavioral of encryptor_tb is
    component AESEncryptor
        generic(N:integer);
        Port(
            CLK: in STD_LOGIC;
            RST: in STD_LOGIC;
            INPUT_TEX: in STD_LOGIC_VECTOR(127 downto 0);
            KEY: in STD_LOGIC_VECTOR(N-1 downto 0);
            OUTPUT_TEX: out STD_LOGIC_VECTOR(127 downto 0);
            DONE: out STD_LOGIC
        );
    end component;

    signal CLK128: STD_LOGIC:='0';----clock
    signal CLK192: STD_LOGIC:='0';
    signal CLK256: STD_LOGIC:='0';
    signal RST128: STD_LOGIC:='0';----reset
    signal RST192: STD_LOGIC:='0';
    signal RST256: STD_LOGIC:='0';
    signal DONE128: STD_LOGIC:='0';----done
    signal DONE192: STD_LOGIC:='0';
    signal DONE256: STD_LOGIC:='0';
    signal INPUT_TEX128: STD_LOGIC_VECTOR(127 downto 0):=(others=>'0');
    signal OUTPUT_TEX128: STD_LOGIC_VECTOR(127 downto 0):=(others=>'0');
    signal INPUT_TEX192: STD_LOGIC_VECTOR(127 downto 0):=(others=>'0');
    signal OUTPUT_TEX192: STD_LOGIC_VECTOR(127 downto 0):=(others=>'0');
    signal INPUT_TEX256: STD_LOGIC_VECTOR(127 downto 0):=(others=>'0');
    signal OUTPUT_TEX256: STD_LOGIC_VECTOR(127 downto 0):=(others=>'0');
    signal KEY128: STD_LOGIC_VECTOR(N128-1 downto 0):=(others=>'0');
    signal KEY192: STD_LOGIC_VECTOR(N192-1 downto 0):=(others=>'0');
    signal KEY256: STD_LOGIC_VECTOR(N256-1 downto 0):=(others=>'0');
    signal flag128:STD_LOGIC:='0';----process finished flag
    signal flag192:STD_LOGIC:='0';
    signal flag256:STD_LOGIC:='0';
    signal over128:STD_LOGIC:='0';----process over flag
    signal over192:STD_LOGIC:='0';
    signal over256:STD_LOGIC:='0';

begin
    aes128: AESEncryptor generic map(N=>N128) port map(CLK=>CLK128,RST=>RST128,DONE=>DONE128,INPUT_TEX=>INPUT_TEX128,OUTPUT_TEX=>OUTPUT_TEX128,KEY=>KEY128);
    aes192: AESEncryptor generic map(N=>N192) port map(CLK=>CLK192,RST=>RST192,DONE=>DONE192,INPUT_TEX=>INPUT_TEX192,OUTPUT_TEX=>OUTPUT_TEX192,KEY=>KEY192);
    aes256: AESEncryptor generic map(N=>N256) port map(CLK=>CLK256,RST=>RST256,DONE=>DONE256,INPUT_TEX=>INPUT_TEX256,OUTPUT_TEX=>OUTPUT_TEX256,KEY=>KEY256);

    clk128_generator:process
    begin
	while flag128='0'loop----when process is over, clock stop
            CLK128<='1';
            wait for 5 ns;
            CLK128<='0';
            wait for 5 ns;
	end loop;
	wait;----stop and wait for other processes
    end process;
    
    clk192_generator:process
    begin
        while flag192='0'loop
            CLK192<='1';
            wait for 5 ns;
            CLK192<='0';
            wait for 5 ns;
        end loop;
        wait;
    end process;
    
    clk256_generator:process
    begin
        while flag256='0'loop
            CLK256<='1';
            wait for 5 ns;
            CLK256<='0';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    --------------128 bits----------------
    process---read
        file F1: TEXT open READ_MODE is "./sim/input_128.txt";
        variable r1: LINE;
        variable Plain128: STD_LOGIC_VECTOR(127 downto 0);
        variable INPUT_KEY128: STD_LOGIC_VECTOR(N128-1 downto 0);
    begin
        wait until rising_edge(CLK128);
        while not ENDFILE(F1) loop
            readline(F1,r1);
            read(r1,Plain128);
            read(r1,INPUT_KEY128);
            
            INPUT_TEX128<=Plain128;
            KEY128<=INPUT_KEY128;
           
            RST128<='0';
            wait for 10 ns;
            RST128<='1';
            wait until DONE128='1';------wait for done
        end loop;
        flag128<='1';-----when read over, process finished flag is up
        file_close(F1);---close file
        wait;---waiting for other processes
    end process;
    
    process---write
        file O1: TEXT open WRITE_MODE is "./sim/output_128.txt";
        variable w1: LINE;
    begin
        wait until rising_edge(CLK128);
        while flag128='0' loop---while process is not over
            wait until DONE128='1';---wait for done, begin to write
            wait for 10 ns;
            WRITE(w1,OUTPUT_TEX128);
            writeline(O1,w1);
        end loop;
        file_close(O1);---close file
	over128<='1';
        wait;---waiting for other processes
    end process;    
    
    ------------192 bits---------------------
    process
        file F2: TEXT open READ_MODE is "./sim/input_192.txt";
        variable r2: LINE;
        variable Plain192: STD_LOGIC_VECTOR(127 downto 0);
        variable INPUT_KEY192: STD_LOGIC_VECTOR(N192-1 downto 0);
    begin
        wait until rising_edge(CLK192);
        while not ENDFILE(F2) loop
            readline(F2,r2);
            read(r2,Plain192);
            read(r2,INPUT_KEY192);
            
            INPUT_TEX192<=Plain192;
            KEY192<=INPUT_KEY192;
            
            RST192<='0';
            wait for 10 ns;
            RST192<='1'; 
            wait until DONE192='1';
        end loop;
        file_close(F2);
        flag192<='1';
        wait;
    end process;
    
    process
        file O2: TEXT open WRITE_MODE is "./sim/output_192.txt";
        variable w2: LINE;
    begin
        wait until rising_edge(CLK192);
        while flag192='0' loop
            wait until DONE192='1';
            wait for 10 ns;
            WRITE(w2,OUTPUT_TEX192);
            writeline(O2,w2);
        end loop;
        file_close(O2);
	over192<='1';
        wait;
    end process; 
    
    -------------256 bits-------------------------
    process
        file F3: TEXT open READ_MODE is "./sim/input_256.txt";
        variable r3: LINE;
        variable Plain256: STD_LOGIC_VECTOR(127 downto 0);
        variable INPUT_KEY256: STD_LOGIC_VECTOR(N256-1 downto 0);
    begin
        wait until rising_edge(CLK256);
        while not ENDFILE(F3) loop
            readline(F3,r3);
            read(r3,Plain256);
            read(r3,INPUT_KEY256);
            
            INPUT_TEX256<=Plain256;
            KEY256<=INPUT_KEY256;
            
            RST256<='0';
            wait for 10 ns;
            RST256<='1';
            wait until DONE256='1';
        end loop;
        file_close(F3);
        flag256<='1';
        wait;
    end process;
    
    process
        file O3: TEXT open WRITE_MODE is "./sim/output_256.txt";
        variable w3: LINE;
    begin
        wait until rising_edge(CLK256);
        while flag256='0' loop
            wait until DONE256='1';
            wait for 10 ns;
            WRITE(w3,OUTPUT_TEX256);
            writeline(O3,w3);
        end loop;
        file_close(O3);
	over256<='1';
        wait;
	--std.env.finish;
    end process; 
    
    ------------check if all the process end----------------
    process(over128,over192,over256)
    begin
        if(over128='1' and over192='1' and over256='1')then
            std.env.finish;
        end if;
    end process;
end Behavioral;
