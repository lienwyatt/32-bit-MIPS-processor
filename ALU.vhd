----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:11:46 02/09/2018 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.all
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
port(
inputA, inputB: in std_logic_vector(31 downto 0);
opcode: in std_logic_vector(5 downto 0);
funct: in std_logic_vector(3 downto 0);
output: out std_logic_vector(31 downto 0);
overflow: out std_logic;
carryout: out std_logic
);
end ALU;

architecture Behavioral of ALU is
signal initial_Output_unsigned: unsigned(32 downto 0);
signal Asigned, Bsigned: signed(31 downto 0); 
signal Aunsigned, Bunsigned: unsigned(31 downto 0); 
begin
case(opcode) is
	when "000000" => 
		case(funct) is
			when "0000" =>
				output <=Asigned + Bsigned;
			when "0001" =>
				initial_Output_unsigned <= Aunsigned + Bunsigned;
			when "0010" =>
				output <=Asigned - Bsigned;
			when "0011" =>
				initial_Output_unsigned <= Aunsigned - Bunsigned;
			when "0100" =>
				output <= inputA AND inputB;
			when "0101" =>
				output <= inputA OR inputB;
			when "0110" =>
				output <= inputA XOR inputB;
			when "0111" =>
				output <= inputA NOR inputB;
			when "1010" => 
				if(inputA < inputB) then
					output<= '1';
				else
					output<= '0';
			when ""
				
			
		
end Behavioral;

