-----------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
USE work.RNS_defs_pkg.all;

entity CPU_module is
   generic (data_width: integer range 1 to 32 := 16;
            addr_width: integer range 1 to 32 := 16);
   Port ( 
      data_in: in std_logic_vector(data_width-1 downto 0);
      we_data_out: out std_logic;
      data_out_addr: out std_logic_vector(addr_width-1 downto 0);
      data_out: out std_logic_vector(data_width-1 downto 0);
      cmd_in: in std_logic_vector(31 downto 0);
      cmd_next_addr: out std_logic_vector(addr_width-1 downto 0);
      reset_ip: in STD_LOGIC;
      clock: in STD_LOGIC
   );
end CPU_module;

architecture Spartan3e500 of CPU_module is

component RNS_ALU_module
   Port ( 
      op_code: in integer range 0 to 7;
      op1,op2: in T_RNS_vector;
      result: out T_RNS_vector;
      equ_out: out std_logic;
      clock: in std_logic
   );
end component;

component bin_ALU_module
   generic (data_width: integer range 1 to 32 := 16);
   Port ( 
      op_code: in integer range 0 to 7;
      op1, op2: in STD_LOGIC_VECTOR (data_width-1 downto 0);
      result: out STD_LOGIC_VECTOR (data_width-1 downto 0);
      equ_out, AgB_out: out std_logic;
      clock: in std_logic
   );
end component;

component RNS_regs_module
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
end component;

component bin_regs_module
   generic(regs_num: integer range 1 to 256 := 8;
           data_width: integer range 1 to 32 := 16);
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
end component;

component RNS_stack_module
   generic(depth: integer range 1 to 256 := 32);
   Port (
      ena: in std_logic;
      rw: in std_logic;
      item_write: in T_RNS_vector;
      item_read: out T_RNS_vector;
      clock: in STD_LOGIC
   );
end component;

component bin_stack_module is
   generic(depth: integer range 1 to 256 := 32;
           item_width: integer range 1 to 32 := 16);
   Port (
      ena: in std_logic;
      rw: in std_logic;
      item_write: in std_logic_vector(item_width-1 downto 0);
      item_read: out std_logic_vector(item_width-1 downto 0);
      clock: in STD_LOGIC
   );
end component;

component CPU_forth_core
   generic (data_width: integer range 1 to 16 := 16;
            addr_width: integer range 1 to 16 := 16);
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
end component;

signal we_rns_mem: std_logic;
signal rns_reg_idx, rns_reg1_idx, rns_reg2_idx: integer range 0 to RNS_regs_num-1;
signal RNS_reg1_in, RNS_reg2_in, RNS_reg_out: T_RNS_vector;

signal d_stack_rns_ena, d_stack_rns_rw: std_logic;
signal d_stack_rns_iw, d_stack_rns_ir: T_RNS_vector;

signal we_bin_mem: std_logic;
signal bin_reg_idx, bin_reg1_idx, bin_reg2_idx: integer range 0 to bin_regs_num-1;
signal bin_reg1_in, bin_reg2_in, bin_reg_out: std_logic_vector(data_width-1 downto 0);

signal d_stack_bin_ena, d_stack_bin_rw: std_logic;
signal d_stack_bin_iw, d_stack_bin_ir: std_logic_vector(data_width-1 downto 0);

signal r_stack_bin_ena, r_stack_bin_rw: std_logic;
signal r_stack_bin_iw, r_stack_bin_ir: std_logic_vector(addr_width-1 downto 0);

signal ALU_bin_op_code, ALU_RNS_op_code: integer range 0 to 7;
signal ALU_bin_op1, ALU_bin_op2, ALU_bin_result: std_logic_vector(data_width-1 downto 0);
signal ALU_RNS_op1, ALU_RNS_op2, ALU_RNS_result: T_RNS_vector;
signal flags: std_logic_vector(7 downto 0);

