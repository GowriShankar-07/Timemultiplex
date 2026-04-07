----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:35:45 10/16/2025 
-- Design Name: 
-- Module Name:    display_with_counter - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display_with_counter is
    Port (
        Clk      : in  std_logic;                   -- FPGA clock
        Clr      : in  std_logic;
        seg      : out std_logic_vector(6 downto 0); -- segments a-g
        digit_en : out std_logic_vector(3 downto 0)  -- digit enable
    );
end display_with_counter;

architecture Behavioral of display_with_counter is

    -- Signals
    signal BCD_out      : std_logic_vector(15 downto 0);
    signal refresh_cnt  : unsigned(12 downto 0) := (others => '0');  -- adjust for refresh
    signal digit_select : unsigned(1 downto 0) := "00";
    signal seg_out      : std_logic_vector(6 downto 0);

    -------------------------------------------------------------------
    -- Function: BCD to 7-segment
    -------------------------------------------------------------------
    function BCD_to_7Seg(B : std_logic_vector(3 downto 0)) return std_logic_vector is
        variable seg : std_logic_vector(6 downto 0);
    begin
        case B is
            when "0000" => seg := "0000001"; -- 0
            when "0001" => seg := "1001111"; -- 1
            when "0010" => seg := "0010010"; -- 2
            when "0011" => seg := "0000110"; -- 3
            when "0100" => seg := "1001100"; -- 4
            when "0101" => seg := "0100100"; -- 5
            when "0110" => seg := "0100000"; -- 6
            when "0111" => seg := "0001111"; -- 7
            when "1000" => seg := "0000000"; -- 8
            when "1001" => seg := "0000100"; -- 9
            when others => seg := "1111111"; -- blank
        end case;
        return seg;
    end function;

    -------------------------------------------------------------------
    -- Instantiate your 4-digit BCD counter
    -------------------------------------------------------------------
    component counter_4digit is
        Port ( Clk : in  STD_LOGIC;
               Clr : in  STD_LOGIC;
               bcd : out  STD_LOGIC_VECTOR (15 downto 0));
    end component;
	 
	 component clk_div is
		 Port ( clk : in  STD_LOGIC;
				  rst : in  STD_LOGIC;
				  clk_out : out  STD_LOGIC);
	 end component;
signal c_inter: std_logic;
begin
		
	 freq_div: clk_div port map( clk, Clr, c_inter);
    counter: counter_4digit port map(
        Clk => c_inter,
        Clr => Clr,
        bcd => BCD_out
    );

    -------------------------------------------------------------------
    -- Refresh counter for multiplexing digits
    -------------------------------------------------------------------
    process(Clk, Clr)
    begin
        if Clr='1' then
            refresh_cnt  <= (others=>'0');
            digit_select <= "00";
        elsif rising_edge(Clk) then
            refresh_cnt <= refresh_cnt + 1;
            if refresh_cnt = 4999 then  -- adjust for ~4kHz total refresh
                refresh_cnt <= (others=>'0');
                digit_select <= digit_select + 1;
            end if;
        end if;
    end process;

    -------------------------------------------------------------------
    -- Select current BCD digit and convert to 7-segment
    -------------------------------------------------------------------
    process(digit_select, BCD_out)
    begin
        case digit_select is
            when "00" => seg_out <= BCD_to_7Seg(BCD_out(3 downto 0));
            when "01" => seg_out <= BCD_to_7Seg(BCD_out(7 downto 4));
            when "10" => seg_out <= BCD_to_7Seg(BCD_out(11 downto 8));
            when "11" => seg_out <= BCD_to_7Seg(BCD_out(15 downto 12));
            when others => seg_out <= "1111111";
        end case;
    end process;

    seg <= seg_out;

    -------------------------------------------------------------------
    -- Generate active-low digit enable signals
    -------------------------------------------------------------------
    process(digit_select)
    begin
        case digit_select is
            when "00" => digit_en <= "1110";
            when "01" => digit_en <= "1101";
            when "10" => digit_en <= "1011";
            when "11" => digit_en <= "0111";
            when others => digit_en <= "1111";
        end case;
    end process;

end Behavioral;
