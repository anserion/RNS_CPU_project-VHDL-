-----------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
USE work.RNS_defs_pkg.all;

entity CPU_forth_core is
   generic (data_width: integer range 1 to 32 := 8;
            addr_width: integer range 1 to 32 := 8);
   Port (
      cmd_in: in std_logic_vector(31 downto 0);
      cmd_next_addr: out std_logic_vector(addr_width-1 downto 0);
      
      flags: in std_logic_vector(7 downto 0);
      reset: in std_logic;

      we_data_out: out std_logic;
      data_out_addr: out std_logic_vector(addr_width-1 downto 0);
      data_out: out std_logic_vector(data_width-1 downto 0);
      data_in: in std_logic_vector(data_width-1 downto 0);

      we_rns, we_bin: out std_logic;
      RNS_reg_idx: out integer range 0 to RNS_regs_num-1;
      RNS_reg_out: out T_RNS_vector;

      bin_reg_idx: out integer range 0 to bin_regs_num-1;
      bin_reg_out: out std_logic_vector(data_width-1 downto 0);

      RNS_reg1_idx: out integer range 0 to RNS_regs_num-1;
      RNS_reg2_idx: out integer range 0 to RNS_regs_num-1;
      RNS_reg1_in: in T_RNS_vector;
      RNS_reg2_in: in T_RNS_vector;

      bin_reg1_idx: out integer range 0 to bin_regs_num-1;
      bin_reg2_idx: out integer range 0 to bin_regs_num-1;
      bin_reg1_in: in std_logic_vector(data_width-1 downto 0);
      bin_reg2_in: in std_logic_vector(data_width-1 downto 0);

      d_stack_rns_ena: in std_logic;
      d_stack_rns_rw: in std_logic;
      d_stack_rns_iw: in T_RNS_vector;
      d_stack_rns_ir: out T_RNS_vector;

      d_stack_bin_ena: in std_logic;
      d_stack_bin_rw: in std_logic;
      d_stack_bin_iw: in std_logic_vector(data_width-1 downto 0);
      d_stack_bin_ir: out std_logic_vector(data_width-1 downto 0);

      r_stack_bin_ena: in std_logic;
      r_stack_bin_rw: in std_logic;
      r_stack_bin_iw: in std_logic_vector(addr_width-1 downto 0);
      r_stack_bin_ir: out std_logic_vector(addr_width-1 downto 0);

      ALU_bin_op_code: out integer range 0 to 7;
      ALU_bin_op1, ALU_bin_op2: out std_logic_vector(data_width-1 downto 0);
      ALU_bin_result: in std_logic_vector(data_width-1 downto 0);

      ALU_RNS_op_code: out integer range 0 to 7;
      ALU_rns_op1, ALU_rns_op2: out T_RNS_vector;
      ALU_rns_result: in T_RNS_vector;
      clock: std_logic
   );
end CPU_forth_core;

