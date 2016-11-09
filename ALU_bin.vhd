---------------------------------------------------------------
library IEEE; -- модуль "обычного" ALU 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity bin_ALU_module is
   generic (data_width: integer range 1 to 32 := 16);
   Port ( 
      op_code: in integer range 0 to 7;
      op1, op2: in STD_LOGIC_VECTOR (data_width-1 downto 0);
      result: out STD_LOGIC_VECTOR (data_width-1 downto 0);
      equ_out, AgB_out: out STD_LOGIC;
      clock: in std_logic
   );
end bin_ALU_module;

---------------------------------------------------------------
architecture Spartan3e500 of bin_ALU_module is
begin
process(clock)
begin
   if (clock'event and clock = '1') then
      case op_code is
      when 0 => result <= op1;
      when 1 => result <= CONV_STD_LOGIC_VECTOR(0,data_width)-op1;
      when 2 => result <= CONV_STD_LOGIC_VECTOR(0,data_width); -- result:=op1 mod op2
      when 3 => result <= op1+op2;
      when 4 => result <= op1*op2;
      when 5 => result <= op1-op2;
      when 6 => result <= CONV_STD_LOGIC_VECTOR(0,data_width); -- result:=op1 div op2
      when 7 => result <= op2;
      when others => null;
      end case;
   end if;
end process;

equ_out <= '1' when op1=op2 else '0';
AgB_out <= '1' when op1>op2 else '0';

end Spartan3e500;

