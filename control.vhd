----------------------------------------------------------------------------------
-- Control unit
--
--sends control signals based on opcodes out to different parts of the processor
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity control is
port(
clk: in std_logic;
branch: in std_logic;
IR2, IR3, IR4, IR5 : in std_logic_vector(31 downto 0);
LoadSel, RegWrite, Asel, readWrite: out std_logic;
PCsel: out std_logic_vector(2 downto 0);
Bsel, Rselect: out std_logic_vector(1 downto 0)
);
end control;

architecture Behavioral of control is
	signal opcode2, opcode3, opcode4, opcode5: std_logic_vector(5 downto 0); --opcodes in each stage
	signal funct2, funct3, funct4, funct5: std_logic_vector(5 downto 0); --function bits for each stage
	signal concat3, concat4: std_logic_vector(11 downto 0);
	signal opResult1, opResult2, functResult, opAndfunct, opOrFunct, storet, stored, bchoose,B, achoose: std_logic;

	begin
	--sets control signals based on values in the instruction registers
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
		--PCsel is the select for mux1 in the datapath
		-- determines what the next value of PC will be
		case opcode4 is
	   when "000010"=>
            PCsel<="011";--jump
		when "111111"=>
		PCsel<="001"; --noop
		when "000001"|"000100"|"000101"|"000110"|"000111"=>--branch instructions
		     if (branch='1') then
		         PCsel<="010"; --only branches if the branch condition was met
		     else 
		         PCsel<="001";
		     end if;
		when others=>
		PCsel <="001";--increase pc by 4
		end case;
	end process;
	
concat4<=opcode4&funct4;

--selects depending on if data needs to be forwarded to either the A or B input of the ALU
process(IR4, IR3, storet, stored)
begin
    if ((IR4(20 downto 16)=IR3(20 downto 16) AND storet='1')OR(IR4(15 downto 11)=IR3(20 downto 16) AND stored='1')) then bchoose<='1';
    else bchoose<='0';
    end if;
    if ((IR4(20 downto 16)=IR3(25 downto 21) AND storet='1')OR(IR4(15 downto 11)=IR3(25 downto 21) AND stored='1')) then achoose<='1';
        else achoose<='0';
   end if;
end process;

process(B, bchoose)
begin
    if (bchoose='1')then Bsel<="11";--forwarding data
    elsif(B='1') then Bsel<="01";--adding from reg
    else Bsel<="00";--adding immediate
    end if;    
end process;

Asel<=achoose;

-- determines if the last operation stored using rd
	with concat4 select stored<=
	'1' when "000000100000" | "000000100001" | "000000100100" | "000000100101" | "000000000000" | "000000000100" | "000000101010" | "000000101011" | "000000000011" | "000000000010" | "000000000110" | "000000100011" | "000000100110",
	'0' when others;
-- determines if the last operation stored using rt
	with opcode4  select storet<=
	'1' when "001001" | "001100" | "100000" | "100011" | "001101" | "011010" | "001011" | "001110" |"010000",
    '0' when others;
-- select for which B value we are using for the given opcode
	with opcode3 select B<=
	'0' when "001000"| "001001" |"001010" |"001011" | "001100" | "001101" | "001110" | "001111" | "100011" | "101011",--options that use immediates
	'1' when others; 
-- select for determining what data is being written into the GPRs
	with opcode5 select LoadSel <=
	'1' when "001000" | "001001" |"001010" |"001011" | "001100" |"001101" | "001110" | "001111"| "000000",
	'0' when others; 
--	select for determining whether we are writing using Rs or Rt
	with opcode5 select Rselect <= 
	"01" when "000000",
	"10" when "000100" | "000101",
	"00" when others; 
--	select for writing to the GPRs
	with opcode5 select RegWrite <=
	   '1' when "000000"|"001000" | "001001" |"001010" |"001011" | "001100" |"001101" | "001110" | "001111"|"100011",
	   '0' when others;
-- used for whether we are writing to memory or not
	with opcode4 select readWrite <=
	'1' when "101011",
	'0' when others;
	
	end Behavioral;
