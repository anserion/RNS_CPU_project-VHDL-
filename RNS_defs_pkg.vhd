-- ������ ����������� ����� ������, ��������, �������� � ROM
-- � ��������������� �����������
-------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

package RNS_defs_pkg is

--8-������� �����
subtype uint_8bit is natural range 0 to 255;
--9-������� ����� (������������ ��� ��������� ����������� 8-���+8-���)
subtype uint_9bit is natural range 0 to 511;
--��������� ���� 8-������ ����� �� 0 �� 255
type T_uint_8bit_set is array(0 to 255) of uint_8bit;
--��������� ���� 8-������ ����� �� 0 �� 511
--������������ ��� ��������� ������� ����������� �������� 8-���+8-���
type T_uint_9bit_set is array(0 to 511) of uint_8bit;

--����� ���-��������� ���������������
constant RNS_regs_num: natural range 1 to 16 := 8;
--����� �������� ��������� ���������������
constant bin_regs_num: natural range 1 to 16 := 8;

--����� ��� � �������� ������, ��������� �� ���� ��������������� � �������� � ��� ������
--(������ ���� ������ ���������������)
constant bin_data_width: natural range 1 to 256 := 16;
--��� ���� �������� ������ (��� �������� ���� � ������������ � ������)
subtype T_bin_data is unsigned(bin_data_width-1 downto 0);

--��� �������� ��� ���������� ��������������� �������, �������� �������� ���,
--��� ������� ������� ��������������� ��������� �����.
--������������, ��������, ��� �������� ������� �������� �������� ����� 2, ������������ � ���
type T_bin_data_width_set is array(0 to bin_data_width-1) of uint_8bit;

--��� ��� �������� ������ (������������ � ������� ���������� ��������� ����������)
--���� ������ ����� ������ i, �� ����� ��������� ����� ������ 2*i, ������ ��������� 2*i+1
type T_tree_array is array(1 to 2*bin_data_width-1)of uint_8bit;

-------------------------------------------------------
--8-������ ��������� ���, �������� � ���
-------------------------------------------------------
--����������� ���������� ����� ��������� ��� (54 -��� ������ ���� ������� 8-������ �����)
constant RNS_P_num_max: natural range 1 to 54 := 54;
type T_RNS_vector_max is array(1 to RNS_P_num_max) of uint_8bit;

--������������ ��������� ���� ������� ����� �� 2 �� RNS_P_num_max-�� �������� �����
function gen_primes_8bit return T_RNS_vector_max;
--�������� ���������� �����, ������� ����� ����� ��������� ������ ������� ����� �����������
--���� ����� ������ ���������, �� ����������������� gen_primes_8bit
constant primes_8bit: T_RNS_vector_max --:= gen_primes_8bit;
 := ( 2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,
      103,107,109,113,127,131,137,139,149,151,157,163,167,173,179,181,191,193,197,
      199,211,223,227,229,233,239,241,251 );

--����� ������� ������������ ��������� ���
constant RNS_P_num: natural range 1 to RNS_P_num_max := 3;
type T_RNS_vector is array(1 to RNS_P_num) of uint_8bit;
--� ������� RNS_primes_order �������� ������ ��������� �� �������� ������� primes_8bit[]
--���, 3-�� ��������� ������������� 3-� ������� ����� 5, 7- �� -> 17, 8-�� -> 19.
constant RNS_primes_order: T_RNS_vector := (3,7,8);
--��� ��� ��������� ����� ��������� ��������� ��������, �� ������������ ������ RNS_primes[],
--� ������� �������� ��� �� ������� ���������, � ���������� �����.
function gen_RNS_primes return T_RNS_vector;
constant RNS_primes: T_RNS_vector := gen_RNS_primes;

--------------------------------------------------------
--��� �������� ������� �������� �� ������� ������������ �������
--�������� [����� ��������� ��� x 512], ��� ������ ����������� 512,
--��� ��� ��������� ��������, ����� �������� ������ ����� ��������� �������,
--����� ��������� 255.
type T_RNS_table_9bit is array(1 to RNS_P_num) of T_uint_9bit_set;

