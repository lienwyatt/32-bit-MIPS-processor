----------------------------------------------------------------------------------
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
	 reset: std_logic; -- used for resetting pc to first address
    clock: in std_logic);
end Datapath;

architecture Behavioral of Datapath is
    signal NPC2: std_logic_vector(31 downto 0);--registers
    signal NPC3: std_logic_vector(31 downto 0);
    signal TA4: std_logic_vector(31 downto 0);
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
    signal zero4: std_logic;
    
    
    
    signal Rs: std_logic_vector(4 downto 0);--gpr signals
    signal Rd: std_logic_vector(4 downto 0);
    signal Rt: std_logic_vector(4 downto 0);
    signal A: std_logic_vector(31 downto 0);
    signal B: std_logic_vector(31 downto 0);
    signal regwrite: std_logic; 
    component registerfile
     port(
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
     signal aluzero: std_logic;
     signal alucarry: std_logic;   
     component ALU
     port(
     inputA: in std_logic_vector(31 downto 0);
     inputB: in std_logic_vector(31 downto 0);
     op: in std_logic_vector(5 downto 0);
     func: in std_logic_vector(3 downto 0);
     output: out std_logic_vector(31 downto 0);
     overflow: out std_logic;
     carryout: out std_logic;
     zero: out std_logic
     );
    end component;
	 
    
    signal mux1: std_logic_vector(31 downto 0);--muxes
    signal mux2: std_logic_vector(31 downto 0);
    signal mux3: std_logic_vector(31 downto 0);
    signal mux4: std_logic_vector(31 downto 0);
    signal Rsel: std_logic_vector(4 downto 0);
    
    
    signal PCsel: std_logic;--control unit signals
    signal Bsel: std_logic;
    signal Rselect: std_logic;
    signal Loadsel: std_logic;
	 --signal RegWriter: std_logic;--WTF
	 component control  
	 port(
	 clk : in std_logic;
	 IR2 : in std_logic_vector(31 downto 0);
	 IR3 : in std_logic_vector(31 downto 0);
	 IR4 : in std_logic_vector(31 downto 0);
	 IR5 : in std_logic_vector(31 downto 0);
	 PCsel : out std_logic;
	 Bsel : out std_logic;
	 LoadSel : out std_logic;
	 Rselect : out std_logic;
	 RegWrite: out std_logic
	);
	end component;
	 
begin

gpr: registerfile port map(
    readreg1=>Rs,
    readreg2=>Rt,
    writereg=>Rsel,
    A=>A,
    B=>B,
    writedata=>mux4,
    regwrite=>regwrite
    );
    

Arithmetic_logic_unit: ALU port map(
    inputA=>A3,
    inputB=>mux3,
    op=>IR3(31 downto 26),
    func=>IR3(3 downto 0),
    output=>aluoutput,
    overflow=> aluoverflow,
    carryout=> alucarry,
    zero=>aluzero
    );
	 
Control_unit: control port map(
	clk=>clock,
	IR2=>IR2,
	IR3=>IR3,
	IR4=>IR4,
	IR5=>IR5,
	PCSel=>PCSel,
	Bsel=>Bsel,
	Rselect=>Rselect,
	LoadSel=>LoadSel,
	RegWrite=>regwrite
);

DB2<=B4;
AB2<=ALU4;
AB1<=PC;

process(PCsel)
begin
    if(PCsel='1') then
        mux1<=PC+"00000000000000000000000000000100";
    else 
        mux1<=TA4;
    end if;
end process;

process(clock)
begin
if(clock' event and clock='1') then
   zero4<=aluzero;
   A3<=A;
   B3<=B;
   NPC2<=mux1;
   MDR5<=DB3;
   NPC2<=NPC3;
   ALU4<=aluoutput; 
   ALU5<=ALU4;
   IR2<=IB1;
   IR3<=IR2;
   IR4<=IR3;
   IR5<=IR4;
   Rs<=IR2(25 downto 21);
   Rt<=IR2(20 downto 16);
   TA4(31 downto 2)<=IMM3(29 downto 0);--pc = imm x 4
   TA4(1 downto 0)<= "00";
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
    IR5(15 downto 11) when '1',
    IR5(20 downto 16) when others;


with Bsel select mux3 <=
    B3 when '1',
    IMM3 when others;



end Behavioral;



