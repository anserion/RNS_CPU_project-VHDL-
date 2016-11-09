------------------------------------------------------------------
--��������� ���������� ��������� ������������ �������� ��������
--A - ����� � ���
--result - �������� ������������ �������� �������
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
--��������� ���������� ��������� ������������ ��������� ��������
--A - ����� � ���
--result - �������� ������������ ��������� �������
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
--��������� �������� ����� � ���
--op1 - ������ ���������
--op2 - ������ ���������
--result - �����
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
--��������� ������������ ����� � ���
--op1 - ������ ���������
--op2 - ������ ���������
--result - ������������
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
--��������� �������� ����� � ��� �� ���������
--op1 - ������� �����
--op2 - ������� ������
--result - ���������� (1 - �����, 0 �� �����) ���������
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
--��������� ��������� ����� � ���
--����� ����������� � ���� � ������������ �������������� ���������
--op1 - ������� �����
--op2 - ������� ������
--result - ���������� ��������� (1 - op1>op2, 0 �����)
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