--������� ��������� � ������ ��� ��� �������� �������� �� �������
--���� 9-������ ����� �� ��� ��������� ��������� ���.
--������ ������ - ����� ���������,
--������ ������ - ����� ��� �������� ����� ����� �������
function gen_RNS_rems_P return T_RNS_table_9bit;
constant RNS_rems_P: T_RNS_table_9bit := gen_RNS_rems_P;

--������� ��������� � ������ ��� ��� �������� �������� �� �������
--���� 9-������ ����� �� �������� ������� ������ �� ��������� ���.
--������ ������ - ����� ���������,
--������ ������ - ����� ��� �������� ����� ����� �������
function gen_RNS_rems_phi return T_RNS_table_9bit;
constant RNS_rems_phi: T_RNS_table_9bit := gen_RNS_rems_phi;

--������� �������� �������� ����� 2, � ���.
type T_RNS_bin_pows_table is array(1 to RNS_P_num) of T_bin_data_width_set;
function gen_RNS_bin_pows return T_RNS_bin_pows_table; 
constant RNS_bin_pows: T_RNS_bin_pows_table := gen_RNS_bin_pows;

--������������ �������� ���������� ������� m ����� n. ��������� - ������� �� ������� �� q.
function GF_pow(n,m,q:natural) return natural;
--����������� ���������� �������������� ����� ���� ����� �� ������ q.
function GF_primitive(q:natural) return natural;

--������������ ������� � ������ ��� �������� ���� ������������� ������
--����� ����� ��� ���� 8-������ ������� �����.
function gen_primitives_8bit return T_RNS_vector_max;
--��� ��� ������ ���� ��������, �� ������� ��������� ������� ������������ �������
--������, ����� ����������������� ������� gen_primitives_8bit
constant primitives_8bit: T_RNS_vector_max --:= gen_primitives_8bit;
 := ( 1, 2, 2, 3, 2, 2, 3, 2, 5, 2, 3, 2, 6, 3, 5, 2, 2, 2, 2,
      7, 5, 3, 2, 3, 5, 2, 5, 2, 6, 3, 3, 2, 3, 2, 2, 6, 5, 2,
      5, 2, 2, 2, 19, 5, 2, 3, 2, 3, 2, 6, 3, 7, 7, 6 );

--��� ��� � ������� ������������ ������������ ������� �����-��������� ���,
--�� ����������� ������� RNS-primitives - ������� ������������ ������������� �����
function gen_RNS_primitives return T_RNS_vector;
constant RNS_primitives: T_RNS_vector := gen_RNS_primitives;

--��� ��������-������������ ������ ���
type T_RNS_table is array(1 to RNS_P_num) of T_uint_8bit_set;

--������������ ������� �������� ���������� ��������� ������� (���������� ��������������)
--������ ������ - ����� ���������,
--������ ������ - ������ ����� (���������� ��������) �� �������� ����� ������������ �����
function gen_RNS_inv_idx_table return T_RNS_table;
constant RNS_inv_idx_table: T_RNS_table := gen_RNS_inv_idx_table;

--������������ ������� �������� ���������� ������� (���������� ����������������)
--������ ������ - ����� ���������,
--������ ������ - ����� ��� �������� ����� ����� ��� ������ (���������� ��������)
function gen_RNS_idx_table return T_RNS_table;
constant RNS_idx_table: T_RNS_table := gen_RNS_idx_table;

--���������� ��������
--j - ����� ���������
--op1 - ������ ���������
--op2 - ������ ���������
function add_mod_8bit(j,op1,op2:uint_8bit) return uint_8bit;

--���������� ����������
--j - ����� ���������
--op1 - ������ ���������
--op2 - ������ ���������
function mul_mod_8bit(j,op1,op2:uint_8bit) return uint_8bit;

--������ ��������� �� ��������� �������� ���� ����� �� ������ q
--������ �������� �� ������ ��������
-- A^(-1) := inv_idx( q -idx(A) ); q=RNS_primes(j);
-- 0^(-1) :=0; (����� �� �������)
function inv_mod_8bit(j,A:uint_8bit) return uint_8bit;

