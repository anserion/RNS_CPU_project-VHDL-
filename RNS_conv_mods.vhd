------------------------------------------------------------------
--компонент перевода числа из позиционной (двоичной) системы счисления
--в систему остаточных классов
------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.RNS_defs_pkg.all;
entity PSS_RNS_module is
   Port (clock: std_logic; A: in T_bin_data; result: out T_RNS_vector);
end PSS_RNS_module;

architecture Spartan3e500 of PSS_RNS_module is
begin
   process(clock)
   begin
   if (clock'event and clock = '1') then
      result <= RNS_conv_PSS_RNS(A);
   end if;
   end process;
end Spartan3e500;
------------------------------------------------------------------

------------------------------------------------------------------
--компонент перевода числа из СОК в обобщенную позиционную систему счисления
--A=(a1,a2,..,a(p_num)) = opss1+opss2*p1+opss3*p1*p2+...+opss(p_num)*p1*p2*..*p(p_num-1)
------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
USE work.RNS_defs_pkg.all;
entity RNS_OPSS_module is
   Port (clock: std_logic; A: in T_RNS_vector; result: out T_RNS_vector);
end RNS_OPSS_module;

architecture Spartan3e500 of RNS_OPSS_module is
begin
   process(clock)
   begin
   if (clock'event and clock = '1') then
      result <= RNS_conv_RNS_OPSS(A);
    end if;
   end process;
end Spartan3e500;
------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
USE work.RNS_defs_pkg.all;
entity OPSS_RNS_module is
   Port (clock: std_logic; A: in T_RNS_vector; result: out T_RNS_vector);
end OPSS_RNS_module;

architecture Spartan3e500 of OPSS_RNS_module is
begin
   process(clock)
   begin
   if (clock'event and clock = '1') then
      result <= RNS_conv_OPSS_RNS(A);
   end if;
   end process;
end Spartan3e500;
------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
USE work.RNS_defs_pkg.all;
entity OPSS_PSS_module is
   Port (clock: std_logic; A: in T_RNS_vector; result: out T_bin_data);
end OPSS_PSS_module;

architecture Spartan3e500 of OPSS_PSS_module is
begin
   process(clock)
   begin
   if (clock'event and clock = '1') then
      result <= RNS_conv_OPSS_PSS(A);
   end if;
   end process;
end Spartan3e500;
------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
USE work.RNS_defs_pkg.all;
entity RNS_PSS_module is
   Port (clock: std_logic; A: in T_RNS_vector; result: out T_bin_data);
end RNS_PSS_module;

architecture Spartan3e500 of RNS_PSS_module is
begin
   process(clock)
   begin
   if (clock'event and clock = '1') then
      result <= RNS_conv_RNS_PSS(A);
   end if;
   end process;
end Spartan3e500;
------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.RNS_defs_pkg.all;
entity PSS_OPSS_module is
   Port (clock: std_logic; A: in T_bin_data; result: out T_RNS_vector);
end PSS_OPSS_module;

architecture Spartan3e500 of PSS_OPSS_module is
begin
   process(clock)
   begin
   if (clock'event and clock = '1') then
      result <= RNS_conv_PSS_OPSS(A);
   end if;
   end process;
end Spartan3e500;
------------------------------------------------------------------
