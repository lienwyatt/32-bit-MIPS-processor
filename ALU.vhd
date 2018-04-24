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
op: in std_logic_vector(5 downto 0);
--<<<<<<< HEAD
offs: in std_logic_vector(4 downto 0);
--=======
-->>>>>>> origin/master
func: in std_logic_vector(5 downto 0);
output: out std_logic_vector(31 downto 0);
overflow: out std_logic;
carryout: out std_logic;
branch: out std_logic
);
end ALU;

architecture Behavioral of ALU is
--signal initial_Output_unsigned: unsigned(32 downto 0);
--signal Asigned, Bsigned: signed(31 downto 0); 
--signal Aunsigned, Bunsigned: unsigned(31 downto 0);
signal offset: std_logic_vector(4 downto 0);
signal opcode: std_logic_vector(5 downto 0);
signal funct: std_logic_vector(5 downto 0);
signal Aunsigned: std_logic_vector(32 downto 0);
signal Bunsigned: std_logic_vector(32 downto 0);
signal Asigned: std_logic_vector(32 downto 0);
signal Bsigned: std_logic_vector(32 downto 0);
signal output_sig: std_logic_vector(32 downto 0);
signal Asigned_tmp, Bsigned_tmp :std_logic_vector(32 downto 0);

begin
offset<= offs;
opcode <= op;
funct <= func;
Aunsigned <= '0' & inputA;
Bunsigned <= '0' & inputB;
Asigned <= '0' & inputA;
Bsigned <= '0' & inputB;

