----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:57:22 10/16/2025 
-- Design Name: 
-- Module Name:    T_FF_PC - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity T_FF_PC is
    Port ( T : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           Q : out  STD_LOGIC;
           Qn : out  STD_LOGIC;
           Clr : in  STD_LOGIC);
end T_FF_PC;

architecture Behavioral of T_FF_PC is

signal qtemp : std_logic := '0';
begin
	process(Clk, Clr)
	begin
		if CLR ='1' then
			qtemp <= '0';
		elsif rising_edge(CLK) then
			if T = '1' then
				qtemp <= not qtemp;
			end if;
		end if;
	end process;
	Q <= qtemp;
	Qn <= not qtemp;

end Behavioral;