--���������� ���������� �������� (��������� �������� ������ ��� ������� ������)
--j - ����� ���������
--op1 - �������
--op2 - �������� (���� op2=0, �� ������������ � ������ 0)
function fdiv_mod_8bit(j,op1,op2:uint_8bit) return uint_8bit;

--��������������� �� ������ ��������� ���
function scale_p1_8bit(A:T_RNS_vector) return T_RNS_vector;

--������� �������� �������� ����������� ������� �����
--������� ��������� ���������� (��������� ������� �� ������ RNS_primes(j) )
function add_tree_method(j:uint_8bit; A: T_bin_data_width_set) return uint_8bit;

--������� �������� ������������ ����������� ������� �����
--������� ��������� ����������� (��������� ������� �� ������ RNS_primes(j) )
function mul_tree_method(j:uint_8bit; A: T_bin_data_width_set) return uint_8bit;

--������� �������� ���������� ���������� ������������ ����������� ���� �������� �����
--������� ��������� ����������� (��������� ������� �� ������ RNS_primes(j) )
function scalar_tree_method(j:uint_8bit; op1,op2: T_bin_data_width_set) return uint_8bit;

--������ ������� �� ������� ������������� ��������� ����� �� ������� ���������
--������ ��� ������������ ����� ���������� �� ��������������� �������
--������, ������� �� ������� �� ������� ����� �� ������� ������� ��������.
--��������� ������������ ������������ ������� ��������� ����������
--j - ����� ��������� �� ������� RNS_primes[]
--A - �������� �����
function calc_rem_P(j:uint_8bit; A: T_bin_data) return uint_8bit;

--������� ����� �� �������� ������� ��������� � ���
function RNS_conv_PSS_RNS(A: T_bin_data) return T_RNS_vector;

--������� ����� �� ��� � ����
--A=(a1,a2,..,a(p_num)) = opss1+opss2*p1+opss3*p1*p2+...+opss(p_num)*p1*p2*..*p(p_num-1)
function RNS_conv_RNS_OPSS(A: T_RNS_vector) return T_RNS_vector;

--������� ����� �� ���� � ���
function RNS_conv_OPSS_RNS(A: T_RNS_vector) return T_RNS_vector;

--������� ����� �� ���� � �������� ������� ���������
function RNS_conv_OPSS_PSS(A: T_RNS_vector) return T_bin_data;

--������� ����� �� ��� � �������� ������� ���������
function RNS_conv_RNS_PSS(A: T_RNS_vector) return T_bin_data;

--������� ����� �� �������� ������� ��������� � ����
function RNS_conv_PSS_OPSS(A: T_bin_data) return T_RNS_vector;

--������� �������� ����� � ��� op1 � op2 �� ���������
--result - ���������� ��������� (1 - �����, 0 �� �����)
function RNS_is_equ(op1,op2:T_RNS_vector) return std_logic;

--������� �������� ����� � ��� op1 � op2 �� "op1>op2"
--result - ���������� ��������� (1 - op1>op2, 0 �����)
function RNS_cmp_g(op1,op2:T_RNS_vector) return std_logic;

--������� ������������ �������� ��������� � 8-������� ��������� �����
--(� ������� �� ������������, ��� ��� ������ �������� ������������� "����������� +")
--function bin_add_int8bit(A: T_bin_data; B:uint_8bit) return T_bin_data;

--������� ������������ ��������� ��������� � 8-������� ��������� �����
--(������������� "����������� *" ������)
function bin_mul_uint8bit(A: T_bin_data; B:uint_8bit) return T_bin_data;

end;

---------------------------------------------------------------
--���������� ����������� �� ����� VHDL
---------------------------------------------------------------
package body RNS_defs_pkg is