process(opcode, Aunsigned, Asigned, Bsigned, Bunsigned, funct, offset)
begin
	case opcode is
		when "000000" => -- arithmetic operations (opcode = 00)
			case funct is
				when "100000" =>  --(signed addition)			
					output_sig <= std_logic_vector(signed(Asigned) + signed(Bsigned));
					 if Asigned(31) /= Bsigned(31) then -- adding a positive and negative number, cant have overflow
						overflow <= '0';
					else
						if output_sig(31) /= Asigned(31) then --both numbers are positive or both numbers are negative (output MSB must match input MSBs which are the same since boeth are of same sign)
							overflow <= '1';
						else overflow <= '0';
						end if;
					end if;
				when "100001" => --(unsigned addition)
					output_sig <= std_logic_vector( unsigned(Aunsigned) + unsigned(Bunsigned));
					if output_sig(32) = '1' then
						overflow <= '1';
					else 
						overflow <= '0';
					end if;
				when "100010" => --(subtraction)
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
					
				when "100011" => --(unsigned subtraction)
					output_sig <= Aunsigned - Bunsigned;
					if (Aunsigned >= Bunsigned) then
						overflow <= '0';
					else
						overflow<= '1';
					end if;
					
				when "100100" => -- (and)
					output_sig <= (Aunsigned) AND (Bunsigned);
				when "100101" => -- (or)
					output_sig <= (Aunsigned) OR (Bunsigned);
				when "100110" => --(xor)
					output_sig <= (Aunsigned) XOR (Bunsigned);
				when "100111" => --(nor)
					output_sig <= (Aunsigned) NOR (Bunsigned);
					
				when "101010" => --(set on less than)
					if(Asigned(31) = Bsigned(31)) then
						if(Asigned(31)='0') then
							if(Asigned<Bsigned) then
								output_sig<= "000000000000000000000000000000001";
							else
								output_sig<= "000000000000000000000000000000000";
							end if;
						else -- both A and B are negative, abs values must be compared
							Asigned_tmp  <= not(Asigned) + '1';
							Bsigned_tmp  <= not(Bsigned) + '1';
							if(Asigned_tmp > Bsigned_tmp) then -- if A is a smaller negative number,althought abs(A) < abs(B), A is > B.
								output_sig<= "000000000000000000000000000000001";
							else
								output_sig<= "000000000000000000000000000000000";
							end if;
						end if;
					end if;

				when "101011"=> --(set on less than unsigned)
					 if(Aunsigned < Bunsigned) then
							  output_sig<= "000000000000000000000000000000001";
					 else
							  output_sig<= "000000000000000000000000000000000";
					 end if;
				when "000000"=>--(shift left logical)
					case offset is
						when "00000" => output_sig<= Bunsigned;
						when "00001" => output_sig<= Bunsigned(31 downto 0) & "0";
						when "00010" => output_sig<= Bunsigned(30 downto 0) & "00";
						when "00011" => output_sig<= Bunsigned(29 downto 0) & "000";
						when "00100" => output_sig<= Bunsigned(28 downto 0) & "0000";
						when "00101" => output_sig<= Bunsigned(27 downto 0) & "00000";
						when "00110" => output_sig<= Bunsigned(26 downto 0) & "000000";
						when "00111" => output_sig<= Bunsigned(25 downto 0) & "0000000";
						when "01000" => output_sig<= Bunsigned(24 downto 0) & "00000000";
						when "01001" => output_sig<= Bunsigned(23 downto 0) & "000000000";
						when "01010" => output_sig<= Bunsigned(22 downto 0) & "0000000000";
						when "01011" => output_sig<= Bunsigned(21 downto 0) & "00000000000";
						when "01100" => output_sig<= Bunsigned(20 downto 0) & "000000000000";
						when "01101" => output_sig<= Bunsigned(19 downto 0) & "0000000000000";
						when "01110" => output_sig<= Bunsigned(18 downto 0) & "00000000000000";
						when "01111" => output_sig<= Bunsigned(17 downto 0) & "000000000000000";
						when "10000" => output_sig<= Bunsigned(16 downto 0) & "0000000000000000";
						when "10001" => output_sig<= Bunsigned(15 downto 0) & "00000000000000000";
						when "10010" => output_sig<= Bunsigned(14 downto 0) & "000000000000000000";
						when "10011" => output_sig<= Bunsigned(13 downto 0) & "0000000000000000000";
						when "10100" => output_sig<= Bunsigned(12 downto 0) & "00000000000000000000";
						when "10101" => output_sig<= Bunsigned(11 downto 0) & "000000000000000000000";
						when "10110" => output_sig<= Bunsigned(10 downto 0) & "0000000000000000000000";
						when "10111" => output_sig<= Bunsigned(9 downto 0) & "00000000000000000000000";
						when "11000" => output_sig<= Bunsigned(8 downto 0) & "000000000000000000000000";
						when "11001" => output_sig<= Bunsigned(7 downto 0) & "0000000000000000000000000";
						when "11010" => output_sig<= Bunsigned(6 downto 0) & "00000000000000000000000000";
						when "11011" => output_sig<= Bunsigned(5 downto 0) & "000000000000000000000000000";
						when "11100" => output_sig<= Bunsigned(4 downto 0) & "0000000000000000000000000000";
						when "11101" => output_sig<= Bunsigned(3 downto 0) & "00000000000000000000000000000";
						when "11110" => output_sig<= Bunsigned(2 downto 0) & "000000000000000000000000000000";
						when "11111" => output_sig<= Bunsigned(1 downto 0) & "0000000000000000000000000000000";
						when others => 
					end case;

				when "000001"=>--(shift left arithmetic)
				
				when "000010"=>--(shift right logical)
				case offset is
						when "00000" => output_sig<= Bunsigned;
						when "00001" => output_sig<= "0" & Bunsigned(32 downto 1);
						when "00010" => output_sig<= "00" & Bunsigned(32 downto 2);
						when "00011" => output_sig<= "000" & Bunsigned(32 downto 3);
						when "00100" => output_sig<= "0000" & Bunsigned(32 downto 4);
						when "00101" => output_sig<= "00000" & Bunsigned(32 downto 5);
						when "00110" => output_sig<= "000000" & Bunsigned(32 downto 6);
						when "00111" => output_sig<= "0000000" & Bunsigned(32 downto 7);
						when "01000" => output_sig<= "00000000" & Bunsigned(32 downto 8);
						when "01001" => output_sig<= "000000000" & Bunsigned(32 downto 9);
						when "01010" => output_sig<= "0000000000" & Bunsigned(32 downto 10);
						when "01011" => output_sig<= "00000000000" & Bunsigned(32 downto 11);
						when "01100" => output_sig<= "000000000000" & Bunsigned(32 downto 12);
						when "01101" => output_sig<= "0000000000000" & Bunsigned(32 downto 13);
						when "01110" => output_sig<= "00000000000000" & Bunsigned(32 downto 14);
						when "01111" => output_sig<= "000000000000000" & Bunsigned(32 downto 15);
						when "10000" => output_sig<= "0000000000000000" & Bunsigned(32 downto 16);
						when "10001" => output_sig<= "00000000000000000" & Bunsigned(32 downto 17);
						when "10010" => output_sig<= "000000000000000000" & Bunsigned(32 downto 18);
						when "10011" => output_sig<= "0000000000000000000" & Bunsigned(32 downto 19);
						when "10100" => output_sig<= "00000000000000000000" & Bunsigned(32 downto 20);
						when "10101" => output_sig<= "000000000000000000000" & Bunsigned(32 downto 21);
						when "10110" => output_sig<= "0000000000000000000000" & Bunsigned(32 downto 22);
						when "10111" => output_sig<= "00000000000000000000000" & Bunsigned(32 downto 23);
						when "11000" => output_sig<= "000000000000000000000000" & Bunsigned(32 downto 24);
						when "11001" => output_sig<= "0000000000000000000000000" & Bunsigned(32 downto 25);
						when "11010" => output_sig<= "00000000000000000000000000" & Bunsigned(32 downto 26);
						when "11011" => output_sig<= "000000000000000000000000000" & Bunsigned(32 downto 27);
						when "11100" => output_sig<= "0000000000000000000000000000" & Bunsigned(32 downto 28);
						when "11101" => output_sig<= "00000000000000000000000000000" & Bunsigned(32 downto 29);
						when "11110" => output_sig<= "000000000000000000000000000000" & Bunsigned(32 downto 30);
						when "11111" => output_sig<= "0000000000000000000000000000000" & Bunsigned(32 downto 31);
						when others => 					end case;
				when "000011"=>--(shift right arithmetic)
				
				when "000100"=> --(shift left logical variable)
