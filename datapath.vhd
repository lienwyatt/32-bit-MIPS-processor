--------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/02/2018 02:36:25 PM
-- Design Name: 
-- Module Name: Datapath - Behavioral
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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Datapath is

    Port (
    AB1: out std_logic_vector(31 downto 0);
    IB1: in std_logic_vector(31 downto 0);
    AB2: out std_logic_vector(31 downto 0);
    DB2: out std_logic_vector(31 downto 0);
    DB3: in std_logic_vector(31 downto 0);
	 memWrite: out std_logic;
	 reset:in std_logic; -- used for resetting pc to first address
    clock: in std_logic);
end Datapath;

architecture Behavioral of Datapath is
    signal NPC2: std_logic_vector(31 downto 0);--registers
    signal NPC3: std_logic_vector(31 downto 0);
    signal TA4: std_logic_vector(31 downto 0);
    signal TA: std_logic_vector(31 downto 0);
    signal A3: std_logic_vector(31 downto 0);
    signal B3: std_logic_vector(31 downto 0);
    signal B4: std_logic_vector(31 downto 0);
    signal IMM3: std_logic_vector(31 downto 0);
    signal IR2: std_logic_vector(31 downto 0);
    signal IR3: std_logic_vector(31 downto 0);
    signal IR4: std_logic_vector(31 downto 0);
    signal IR5: std_logic_vector(31 downto 0);
    signal ALU4: std_logic_vector(31 downto 0);
    signal ALU5: std_logic_vector(31 downto 0);
    signal MDR5: std_logic_vector(31 downto 0);
    signal PC: std_logic_vector(31 downto 0);
    signal branch4: std_logic;
    signal readWrite: std_logic;
    signal pc_count: std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
    
    
    
    signal Rs: std_logic_vector(4 downto 0);--gpr signals
    signal Rd: std_logic_vector(4 downto 0);
    signal Rt: std_logic_vector(4 downto 0);
    signal A: std_logic_vector(31 downto 0);
    signal B: std_logic_vector(31 downto 0);
    signal regwrite: std_logic; 
    component registerfile
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
    end component;
     
     
     signal aluoutput: std_logic_vector(31 downto 0);--alu signals
     signal aluoverflow: std_logic;
     signal alubranch: std_logic;
     signal alucarry: std_logic;
     --signal sign_extended_imm: std_logic_vector(18 downto 0);   
     component ALU
     port(
     inputA: in std_logic_vector(31 downto 0);
     inputB: in std_logic_vector(31 downto 0);
     op: in std_logic_vector(5 downto 0);
	  offs: in std_logic_vector(4 downto 0);--should this exist
     func: in std_logic_vector(5 downto 0);
     output: out std_logic_vector(31 downto 0);
     overflow: out std_logic;
     carryout: out std_logic;
     branch: out std_logic
     );
    end component;
	 
    
    signal mux1: std_logic_vector(31 downto 0);--muxes
    signal mux2: std_logic_vector(31 downto 0);
    signal mux3: std_logic_vector(31 downto 0);
    signal mux4: std_logic_vector(31 downto 0);
    signal mux5: std_logic_vector(31 downto 0);
    
    
    
    signal PCsel: std_logic_vector(2 downto 0);--control unit signals
    signal Bsel: std_logic_vector(1 downto 0);
    signal Rselect: std_logic_vector(1 downto 0);
    signal Loadsel: std_logic;
    signal Rsel: std_logic_vector(4 downto 0);
    signal Asel: std_logic;
	 --signal RegWriter: std_logic;--WTF
	 
	 
	 
	 component control  
	 port(
	 branch : in std_logic;
	 clk : in std_logic;
	 IR2 : in std_logic_vector(31 downto 0);
	 IR3 : in std_logic_vector(31 downto 0);
	 IR4 : in std_logic_vector(31 downto 0);
	 IR5 : in std_logic_vector(31 downto 0);
	 PCsel : out std_logic_vector (2 downto 0);
	 Bsel : out std_logic_vector(1 downto 0);
	 Asel : out std_logic;
	 LoadSel : out std_logic;
	 Rselect : out std_logic_vector(1 downto 0);
	 RegWrite: out std_logic;
	 readWrite: out std_logic
	);
	end component;
	 
begin

gpr: registerfile port map(
	 clk=>clock,
    readreg1=>Rs,
    readreg2=>Rt,
    writereg=>Rsel,
    A=>A,
    B=>B,
    writedata=>mux4,
    regwrite=>regwrite
    );
    

Arithmetic_logic_unit: ALU port map(
    inputA=>mux5,
    inputB=>mux3,
    op=>IR3(31 downto 26),
    func=>IR3(5 downto 0),
	 offs=>IR3(10 downto 6),--should this exist
    output=>aluoutput,
    overflow=> aluoverflow,
    carryout=> alucarry,
    branch=>alubranch
    );
	 
Control_unit: control port map(
    branch=>branch4,
	clk=>clock,
	IR2=>IR2,
	IR3=>IR3,
	IR4=>IR4,
	IR5=>IR5,
	PCSel=>PCSel,
	Asel=>Asel,
	Bsel=>Bsel,
	Rselect=>Rselect,
	LoadSel=>LoadSel,
	RegWrite=>regwrite,
	readWrite => readWrite
);
--sign_extended_imm<=IR4 
DB2<=B4;
AB2<=ALU4;
AB1<=PC;
Rs<=IR2(25 downto 21);
Rt<=IR2(20 downto 16);
memWrite<= readWrite;
pc_count <= PC + "00000000000000000000000000000100";

with PCsel select mux1<= 
pc_count when "001", 
TA4 when "010",      
PC(31 downto 28) & IR4(25 downto 0) & "00" when "011",
pc_count when others;
TA(31 downto 2)<=IMM3(29 downto 0);--pc = imm x 4
TA(1 downto 0)<= "00";
process(clock, reset)
begin
if(clock' event and clock='1') then
   branch4<=alubranch;
   A3<=A;
   B3<=B;
   B4<=B3;
   NPC2<=mux1;
   MDR5<=DB3;
   NPC3<=NPC2;
   ALU4<=aluoutput; 
   ALU5<=ALU4;
   IR2<=IB1;
   IR3<=IR2;
   IR4<=IR3;
   IR5<=IR4;
   TA4<=TA+NPC3;

   IMM3(15 downto 0)<=IR2(15 downto 0);--sign extend
   if (IR2(15)='1') then
       IMM3(31 downto 16)<="1111111111111111";
   else
       IMM3(31 downto 16)<="0000000000000000";
   end if;
end if;
end process;

--pc reg
process (clock, reset)
begin
	if(reset = '0') then
		if(clock' event and clock='1') then
			PC<=mux1;
		end if;
	else -- reset = 1
		PC<= x"00000000";
	end if;
end process;

with Loadsel select mux4 <=
ALU5 when '1',
MDR5 when others;

with Rselect select Rsel <=
    IR5(15 downto 11) when "01",
    IR5(20 downto 16) when "00",
	 "00000" when others;
	 

with Asel select mux5<=
    ALU4 when '1',
    A3 when others;
    

with Bsel select mux3 <=
    B3 when "01",
    ALU4 when "11",
    IMM3 when others;

end Behavioral;
