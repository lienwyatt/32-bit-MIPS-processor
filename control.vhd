----------------------------------------------------------------------------------
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
PCsel, Bsel, LoadSel, Rselect, RegWrite: out std_logic
);
end control;

architecture Behavioral of control is
	signal opcode2, opcode3, opcode4, opcode5: std_logic_vector(5 downto 0);
	signal funct2, funct3, funct4, funct5: std_logic_vector(3 downto 0);
	signal opResult1, opResult2, functResult, opAndfunct, opOrFunct: std_logic;

	begin
	opcode2 <= IR2(31 downto 26);
	opcode3 <= IR3(31 downto 26);
	opcode4 <= IR4(31 downto 26);
	opcode5 <= IR5(31 downto 26);
	funct2 <= IR2(3 downto 0);
	funct3 <= IR3(3 downto 0);
	funct4 <= IR4(3 downto 0);
	funct5 <= IR5(3 downto 0);

--    with opcode4 select opResult1<=
--    '1' when "000000",
--    '0' when others;
    
--    with funct4 select functResult<=
--    '1' when "1000"| "1001",
--    '0' when others;
    
--    with opcode4 select opResult2<=
--    '1' when  "000001"|"000010"|"000011"|"000100"|"000101"|"000111"|"001000"|"111111",
--    '0' when others;
    
--    opAndfunct <= opResult1 AND functResult;
    
--    opOrFunct<= opAndFunct OR functResult;
    
--    with opOrFunct select PCsel<=
--    '0' when '1',
--    '1' when '0';
    
    
    
    
--	process(clk, IR2, IR3, IR4, IR5)
--	begin
		-----IF
		
--		case opcode4 is
--		when "000000" =>
--		if (funct4 = "1000")  then
--			PCsel <='0';
--		elsif (funct4 = "1001") then
--			PCsel<='0';
--		end if;
--		when "000001"|"000010"|"000011"|"000100"|"000101"|"000111"|"001000"=>
--			PCsel <='0';
--		when "111111"=>
--		--do nothing(nop) 	
--		when others=>
--		PCsel <='1';
--		end case;
		
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
	
	with opcode3 select Bsel<=
	'0' when "001000" | "001001" |"001010" |"001011" | "001100" | "001101" | "001110" | "001111",
	'1' when others; -- need to add all of the other opcodes
	
	with opcode5 select LoadSel <=
	'1' when "001000" | "001001" |"001010" |"001011" | "001100" |"001101" | "001110" | "001111"| "000000",
	'0' when others; -- Need to add other opcodes
	
	with opcode5 select Rselect <= 
	'1' when "000000",
	'0' when others; --add in other opcodes
	
	with opcode5 select RegWrite <=
	   '1' when "000000"|"001000" | "001001" |"001010" |"001011" | "001100" |"001101" | "001110" | "001111",
	   '0' when others;
	   
end Behavioral;

