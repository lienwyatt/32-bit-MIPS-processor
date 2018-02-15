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
use ieee.std_logic_unsigned.all;

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
zero: out std_logic
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
Aunsigned <= inputA;
Bunsigned <= inputB;

Asigned <= inputA;
Bsigned <= inputB;

process(opcode)
begin
	case opcode is
		when "000000" => -- arithmetic operations (opcode = 00)
			case funct is
				when "0000" =>  --(signed addition)			
					output_sig <= std_logic_vector(signed(Asigned) + signed(Bsigned));
					 if Asigned(31) /= Bsigned(31) then
						overflow <= '0';
					else
						if output_sig(31) /= Asigned(31) then
							overflow <= '1';
						end if;
					end if;
				when "0001" => --(unsigned addition)
					output_sig <= std_logic_vector( unsigned(Aunsigned) + unsigned(Bunsigned));
					if output_sig(32) = '1' then
						overflow <= '1';
					else 
						overflow <= '0';
					end if;
				when "0010" => --(subtraction)
					Bsigned_tmp <= not(Bsigned) + '1';
					output_sig <= Asigned + Bsigned_tmp;
					if(Asigned(31) = Bsigned(31)) then--overflow handling. A and B have different signs
						overflow <= '0';
					elsif(Asigned(31) = '1') then -- A is negative, so B must be positive according to previous if (above the else)
						Asigned_tmp <= not(Asigned) + '1'; -- turns A positive
							if(Asigned_tmp > Bsigned) then --if absolute value of A is > B, and A is negative, output must be negative 
								if(output_sig(31) /= '1') then
									overflow <= '1';
								else
									overflow <= '0';
								end if;
							end if;
					else -- A is positive, B is negative (meaning we did A + B, where both A and B are positive)
							if(output_sig(32) /= '1') then--checking the carry-out bit
								overflow <= '1';
							else
								overflow <= '0';
							end if;
						end if;
					
				when "0011" => --(unsigned subtraction)
					output_sig <= Aunsigned - Bunsigned;
					if (Aunsigned >= Bunsigned) then
						overflow <= '0';
					else
						overflow<= '1';
					end if;
					
				when "0100" => -- (and)
					output_sig <= inputA AND inputB;
				when "0101" => -- (or)
					output_sig <= inputA OR inputB;
				when "0110" => --(xor)
					output_sig <= inputA XOR inputB;
				when "0111" => --(nor)
					output_sig <= inputA NOR inputB;
					
				when "1010" => --(set on less than)
					if(Asigned(31) = Bsigned(31)) then
						if(Asigned(31)='0') then
							if(Asigned<Bsigned) then
								output_sig<= "00000000000000000000000000000001";
							else
								output_sig<= "00000000000000000000000000000000";
							end if;
						else -- both A and B are negative, abs values must be compared
							Asigned_tmp  <= not(Asigned) + '1';
							Bsigned_tmp  <= not(Bsigned) + '1';
							if(Asigned_tmp > Bsigned_tmp) then -- if A is a smaller negative number,althought abs(A) < abs(B), A is > B.
								output_sig<= "00000000000000000000000000000001";
							else
								output_sig<= "00000000000000000000000000000000";
							end if;
						end if;
					end if;

				when "1011"=> --(set on less than unsigned)
					 if(Aunsigned < Bunsigned) then
							  output_sig<= "00000000000000000000000000000001";
						 else
							  output_sig<= "00000000000000000000000000000000";
						 end if;
				when others =>
				
			 end case; -- opcodes are no longer x00
		 
		 when "001000"=> --(add immediate) 
			  output_sig <=Asigned + Bsigned;
				 if (Asigned(31) /= Bsigned(31)) then
					overflow <= '0';
				else
					if(output_sig(31) /= Asigned(31)) then
						overflow <= '1';
					end if;
				end if;
		 when "001001"=> --(add immediate unsigned)
			 output_sig <= Aunsigned + Bunsigned;
			 if(output_sig(32) = '1') then
				overflow <= '1';
			else 
				overflow <= '0';
			end if;
			
		 when "001010"=> --(set on less than immediate)
				if(Asigned(31) = Bsigned(31)) then
					if(Asigned(31)='0') then
						if(Asigned<Bsigned) then
							output_sig<= "00000000000000000000000000000001";
						else
							output_sig<= "00000000000000000000000000000000";
						end if;
					else -- both A and B are negative, abs values must be compared
						Asigned_tmp  <= not(Asigned) + '1';
						Bsigned_tmp  <= not(Bsigned) + '1';
						if(Asigned_tmp > Bsigned_tmp) then -- if A is a smaller negative number,althought abs(A) < abs(B), A is > B.
							output_sig<= "00000000000000000000000000000001";
						else
							output_sig<= "00000000000000000000000000000000";
						end if;
					end if;
				end if;
				
		 when "001011"=> --(set on less than immediate unsigned)
			 if(Aunsigned < Bunsigned) then
				output_sig<= "00000000000000000000000000000001";
			else
				output_sig<= "00000000000000000000000000000000";
			end if;
				 
		 when "001100"=> --(and immediate) 
				output_sig <= inputA AND inputB;
		 when "001101"=> --(or immediate) 
				output_sig <= inputA OR inputB;
		 when "001110"=> --(xor immediate) 
				output_sig <= inputA XOR inputB;
		 when "001111"=> --(load upper immediate) 
				output_sig(15 downto 0)<="0000000000000000";
				output_sig(31 downto 16)<=inputA;
		when others =>
	end case;
end process;

process(output_sig)
begin
    if (output_sig = x"00000000") then zero <= '1';
    end if;
end process;
				
output<=output_sig;
end Behavioral;
