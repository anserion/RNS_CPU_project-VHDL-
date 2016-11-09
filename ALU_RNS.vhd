---------------------------------------------------------------
--арифметический сопроцессор СОК
--op_code - выбор операции
--   0 - result <= op1 (копирование первого операнда)
--   1 - result <= -op1 (нахождение обратного относительно сложения элемента)
--   2 - result <= op1^(-1) (нахождение обратного относительно умножения элемента)
--   3 - result <= op1 + op2 (сложение)
--   4 - result <= op1 * op2 (перемножение)
--   5 - result <= op1 - op2 (вычитание)
--   6 - result <= op1 / op2 (формальное деление)
--   7 - result <= op2 (копирование второго операнда)
--op1 - первый операнд операции
--op2 - второй операнд операции
--result - результат арифметической операции
--equ_out - результат проверки операндов на равенство (1 - равны, 0 - не равны)
--cmp_out - результат проверки op1>op2 (1 - op1>op2, 0 - иначе)
---------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.RNS_defs_pkg.all;

entity RNS_ALU_module is
   Port ( 
      op_code: in integer range 0 to 7;
      op1,op2: in T_RNS_vector;
      result: out T_RNS_vector;
      equ_out: out std_logic;
      cmp_out: out std_logic;
      clock: in std_logic
   );
end RNS_ALU_module;

---------------------------------------------------------------
architecture Spartan3e500 of RNS_ALU_module is
component RNS_ALU_neg is
   Port (clock: std_logic; A: in T_RNS_vector; result: out T_RNS_vector);
end component;

component RNS_ALU_inv is
   Port (clock: std_logic; A: in T_RNS_vector; result: out T_RNS_vector);
end component;

component RNS_ALU_add is
   Port (clock: std_logic; op1, op2: in T_RNS_vector; result: out T_RNS_vector);
end component;

component RNS_ALU_mul is
   Port (clock: std_logic; op1, op2: in T_RNS_vector; result: out T_RNS_vector);
end component;

component RNS_ALU_cmp_equ
   Port (clock: std_logic; op1, op2: in T_RNS_vector; result: out STD_LOGIC);
end component;

component RNS_ALU_cmp_g
   Port (clock: std_logic; op1, op2: in T_RNS_vector; result: out STD_LOGIC);
end component;

signal neg_in_RNS, neg2_in_RNS, inv_in_RNS, inv2_in_RNS,
       add_in_RNS, mul_in_RNS, sub_in_RNS, fdiv_in_RNS: T_RNS_vector;
--------------------------------------------------------------------

begin

neg_mod: RNS_ALU_neg port map (clock=>clock, A => op1, result => neg_in_RNS);
inv_mod: RNS_ALU_inv port map (clock=>clock, A => op1, result => inv_in_RNS);
add_mod: RNS_ALU_add port map (clock=>clock, op1 => op1, op2 => op2, result => add_in_RNS);
mul_mod: RNS_ALU_mul port map (clock=>clock, op1 => op1, op2 => op2, result => mul_in_RNS);
neg2_mod: RNS_ALU_neg port map (clock=>clock, A => op2, result => neg2_in_RNS);
sub_mod: RNS_ALU_add port map (clock=>clock, op1 => op1, op2 => neg2_in_RNS, result => sub_in_RNS);
inv2_mod: RNS_ALU_inv port map (clock=>clock, A => op2, result => inv2_in_RNS);
fdiv_mod: RNS_ALU_mul port map (clock=>clock, op1 => op1, op2 => inv2_in_RNS, result => fdiv_in_RNS);
equ_mod: RNS_ALU_cmp_equ port map(clock=>clock, op1 => op1, op2 => op2, result => equ_out);
cmp_mod: RNS_ALU_cmp_g port map(clock=>clock, op1 => op1, op2 => op2, result => cmp_out);

process(clock)
begin
   if (clock'event and clock = '1') then
      case op_code is
      when 0 => result <= op1;
      when 1 => result <= neg_in_RNS;
      when 2 => result <= inv_in_RNS;
      when 3 => result <= add_in_RNS;
      when 4 => result <= mul_in_RNS;
      when 5 => result <= sub_in_RNS;
      when 6 => result <= fdiv_in_RNS;
      when 7 => result <= op2;
      when others => null;
      end case;
   end if;
end process;
   
end Spartan3e500;
