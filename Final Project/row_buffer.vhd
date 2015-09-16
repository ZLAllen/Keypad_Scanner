library ieee;
use ieee.std_logic_1164.all;

entity row_buffer is
	port(
	row_in : in std_logic_vector(3 downto 0);
	row_driver: out std_logic_vector(3 downto 0)
	);
end row_buffer;

architecture behavioral_3 of row_buffer is
begin
	buff: process(row_in)
	variable index: Integer range 0 to 4;
	variable output : std_logic_vector(3 downto 0);
	begin
		index := 4; 	-- index will be sitting at default case   
		output := (others => 'Z');
		for i in 3 downto 0 loop
			if row_in(i) = '0' then
				index := i;
				exit;
			end if;
		end loop;
		if (index >= 0) and (index < 4) then -- no 0 found will cause output to be "ZZZZ"
			output(index) := '0';
		end if;
		row_driver <= output;	 
	end process;
end behavioral_3;

		
			