----------------------------------------------------------------------------------
--NET2FPGA_base_DAC module
 
--MIT License
--Copyright (c) 2019 Pau Gomez Kabelka <paugomezkabelka@gmail.com>
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity NET2FPGA_base_DAC is
    Port ( clk : in STD_LOGIC;
    	   dac_clk : in STD_LOGIC;
           dac_data1 : in STD_LOGIC_VECTOR (13 downto 0);
           dac_data2 : in STD_LOGIC_VECTOR (13 downto 0);
           dac_dat_o : out STD_LOGIC_VECTOR (13 downto 0);
           dac_clk_o: out STD_LOGIC;
           dac_wrt_o: out STD_LOGIC;
           dac_sel_o: out STD_LOGIC;
           dac_rst_o: out STD_LOGIC);
end NET2FPGA_base_DAC;

architecture Behavioral of NET2FPGA_base_DAC is
	signal  dac_data1_reg :  STD_LOGIC_VECTOR (13 downto 0);
    signal  dac_data2_reg :  STD_LOGIC_VECTOR (13 downto 0);
	
	begin
		
		process(clk)
		begin
			if rising_edge(clk) then
				dac_data1_reg<=dac_data1;
				dac_data2_reg<=dac_data2;
			end if;
		end process;

	dac_rst_o<='0';
	
	ODDR_dac_clk : ODDR
		generic map(
		DDR_CLK_EDGE => "SAME_EDGE", -- "OPPOSITE_EDGE" or "SAME_EDGE"
		INIT => '0', -- Initial value for Q port ('1' or '0')
		SRTYPE => "SYNC") -- Reset Type ("ASYNC" or "SYNC")
		port map (
		Q => dac_clk_o, -- 1-bit DDR output
		C => dac_clk, -- 1-bit clock input
		CE => '1', -- 1-bit clock enable input
		D1 => '1', -- 1-bit data input (positive edge)
		D2 => '0', -- 1-bit data input (negative edge)
		R => '0', -- 1-bit reset input
		S => '0' -- 1-bit set input
		);
	
	ODDR_dac_wrt : ODDR
		generic map(
		DDR_CLK_EDGE => "SAME_EDGE", -- "OPPOSITE_EDGE" or "SAME_EDGE"
		INIT => '0', -- Initial value for Q port ('1' or '0')
		SRTYPE => "SYNC") -- Reset Type ("ASYNC" or "SYNC")
		port map (
		Q => dac_wrt_o, -- 1-bit DDR output
		C => dac_clk, -- 1-bit clock input
		CE => '1', -- 1-bit clock enable input
		D1 => '1', -- 1-bit data input (positive edge)
		D2 => '0', -- 1-bit data input (negative edge)
		R => '0', -- 1-bit reset input
		S => '0' -- 1-bit set input
		);
			
	ODDR_dac_sel : ODDR
		generic map(
		DDR_CLK_EDGE => "SAME_EDGE", -- "OPPOSITE_EDGE" or "SAME_EDGE"
		INIT => '0', -- Initial value for Q port ('1' or '0')
		SRTYPE => "SYNC") -- Reset Type ("ASYNC" or "SYNC")
		port map (
		Q => dac_sel_o, -- 1-bit DDR output
		C => clk, -- 1-bit clock input
		CE => '1', -- 1-bit clock enable input
		D1 => '0', -- 1-bit data input (positive edge)
		D2 => '1', -- 1-bit data input (negative edge)
		R => '0', -- 1-bit reset input
		S => '0' -- 1-bit set input
		);	

	GEN_ODDR_dac_dat: for i in 0 to 13 generate
		ODDR_dac_dat : ODDR
			generic map(
			DDR_CLK_EDGE => "SAME_EDGE", -- "OPPOSITE_EDGE" or "SAME_EDGE"
			INIT => '0', -- Initial value for Q port ('1' or '0')
			SRTYPE => "SYNC") -- Reset Type ("ASYNC" or "SYNC")
			port map (
			Q => dac_dat_o(i), -- 1-bit DDR output
			C => clk, -- 1-bit clock input
			CE => '1', -- 1-bit clock enable input
			D1 => dac_data1_reg(i), -- 1-bit data input (positive edge)
			D2 => dac_data2_reg(i), -- 1-bit data input (negative edge)
			R => '0', -- 1-bit reset input
			S => '0' -- 1-bit set input
			);	
	end generate GEN_ODDR_dac_dat;

end Behavioral;

