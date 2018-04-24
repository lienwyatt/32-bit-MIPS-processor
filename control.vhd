-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:24:20 03/08/2018 
-- Design Name: 
-- Module Name:    control - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control is
port(
clk: in std_logic;
IR2, IR3, IR4, IR5 : in std_logic_vector(31 downto 0);
 LoadSel, Rselect, RegWrite, Asel, readWrite: out std_logic;
PCsel: out std_logic_vector(2 downto 0);
Bsel: out std_logic_vector(1 downto 0)
);
end control;

architecture Behavioral of control is
	signal opcode2, opcode3, opcode4, opcode5: std_logic_vector(5 downto 0);
	signal funct2, funct3, funct4, funct5: std_logic_vector(5 downto 0);
	signal concat3, concat4: std_logic_vector(11 downto 0);
	signal opResult1, opResult2, functResult, opAndfunct, opOrFunct, storet, stored, bchoose,B, achoose: std_logic;

	begin
	opcode2 <= IR2(31 downto 26);
	opcode3 <= IR3(31 downto 26);
	opcode4 <= IR4(31 downto 26);
	opcode5 <= IR5(31 downto 26);
	funct2 <= IR2(5 downto 0);
	funct3 <= IR3(5 downto 0);
	funct4 <= IR4(5 downto 0);
	funct5 <= IR5(5 downto 0);
    
    
    
    
	process(clk, IR4)
	begin
		---IF
		
		case opcode4 is
		when "000000" =>
		if (funct4 = "101000")  then--RIGHT?
			PCsel <="000";
		elsif (funct4 = "101001") then--RIGHT?
			PCsel<="000";
	    elsif (funct4 = "000010") then
            PCsel<="011";--jump
		end if;
		when "000001"|"000010"|"000011"|"000100"|"000101"|"000111"|"001000"=>
			PCsel <="000";
		when "111111"=>
		PCsel<="001"; --noop
		when "000001"|"000100"|"000101"=>--BLTZ, beq, bne
		     PCsel<="010";
		when others=>
		PCsel <="001";
		end case;
	end process;
		-----ID
		----EX
--		case opcode3 is
--			when "001000" | "001001" |"001010" |"001011" | "001100" | "001101" | "001110" | "001111" =>
--			Bsel <= '0';
--			when "000000" => 
--			Bsel<= '1';
--			when others =>
--		end case;
		----MEM
		----WB
--		case opcode5 is
--			when "000000" =>
--			LoadSel<= '1';
--			Rselect <= '1';
--			when "001000" | "001001" |"001010" |"001011" | "001100" |"001101" | "001110" | "001111" =>
--			LoadSel<= '1';
--			Rselect <='0';
--			when others =>
--		end case;
--	end process;
concat4<=opcode4&funct4;
process(IR4, IR3, storet, stored)
begin
    if ((IR4(20 downto 16)=IR3(20 downto 16) AND storet='1')OR(IR4(15 downto 11)=IR3(20 downto 16) AND stored='1')) then bchoose<='1';
    else bchoose<='0';
    end if;
    if ((IR4(20 downto 16)=IR3(20 downto 16) AND storet='1')OR(IR4(15 downto 11)=IR3(25 downto 21) AND stored='1')) then achoose<='1';
        else achoose<='0';
   end if;
end process;
process(B, bchoose)
begin
    if (bchoose='1')then Bsel<="11";
    elsif(B='1') then Bsel<="01";
    else Bsel<="00";
    end if;    
end process;
Asel<=achoose;
--check opcodes
	with concat4 select stored<=
	'1' when "000000100000" | "000000100001" | "000000100100" | "000000100101" | "000000000000" | "000000000100" | "000000101010" | "000000101011" | "000000000011" | "000000000010" | "000000000110" | "000000100011" | "000000100110",
	'0' when others;
--check opcodes
	with opcode4  select storet<=
	'1' when "001001" | "001100" | "100000" | "100011" | "001101" | "011010" | "001011" | "001110" |"010000",
    '0' when others;

	with concat4 select stored<=
	'1' when "000000100000" | "000000100001" | "000000100100" | "000000100101" | "000000000000" | "0000000000100" | "000000101010" | "000000101011" | "000000000011" | "000000000010" | "000000000110" | "000000100011" | "000000100110",
	'0' when others;
	
	with opcode4  select storet<=
	'1' when "01001" | "001100" | "100000" | "100011" | "001101" | "0011010" | "001011" | "001110" |"01000",
	'0' when others;
	
	with opcode3 select B<=
	'1' when "001000" | "001001" |"001010" |"001011" | "001100" | "001101" | "001110" | "001111",
	'0' when others; -- need to add all of the other opcodes

	with opcode5 select LoadSel <=
	'1' when "001000" | "001001" |"001010" |"001011" | "001100" |"001101" | "001110" | "001111"| "000000",
	'0' when others; -- Need to add other opcodes
	
	with opcode5 select Rselect <= 
	'1' when "000000",
	'0' when others; --add in other opcodes
	
	with opcode5 select RegWrite <=
	   '1' when "000000"|"001000" | "001001" |"001010" |"001011" | "001100" |"001101" | "001110" | "001111",
	   '0' when others;
		
	with opcode4 select readWrite <=
	'1' when "101000",
	'0' when others;