--��� ������ �� unsigned � ������ std_logic vector
--subtype T_bin_data is std_logic_vector(bin_data_width-1 downto 0);
----�������� ��������� ����� � 8-������� ��������� �����
----(������������, ��������, ��� �������� ����� �� ���� � ���)
--function bin_add_int8bit(A: T_bin_data; B:uint_8bit) return T_bin_data is
--variable res: T_bin_data;
--variable B_stdlgc: std_logic_vector(7 downto 0);
--variable i: natural;
--variable carry: std_logic;
--begin
--   res:=A; B_stdlgc:=conv_std_logic_vector(B,8); carry:='0';
--   for i in 0 to 7 loop
--      res(i) := (A(i) xor B_stdlgc(i)) xor carry;
--      carry:= (A(i) and B_stdlgc(i)) or ((A(i) or B_stdlgc(i)) and carry);
--   end loop;
--   for i in 8 to bin_data_width-1 loop
--      res(i) := A(i) xor carry;
--      carry := carry and A(i);
--   end loop;
--   return res;
--end;
--
----���������� ��������� ����� �� 8-������ �������� �����
----(������������, ��������, ��� �������� ����� �� ���� � ���)
function bin_mul_uint8bit(A: T_bin_data; B:uint_8bit) return T_bin_data is
variable res: T_bin_data;
variable B_stdlgc: unsigned(7 downto 0);
variable i: natural;
begin
   res:=conv_unsigned(0,bin_data_width);
   if B/=0 then
      B_stdlgc:=conv_unsigned(B,8);
      for i in bin_data_width-1 downto 0 loop
         res:=res+res;
         if A(i)='1' then
            res:=res+B_stdlgc;
         end if;
      end loop;
   end if;           
   return res;
end;
------------------------------------------------------------------------

--��������� ���� 8-������ ������� ����� �� 2 �� RNS_P_num_max-��
function gen_primes_8bit return T_RNS_vector_max is
variable i,j,k:natural;
variable is_prime:boolean;
variable p: T_RNS_vector_max;
begin
     p(1):=2;
     i:=2;
     for k in 1 to RNS_p_num_max loop
          is_prime:=false;
          while not(is_prime) loop
               i:=i+1; is_prime:=true;
               for j in 1 to k loop
                   if (i mod p(j))=0 then is_prime:=false; end if;
               end loop;
          end loop;
          if (i<=255)and(k<RNS_p_num_max) then p(k+1):=i; end if;
     end loop;
     return p;
end;

--���������� ������� RNS_primes �������� �������
--�������� ��������, �������� � ������� RNS_primes_order
function gen_RNS_primes return T_RNS_vector is
variable i: natural;
variable tmp: T_RNS_vector;
begin
   for i in 1 to RNS_p_num loop
      tmp(i) := primes_8bit(RNS_primes_order(i));
   end loop;
   return tmp;
end;

--������ ����������� ������� RNS_rems_P[] - �������� �� ������� 9-������ ����� �� ��������� ���
--������ ������ - ����� ���������
--������ ������ - �����, ��� �������� ����� ����� ������� �� �������
--(������������ � ���������� ��������� )
function gen_RNS_rems_P return T_RNS_table_9bit is
variable i,k:natural;
variable tmp: T_RNS_table_9bit;
begin
   for i in 1 to RNS_P_num loop
      tmp(i)(0):=0;
      for k in 1 to 511 loop
         tmp(i)(k):=k mod RNS_primes(i);
      end loop;
   end loop;
   return tmp;
end;

--������ ����������� ������� RNS_rems_phi[] - �������� �� ������� 9-������ ����� 
--�� ������� ������ �� ��������� ���
--������ ������ - ����� ���������
--������ ������ - �����, ��� �������� ����� ����� ������� �� �������
--(������������ � ���������� ����������)
function gen_RNS_rems_phi return T_RNS_table_9bit is
variable i,k:natural;
variable tmp: T_RNS_table_9bit;
begin
   for i in 1 to RNS_P_num loop
      tmp(i)(0):=0;
      for k in 1 to 511 loop
         tmp(i)(k):=k mod (RNS_primes(i)-1);
      end loop;
   end loop;
   return tmp;
end;

--������ �������� �������� ����� 2 � ���
--(������������ ��� �������� �������� ����� � ���)
function gen_RNS_bin_pows return T_RNS_bin_pows_table is
variable tmp_table: T_RNS_bin_pows_table;
variable i,k,new_pow: natural;
begin
   for i in 1 to RNS_P_num loop
      tmp_table(i)(0):=1;
      for k in 1 to bin_data_width-1 loop
         new_pow:=tmp_table(i)(k-1)*2;
         tmp_table(i)(k):=RNS_rems_P(i)(new_pow);
      end loop;
   end loop;
   return tmp_table;
