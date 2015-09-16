library ieee;
use ieee.std_logic_1164.all;
  
entity scan4 is
port(
clk : in std_logic;-- clock input
rst_bar : in std_logic;-- active low reset
col_input : in std_logic_vector(4 downto 0);-- col. input from keypad
sck : in std_logic; -- serial clock
ss_bar : in std_logic; -- slave select
row_out : out std_logic_vector(3 downto 0);-- row output to keypad
dav : out std_logic; -- data valid flag
miso : out std_logic; -- master in slave out serial data
busy : out std_logic -- busy flag, no key presses are accepted
);
   attribute loc : string;
   attribute loc of clk : signal is "93";
   attribute loc of rst_bar : signal is "81";
   attribute loc of col_input : signal is "57,56,55,54,53";
   attribute loc of row_out : signal is "64,63,62,61";
   attribute loc of sck : signal is "98";
   attribute loc of miso : signal is "97";
   attribute loc of ss_bar : signal is "96";
--   attribute loc of term : signal is "5";
   attribute loc of busy : signal is "79";
   attribute loc of dav : signal is "80";
--   attribute loc of key_code : signal is "69,50,51,67,66";	
end scan4;
	
architecture structure of scan4 is 
signal pscal : std_logic;	 
signal kp_sig: std_logic;  
signal q_sig: std_logic; 
signal reg_sig: std_logic;	
signal row_scan: std_logic_vector(3 downto 0); 
signal keycode_sig: std_logic_vector(4 downto 0);  
signal keycode_reg: std_logic_vector(4 downto 0);
signal sr_busy, en_buff, en_load, en_shift_1, en_shift_2, en_miso: std_logic;
signal data : std_logic_vector(7 downto 0);
begin
	u0: entity scan_rate2 port map(clk => clk, reset_bar => rst_bar, q => pscal);
		
	u1: entity row_scanner_fsm port map(clk => clk, en1 => q_sig, en2 => pscal,
		rst_bar => rst_bar, qout => row_scan); 
		
	u2: entity row_buffer port map(row_in => row_scan, row_driver => row_out);
		
	u3: entity key_encoder port map(col_in => col_input, row_in => row_scan,
		key_code => keycode_sig, kp_bar => kp_sig);	 
		
	u4: entity debounce port map(a => kp_sig, rst_bar => rst_bar, clk => clk, 
		q_bar => q_sig, term => reg_sig);  
		
	u5: entity keycode_reg port map(clk => clk, rst_bar => rst_bar, enable => reg_sig,
		d => keycode_sig, oe_bar => ss_bar, q => keycode_reg, dav => dav);	
	
	u6: entity fsm_br port map(clk => clk, rst_bar => rst_bar, term => reg_sig,
		sr_busy => sr_busy, en_buff => en_buff, en_load => en_load, busy => busy);
		
	u7: entity fsm_sr port map(clk => clk, rst_bar => rst_bar, ss_bar => ss_bar,
		en_load => en_load, sr_busy => sr_busy, en_shift_1 => en_shift_1,
		en_miso => en_miso, dav => dav);
	
	u8: entity spi_br port map(clk => clk, rst_bar => rst_bar, en_buff => en_buff,
		key_code => keycode_reg, data => data);
		
	u9: entity spi_sr port map(clk => clk, rst_bar => rst_bar, en_load => en_load, 
		en_miso => en_miso, en_shift_1 => en_shift_1, en_shift_2 => en_shift_2,
		data => data, miso => miso);
	
	uA: entity edge_detect port map(clk => clk, sck => sck, en_shift_2 => en_shift_2);	
		
end structure;