--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:51:16 02/15/2018
-- Design Name:   
-- Module Name:   C:/Users/Jesse Coma/ALU/alu_test.vhd
-- Project Name:  ALU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU
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
 
ENTITY alu_test IS
END alu_test;
 
ARCHITECTURE behavior OF alu_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         inputA : IN  std_logic_vector(31 downto 0);
         inputB : IN  std_logic_vector(31 downto 0);
         op : IN  std_logic_vector(5 downto 0);
         func : IN  std_logic_vector(3 downto 0);
         output : OUT  std_logic_vector(31 downto 0);
         ovrf : OUT  std_logic;
         carryout : OUT  std_logic;
         zero : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal inputA : std_logic_vector(31 downto 0) := (others => '0');
   signal inputB : std_logic_vector(31 downto 0) := (others => '0');
   signal op : std_logic_vector(5 downto 0) := (others => '0');
   signal func : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal output : std_logic_vector(31 downto 0);
   signal ovrf : std_logic;
   signal carryout : std_logic;
   signal zero : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          inputA => inputA,
          inputB => inputB,
          op => op,
          func => func,
          output => output,
          ovrf => ovrf,
          carryout => carryout,
          zero => zero
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
	InputA <= "11111111111111111111111111111110";
	InputB <= "00000000000000000000000000000001";
	op <= "000000";
	func <= "0001";
	
--    InputA <= "11111111111111111111111111111111";
--    InputB <= "00000000000000000000000000000001";
--    op <= "000000";
--    func <= "0000";
    
--    InputA <= x"fffffff7";
--	InputB <= x"00000007";
--	op <= "000000";
--	func <= "0010";

      -- insert stimulus here 

      wait;
   end process;

END;