--				 case Aunsigned is
--						when "00000" => output_sig<= Bunsigned;
--						when "00001" => output_sig<= Bunsigned(31 downto 0) & "0";
--						when "00010" => output_sig<= Bunsigned(30 downto 0) & "00";
--						when "00011" => output_sig<= Bunsigned(29 downto 0) & "000";
--						when "00100" => output_sig<= Bunsigned(28 downto 0) & "0000";
--						when "00101" => output_sig<= Bunsigned(27 downto 0) & "00000";
--						when "00110" => output_sig<= Bunsigned(26 downto 0) & "000000";
--						when "00111" => output_sig<= Bunsigned(25 downto 0) & "0000000";
--						when "01000" => output_sig<= Bunsigned(24 downto 0) & "00000000";
--						when "01001" => output_sig<= Bunsigned(23 downto 0) & "000000000";
--						when "01010" => output_sig<= Bunsigned(22 downto 0) & "0000000000";
--						when "01011" => output_sig<= Bunsigned(21 downto 0) & "00000000000";
--						when "01100" => output_sig<= Bunsigned(20 downto 0) & "000000000000";
--						when "01101" => output_sig<= Bunsigned(19 downto 0) & "0000000000000";
--						when "01110" => output_sig<= Bunsigned(18 downto 0) & "00000000000000";
--						when "01111" => output_sig<= Bunsigned(17 downto 0) & "000000000000000";
--						when "10000" => output_sig<= Bunsigned(16 downto 0) & "0000000000000000";
--						when "10001" => output_sig<= Bunsigned(15 downto 0) & "00000000000000000";
--						when "10010" => output_sig<= Bunsigned(14 downto 0) & "000000000000000000";
--						when "10011" => output_sig<= Bunsigned(13 downto 0) & "0000000000000000000";
--						when "10100" => output_sig<= Bunsigned(12 downto 0) & "00000000000000000000";
--						when "10101" => output_sig<= Bunsigned(11 downto 0) & "000000000000000000000";
--						when "10110" => output_sig<= Bunsigned(10 downto 0) & "0000000000000000000000";
--						when "10111" => output_sig<= Bunsigned(9 downto 0) & "00000000000000000000000";
--						when "11000" => output_sig<= Bunsigned(8 downto 0) & "000000000000000000000000";
--						when "11001" => output_sig<= Bunsigned(7 downto 0) & "0000000000000000000000000";
--						when "11010" => output_sig<= Bunsigned(6 downto 0) & "00000000000000000000000000";
--						when "11011" => output_sig<= Bunsigned(5 downto 0) & "000000000000000000000000000";
--						when "11100" => output_sig<= Bunsigned(4 downto 0) & "0000000000000000000000000000";
--						when "11101" => output_sig<= Bunsigned(3 downto 0) & "00000000000000000000000000000";
--						when "11110" => output_sig<= Bunsigned(2 downto 0) & "000000000000000000000000000000";
--						when "11111" => output_sig<= Bunsigned(1 downto 0) & "0000000000000000000000000000000";
--						when others => 
--					end case;
				when "000101"=> --(shift left arithmetic variable)
				
				when "000110"=> --(shift right logical variable)
