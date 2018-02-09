----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/09/2018 03:15:50 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
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
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.numeric_std.all;
--use IEEE.std_logic_arith.all;

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
carryout: out std_logic;
zero: std_logic
);
end ALU;

architecture Behavioral of ALU is
--signal initial_Output_unsigned: unsigned(32 downto 0);
--signal Asigned, Bsigned: signed(31 downto 0); 
--signal Aunsigned, Bunsigned: unsigned(31 downto 0);
signal Aunsigned: std_logic_vector(31 downto 0);
signal Bunsigned: std_logic_vector(31 downto 0);
signal Asigned: std_logic_vector(31 downto 0);
signal Bsigned: std_logic_vector(31 downto 0);
signal out: std_logic_vector(31 downto 0);
begin
Aunsigned<=inputA;
Bunsigned<=inputB;

case (opcode) is
	when "000000" => 
		case(funct) is
			when "0000" => 
			    out <=Asigned + Bsigned;
			    
			when "0001" =>
				initial_Output_unsigned <= Aunsigned + Bunsigned;
			when "0010" =>
				out <=Asigned - Bsigned;
			when "0011" =>
				initial_Output_unsigned <= Aunsigned - Bunsigned;
			when "0100" =>
				out <= inputA AND inputB;
			when "0101" =>
				out <= inputA OR inputB;
			when "0110" =>
				out <= inputA XOR inputB;
			when "0111" =>
				out <= inputA NOR inputB;
			when "1010" => 
				if(Asigned < Bsigned) then
					out<= "1";
				else
					out<= "0";
			    end if;
			when "1011"=>
			    if(Aunsigned < Bunsigned) then
                    out<= "1";
                else
                    out<= "0";
                end if;
         end case;
    when "001000"=>
        out<=(Asigned + Bsigned);
    when "001001"=>
       out<=(Aunsigned + Bunsigned);
    when "001010"=>
       if(Aunsigned < Bunsigned) then
          out<= "1";
       else
          out<= "0";
       end if;
    when "001011"=>
       if(Aunsigned < Bunsigned) then
          out<= "1";
       else
          out<= "0";
       end if;
    when "001100"=>
         out <= inputA AND inputB;
    when "001101"=>
         out <= inputA OR inputB;
    when "001110"=>
         out <= inputA XOR inputB;
    when "001111"=>
         out(15 downto 0)<="0000000000000000";
         out(31 downto 16)<=inputA;
end case;

process(out)
    if (out="00000000000000000000000000000000") then zero<="1";
    end if;
end process;
				
output<=out;
end Behavioral;

