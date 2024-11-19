----------------------------
-- Authors: Isaac Santos Soares
-- nUSP: 12751713
--
-- Copyright (c) 2024 Isaac Soares
-- Licensed under the MIT License
-- 
-- Description:
--
-- Last Modified: 2024-11-19
----------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.riscv_pkg.ALL;

entity datapath is
  generic(
    Width : integer := 32  -- Register width
  );
  port (
    clk, reset : in std_logic;  -- Clock signal
    resultsrc : in STD_LOGIC_VECTOR(1 downto 0);
		pcsrc, alusrc : in STD_LOGIC;
		regwrite: in STD_LOGIC;
		immsrc : in STD_LOGIC_VECTOR(1 downto 0);
		alucontrol : in STD_LOGIC_VECTOR(2 downto 0);
		instr : in STD_LOGIC_VECTOR(Width-1 downto 0);
		readdata : in STD_LOGIC_VECTOR(Width-1 downto 0);
		
		aluresult, writedata : buffer STD_LOGIC_VECTOR(Width-1 downto 0);
		pc: buffer STD_LOGIC_VECTOR(Width-1 downto 0);

    zero: out STD_LOGIC
  ) ;
end datapath;
architecture behavioral of datapath is
  -- PC Signals
  signal pcnext, pcplus4, pctarget : STD_LOGIC_VECTOR(Width-1 downto 0);
  -- Extend Signal
  signal immext : STD_LOGIC_VECTOR(Width-1 downto 0);
  -- Register File Signals
  signal srca : STD_LOGIC_VECTOR(Width-1 downto 0);
  -- ALU Signals
  signal result, srcb : STD_LOGIC_VECTOR(Width-1 downto 0);
begin
  -- PC Next logic
  pcreg : flopr generic map(Width) port map (
    clk => clk,
    reset => reset,
    d => pcnext,
    q => PC
  );

  -- PC + 4 logic
  pcadd4 : adder port map (
    a => pc,
    b => x"00000004",
    c_in => '0',
    y => pcplus4,
    c_out => open
  );

  -- PC Target logic
  pcaddbranch : adder port map (
    a => pc,
    b => immext,
    c_in => '0',
    y => pctarget,
    c_out => open
  );

  -- PC Mux logic
  pcmux : mux2 generic map(Width) port map (
    d0 => pcplus4,
    d1 => pctarget,
    s => pcsrc,
    y => pcnext
  );

  -- Extend logic
  ext : extend port map (
    instr => instr(31 downto 7),
    immsrc => immsrc,
    immext => immext
  );

  -- Register File logic
  rf : regfile port map (
    clk => clk,
    we => regwrite,
    a1 => instr(19 downto 15),
    a2 => instr(24 downto 20),
    a3 => instr(11 downto 7),
    wd => result,
    rd1 => srca,
    rd2 => writedata
  );

  -- srcB (ALU) logic
  srcbmux : mux2 generic map(Width) port map (
    d0 => writedata,
    d1 => immext,
    s => alusrc,
    y => srcb
  );

  -- ALU logic
  alunit : alu generic map(Width) port map (
    a => srca,
    b => srcb,
    alucontrol => alucontrol,
    result => aluresult,
    zero => zero
  );

  -- Result logic
  resultmux : mux3 generic map(Width) port map (
    d0 => aluresult,
    d1 => readdata,
    d2 => pcplus4,
    s => resultsrc,
    y => result
  );
end behavioral;