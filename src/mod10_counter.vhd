----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:07:17 10/16/2025 
-- Design Name: 
-- Module Name:    mod10_counter - Structural 
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

entity mod10_counter is
    Port ( Clk_in : in  STD_LOGIC;
           Clr : in  STD_LOGIC;
           Qout : out  STD_LOGIC_VECTOR (3 downto 0);
           Clk_out : out  STD_LOGIC);
end mod10_counter;

architecture Structural of mod10_counter is

component T_FF_PC is
    Port ( T : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           Q : out  STD_LOGIC;
           Qn : out  STD_LOGIC;
           Clr : in  STD_LOGIC);
end component;

component and_gate is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           c : out  STD_LOGIC);
end component;

component or_gate is
    Port ( x : in  STD_LOGIC;
           y : in  STD_LOGIC;
           z : out  STD_LOGIC);
end component;

signal qtemp: std_logic_vector(3 downto 0);
signal n_qtemp3 : std_logic;
signal T_in: std_logic_vector(3 downto 0) := "0001";
signal s0, s1: std_logic;

begin
	T_in(0) <= '1';
	n_qtemp3 <= not qtemp(3);
	
	A0: and_gate port map (qtemp(0), n_qtemp3, T_in(1));
	A1: and_gate port map (qtemp(0), qtemp(1), T_in(2));
	A2: and_gate port map (T_in(2), qtemp(2), s0);
	A3: and_gate port map (qtemp(3), qtemp(0), s1);
	
	or1: or_gate port map (s0,s1,T_in(3));
	

	FF0: T_FF_PC port map (T_in(0),Clk_in,qtemp(0),open,Clr );
	FF1: T_FF_PC port map (T_in(1),Clk_in,qtemp(1),open,Clr );
	FF2: T_FF_PC port map (T_in(2),Clk_in,qtemp(2),open,Clr );
	FF3: T_FF_PC port map (T_in(3),Clk_in,qtemp(3),open,Clr );
	
	Qout<=qtemp;
	
	Clk_out<=not qtemp(3);

end Structural;

