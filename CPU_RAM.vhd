-----------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.RNS_defs_pkg.all;

entity RNS_regs_module is
   generic(regs_num: integer range 1 to 256 := 8);
   Port (
      we: in std_logic;
      reg_idx: in integer range 0 to regs_num-1;
      data_in: in T_RNS_vector;
      reg1_idx: in integer range 0 to regs_num-1;
      reg2_idx: in integer range 0 to regs_num-1;
      data1_out: out T_RNS_vector;
      data2_out: out T_RNS_vector;
      clock: in STD_LOGIC
   );
end RNS_regs_module;

architecture Spartan3e500 of RNS_regs_module is
type T_RNS_regs is array(0 to regs_num-1) of T_RNS_vector;
signal regs_RNS: T_RNS_regs;
begin
   process(clock)
   begin
      if (clock'event and clock = '1') then
         if we = '1' then regs_RNS(reg_idx) <= data_in; end if;
         data1_out <= regs_RNS(reg1_idx);
         data2_out <= regs_RNS(reg2_idx);
      end if;
   end process;
end Spartan3e500;

-----------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.RNS_defs_pkg.all;

entity RNS_stack_module is
   generic(depth: integer range 1 to 256 := 32);
   Port (
      ena: in std_logic;
      rw: in std_logic;
      item_write: in T_RNS_vector;
      item_read: out T_RNS_vector;
      clock: in STD_LOGIC
   );
end RNS_stack_module;

architecture Spartan3e500 of RNS_stack_module is
type T_stack is array(0 to depth-1) of T_RNS_vector;
signal stack: T_stack;
signal top_idx: integer range 0 to depth-1;
begin
   process(clock)
   begin
      if (clock'event and clock = '1' and ena='1') then
         if rw = '1' then
            if top_idx<depth-1 then top_idx <= top_idx +1; end if;
            stack(top_idx) <= item_write; 
         else
            item_read <= stack(top_idx);
            if top_idx>0 then top_idx <= top_idx - 1; end if;
         end if;
      end if;
   end process;
end Spartan3e500;

-----------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;

entity bin_regs_module is
   generic(regs_num: integer range 1 to 256 := 8;
           data_width: integer range 1 to 32 := 8);
   Port (
      we: in std_logic;
      reg_idx: in integer range 0 to regs_num-1;
      data_in: in std_logic_vector(data_width-1 downto 0);
      reg1_idx: in integer range 0 to regs_num-1;
      reg2_idx: in integer range 0 to regs_num-1;
      data1_out: out std_logic_vector(data_width-1 downto 0);
      data2_out: out std_logic_vector(data_width-1 downto 0);
      clock: in STD_LOGIC
   );
end bin_regs_module;

architecture Spartan3e500 of bin_regs_module is
type T_bin_regs is array(0 to regs_num-1) of std_logic_vector(data_width-1 downto 0);
signal regs_bin: T_bin_regs;
begin
   process(clock)
   begin
      if (clock'event and clock = '1') then
         if we = '1' then regs_bin(reg_idx) <= data_in; end if;
         data1_out <= regs_bin(reg1_idx);
         data2_out <= regs_bin(reg2_idx);
      end if;
   end process;
end Spartan3e500;

-----------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bin_stack_module is
   generic(depth: integer range 1 to 256 := 32;
           item_width: integer range 1 to 32 := 8);
   Port (
      ena: in std_logic;
      rw: in std_logic;
      item_write: in std_logic_vector(item_width-1 downto 0);
      item_read: out std_logic_vector(item_width-1 downto 0);
      clock: in STD_LOGIC
   );
end bin_stack_module;

architecture Spartan3e500 of bin_stack_module is
type T_stack is array(0 to depth-1) of std_logic_vector(item_width-1 downto 0);
signal stack: T_stack;
signal top_idx: integer range 0 to depth-1;
begin
   process(clock)
   begin
      if (clock'event and clock = '1' and ena='1') then
         if rw = '1' then
            if top_idx<depth-1 then top_idx <= top_idx +1; end if;
            stack(top_idx) <= item_write; 
         else
            item_read <= stack(top_idx);
            if top_idx>0 then top_idx <= top_idx - 1; end if;
         end if;
      end if;
   end process;
end Spartan3e500;
