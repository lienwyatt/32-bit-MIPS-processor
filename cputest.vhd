----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2018 04:09:03 PM
-- Design Name: 
-- Module Name: Datapth_testbench - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
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
         reset : IN  std_logic;
         clock : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal IB1 : std_logic_vector(31 downto 0) := (others => '0');
   signal DB3 : std_logic_vector(31 downto 0) := (others => '0');
   signal reset : std_logic := '0';
   signal clock : std_logic := '0';

 	--Outputs
   signal AB1 : std_logic_vector(31 downto 0);
   signal AB2 : std_logic_vector(31 downto 0);
   signal DB2 : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Datapath PORT MAP (
          AB1 => AB1,
          IB1 => IB1,
          AB2 => AB2,
          DB2 => DB2,
          DB3 => DB3,
          reset => reset,
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
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clock_period*9.5;

      -- insert stimulus here 
     IB1 <="11111100001000000001000000000000"; 
     wait for clock_period;
		IB1<="00000000001000010001100000000001";
	   wait for clock_period;
	  IB1 <="00100000001001100010000000000100"; 
     wait for clock_period;
      IB1 <="11111100001000000010100000000000"; 
      wait;
   end process;

END;

