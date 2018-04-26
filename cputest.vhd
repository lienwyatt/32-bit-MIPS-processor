--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:53:13 03/27/2018
-- Design Name:   
-- Module Name:   C:/Users/Jesse Coma/Data_path/alutest.vhd
-- Project Name:  Data_path
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Datapath
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY cputest IS
END cputest;
 
ARCHITECTURE behavioral OF cputest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Datapath
    PORT(
         AB1 : OUT  std_logic_vector(31 downto 0);
         IB1 : IN  std_logic_vector(31 downto 0);
         AB2 : OUT  std_logic_vector(31 downto 0);
         DB2 : OUT  std_logic_vector(31 downto 0);
         DB3 : IN  std_logic_vector(31 downto 0);
			memWrite: OUT std_logic;
         reset : IN  std_logic;
         clock : IN  std_logic
        );
    END COMPONENT;
	 
	component memory_unit
	port(
	ab1: in std_logic_vector(31 downto 0); -- pc (address of instruction)
	ib1: out std_logic_vector(31 downto 0); -- instruction fetched from memory

	ab2: in std_logic_vector(31 downto 0); --  address of data (to be fetched or written to)
	db2: in std_logic_vector(31 downto 0); -- carries the data to be written to memory
	write_en : in std_logic; -- write enable
	db3: out std_logic_vector(31 downto 0); -- data out

	clear: in std_logic; -- clear bit (for data memory)
	clock : in std_logic -- clock signal
	);
	end component;
    

   --Inputs
   signal IB1sig : std_logic_vector(31 downto 0) := (others => '0');
   signal DB3 : std_logic_vector(31 downto 0) := (others => '0');
   signal reset : std_logic := '0';
   signal clock : std_logic := '0';

 	--Outputs
   signal AB1 : std_logic_vector(31 downto 0);
   signal AB2 : std_logic_vector(31 downto 0);
   signal DB2 : std_logic_vector(31 downto 0);
	signal MemWrite: std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Datapath PORT MAP (
          AB1 => AB1,
          IB1 => IB1sig,
          AB2 => AB2,
          DB2 => DB2,
          DB3 => DB3,
			 memWrite => MemWrite,
          reset => reset,
          clock => clock
        );
		  
memory: memory_unit PORT MAP(
	ab1 => AB1,
	--ib1 => IB1sig,
	ab2 => AB2,
	db2 => DB2,
	db3 => DB3,
	write_en => MemWrite,
	clear =>reset,
	clock => clock
	);

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		reset<='1';
		wait for clock_period;
		reset<='0';
      wait for clock_period*10.5;

      -- insert stimulus here 

--IB1<="00000000001000010001100000000011";
--	   wait for clock_period;
		IB1sig<="00000000000000010001100000100000";
		     wait for clock_period;
	  	IB1sig<="00000000001000110001100000100000";--r3+1
             wait for clock_period;
        IB1sig<="00000000001000110001100000100000";--r3+1
               wait for clock_period;
        IB1sig <="00001000000000000000000000000111"; --jump to pc 7
             wait for clock_period;
        IB1sig<="00000000001000110001100000100000";--r3+1
             wait for clock_period;
        IB1sig<="00000000001000110001100000100000";--r3+1
                  wait for clock_period;
        IB1sig<="00000000001000110001100000100000";--r3+1
                       wait for clock_period;
        IB1sig<="00000000001000110001100000100000";--r3+1
                            wait for clock_period;
--     wait for clock_period;
--      wait;
   end process;

END;
