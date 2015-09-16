library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;

entity key_encoder is
    port(
	col_in:in std_logic_vector(4 downto 0); --input
	row_in:in std_logic_vector(3 downto 0); --input
	key_code : out std_logic_vector(4 downto 0); -- output
	kp_bar : out std_logic -- indicates keypress 
	);
end key_encoder;  

architecture behavioral_4 of key_encoder is 
begin
	enc: process(col_in, row_in)
	variable col_cnt, row_cnt, r_cnt: Integer range 0 to 40;
	variable keypressed: std_logic;
	begin
		keypressed := '1';
		for i in 0 to 4 loop
			if col_in(i) = '0' then
				keypressed := '0';
				col_cnt := i;
				exit;
			end if;
		end loop;
		kp_bar <= keypressed;
		for j in 0 to 3 loop
			if row_in(j) = '0' then
				row_cnt := j;
				exit;
			end if;
		end loop;
		if(keypressed = '1') then
			key_code <= std_logic_vector(to_unsigned(20,5));
		else
			r_cnt := col_cnt + row_cnt*5;  
			key_code <= std_logic_vector(to_unsigned(r_cnt, 5));
		end if;
	end process;
end behavioral_4;