begin
   RNS_ALU: RNS_ALU_module
      port map (
         op_code => ALU_RNS_op_code,
         op1 => ALU_RNS_op1,
         op2 => ALU_RNS_op2,
         result => ALU_RNS_result,
         equ_out => flags(0),
         clock => clock
      );
   flags(1) <= '0';
   flags(2) <= '0';
   flags(3) <= not(flags(0));

   BIN_ALU: bin_ALU_module
      generic map (data_width => data_width)
      port map (
         op_code => ALU_bin_op_code,
         op1 => ALU_bin_op1,
         op2 => ALU_bin_op2,
         result => ALU_bin_result,
         equ_out => flags(4),
         AgB_out => flags(5),
         clock => clock
      );
   
   flags(6) <= not(flags(5));
   flags(7) <= not(flags(4));

   RNS_regs: RNS_regs_module
   generic map(regs_num => RNS_regs_num)
   Port map(
      we => we_rns_mem,
      reg_idx => rns_reg_idx,
      data_in => RNS_reg_out,
      reg1_idx => rns_reg1_idx,
      reg2_idx => rns_reg2_idx,
      data1_out => RNS_reg1_in,
      data2_out => RNS_reg2_in,
      clock => clock
   );

   BIN_regs: bin_regs_module
   generic map(regs_num => bin_regs_num, data_width => data_width)
   Port map(
      we => we_bin_mem,
      reg_idx => bin_reg_idx,
      data_in => bin_reg_out,
      reg1_idx => bin_reg1_idx,
      reg2_idx => bin_reg2_idx,
      data1_out => bin_reg1_in,
      data2_out => bin_reg2_in,
      clock => clock
   );

   D_stack_RNS: RNS_stack_module
   generic map(depth => 32)
   Port map(
      ena => d_stack_rns_ena,
      rw => d_stack_rns_rw,
      item_write => d_stack_rns_ir,
      item_read => d_stack_rns_iw,
      clock => clock
   );

   D_stack_bin: bin_stack_module
   generic map(depth => 32, item_width => data_width)
   Port map(
      ena => d_stack_bin_ena,
      rw => d_stack_bin_rw,
      item_write => d_stack_bin_ir,
      item_read => d_stack_bin_iw,
      clock => clock
   );

   R_stack_bin: bin_stack_module
   generic map(depth => 32, item_width => addr_width)
   Port map(
      ena => r_stack_bin_ena,
      rw => r_stack_bin_rw,
      item_write => r_stack_bin_ir,
      item_read => r_stack_bin_iw,
      clock => clock
   );

   forth_core: CPU_forth_core
   generic map(data_width => data_width, addr_width => addr_width)
   Port map(
      cmd_in => cmd_in,
      cmd_next_addr => cmd_next_addr,
      
      flags => flags,
      reset => reset_ip,
      
      we_data_out => we_data_out,
      data_out_addr => data_out_addr,
      data_out => data_out,
      data_in => data_in,

      we_rns => we_rns_mem,
      we_bin => we_bin_mem,
      
      RNS_reg_idx => RNS_reg_idx,
      bin_reg_idx => bin_reg_idx,
      RNS_reg_out => RNS_reg_out,
      bin_reg_out => bin_reg_out,

      RNS_reg1_idx => RNS_reg1_idx,
      RNS_reg2_idx => RNS_reg2_idx,
      bin_reg1_idx => bin_reg1_idx,
      bin_reg2_idx => bin_reg2_idx,
      RNS_reg1_in => RNS_reg1_in,
      RNS_reg2_in => RNS_reg2_in,
      bin_reg1_in => bin_reg1_in,
      bin_reg2_in => bin_reg2_in,

      d_stack_rns_ena => d_stack_rns_ena,
      d_stack_rns_rw => d_stack_rns_rw,
      d_stack_rns_iw => d_stack_rns_iw,
      d_stack_rns_ir => d_stack_rns_ir,

      d_stack_bin_ena => d_stack_bin_ena,
      d_stack_bin_rw => d_stack_bin_rw,
      d_stack_bin_iw => d_stack_bin_iw,
      d_stack_bin_ir => d_stack_bin_ir,

      r_stack_bin_ena => r_stack_bin_ena,
      r_stack_bin_rw => r_stack_bin_rw,
      r_stack_bin_iw => r_stack_bin_iw,
      r_stack_bin_ir => r_stack_bin_ir,

      ALU_bin_op_code => ALU_bin_op_code,
      ALU_bin_op1 => ALU_bin_op1,
      ALU_bin_op2 => ALU_bin_op2,
      ALU_bin_result => ALU_bin_result,
      
      ALU_RNS_op_code => ALU_RNS_op_code,
      ALU_RNS_op1 => ALU_RNS_op1,
      ALU_RNS_op2 => ALU_RNS_op2,
      ALU_RNS_result => ALU_RNS_result,
      clock => clock
   );
end Spartan3e500;