end;

--������� ���������� ���������� ����� n � ������� m
--��������� ������� �� ������ q
function GF_pow(n,m,q:natural) return natural is
variable res,h,hm:natural;
begin
  res:=1; h:=n; hm:=m;
  while (hm>0) loop 
     if (hm mod 2)=0 then h:=(h*h) mod q; hm:=hm/2;
                     else res:=(res*h) mod q; hm:=hm-1;
     end if;
  end loop;
  return res;
end;

--������ �������� �������������� ����� ���� ����� �� �������� ��������� q
function GF_primitive(q:natural) return natural is
variable i,j,flag:natural;
begin
   flag:=0;
   for i in 1 to q-1 loop
      for j in 1 to q-1 loop
         if GF_pow(i,j,q)=1 then flag:=flag+1; end if;
      end loop;
      if flag=1 then return i; else flag:=0; end if;
   end loop;
end;

--���������� ������������� ������ ��� ���� 8-������ ������� �����
function gen_primitives_8bit return T_RNS_vector_max is
variable i:natural;
variable tmp: T_RNS_vector_max;
begin
   for i in 1 to RNS_p_num_max loop
      tmp(i) := GF_primitive(primes_8bit(i));
   end loop;
   return tmp;
end;

--���������� ������� RNS_primitives �������������� �������
--�������� ��������, �������� � ������� RNS_primes_order
function gen_RNS_primitives return T_RNS_vector is
variable i: natural;
variable tmp: T_RNS_vector;
begin
   for i in 1 to RNS_p_num loop
      tmp(i) := primitives_8bit(RNS_primes_order(i));
   end loop;
   return tmp;
end;

--������ ������������ ������� ����������� ��������������
--(�� ������� ����������������� �����)
function gen_RNS_inv_idx_table return T_RNS_table is
variable tmp_inv: T_RNS_table;
variable i,k:natural;
begin
   for i in 1 to RNS_p_num loop
      for k in 0 to 255 loop
         tmp_inv(i)(k) := GF_pow(RNS_primitives(i),k,RNS_primes(i));
      end loop;
   end loop;
   return tmp_inv;
end;

--������ ������������ ������� ����������� ����������������� (�������)
--(��� ��������� ����� ��������� ��� ������)
function gen_RNS_idx_table return T_RNS_table is
variable tmp_idx: T_RNS_table;
variable i,k:natural;
begin
   for i in 1 to RNS_p_num loop
      for k in 255 downto 0 loop
         tmp_idx(i)(RNS_inv_idx_table(i)(k)):=k;
      end loop;
   end loop;
   return tmp_idx;
end;

--���������� ��������
function add_mod_8bit(j,op1,op2:uint_8bit) return uint_8bit is
variable res_9bit: uint_9bit;
begin
   res_9bit := op1 + op2;
   return RNS_rems_P(j)(res_9bit);
end;

--���������� ����������
--������ �������� �� ������ ��������
-- op1*op2 := inv_idx( idx(op1) + idx(op2) );
function mul_mod_8bit(j,op1,op2:uint_8bit) return uint_8bit is
variable op1_idx,op2_idx,sum_idx: uint_8bit;
variable res_9bit: uint_9bit;
begin
   if op1=0 then return 0;
   else if op2=0 then return 0;
   else
      op1_idx := RNS_idx_table(j)(op1);
      op2_idx := RNS_idx_table(j)(op2);
      res_9bit := op1_idx + op2_idx;
      sum_idx := RNS_rems_phi(j)(res_9bit);
      return RNS_inv_idx_table(j)(sum_idx);
   end if;
   end if;
end;

--������ ��������� �� ��������� �������� ���� ����� �� ������ q
--������ �������� �� ������ ��������
-- A^(-1) := inv_idx( phi(q) -idx(A) );
-- 0^(-1) :=0; (����� �� �������)
function inv_mod_8bit(j,A:uint_8bit) return uint_8bit is
variable A_idx, neg_A_idx: uint_8bit;
begin
   if A=0 then return 0;
          else
      A_idx := RNS_idx_table(j)(A);
      neg_A_idx := (RNS_primes(j)-1)-A_idx;
      return RNS_inv_idx_table(j)(neg_A_idx);
   end if;
