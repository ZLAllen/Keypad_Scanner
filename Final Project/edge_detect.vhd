library ieee;
use ieee.std_logic_1164.all;

entity edge_detect is
	port(sck, clk : in std_logic;
	en_shift_2 : out std_logic);
end edge_detect;

architecture edge_arch of edge_detect is
signal sck_delay : std_logic;
begin
	edge: process(clk)
	begin
		if clk = '1' and clk'event then
			sck_delay <= sck;
		end if;
	end process; 
	
	trigger: process(clk)
	variable sck_tran: std_logic_vector(1 downto 0);
	begin
		if rising_edge(clk) then
			sck_tran := sck_delay&sck;
			case std_logic_vector'(sck_delay,sck) is
				when "10" => en_shift_2 <= '1';
				when others => en_shift_2 <= '0';
			end case;
		end if;
	end process;	
end edge_arch;

			