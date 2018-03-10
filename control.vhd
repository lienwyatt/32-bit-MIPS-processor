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
IR1, IR2, IR3, IR4, IR5 : in std_logic_vector(31 downto 0);
ALUopcode: out std_logic_vector(5 downto 0);
ALUfunct: out std_logic_vector(3 downto 0);
PCsel, Bsel, LoadSel, Rselect, RegWrite: out std_logic
);
end control;

architecture Behavioral of control is
	signal opcode2, opcode3, opcode4, opcode5: std_logic_vector(5 downto 0);
	signal funct2, funct3, funct4, funct5: std_logic_vector(3 downto 0);
	begin
	opcode2 <= IR2(31 downto 26);
	opcode3 <= IR3(31 downto 26);
	opcode4 <= IR4(31 downto 26);
	opcode5 <= IR5(31 downto 26);
	funct2 <= IR2(3 downto 0);
	funct3 <= IR3(3 downto 0);
	funct4 <= IR4(3 downto 0);
	funct5 <= IR5(3 downto 0);

	ALUopcode <= opcode3;
	ALUfunct <= funct3;

	process(clk)
	begin
		-----IF
		case opcode4 is
		when "000000" =>
		if (funct4 = "1000")  then
			PCsel <='0';
		elsif (funct4 = "1001") then
			PCsel<='0';
		end if;
		when "000001"|"000010"|"000011"|"000100"|"000101"|"000111"|"001000"=>
			PCsel <='0';
		when others=>
		PCsel <='1';
		end case;
		-----ID
		case opcode5 is
			when "000000" | "001000" | "001001" | "001010" | "001011" | "001100" | "001101" | "001110" | "001111" =>
			RegWrite <= '1';
			when others => 
			RegWrite<= '0';
		end case;
		----EX
		case opcode3 is
			when "001000" | "001001" |"001010" |"001011" | "001100" | "001101" | "001110" | "001111" =>
			Bsel <= '1';
			when "000000" => 
			Bsel<= '0';
			when others =>
		end case;
		----MEM
		----WB
		case opcode5 is
			when "000000" =>
			LoadSel<= '1';
			Rselect <= '1';
			when "001000" | "001001" |"001010" |"001011" | "001100" |"001101" | "001110" | "001111" =>
			LoadSel<= '1';
			Rselect <='0';
			when others =>
		end case;
	end process;
end Behavioral;