end;

--���������� ���������� �������� (��������� �������� ������ ��� ������� ������)
--j - ����� ���������
--op1 - �������
--op2 - �������� (���� op2=0, �� ������������ � ������ 0)
function fdiv_mod_8bit(j,op1,op2:uint_8bit) return uint_8bit is
variable op2_inv: uint_8bit;
begin
   op2_inv:=inv_mod_8bit(j,op2);
   return mul_mod_8bit(j,op1,op2_inv);
end;

--��������������� �� ������ ��������� ���
function scale_p1_8bit(A:T_RNS_vector) return T_RNS_vector is
variable A_opss, tmp: T_RNS_vector;
begin
   A_opss:=RNS_conv_RNS_OPSS(A);
   for i in 1 to RNS_P_num -1 loop
      tmp(i):=A_opss(i+1);
   end loop;
   tmp(RNS_P_num):=0;
   return RNS_conv_OPSS_RNS(tmp);
end;

--������� �������� �������� ����������� ������� ����� ������� ��������� ����������
--��������� ������� �� ������ RNS_primes(j)
function add_tree_method(j:uint_8bit; A: T_bin_data_width_set) return uint_8bit is
variable tree_array: T_tree_array;
variable i: uint_8bit;
begin
   for i in 0 to bin_data_width-1 loop
      tree_array(bin_data_width+i):=A(i);
   end loop;
   for i in bin_data_width-1 downto 1 loop
      tree_array(i) := add_mod_8bit(j,tree_array(2*i), tree_array(2*i+1));
   end loop;
   return tree_array(1);
end;

--������� �������� ������������ ������� ����� ������� ��������� ����������
--��������� ������� �� ������ RNS_primes(j)
function mul_tree_method(j:uint_8bit; A: T_bin_data_width_set) return uint_8bit is
variable tree_array: T_tree_array;
variable i: uint_8bit;
begin
   for i in 0 to bin_data_width-1 loop
      tree_array(bin_data_width+i):=A(i);
   end loop;
   for i in bin_data_width-1 downto 1 loop
      tree_array(i) := mul_mod_8bit(j,tree_array(2*i), tree_array(2*i+1));
   end loop;
   return tree_array(1);
end;

--������� �������� ���������� ���������� ������������ ����������� ���� �������� �����
--������� ��������� ���������� (��������� ������� �� ������ RNS_primes(j) )
function scalar_tree_method(j:uint_8bit; op1,op2: T_bin_data_width_set) return uint_8bit is
variable tree_array: T_tree_array;
variable i: uint_8bit;
begin
   for i in 0 to bin_data_width-1 loop
      tree_array(bin_data_width+i):=mul_mod_8bit(j,op1(i),op2(i));
   end loop;
   for i in bin_data_width-1 downto 1 loop
      tree_array(i) := add_mod_8bit(j,tree_array(2*i), tree_array(2*i+1));
   end loop;
   return tree_array(1);
end;

--������ ������� �� ������� ������������� ��������� ����� �� ������� ���������
--������ ��� ������������ ����� ���������� �� ��������������� �������
--������, ������� �� ������� �� ������� ����� �� ������� ������� ��������.
--��������� ������������ ������������ ������� ��������� ����������
--j - ����� ��������� �� ������� RNS_primes[]
--A - �������� �����
function calc_rem_P(j:uint_8bit; A:T_bin_data) return uint_8bit is
variable tmp: T_bin_data_width_set;
variable k: uint_8bit;
begin
   for k in 0 to bin_data_width-1 loop
      if A(k)='1' then tmp(k):=RNS_bin_pows(j)(k); else tmp(k):=0; end if;
   end loop;
   return add_tree_method(j,tmp);
end;

--������� ����� �� �������� ������� ��������� � ���
------------------------------------------------------------------
function RNS_conv_PSS_RNS(A: T_bin_data) return T_RNS_vector is
variable result: T_RNS_vector;
variable i: uint_8bit;
begin
   for i in 1 to RNS_P_num loop
      result(i) := calc_rem_P(i,A);
   end loop;
   return result;
