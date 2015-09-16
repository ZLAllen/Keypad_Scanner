library ieee;
use ieee.std_logic_1164.all;

entity spi_sr is
	port(rst_bar, clk, en_load, en_miso,
		en_shift_1,en_shift_2 : in std_logic;
		data : in std_logic_vector(7 downto 0);
	  	miso : out std_logic
	);
end spi_sr;	

architecture spi_sr_arch of spi_sr is
signal shift_reg : std_logic_vector(7 downto 0);
begin
	reg: process(clk)
	begin
		if rising_edge(clk) then
			if rst_bar = '0' then
				shift_reg <= (others => '0'); 
			elsif en_load = '1' then
				shift_reg <= data; 
			elsif en_shift_1 = '1' and en_shift_2 = '1' then
				shift_reg <= shift_reg(6 downto 0) & '0';
			end if;
		end if;	   
	end process;
	
	miso <= shift_reg(7) when en_miso = '1' else 'Z'; 
		
end spi_sr_arch;
	
		
			
				
  