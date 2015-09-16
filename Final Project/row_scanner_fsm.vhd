library ieee;
use ieee.std_logic_1164.all;

entity row_scanner_fsm is 
	port (rst_bar : in std_logic; -- synchronous active low reset
	clk : in std_logic; -- clk
	en1, en2 : in std_logic; -- active high enable inputs
	qout : out std_logic_vector(3 downto 0) -- output
	);
end row_scanner_fsm;

architecture moore_fsm of row_scanner_fsm is  
type state is array(3 downto 0) of std_logic;
signal present_state, next_state: state;	 	  

constant row_0: state := "1110"; 
constant row_1: state := "1101";
constant row_2: state := "1011";
constant row_3: state := "0111";		 

begin									
	state_reg: process(clk)
	begin
		if rising_edge(clk) then 
			if rst_bar = '0' then
				present_state <= "1110";
			elsif en1 = '1' and en2 = '1' then
				present_state <= next_state;		 
			end if;	
		end if;
	end process;   
	
	nxt_state: process(present_state, clk)
	begin 
		case present_state is
			when row_0 => next_state <= row_1;
			when row_1 => next_state <= row_2;
			when row_2 => next_state <= row_3;
			when others => next_state <= row_0;	
		end case;  
	end process;
	
	qout <= std_logic_vector(present_state);
	
end moore_fsm;
		
	