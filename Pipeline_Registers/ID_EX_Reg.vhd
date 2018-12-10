-- ID/EX
library IEEE;
use IEEE.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity ID_EX_Reg is 
	port ( 
		-- inputs
		clk			: in std_logic;
		arst, aload	: in std_logic;
		
		control_wb	: in std_logic_vector(1 downto 0);
		control_mem	: in std_logic_vector(4 downto 0);
      		--control_mem(0): beq
      		--control_mem(1): bneq
      		--control_mem(2): bgtz
      		--control_mem(3): MemRead
      		--control_mem(4): MemWrite
		control_ex	: in std_logic_vector(3 downto 0);
		
		pc_in		: in std_logic_vector(31 downto 0);
		
		read_data1	: in std_logic_vector(31 downto 0);
		read_data2	: in std_logic_vector(31 downto 0);
		
		sign_ext	: in std_logic_vector(31 downto 0);
		
		instruct_1	: in std_logic_vector(4 downto 0);
		instruct_2	: in std_logic_vector(4 downto 0);
		
		--outputs
		control_wb_out	: out std_logic_vector(1 downto 0);
		control_mem_out	: out std_logic_vector(4 downto 0);
		ALUSrc			: out std_logic;
		ALUOp			: out std_logic_vector(1 downto 0);
		RegDst			: out std_logic;
		
		pc_out 			: out std_logic_vector(31 downto 0);
		bus_a			: out std_logic_vector(31 downto 0);
		bus_b			: out std_logic_vector(31 downto 0);
		out_sign_ext	: out std_logic_vector(31 downto 0);
		
		out_instruct1	: out std_logic_vector(4 downto 0);
		out_instruct2	: out std_logic_vector(4 downto 0)
	);
end entity ID_EX_Reg;

architecture structural of ID_EX_Reg is
begin

-- WB
	gen_WB_reg : for i in 0 to 1 generate
		dff_WB : dffr_a port map(
			clk => clk,
			arst => arst,
			aload => aload,
			adata => '0',
			d => control_wb(i),
			enable => '1',
			q => control_wb_out(i)
		);
	end generate;
	
-- MEM
	gen_MEM_reg : for i in 0 to 4 generate
		dff_MEM : dffr_a port map(
			clk => clk,
			arst => arst,
			aload => aload,
			adata => '0',
			d => control_mem(i),
			enable => '1',
			q => control_mem_out(i)
		);
	end generate;
	
-- EX
	control_ex1 : dffr_a port map(
			clk => clk,
			arst => arst,
			aload => aload,
			adata => '0',
			d => control_ex(0),
			enable => '1',
			q => ALUSrc
	);
	
	control_ex2 : dffr_a port map(
			clk => clk,
			arst => arst,
			aload => aload,
			adata => '0',
			d => control_ex(1),
			enable => '1',
			q => ALUOp(0)
	);

	control_ex3 : dffr_a port map(
			clk => clk,
			arst => arst,
			aload => aload,
			adata => '0',
			d => control_ex(2),
			enable => '1',
			q => ALUOp(1)
	);
	
	control_ex4 : dffr_a port map(
			clk => clk,
			arst => arst,
			aload => aload,
			adata => '0',
			d => control_ex(3),
			enable => '1',
			q => RegDst
	);

-- pc
	gen_pc_reg : for i in 0 to 31 generate
		dff_pc : dffr_a port map (
			clk	=> clk,
			arst => arst,
			aload => aload,
			adata => '0', --reset will initialize register with 0
			d => pc_in(i),
			enable => '1',
			q => pc_out(i)
		);
	end generate;

-- read_data1
	gen_data_1_reg : for i in 0 to 31 generate
		dff_data_1 : dffr_a port map (
			clk	=> clk,
			arst => arst,
			aload => aload,
			adata => '0', --reset will initialize register with 0
			d => read_data1(i),
			enable => '1',
			q => bus_a(i)
		);
	end generate;
	
-- read_data2
	gen_data_2_reg : for i in 0 to 31 generate
		dff_data_2 : dffr_a port map (
			clk	=> clk,
			arst => arst,
			aload => aload,
			adata => '0', --reset will initialize register with 0
			d => read_data2(i),
			enable => '1',
			q => bus_b(i)
		);
	end generate;

-- sign ext
	gen_sign_ext_reg : for i in 0 to 31 generate
		dff_sign_ext : dffr_a port map (
			clk	=> clk,
			arst => arst,
			aload => aload,
			adata => '0', --reset will initialize register with 0
			d => sign_ext(i),
			enable => '1',
			q => out_sign_ext(i)
		);
	end generate;

-- instruct 1
	gen_instruct_1_reg : for i in 0 to 4 generate
		dff_instruct_1 : dffr_a port map (
			clk	=> clk,
			arst => arst,
			aload => aload,
			adata => '0', --reset will initialize register with 0
			d => instruct_1(i),
			enable => '1',
			q => out_instruct1(i)
		);
	end generate;
	
-- instruct 2
	gen_instruct_2_reg : for i in 0 to 4 generate
		dff_instruct_2 : dffr_a port map (
			clk	=> clk,
			arst => arst,
			aload => aload,
			adata => '0', --reset will initialize register with 0
			d => instruct_2(i),
			enable => '1',
			q => out_instruct2(i)
		);
	end generate;


end architecture structural;