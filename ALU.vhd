----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:25:50 02/09/2018 
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
use IEEE.numeric_std.all;

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
signal output_sig: std_logic_vector(31 downto 0);
signal Asigned_tmp, Bsigned_tmp :std_logic_vector(31 downto 0);
begin
Aunsigned<=inputA;
Bunsigned<=inputB;

case (opcode) is
	when "000000" => -- arithmetic operations (opcode = 00)
		case(funct) is
			when "0000" =>  --(signed addition)			
			    if (Asigned(31) != Bsigned(31)) then
					output_sig <=Asigned + Bsigned;
					overflow <= '0';
					carryout <= '0';
				else
					
			when "0001" =>
				initial_Output_unsigned <= Aunsigned + Bunsigned;
			when "0010" => --(subtraction)
				output_sig <=Asigned - Bsigned;
			when "0011" =>
				initial_Output_unsigned <= Aunsigned - Bunsigned;
			when "0100" =>
				output_sig <= inputA AND inputB;
			when "0101" =>
				output_sig <= inputA OR inputB;
			when "0110" =>
				output_sig <= inputA XOR 	inputB;
			when "0111" =>
				output_sig <= inputA NOR inputB;
			when "1010" => 
				if(Asigned < Bsigned) then
					output_sig<= "1";
				else
					output_sig<= "0";
			    end if;
			when "1011"=>
			    if(Aunsigned < Bunsigned) then
                    output_sig<= "1";
                else
                    output_sig<= "0";
                end if;
         end case;
    when "001000"=>
        output_sig<=(Asigned + Bsigned);
    when "001001"=>
       output_sig<=(Aunsigned + Bunsigned);
    when "001010"=>
       if(Aunsigned < Bunsigned) then
          output_sig<= "1";
       else
          output_sig<= "0";
       end if;
    when "001011"=>
       if(Aunsigned < Bunsigned) then
          output_sig<= "1";
       else
          output_sig<= "0";
       end if;
    when "001100"=>
         output_sig <= inputA AND inputB;
    when "001101"=>
         output_sig <= inputA OR inputB;
    when "001110"=>
         output_sig <= inputA XOR inputB;
    when "001111"=>
         output_sig(15 downto 0)<="0000000000000000";
         output_sig(31 downto 16)<=inputA;
end case;

process(output_sig)
    if (output_sig="00000000000000000000000000000000") then zero<="1";
    end if;
end process;
				
output<=output_sig;
end Behavioral;

