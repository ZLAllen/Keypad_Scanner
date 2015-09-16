library ieee;
use ieee.std_logic_1164.all;

entity fsm_sr is
	port(rst_bar, clk, ss_bar, en_load: in std_logic;
	sr_busy, en_shift_1, en_miso, dav: out std_logic);
end fsm_sr;

architecture fsm_sr_arch of fsm_sr is
subtype state is std_logic_vector(1 downto 0);
signal present_state, next_state : state;
constant shift_empty : state := "00";
constant data_valid : state := "01";
constant shift_bit : state := "10";

begin
	state_reg: process(clk)
	begin
		if rising_edge(clk) then
			if rst_bar = '0' then
				present_state <= shift_empty;
			else
				present_state <= next_state;
			end if;
		end if;	 
	end process;
	
	nxt_state : process(en_load, ss_bar, present_state)
	begin
		case present_state is
			when shift_empty => 
			if en_load = '1' then
				next_state <= data_valid;
			else
				next_state <= shift_empty;
			end if;
			
			when data_valid => 
			if ss_bar = '0' then
				next_state <= shift_bit;
			else
				next_state <= data_valid;
			end if;
			
			when shift_bit =>
			if ss_bar = '1' then
				next_state <= shift_empty;
			else
				next_state <= shift_bit;
			end if;
			
			when others => next_state <= shift_empty;
		end case;	 
	end process;  
	
	output: process(present_state)
	begin
		case present_state is
			when shift_empty => sr_busy <= '0'; en_shift_1 <= '0'; en_miso <= '0'; dav <= '0'; 
			when data_valid => sr_busy <= '1'; en_shift_1 <= '0'; en_miso <= '0'; dav <= '1';
			when shift_bit => sr_busy <= '1'; en_shift_1 <= '1'; en_miso <= '1'; dav <= '0';
			when others => null;
		end case;
	end process;

end fsm_sr_arch;
	
		
			
		
			