--				case offset is
--						when "00000" => output_sig<= Bunsigned;
--						when "00001" => output_sig<= "0" & Bunsigned(32 downto 1);
--						when "00010" => output_sig<= "00" & Bunsigned(32 downto 1);
--						when "00011" => output_sig<= "000" & Bunsigned(32 downto 1);
--						when "00100" => output_sig<= "0000" & Bunsigned(32 downto 1);
--						when "00101" => output_sig<= "00000" & Bunsigned(32 downto 1);
--						when "00110" => output_sig<= "000000" & Bunsigned(32 downto 1);
--						when "00111" => output_sig<= "0000000" & Bunsigned(32 downto 1);
--						when "01000" => output_sig<= "00000000" & Bunsigned(32 downto 1);
--						when "01001" => output_sig<= "000000000" & Bunsigned(32 downto 1);
--						when "01010" => output_sig<= "0000000000" & Bunsigned(32 downto 1);
--						when "01011" => output_sig<= "00000000000" & Bunsigned(32 downto 1);
--						when "01100" => output_sig<= "000000000000" & Bunsigned(32 downto 1);
--						when "01101" => output_sig<= "0000000000000" & Bunsigned(32 downto 1);
--						when "01110" => output_sig<= "00000000000000" & Bunsigned(32 downto 1);
--						when "01111" => output_sig<= "000000000000000" & Bunsigned(32 downto 1);
--						when "10000" => output_sig<= "0000000000000000" & Bunsigned(32 downto 1);
--						when "10001" => output_sig<= "00000000000000000" & Bunsigned(32 downto 1);
--						when "10010" => output_sig<= "000000000000000000" & Bunsigned(32 downto 1);
--						when "10011" => output_sig<= "0000000000000000000" & Bunsigned(32 downto 1);
--						when "10100" => output_sig<= "00000000000000000000" & Bunsigned(32 downto 1);
--						when "10101" => output_sig<= "000000000000000000000" & Bunsigned(32 downto 1);
--						when "10110" => output_sig<= "0000000000000000000000" & Bunsigned(32 downto 1);
--						when "10111" => output_sig<= "00000000000000000000000" & Bunsigned(32 downto 1);
--						when "11000" => output_sig<= "000000000000000000000000" & Bunsigned(32 downto 1);
--						when "11001" => output_sig<= "0000000000000000000000000" & Bunsigned(32 downto 1);
--						when "11010" => output_sig<= "00000000000000000000000000" & Bunsigned(32 downto 1);
--						when "11011" => output_sig<= "000000000000000000000000000" & Bunsigned(32 downto 1);
--						when "11100" => output_sig<= "0000000000000000000000000000" & Bunsigned(32 downto 1);
--						when "11101" => output_sig<= "00000000000000000000000000000" & Bunsigned(32 downto 1);
--						when "11110" => output_sig<= "000000000000000000000000000000" & Bunsigned(32 downto 1);
--						when "11111" => output_sig<= "0000000000000000000000000000000" & Bunsigned(32 downto 1);
--						when others => 
--					end case;
				when "000111"=> --(shift right arithmetic variable)
					
				when others =>
				
			 end case; -- opcodes are no longer x00
		 
		 when "001000"=> --(add immediate) 
			  output_sig <=Asigned + Bsigned;
				 if (Asigned(31) /= Bsigned(31)) then
					overflow <= '0';
				else
					if(output_sig(31) /= Asigned(31)) then
						overflow <= '1';
					else 
						overflow<= '0';
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
							output_sig<= "000000000000000000000000000000001";
						else
							output_sig<= "000000000000000000000000000000000";
						end if;
					else -- both A and B are negative, abs values must be compared
						Asigned_tmp  <= not(Asigned) + '1';
						Bsigned_tmp  <= not(Bsigned) + '1';
						if(Asigned_tmp > Bsigned_tmp) then -- if A is a smaller negative number,althought abs(A) < abs(B), A is > B.
							output_sig<= "000000000000000000000000000000001";
						else
							output_sig<= "000000000000000000000000000000000";
						end if;
					end if;
				end if;
				-------------------------------------------------------------BRANCH STUFF
	     when "000100"=>--BEQ
	          if (inputA=inputB) then
	              branch<='1';
	          else 
	           branch<='0';
	          end if;
	     when "000101"=>--BNE
            if (NOT (inputA=inputB)) then
                branch<='1';
            else 
             branch<='0';
            end if;
                       
	     when "000001" =>--Branch on less than than zero (we are ignoring the other bits for now)
	         if (inputA(31)='1') then--if the signed number is negative
	            branch<='1';
	         else 
	            branch<='0';
	         end if;
	     
		 when "001011"=> --(set on less than immediate unsigned)
			 if(Aunsigned < Bunsigned) then
				output_sig<= "000000000000000000000000000000001";
			else
				output_sig<= "000000000000000000000000000000000";
			end if;
				 
		 when "001100"=> --(and immediate) 
				output_sig <= (Aunsigned) AND (Bunsigned);
		 when "001101"=> --(or immediate) 
				output_sig <= (Aunsigned) OR (Bunsigned);
		 when "001110"=> --(xor immediate) 
				output_sig <= (Aunsigned) XOR (Bunsigned);
		 when "001111"=> --(load upper immediate) 
				output_sig(15 downto 0)<="0000000000000000";
				output_sig(31 downto 16)<=Aunsigned(15 downto 0);
		when others =>
	end case;
end process;

--process(output_sig)
--begin
 --   if (output_sig = "000000000000000000000000000000000") then zero <= '1';
   -- end if;

--end process;
	 	output<=output_sig(31 downto 0);				

end Behavioral;