architecture Spartan3e500 of CPU_forth_core is
signal reg_ip,reg_ip_next: integer range 0 to CPU_cmds_num-1;
signal cmd: T_RNS_CPU_CMD;
begin
--   process(clock)
--   begin
--   if (clock'event and clock = '1') then
--      if reset='1' then reg_ip <= 0;
--      else
--         if reg_ip /= CPU_cmds_num-1 then
--            cmd.mne <= conv_integer(cmd_in(31 downto 24));
--            cmd.op1 <= conv_integer(cmd_in(23 downto 16));
--            cmd.op2 <= conv_integer(cmd_in(15 downto 8));
--            cmd.op3 <= conv_integer(cmd_in(7 downto 0));
--            reg_ip_next <= reg_ip+1;
--            case cmd.mne is
--              --cpu system mnemonics
--            ----------------------
--            when 0 => null; --NOP
--            when 1 => reg_ip_next <= CPU_cmds_num-1; --HALT
--            when 2 => ALU_op_code <= 14; --set ALU to RNS-only mode
--            when 3 => ALU_op_code <= 15; --set ALU to binary input mode
--            
--            --binary<-->RNS transform
--            -------------------------
--            --convert bin_reg(op1) --> RNS_reg(op2)
--            when 8 => we_RNS <= '1'; we_bin <= '0';
--                      RNS_reg_idx <= cmd.op2;
--                      bin_reg1_idx <= cmd.op1;
--                      ALU_op_code <= 0;
--                      ALU_A_bin <= bin_reg1_in;                        
--                      RNS_reg_out <= ALU_result_RNS;
--            --convert RNS_reg(op1) --> bin_reg(op2) 
--            when 9 => we_RNS <= '0'; we_bin <= '1';
--                      RNS_reg1_idx <= cmd.op1;
--                      bin_reg_idx <= cmd.op2;
--                      ALU_op_code <= 0;
--                      ALU_A_RNS <= RNS_reg1_in;
--                      bin_reg_out <= ALU_result_bin;
--         
--            --jump logic mnemonics
--            ----------------------
--            when 16 => reg_ip <= cmd.op1; --goto cmd.op1
--            when 17 => if reg_flags(0)='1' then reg_ip_next <= cmd.op1; end if; --jump equal
--            when 18 => if reg_flags(1)='1' then reg_ip_next <= cmd.op1; end if; --jump greater  
--            when 19 => if reg_flags(2)='1' then reg_ip_next <= cmd.op1; end if; --jump lower
--            when 20 => if reg_flags(3)='1' then reg_ip_next <= cmd.op1; end if; --jump not equal
--            when 21 => if (reg_flags(0)='1')and(reg_flags(1)='1') then --jump greater&equal
--                         reg_ip_next <= cmd.op1;
--                       end if;
--            when 22 => if (reg_flags(0)='1')and(reg_flags(2)='1') then --jump low&equal
--                         reg_ip_next <= cmd.op1;
--                       end if;
--
--            --set "reg_flag" bits for a "bin_reg(op1)" and "bin_reg(op2)"
--            --need to set ALU the "binary input mode" before it
--            when 23 => we_bin <= '0';
--                       bin_reg1_idx <= cmd.op1; bin_reg2_idx <= cmd.op2;
--                       ALU_op_code <= 0;
--                       ALU_A_bin <= bin_reg1_in;
--                       ALU_B_bin <= bin_reg2_in;
--
--            --set "reg_flag" bits for a "RNS_reg(op1)" and "RNS_reg(op2)"
--            --need to set ALU the "RNS input mode" before it
--            when 24 => we_rns <= '0';
--                       RNS_reg1_idx <= cmd.op1; RNS_reg2_idx <= cmd.op2;
--                       ALU_op_code <= 0;
--                       ALU_A_RNS <= RNS_reg1_in;
--                       ALU_B_RNS <= RNS_reg2_in;
--
--            --data move mnemonics
--            ------------------------------
--            --bin_reg(op1) := op2
--            when 32 => we_bin <= '1';
--                      bin_reg_idx <= cmd.op1;
--                      bin_reg_out <= conv_std_logic_vector(cmd.op2,data_width);
--            --RNS_reg(op1)(p_op2) := op3
--            when 33 => we_RNS <= '1';
--                      RNS_reg_idx <= cmd.op1;
--                      RNS_reg_out(cmd.op2) <= cmd.op3;
--            --bin_reg(op1) := CPU_data_in
--            when 34 => we_bin <= '1';
--                      bin_reg_idx <= cmd.op1;
--                      bin_reg_out <= CPU_data_in;
--            --CPU_data_out := bin_reg(op1)
--            when 35 => we_bin <= '0';
--                      bin_reg1_idx <= cmd.op1;
--                      CPU_data_out <= bin_reg1_in;
--            --RNS_reg(op1)(p_op2) := CPU_data_in
--            when 36 => we_RNS <= '1';
--                      RNS_reg_idx <= cmd.op1;
--                      RNS_reg_out(cmd.op2) <= conv_integer(CPU_data_in);
--            --CPU_data_out := RNS_reg(op1)(p_op2)
--            when 37 => we_RNS <= '0';
--                      RNS_reg1_idx <= cmd.op1;
--                      CPU_data_out <= conv_std_logic_vector(RNS_reg1_in(cmd.op2),data_width);
--            --RNS_reg(op1)(p_op2) := bin_reg(op3)
--            when 38 => we_RNS <= '1'; we_bin <= '0';
--                       RNS_reg_idx <= cmd.op1; bin_reg1_idx <= cmd.op3;
--                       RNS_reg_out(cmd.op2) <= conv_integer(bin_reg1_in);
--             --bin_reg(op1) := RNS_reg(op2)(p_op3)
--            when 39 => we_RNS <= '0'; we_bin <= '1';
--                       RNS_reg1_idx <= cmd.op2; bin_reg_idx <= cmd.op1;
--                       bin_reg_out <= conv_std_logic_vector(RNS_reg1_in(cmd.op3),data_width);
--
--            --binary input math mnemonics
--            --need to set ALU the "binary input mode" before it
--            ---------------------------------------------------
--            --bin_reg(op2) := neg(bin_reg(op1))
--            when 48 => we_bin <= '1';
--                       bin_reg_idx <= cmd.op2; bin_reg1_idx <= cmd.op1;
--                       ALU_op_code <= 1;
--                       ALU_A_bin <= bin_reg1_in;
--                       bin_reg_out <= ALU_result_bin;
--                       
--            --bin_reg(op2) := inv(bin_reg(op1))
--            when 49 => we_bin <= '1';
--                       bin_reg_idx <= cmd.op2; bin_reg1_idx <= cmd.op1;
--                       ALU_op_code <= 2;
--                       ALU_A_bin <= bin_reg1_in;
--                       bin_reg_out <= ALU_result_bin;
--                       
--            --bin_reg(op3) := bin_reg(op1) + bin_reg(op2)
--            when 50 => we_bin <= '1';
--                       bin_reg_idx <= cmd.op3; bin_reg1_idx <= cmd.op1; bin_reg2_idx <= cmd.op2;
--                       ALU_op_code <= 3;
--                       ALU_A_bin <= bin_reg1_in;
--                       ALU_B_bin <= bin_reg2_in;
--                       bin_reg_out <= ALU_result_bin;
--                       
--            --bin_reg(op3) := bin_reg(op1) * bin_reg(op2)
--            when 51 => we_bin <= '1';
--                       bin_reg_idx <= cmd.op3; bin_reg1_idx <= cmd.op1; bin_reg2_idx <= cmd.op2;
--                       ALU_op_code <= 4;
--                       ALU_A_bin <= bin_reg1_in;
--                       ALU_B_bin <= bin_reg2_in;
--                       bin_reg_out <= ALU_result_bin;
--                       
--            --bin_reg(op3) := bin_reg(op1) - bin_reg(op2)
--            when 52 => we_bin <= '1';
--                       bin_reg_idx <= cmd.op3; bin_reg1_idx <= cmd.op1; bin_reg2_idx <= cmd.op2;
--                       ALU_op_code <= 5;
--                       ALU_A_bin <= bin_reg1_in;
--                       ALU_B_bin <= bin_reg2_in;
--                       bin_reg_out <= ALU_result_bin;
--                       
--            --bin_reg(op3) := bin_reg(op1) fdiv bin_reg(op2)
--            when 53 => we_bin <= '1';
--                       bin_reg_idx <= cmd.op3; bin_reg1_idx <= cmd.op1; bin_reg2_idx <= cmd.op2;
--                       ALU_op_code <= 6;
--                       ALU_A_bin <= bin_reg1_in;
--                       ALU_B_bin <= bin_reg2_in;
--                       bin_reg_out <= ALU_result_bin;
--
--            --RNS input math mnemonics
--            --need to set ALU the "RNS input mode" before it
--            ------------------------------------------------
--            --RNS_reg(op2) := neg(RNS_reg(op1))
--            when 64 => we_RNS <= '1';
--                       RNS_reg_idx <= cmd.op2; RNS_reg1_idx <= cmd.op1;
--                       ALU_op_code <= 1;
--                       ALU_A_RNS <= RNS_reg1_in;
--                       RNS_reg_out <= ALU_result_RNS;
--                       
--            --RNS_reg(op2) := inv(RNS_reg(op1))
--            when 65 => we_RNS <= '1';
--                       RNS_reg_idx <= cmd.op2; RNS_reg1_idx <= cmd.op1;
--                       ALU_op_code <= 2;
--                       ALU_A_RNS <= RNS_reg1_in;
--                       RNS_reg_out <= ALU_result_RNS;
--                       
--            --RNS_reg(op3) := RNS_reg(op1) + RNS_reg(op2)
--            when 66 => we_RNS <= '1';
--                       RNS_reg_idx <= cmd.op3; RNS_reg1_idx <= cmd.op1; RNS_reg2_idx <= cmd.op2;
--                       ALU_op_code <= 3;
--                       ALU_A_RNS <= RNS_reg1_in;
--                       ALU_B_RNS <= RNS_reg2_in;
--                       RNS_reg_out <= ALU_result_RNS;
--                       
--            --RNS_reg(op3) := RNS_reg(op1) * RNS_reg(op2)
--            when 67 => we_RNS <= '1';
--                       RNS_reg_idx <= cmd.op3; RNS_reg1_idx <= cmd.op1; RNS_reg2_idx <= cmd.op2;
--                       ALU_op_code <= 4;
--                       ALU_A_RNS <= RNS_reg1_in;
--                       ALU_B_RNS <= RNS_reg2_in;
--                       RNS_reg_out <= ALU_result_RNS;
--                       
--            --RNS_reg(op3) := RNS_reg(op1) - RNS_reg(op2)
--            when 68 => we_RNS <= '1';
--                       RNS_reg_idx <= cmd.op3; RNS_reg1_idx <= cmd.op1; RNS_reg2_idx <= cmd.op2;
--                       ALU_op_code <= 5;
--                       ALU_A_RNS <= RNS_reg1_in;
--                       ALU_B_RNS <= RNS_reg2_in;
--                       RNS_reg_out <= ALU_result_RNS;
--                       
--            --RNS_reg(op3) := RNS_reg(op1) fdiv RNS_reg(op2)
--            when 69 => we_RNS <= '1';
--                       RNS_reg_idx <= cmd.op3; RNS_reg1_idx <= cmd.op1; RNS_reg2_idx <= cmd.op2;
--                       ALU_op_code <= 6;
--                       ALU_A_RNS <= RNS_reg1_in;
--                       ALU_B_RNS <= RNS_reg2_in;
--                       RNS_reg_out <= ALU_result_RNS;
--            when others => null;
--            end case;
--            reg_ip <= reg_ip_next;
--         end if;
--      end if;
--   end if;
--   end process;
--   reg_ip_out <= reg_ip;
--   
end Spartan3e500;
