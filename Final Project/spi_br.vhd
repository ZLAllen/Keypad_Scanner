library ieee;
use ieee.std_logic_1164.all;

entity spi_br is
	port(en_buff, rst_bar, clk : in std_logic;
	key_code : in std_logic_vector(4 downto 0);
	data : out std_logic_vector(7 downto 0)
	);
end spi_br;

architecture spi_br_arch of spi_br is 
signal buff_reg : std_logic_vector(7 downto 0);
begin
	reg: process(clk) 
	begin
		if rising_edge(clk) then
			if rst_bar = '0' then
				buff_reg <= (others => '0' );
			elsif en_buff = '1' then
				buff_reg <= "000" & key_code;
			end if;
			data <=  buff_reg;
		end if;
	end process;
end spi_br_arch;

		
			
				