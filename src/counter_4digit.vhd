----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:33:57 10/16/2025 
-- Design Name: 
-- Module Name:    counter_4digit - Behavioral 
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

entity counter_4digit is
    Port ( Clk : in  STD_LOGIC;
           Clr : in  STD_LOGIC;
           bcd : out  STD_LOGIC_VECTOR (15 downto 0));
end counter_4digit;

architecture Structural of counter_4digit is

component mod10_counter is
    Port ( Clk_in : in  STD_LOGIC;
           Clr : in  STD_LOGIC;
           Qout : out  STD_LOGIC_VECTOR (3 downto 0);
           Clk_out : out  STD_LOGIC);
end component;

signal clk0, clk1, clk2 : std_logic;
begin

		D0: mod10_counter port map (Clk, Clr, bcd(3 downto 0), clk0);
		D1: mod10_counter port map (clk0, Clr, bcd(7 downto 4), clk1);
		D2: mod10_counter port map (clk1, Clr, bcd(11 downto 8), clk2);
		D3: mod10_counter port map (clk2, Clr, bcd(15 downto 12), open);
		

end Structural;

