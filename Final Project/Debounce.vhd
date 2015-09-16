---------------------------------------------------------------------------------------------------
--
-- Title       : debounce.vhd
-- Design      : scan2
-- Author      : kls
-- Company     : 
--
---------------------------------------------------------------------------------------------------
--
-- File        : debounce.vhd
-- Generated   : 3/21/15, 11:59 AM
-- From        : $DSN\src\scan2.vhd
-- By          : Active-HDL Built-in Test Bench Generator
--
---------------------------------------------------------------------------------------------------
--
-- Description : a program to delay and sample the period of keypress in order to clear the potential 
-- bounce of each keypress. This program is using a single shot reset approach to detect each bounce and 
-- wait until the keypress signal become stable...
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debounce is
	generic (d : positive := 65535);
	port( a: in std_logic;
	rst_bar : in std_logic;
	clk : in std_logic;
	q_bar: out std_logic;
	term: inout std_logic
	);
end debounce;

architecture gen_arch of debounce is 
signal a_delayed, a_nedg: std_logic;
signal count: Integer range 0 to 65536;

begin
	
	delayed: process(clk)
	begin
		if rising_edge(clk) then
			a_delayed <= a;
		end if;
	end process;
	
	trigger: process(a, a_delayed)
	variable a_tran: std_logic_vector(1 downto 0);
	begin  
		a_tran := a_delayed&a;
		case a_tran is
			when "10" => a_nedg <= '1';
			when others => a_nedg <= '0';
		end case;
	end process;	

	
	pulse_duration: process(clk)
	begin
		if rising_edge(clk) then
			if rst_bar = '0' then
				count <= 0;
			elsif a_nedg = '1' then
				count <= d;
			else
				if count /= 0 then
					count <= count - 1;	
				else
					count <= 0;
				end if;
			end if;
		end if;
	end process;
	
	reg_output: process(clk)
	variable flag : std_logic;
	begin
		if rising_edge(clk) then
			if rst_bar = '0' then
				q_bar <= '1';	 
				term <= '0';
				flag := '0';
			elsif count = 0 then
				q_bar <= '1';
				term <= '0';
			else
				q_bar <= '0';
				if count = 1 and a = '0' and flag = '0' then 
					term <= '1'; 	  
					flag := '1';	
				end if;	
				
				if a = '1' then
					flag := '0';
				end if;

			end if;
		end if;
	end process;
end gen_arch;
	
			
				
					
					
					
					
					
					