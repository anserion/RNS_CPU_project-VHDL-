--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
USE work.RNS_defs_pkg.all;
 
ENTITY RNS_ALU_tb IS
END RNS_ALU_tb;
 
ARCHITECTURE behavior OF RNS_ALU_tb IS 

component RNS_ALU_module
   Port ( 
      op_code: in integer range 0 to 7;
      op1,op2: in T_RNS_vector;
      result: out T_RNS_vector;
      equ_out: out std_logic;
      cmp_out: out std_logic;
      clock: in std_logic
   );
end component;
 
   --Inputs
   signal sig_op_code:integer range 0 to 7:=0;
   signal sig_op1, sig_op2: T_RNS_vector;
 	--Outputs
   signal result: T_RNS_vector;
   signal result_equ, result_cmp: std_logic;
   
   --Clock
   constant clock_period : time := 100 ns;
   signal clock:std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
uut_ALU: RNS_ALU_module
   Port map( 
      op_code=>sig_op_code,
      op1=>sig_op1,
      op2=>sig_op2,      
      result=>result,
      equ_out=>result_equ,
      cmp_out=>result_cmp,
      clock=>clock
   );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '1';
		wait for clock_period/2;
		clock <= '0';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   variable i:uint_8bit;
   variable op1_bin:integer :=0 ;
   variable op2_bin:integer :=0 ;
   variable op_code:integer :=0 ;
   variable op1,op2: T_RNS_vector;
   begin
      wait for clock_period;
      op1_bin := op1_bin+1;
      if op1_bin>=255 then
         op2_bin := op2_bin+1;
         op1_bin := 0;
      end if;
      op1 := RNS_conv_PSS_RNS(conv_unsigned(op1_bin,bin_data_width));
      op2 := RNS_conv_PSS_RNS(conv_unsigned(op2_bin,bin_data_width)); 
      sig_op1 <= op1;
      sig_op2 <= op2;
      op_code := op_code+1;
      if op_code>7 then op_code:=0; end if;
      sig_op_code <= op_code;
      wait for clock_period;
   end process;

END;
