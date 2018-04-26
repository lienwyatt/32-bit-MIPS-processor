
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:54:03 04/06/2018 
-- Design Name: 
-- Module Name:    memory_unit - Behavioral 
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
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memory_unit is
port
(
ab1: in std_logic_vector(31 downto 0); -- pc (address of instruction)
ib1: out std_logic_vector(31 downto 0); -- instruction fetched from memory

ab2: in std_logic_vector(31 downto 0); --  address of data (to be fetched or written to)
db2: in std_logic_vector(31 downto 0); -- carries the data to be written to memory
write_en : in std_logic; -- write enable
db3: out std_logic_vector(31 downto 0); -- data out

clear: in std_logic; -- clear bit (for data memory)
clock : in std_logic -- clock signal
);
end memory_unit;

architecture Behavioral of memory_unit is

signal inst_addr : std_logic_vector(31 downto 0);
signal inst : std_logic_vector(31 downto 0); -- instruction that'll go out on ib1

signal data_addr : std_logic_vector(31 downto 0);
signal data_in : std_logic_vector(31 downto 0);
signal data_out : std_logic_vector(31 downto 0);


-- size of memory is 64x32 (64 32-bit locations)
type rom is array (0 to 63) of std_logic_vector(31 downto 0);
type ram is array (0 to 63) of std_logic_vector(31 downto 0);

--instruction memory
--instruction memory (count instances progeam). Remove spaces before implementing. They are for documentation/debug purposes
constant inst_mem : rom :=  
(
"11111100000000000000000000000000", "10001100000000100000000000011100", "00000000000000000011000000100000","00000000000000000011000000100000", "11111100100000000000000000010101", 
"10001100101000110000000000000000", "00010000101000100000000000001000", "11111100000000000000000000000000", "11111100000000000000000000000000", 
"00100000011000110000000000000001", "00010100011001000000000000000101", "11111100000000000000000000000000", "11111100000000000000000000000000", 
"11111100000000000000000000000000", "00000000110000010011000000100000", "11111100000000000000000000000000", "11111100000000000000000000000000", 
"00001000000000000000000001010100", "11111100000000000000000000000000", "11111100000000000000000000000000", "10101100110000000000000000100000", 
"11111100000000000000000000000000", "11111100000000000000000000000000", "11111100000000000000000000000000", "11111100000000000000000000000000", 
"11111100000000000000000000000000", "11111100000000000000000000000000", "11111100000000000000000000000000", "11111100000000000000000000000000", 
"11111100000000000000000000000000", "11111100000000000000000000000000", "11111100000000000000000000000000", "11111100000000000000000000000000", 
"11111100000000000000000000000000", "11111100000000000000000000000000", "11111100000000000000000000000000", "11111100000000000000000000000000", 
"11111100000000000000000000000000", "11111100000000000000000000000000", "11111100000000000000000000000000", "11111100000000000000000000000000", 
"11111100000000000000000000000000", "11111100000000000000000000000000", "11111100000000000000000000000000", "11111100000000000000000000000000", 
"11111100000000000000000000000000", "11111100000000000000000000000000", "11111100000000000000000000000000", "11111100000000000000000000000000", 
"11111100000000000000000000000000", "11111100000000000000000000000000", "11111100000000000000000000000000", "11111100000000000000000000000000", 
"11111100000000000000000000000000", "11111100000000000000000000000000", "11111100000000000000000000000000", "11111100000000000000000000000000", 
"11111100000000000000000000000000", "11111100000000000000000000000000", "11111100000000000000000000000000", "11111100000000000000000000000000", 
"11111100000000000000000000000000", "11111100000000000000000000000000", "11111100000000000000000000000000" --"11111100000000000000000000000000"
);

--DATA Memory. In this example the array is searched for "110" or 6, the destination is on line 31, location 0x20. It should find 3 instances.
signal data_mem : ram := 
(
"00000000000000000000000000000001", "00000000000000000000000000001100", "00000000000000000000000000000110", "00000000000000000000000000000110", 
"00000000000000000000000000000001", "00000000000000000000000000000110", "00000000000000000000000000000001", "00000000000000000000000000000101", 
"00000000000000000000000000001111", "00000000000000000000000000000011", "00000000000000000000000000000001", "00000000000000000000000000000011", 
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000111", "00000000000000000000000000000001", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000000", "00000000000000000000000000000100", "00000000000000000000000000000000", "00000000000000000000000000000001", 
"00000000000000000000000000000110", "00000000000000000000000000001000", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000"
);

--data memory
constant data_mem_cleared : ram := 
(
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", 
"00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000", "00000000000000000000000000000000" 
);


begin

inst_addr <= ab1;
data_addr <= ab2;
data_in <= db2;

-- process to get next instruction
process(clock)
begin
	if(clock = '1' and clock' event) then
		inst <= inst_mem(to_integer(unsigned(inst_addr))/4);
	end if;
end process;

--process to read/write data, data memory can be cleared as well
process(clock, clear)
begin
	if(clear = '1') then
		data_mem <= data_mem_cleared;
	else
		if(clock = '1' and clock' event) then
			-- write data to memory
			if(write_en = '1') then
				data_mem(to_integer(unsigned(data_addr))) <= data_in;
			end if;
			data_out <= data_mem(to_integer(unsigned(data_addr))); -- read data
		end if;
	end if;
end process;

ib1 <= inst;
db3 <= data_out;


end Behavioral;
