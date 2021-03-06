-----------------------------------------------------------------------------------
-- GPR
-- contains all 32 general purpose registers that can be written to as well as read
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registerfile is
    port(
	 clk: in std_logic;
    readreg1: in std_logic_vector(4 downto 0);
    readreg2: in std_logic_vector(4 downto 0);
    writereg: in std_logic_vector(4 downto 0);
    writedata: in std_logic_vector(31 downto 0);
    regwrite: in std_logic;
    A: out std_logic_vector(31 downto 0);
    B: out std_logic_vector(31 downto 0)
    );
    
--  Port ( );
end registerfile;

architecture Behavioral of registerfile is --contains 32 registers
    signal R0 : std_logic_vector(31 downto 0);
    signal R1 : std_logic_vector(31 downto 0);
    signal R2 : std_logic_vector(31 downto 0);
    signal R3 : std_logic_vector(31 downto 0);
    signal R4 : std_logic_vector(31 downto 0);
    signal R5 : std_logic_vector(31 downto 0);
    signal R6 : std_logic_vector(31 downto 0);
    signal R7 : std_logic_vector(31 downto 0);
    signal R8 : std_logic_vector(31 downto 0);
    signal R9 : std_logic_vector(31 downto 0);
    signal R10 : std_logic_vector(31 downto 0);
    signal R11: std_logic_vector(31 downto 0);
    signal R12 : std_logic_vector(31 downto 0);
    signal R13 : std_logic_vector(31 downto 0);
    signal R14 : std_logic_vector(31 downto 0);
    signal R15 : std_logic_vector(31 downto 0);
    signal R16 : std_logic_vector(31 downto 0);
    signal R17 : std_logic_vector(31 downto 0);
    signal R18 : std_logic_vector(31 downto 0);
    signal R19 : std_logic_vector(31 downto 0);
    signal R20 : std_logic_vector(31 downto 0);
    signal R21 : std_logic_vector(31 downto 0);
    signal R22 : std_logic_vector(31 downto 0);
    signal R23 : std_logic_vector(31 downto 0);
    signal R24 : std_logic_vector(31 downto 0);
    signal R25 : std_logic_vector(31 downto 0);
    signal R26 : std_logic_vector(31 downto 0);
    signal R27 : std_logic_vector(31 downto 0);
    signal R28 : std_logic_vector(31 downto 0);
    signal R29 : std_logic_vector(31 downto 0);
    signal R30 : std_logic_vector(31 downto 0);
    signal R31 : std_logic_vector(31 downto 0);
begin
--R0 and R1 are constant values
R0<="00000000000000000000000000000000";
R1<="00000000000000000000000000000001";
process(readreg1, readreg2, regwrite)
begin
--gets the value for the A input for the ALU
case readreg1 is 
    when "00000"=> A<=R0;
    when "00001"=> A<=R1;
    when "00010"=> A<=R2;
    when "00011"=> A<=R3;
    when "00100"=> A<=R4;
    when "00101"=> A<=R5;
    when "00110" =>A<=R6;
    when "00111"=> A<=R7;
    when "01000"=> A<=R8;
    when "01001"=> A<=R9;
    when "01010"=> A<=R10;
    when "01011"=> A<=R11;
    when "01100"=> A<=R12;
    when "01101"=> A<=R13;
    when "01110"=> A<=R14;
    when "01111"=> A<=R15;
    when "10000"=> A<=R16;
    when "10001"=> A<=R17;
    when "10010"=> A<=R18;
    when "10011"=> A<=R19;
    when "10100"=> A<=R20;
    when "10101"=> A<=R21;
    when "10110"=> A<=R22;
    when "10111"=> A<=R23;
    when "11000"=> A<=R24;
    when "11001"=> A<=R25;
    when "11010"=> A<=R26;
    when "11011"=> A<=R27;
    when "11100"=> A<=R28;
    when "11101"=> A<=R29;
    when "11110"=> A<=R30;
    when "11111"=> A<=R31;
    when others =>
end case;
-- gets the value for the B input of the ALU
case readreg2 is 
        when "00000"=> B<=R0;
        when "00001"=> B<=R1;
        when "00010"=> B<=R2;
        when "00011"=> B<=R3;
        when "00100"=> B<=R4;
        when "00101"=> B<=R5;
        when "00110"=> B<=R6;
        when "00111"=> B<=R7;
        when "01000"=> B<=R8;
        when "01001"=> B<=R9;
        when "01010"=> B<=R10;
        when "01011"=> B<=R11;
        when "01100"=> B<=R12;
        when "01101"=> B<=R13;
        when "01110"=> B<=R14;
        when "01111"=> B<=R15;
        when "10000"=> B<=R16;
        when "10001"=> B<=R17;
        when "10010"=> B<=R18;
        when "10011"=> B<=R19;
        when "10100"=> B<=R20;
        when "10101"=> B<=R21;
        when "10110"=> B<=R22;
        when "10111"=> B<=R23;
        when "11000"=> B<=R24;
        when "11001"=> B<=R25;
        when "11010"=> B<=R26;
        when "11011"=> B<=R27;
        when "11100"=> B<=R28;
        when "11101"=> B<=R29;
        when "11110"=> B<=R30;
        when "11111"=> B<=R31;
        when others =>
    end case;
end process;

process(writereg, regwrite, writedata, clk)
begin 
--synchronous write to the GPRs
if (regwrite='1' and clk' event and clk='1') then
case writereg is 
    when "00010"=> R2<=writedata;
    when "00011"=> R3<=writedata;
    when "00100"=> R4<=writedata;
    when "00101"=> R5<=writedata;
    when "00110"=> R6<=writedata;
    when "00111"=> R7<=writedata;
    when "01000"=> R8<=writedata;
    when "01001"=> R9<=writedata;
    when "01010"=> R10<=writedata;
    when "01011"=> R11<=writedata;
    when "01100"=> R12<=writedata;
    when "01101"=> R13<=writedata;
    when "01110"=> R14<=writedata;
    when "01111"=> R15<=writedata;
    when "10000"=> R16<=writedata;
    when "10001"=> R17<=writedata;
    when "10010"=> R18<=writedata;
    when "10011"=> R19<=writedata;
    when "10100"=> R20<=writedata;
    when "10101"=> R21<=writedata;
    when "10110"=> R22<=writedata;
    when "10111"=> R23<=writedata;
    when "11000"=> R24<=writedata;
    when "11001"=> R25<=writedata;
    when "11010"=> R26<=writedata;
    when "11011"=> R27<=writedata;
    when "11100"=> R28<=writedata;
    when "11101"=> R29<=writedata;
    when "11110"=> R30<=writedata;
    when "11111"=> R31<=writedata;
    when others => 
end case;
end if;
end process;
end Behavioral;
