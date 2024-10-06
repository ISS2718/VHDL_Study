----------------------------
--Author Isaac Santos Soares
--nUSP 12751713
--
--Copyright (c) 2024 Isaac Soares
--Licensed under the MIT License
--Last modified: 2023-10-05
--
-- 32-bit register with rising edge and asynchronous reset.
--
----------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flopr is
  port (
    d : in std_logic_vector (31 downto 0);
    q : out std_logic_vector (31 downto 0);
    clk, reset : in std_logic
  );
end flopr;

architecture behavioral of flopr is
begin 
  process(clk, reset)
  begin
    if reset = '1' then
      q <= (others => '0');
    elsif rising_edge(clk) then
      q <= d;
    end if;
  end process;
end behavioral;