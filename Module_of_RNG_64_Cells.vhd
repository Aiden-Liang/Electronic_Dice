-- Random Number Generator
library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_BIT.all;
library Cell_of_RNG_4_inputs;
use Cell_of_RNG_4_inputs.all;

entity Module_of_RNG_64_Cells is
port ( initi_seed: in std_logic_vector(63 downto 0);
	   CLK, RST: in std_logic;
	   RNG_out: out std_logic_vector(63 downto 0));
end Module_of_RNG_64_Cells;

architecture Structure_of_RNG of Module_of_RNG_64_Cells is
--63 Cells, Each Cell has 4-bit inputs
type Input_Bundle is array(63 downto 0) of std_logic_vector(3 downto 0);

component Cell_of_RNG_4_inputs 
port ( Cell_addr: in std_logic_vector(3 downto 0); 
	   CLK, RST: in std_logic;
	   FF_initi: in std_logic; 
	   Y: out std_logic );
end component;
	   
signal Cell_input: Input_Bundle; --2-D array inputs
signal Cell_output: std_logic_vector(63 downto 0); --one cell one output

begin
	process(Cell_output) --feedback drive
	variable i,j,k: integer; --index
	-- i:cell's 1-input, j:cell's 2-input, k:cell's 4-input
	begin
		for n in 63 downto 0 loop --{i,j,n,k}={-2,-1,0,3} 
		-- i: cell's 1-input
			if n=1 then i:=63;
			elsif n=0 then i:=62;
			else i:=n-2;
			end if;
		-- j: cell's 2-input
			if n=0 then j:=63;
			else j:=n-1;
			end if;
		-- k: cell's 4-input
			if n=61 then k:=0;
			elsif n=62 then k:=1;
			elsif n=63 then k:=2;
			else k:=n+3;
			end if;
		Cell_input(n) <= Cell_output(i)&Cell_output(j)
						&Cell_output(n)&Cell_output(k);
		end loop;
	end process;
	
	Cell_array_generator: for n in 63 downto 0 generate --parameter
	Cells_array_of_RNG: Cell_of_RNG_4_inputs port map( Cell_addr => Cell_input(n),
		    CLK => CLK, RST => RST, FF_initi => initi_seed(n), Y => Cell_output(n));
	end generate;
	
	RNG_out <= Cell_output;
	
end Structure_of_RNG;
			



