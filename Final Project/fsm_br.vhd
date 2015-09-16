library ieee;
use ieee.std_logic_1164.all;

entity fsm_br is 
	port(clk, rst_bar, term, sr_busy: in std_logic;
	en_buff, en_load, busy : out std_logic);
end fsm_br;

architecture fsm_br_arch of fsm_br is
subtype state is std_logic_vector(1 downto 0);
signal present_state, next_state : state;  
-- states definition...
constant buff_empty : state := "00";  
constant buff_load : state := "01";	
constant buff_full : state := "10";
constant buff_shift : state := "11";  

begin
	
	state_reg: process(clk)
	begin
		if rising_edge(clk) then
			if rst_bar = '0' then
				present_state <= buff_empty;
			else
				present_state <= next_state;
			end if;
		end if;	
	end process;
	
	nxt_state: process(term, sr_busy, present_state)
	begin
		case present_state is
			
			when buff_empty =>
			if term = '1' then
				next_state <= buff_load;
			else
				next_state <= buff_empty;
			end if;
			
			when buff_load => next_state <= buff_full;
			
			when buff_full =>
			if sr_busy = '1' then 
				next_state <= buff_full;
			else
				next_state <= buff_shift;
			end if;
			
			when buff_shift => next_state <= buff_empty;
			
			when others => next_state <= buff_empty;
		
		end case;  
	end process;
		
	output: process(present_state)
	begin
		case present_state is
			when buff_empty => en_buff <= '0'; en_load <= '0'; busy <= '0';
			when buff_load => en_buff <= '1'; busy <= '1'; en_load <= '0';
			when buff_full => busy <= '1'; en_buff <= '0'; en_load <= '0';
			when buff_shift => en_load <= '1'; busy <= '1'; en_buff <= '0';	 
			when others => null;
		end case;
	end process;
	
end fsm_br_arch;
	
		