end;

--������� ����� �� ��� � ����
--A=(a1,a2,..,a(p_num)) = opss1+opss2*p1+opss3*p1*p2+...+opss(p_num)*p1*p2*..*p(p_num-1)
function RNS_conv_RNS_OPSS(A: T_RNS_vector) return T_RNS_vector is
variable tmp_res: T_RNS_vector;
variable i,digit: uint_8bit;
variable tmp_add,tmp_neg,tmp_inv: uint_8bit;
begin
   for i in 1 to RNS_P_num loop
      digit := A(i);
      for j in 2 to i loop
         tmp_neg := RNS_primes(i) - RNS_rems_P(i)(tmp_res(j-1));
         tmp_add := add_mod_8bit(i,digit,tmp_neg);
         tmp_inv := inv_mod_8bit(i,RNS_primes(j-1));
         digit := mul_mod_8bit(i,tmp_add,tmp_inv);
      end loop;
      tmp_res(i) := digit;
   end loop;
   return tmp_res;
end;

--������� �������� ����� �� ���� � ���
function RNS_conv_OPSS_RNS(A: T_RNS_vector) return T_RNS_vector is
variable i,j,tmp_res,tmp_rem,tmp_mul: uint_8bit;
variable result: T_RNS_vector;
begin
      for i in 1 to RNS_P_num loop
         tmp_res := 0;
         for j in RNS_P_num downto 1 loop
            tmp_rem := RNS_rems_P(i)(RNS_primes(j));
            tmp_mul := mul_mod_8bit(i,tmp_res,tmp_rem);
            tmp_res := add_mod_8bit(i,tmp_mul,A(j));
         end loop;
         result(i) := tmp_res;
      end loop;
      return result;
end;
 
--������� ����� �� ���� � �������� ������� ���������
function RNS_conv_OPSS_PSS(A: T_RNS_vector) return T_bin_data is
variable tmp_res: T_bin_data;
begin
   tmp_res:=conv_unsigned(0,bin_data_width);
   for i in RNS_P_num downto 1 loop
      tmp_res := conv_unsigned(A(i),8) + bin_mul_uint8bit(tmp_res,RNS_primes(i));
   end loop;
   return tmp_res;
end;

--������� ����� �� ��� � �������� ������� ���������
function RNS_conv_RNS_PSS(A: T_RNS_vector) return T_bin_data is
variable OPSS_res: T_RNS_vector;
begin
   OPSS_res := RNS_conv_RNS_OPSS(A);
   return RNS_conv_OPSS_PSS(OPSS_res);
end;

--������� ����� �� �������� ������� ��������� � ����
function RNS_conv_PSS_OPSS(A: T_bin_data) return T_RNS_vector is
variable RNS_res: T_RNS_vector;
begin
   RNS_res := RNS_conv_PSS_RNS(A);
   return RNS_conv_RNS_OPSS(RNS_res);
end;

--������� �������� ����� � ��� op1 � op2 �� ���������
--result - ���������� ��������� (1 - �����, 0 �� �����)
function RNS_is_equ(op1,op2:T_RNS_vector) return std_logic is
variable flag:std_logic;
variable i:uint_8bit;
begin
   flag:='1';
   for i in 1 to RNS_P_num loop
      if op1(i) /= op2(i) then flag := '0'; end if;
   end loop;
   return flag;
end;

--������� �������� ����� � ��� op1 � op2 �� "op1>op2"
--result - ���������� ��������� (1 - op1>op2, 0 �����)
function RNS_cmp_g(op1,op2:T_RNS_vector) return std_logic is
variable flag1,flag2:std_logic;
variable op1_opss, op2_opss: T_RNS_vector;
begin
   op1_opss:=RNS_conv_RNS_OPSS(op1);
   op2_opss:=RNS_conv_RNS_OPSS(op2);
   flag1:='0'; flag2:='0';
   for i in RNS_P_num downto 1 loop
      if (flag2='0')and(op1_opss(i)>op2_opss(i)) then flag1:='1'; end if;
      if (flag1='0')and(op2_opss(i)>op1_opss(i)) then flag2:='1'; end if;
   end loop;
   return flag1;
end;

end;
