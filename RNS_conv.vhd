---------------------------------------------------------------
--компонент преобразований между СОК--ОПСС--ПСС
--input_fmt - выбор входного сигнала для перевода
--   0 - reserved
--   1 - RNS
--   2 - OPSS
--   3 - bin
---------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.RNS_defs_pkg.all;

entity RNS_conv is
   Port ( 
      input_fmt: in integer range 0 to 3;
      RNS_op: inout T_RNS_vector;
      OPSS_op: inout T_RNS_vector;
      bin_op: inout T_bin_data;
      clock: in std_logic
   );
end RNS_conv;

---------------------------------------------------------------
architecture Spartan3e500 of RNS_conv is
component PSS_RNS_module
   Port (clock: std_logic; A: in T_bin_data; result: out T_RNS_vector);
end component;

component RNS_OPSS_module
   Port (clock: std_logic; A: in T_RNS_vector; result: out T_RNS_vector);
end component;

component OPSS_RNS_module
   Port (clock: std_logic; A: in T_RNS_vector; result: out T_RNS_vector);
end component;

component OPSS_PSS_module
   Port (clock: std_logic; A: in T_RNS_vector; result: out T_bin_data);
end component;

signal RNS_in, OPSS_in, OPSS_RNS_out,  RNS_OPSS_out, bin_RNS_out: T_RNS_vector;
signal bin_in, OPSS_bin_out: T_bin_data;
--------------------------------------------------------------------

begin
   OPSS_RNS: OPSS_RNS_module port map(clock=>clock, A=>OPSS_in, result=>OPSS_RNS_out);
   OPSS_PSS: OPSS_PSS_module port map(clock=>clock, A=>OPSS_in, result=>OPSS_bin_out);
   RNS_OPSS: RNS_OPSS_module port map(clock=>clock, A=>RNS_in, result=>RNS_OPSS_out);
   PSS_RNS: PSS_RNS_module port map(clock=>clock, A=>bin_in, result=>bin_RNS_out);

process(clock)
begin
   if (clock'event and clock = '1') then
      case input_fmt is
      when 0 => null;
      when 1 => RNS_in<=RNS_op; bin_op<=OPSS_bin_out; OPSS_op<=RNS_OPSS_out;
      when 2 => OPSS_in<=OPSS_op; bin_op<=OPSS_bin_out; RNS_op<=OPSS_RNS_out;
      when 3 => bin_in<=bin_op; RNS_op<=bin_RNS_out; OPSS_op<=RNS_OPSS_out;
      when others => null;
      end case;
   end if;
end process;
   
end Spartan3e500;
