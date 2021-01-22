--------------------------------------------

-- some useful funcitons

--------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package functions is    
    function mul_2 (x:std_logic_vector(7 downto 0)) return std_logic_vector;
    function mtpe (x:std_logic_vector(7 downto 0)) return std_logic_vector;
    function mtpb (x:std_logic_vector(7 downto 0)) return std_logic_vector;
    function mtpd (x:std_logic_vector(7 downto 0)) return std_logic_vector;
    function mtp9 (x:std_logic_vector(7 downto 0)) return std_logic_vector;
end functions;

package body functions is

-------multiply 2 for binary numbers
function mul_2 (x : std_logic_vector(7 downto 0)) return std_logic_vector is
    variable i : std_logic_vector(7 downto 0);
begin
    if x(7)='0' then
        i:=x(6 downto 0)&"0";
    else
        i:=(x(6 downto 0)&"0") xor "00011011";
    end if;
    return i;
end function;

function mtpe (x:std_logic_vector(7 downto 0)) return std_logic_vector is
begin
    return mul_2(mul_2(mul_2(x))) xor mul_2(mul_2(x)) xor mul_2(x);
end function;

function mtpb (x:std_logic_vector(7 downto 0)) return std_logic_vector is
begin
    return mul_2(mul_2(mul_2(x))) xor mul_2(x) xor x;
end function;

function mtpd (x:std_logic_vector(7 downto 0)) return std_logic_vector is
begin
    return mul_2(mul_2(mul_2(x))) xor mul_2(mul_2(x)) xor x;
end function;

function mtp9 (x:std_logic_vector(7 downto 0)) return std_logic_vector is
begin
    return mul_2(mul_2(mul_2(x))) xor x;
end function;

end package body functions;
