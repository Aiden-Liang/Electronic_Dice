-- CA: Cellular Automata (based on RNG circuit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_BIT.all;

entity Cell_of_RNG_4_inputs is
port ( Cell_addr: in std_logic_vector(3 downto 0); -- each Cell has 4-inputs
	   CLK, RST: in std_logic;
	   FF_initi: in std_logic; -- initial Flip-Flop Value
	   Y: out std_logic );
end Cell_of_RNG_4_inputs;

architecture Cell_behavior of Cell_of_RNG_4_inputs is
signal X: std_logic;

begin 
	with Cell_addr select  -- design LUT(Look-Up-Table) 
	X <= '1' when "0000",
		 '0' when "0001",
		 '1' when "0010",
		 '0' when "0011",
		 '0' when "0100",
		 '0' when "0101",
		 '1' when "0110",
		 '1' when "0111",
		 '0' when "1000",
		 '1' when "1001",
		 '0' when "1010",
		 '1' when "1011",
		 '1' when "1100",
		 '0' when "1101",
		 '0' when "1110",
		 '1' when "1111",
		 '0' when others;
	
	process(CLK)  -- Look-Up-Table Behavior
	begin
		if (rising_edge(CLK)) then 
			if (RST = '1') then 
				Y <= FF_initi;
			else 
				Y <= X;
			end if;
		end if;
	end process;
end Cell_behavior;




