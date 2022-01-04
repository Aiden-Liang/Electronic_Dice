-- Electronic Dice Circuit --
library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_BIT.all;
library Module_of_RNG_64_Cells;
use Module_of_RNG_64_Cells.all;

entity Electronic_Dice is 
port( RNG_Seed: in std_logic_vector(63 downto 0);
	  CLK, RST, En: in std_logic;
	  Tossing_Result: out UNSIGNED(2 downto 0));
end Electronic_Dice;

architecture Dice_Structure of Electronic_Dice is

component Module_of_RNG_64_Cells 
port( initi_seed: in std_logic_vector(63 downto 0);
	  CLK, RST: in std_logic;
	  RNG_out: out UNSIGNED(63 downto 0));
end component;

signal RNG_to_Modu: UNSIGNED(63 downto 0);
signal temp: UNSIGNED(63 downto 0);
signal Modu_to_Reg: UNSIGNED(2 downto 0);

begin

RNG: Module_of_RNG_64_Cells port map( initi_seed => RNG_Seed,
	  CLK => CLK, RST => RST, RNG_out => RNG_to_Modu );
	 
-- Modulo Circuit --
temp <= (RNG_to_Modu mod 6) ;
Modu_to_Reg <= temp(2 downto 0);

-- D_FF --
process
begin
	wait until (rising_edge(CLK));
	if (En='1') then
		Tossing_Result <= Modu_to_Reg;
	end if;
end process;

end Dice_Structure;

