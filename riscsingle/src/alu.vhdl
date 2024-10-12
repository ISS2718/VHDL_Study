----------------------------
--Author Isaac Santos Soares
--nUSP 12751713
--
--Copyright (c) 2024 Isaac Soares
--Licensed under the MIT License
--Last modified: 2023-10-06
--
-- This VHDL module defines a parameterizable ALU.
--
----------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
  generic(
    n_bits : integer := 32
  );
  port(
    a : in std_logic_vector(n_bits-1 downto 0);
    b : in std_logic_vector(n_bits-1 downto 0);
    alucontrol : in std_logic_vector(2 downto 0);
    result : out std_logic_vector(n_bits-1 downto 0);
    zero : out std_logic
  );
end alu;

architecture behavioral of alu is
  function "+" (a, b : std_logic_vector) return std_logic_vector is
    -- variable carry : std_logic_vector(a'length - 1 downto 0);
    variable sum : std_logic_vector(a'length - 1 downto 0);
  begin
    -- carry(0) := cin;
    for i in 0 to n_bits - 1 loop
      sum(i) := a(i) XOR b(i);
      -- sum(i) := a(i) XOR b(i) XOR carry(i);
      -- carry(i+1) <= (a(i) AND b(i)) OR (a(i) AND carry(i)) OR (b(i) AND carry(i));
    end loop;
    return sum;
  end function;

  function "-" (a, b : std_logic_vector) 
  return std_logic_vector is
    variable carry : std_logic_vector(a'length - 1 downto 0);
    variable two_complement : std_logic_vector(a'length - 1 downto 0);
    variable sub : std_logic_vector(a'length - 1 downto 0);
  begin
    carry := (0 => '1', others => '0');
    two_complement := not b;
    for i in 0 to n_bits - 1 loop
      if i = 0 then
        sub(i) := a(i) XOR b(i) XOR carry(i);
      else
        sub(i) := a(i) XOR b(i);
      end if;
      -- carry(i+1) <= (a(i) AND b(i)) OR (a(i) AND carry(i)) OR (b(i) AND carry(i));
    end loop;
    return sub;
  end function;

  function "<" (a, b : std_logic_vector) return std_logic_vector is
    variable sub : std_logic_vector(a'length - 1 downto 0);
    variable result : std_logic_vector(a'length - 1 downto 0);
  begin
    sub := a - b;
    if sub(n_bits - 1) = '1' then
      result := (0 => '1', others => '0');
      return result;
    else
      result := (others => '0');
      return result;
    end if;
  end function;

  function itzero(a : std_logic_vector) return std_logic is
    variable result : std_logic;
  begin
    for i in a'range loop
      if a(i) /= '0' then
        result := '0';
        exit;
      end if;
    end loop;
    return result;
  end function;

  signal res : std_logic_vector(n_bits-1 downto 0);
begin
  with alucontrol select
    res <=
      a + b when "000",
      a - b when "001",
      a AND b when "010",
      a OR b when "011",
      a < b when "101",
      (others => '0') when others;

  result <= res;
  zero <= itzero(res);
end behavioral;