------------------------------------------------------------------
--компонент нахождения обратного относительно сложения элемента
--A - число в СОК
--result - обратный относительно сложения элемент
------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
USE work.RNS_defs_pkg.all;

entity RNS_ALU_neg is
   Port (clock: std_logic; A: in T_RNS_vector; result: out T_RNS_vector);
end RNS_ALU_neg;

architecture Spartan3e500 of RNS_ALU_neg is
begin
   process(clock)
   begin
   if (clock'event and clock = '1') then
      for i in 1 to RNS_P_num loop
         if A(i)=0 then result(i)<=0;
                   else result(i)<=RNS_primes(i)-A(i);
         end if;
      end loop;
   end if;
   end process;
end Spartan3e500;
------------------------------------------------------------------

------------------------------------------------------------------
--компонент нахождения обратного относительно умножения элемента
--A - число в СОК
--result - обратный относительно умножения элемент
------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
USE work.RNS_defs_pkg.all;

entity RNS_ALU_inv is
   Port (clock: std_logic; A: in T_RNS_vector; result: out T_RNS_vector);
end RNS_ALU_inv;

architecture Spartan3e500 of RNS_ALU_inv is
begin
   process(clock)
   begin
   if (clock'event and clock = '1') then
      for i in 1 to RNS_P_num loop
         result(i) <= inv_mod_8bit(i,A(i));
      end loop;
   end if;
   end process;
end Spartan3e500;
------------------------------------------------------------------

------------------------------------------------------------------
--компонент сложения чисел в СОК
--op1 - первое слагаемое
--op2 - второе слагаемое
--result - сумма
------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.RNS_defs_pkg.all;

entity RNS_ALU_add is
   Port(clock: in std_logic;
        op1, op2: in T_RNS_vector; result: out T_RNS_vector);
end RNS_ALU_add;

architecture Spartan3e500 of RNS_ALU_add is
begin
   process(clock)
   begin
   if (clock'event and clock = '1') then
      for i in 1 to RNS_P_num loop
         result(i) <= add_mod_8bit(i,op1(i),op2(i));
      end loop;
   end if;
   end process;
end Spartan3e500;
------------------------------------------------------------------

------------------------------------------------------------------
--компонент перемножения чисел в СОК
--op1 - первый множитель
--op2 - второй множитель
--result - произведение
------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
USE work.RNS_defs_pkg.all;
entity RNS_ALU_mul is
   Port (clock: in std_logic; 
         op1, op2: in T_RNS_vector; result: out T_RNS_vector);
end RNS_ALU_mul;

architecture Spartan3e500 of RNS_ALU_mul is
begin
   process(clock)
   begin
   if (clock'event and clock = '1') then
      for i in 1 to RNS_P_num loop
         result(i) <= mul_mod_8bit(i,op1(i),op2(i));
      end loop;
   end if;
   end process;
end Spartan3e500;
------------------------------------------------------------------

------------------------------------------------------------------
--компонент проверки чисел в СОК на равенство
--op1 - операнд слева
--op2 - операнд справа
--result - логический (1 - равны, 0 не равны) результат
------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.RNS_defs_pkg.all;

entity RNS_ALU_cmp_equ is
   Port (clock: std_logic; op1, op2: in T_RNS_vector; result: out std_logic);
end RNS_ALU_cmp_equ;

architecture Spartan3e500 of RNS_ALU_cmp_equ is
begin
   process(clock)
   begin
   if (clock'event and clock = '1') then
      result <= RNS_is_equ(op1,op2);
   end if;
   end process;
end Spartan3e500;
------------------------------------------------------------------

------------------------------------------------------------------
--компонент сравнения чисел в СОК
--числа переводятся в ОПСС и производится покомпонентное сравнение
--op1 - операнд слева
--op2 - операнд справа
--result - логический результат (1 - op1>op2, 0 иначе)
------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.RNS_defs_pkg.all;

entity RNS_ALU_cmp_g is
   Port (clock: std_logic; op1, op2: in T_RNS_vector; result: out std_logic);
end RNS_ALU_cmp_g;

architecture Spartan3e500 of RNS_ALU_cmp_g is
begin
   process(clock)
   begin
   if (clock'event and clock = '1') then
      result<=RNS_cmp_g(op1,op2);
   end if;
   end process;
end Spartan3e500;
------------------------------------------------------------------
