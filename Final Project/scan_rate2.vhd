-------------------------------------------------------------------------------
--
-- Title       : scan_rate2.vhd
-- Design      : lab10
-- Author      : Zhaoqi, David
-- Company     : CEAS      
--
-------------------------------------------------------------------------------
--
-- File        : scan_rate2.vhd
-- Generated   : Mon April 6th, 2015
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.20
-- 	
-------------------------------------------------------------------------------
-- Arthor : Zhaoqi Li, David Eberhard	
-- Lab Section 02
-- Lab 10:  Walking 0 Key Matrix Scan and Encoder II
-------------------------------------------------------------------------------
--
-- Ports	   : reset_bar - Scalar input, synchronous reset, active low, 
--                           clears clock divisor output
--		 		 clk       - Scalar input, clock signal
--		 		 q		   - Scalar output, outputs the divided clock signal
--				 
--
-- Description : This file describes a clock prescaler, which divides the input
--               clock signal by a generic integer variable. The prescaler has 
--				 scalar inputs clk and reset_bar, and scalar output q. The 
--				 frequency of the clock signal output at q is equal to the 
--				 frequency the input clock devided by the value of the generic
--               prescalar. Applying a 0 to reset_bar will clear the output of 
--				 the prescaler and reset the internal clounter used to determine
--               the clock output at the next rising edge of the input clock.
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity scan_rate2 is
	generic (prescalar : integer := 4);-- divisor value
	port (clk : in std_logic;-- clock input
		reset_bar : in std_logic;-- active low synchronous reset
		q : out std_logic-- output clock frequency
	);
end scan_rate2;	

architecture gen_arch of scan_rate2 is
begin
	pscal: process(clk)	 				 
	variable count_v: integer range prescalar downto 0;
	begin								 
		if rising_edge(clk) then
			if reset_bar = '0' then 
				count_v := prescalar - 1;  
				q <= '0';
			else
				case count_v is
					when 0 => count_v := prescalar - 1;
					when others => count_v := count_v - 1;
				end case; 	
				if count_v = 0 then
					q <= '1';
				else
					q <= '0';
				end if;
			end if;
		 end if;   
	end process;  
end gen_arch;