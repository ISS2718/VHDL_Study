----------------------------
--Autor Isaac Santos Soares
--nUSP 12751713
--
--Copyright (c) 2024 Isaac Soares
--Licenciado sob a Licença MIT
--Última modificação: 2023-10-05
--
--Um multiplixador de 32bits de quatro entradas: d0; d1; d2; d3, com uma chave seletrora s.
--Se s = "00", a saída y é igual a d0.
--Se s = "01", a saída y é igual a d1.
--Se s = "10", a saída y é igual a d2.
--Se s = "11", a saída y é igual a d3.
--
----------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4 is
  port (
    d0, d1, d2, d3 : in std_logic_vector (31 downto 0);
    s : in std_logic_vector (1 downto 0);
    y : out std_logic_vector (31 downto 0)
  ) ;
end mux4;
architecture behavioral of mux4 is
begin 
  with s select
    y <= d0 when "00",
         d1 when "01",
         d2 when "10",
         d3 when "11";
end behavioral;