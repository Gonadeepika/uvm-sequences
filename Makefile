#Makefile for UVM Testbench - Lab 05

# SIMULATOR = Questa for Mentor's Questasim
# SIMULATOR = VCS for Synopsys's VCS

SIMULATOR = VCS



RTL= ../rtl/*
work= work #library name
SVTB1= ../tb/top.sv
INC = +incdir+../tb +incdir+../test +incdir+../wr_agt_top +incdir+../rd_agt_top
SVTB2 = ../test/ram_test_pkg.sv
VSIMOPT= -vopt -voptargs=+acc 
VSIMCOV= -coverage -sva 
VSIMBATCH1= -c -do  " log -r /* ;coverage save -onexit mem_cov1;run -all; exit"
VSIMBATCH2= -c -do  " log -r /* ;coverage save -onexit mem_cov2;run -all; exit"
VSIMBATCH3= -c -do  " log -r /* ;coverage save -onexit mem_cov3;run -all; exit"
VSIMBATCH4= -c -do  " log -r /* ;coverage save -onexit mem_cov4;run -all; exit"


help:
	@echo =============================================================================================================
	@echo "! USAGE   	--  make target                             											!"
	@echo "! clean   	=>  clean the earlier log and intermediate files.       								!"
	@echo "! sv_cmp    	=>  Create library and compile the code.                   								!"
	@echo "! run_test	=>  clean, compile & run the simulation for ram_signle_adddr_test in batch mode.		!" 
	@echo "! run_test1	=>  clean, compile & run the simulation for ram_ten_addr_test in batch mode.			!" 
	@echo "! run_test2	=>  clean, compile & run the simulation for ram_odd_addr_test in batch mode.			!"
	@echo "! run_test3	=>  clean, compile & run the simulation for ram_even_addr_test in batch mode.		!" 
	@echo ====================================================================================================================

clean : clean_$(SIMULATOR)
sv_cmp : sv_cmp_$(SIMULATOR)
run_test : run_test_$(SIMULATOR)
run_test1 : run_test1_$(SIMULATOR)
run_test2 : run_test2_$(SIMULATOR)
run_test3 : run_test3_$(SIMULATOR)

# ----------------------------- Start of Definitions for Mentor's Questa Specific Targets -------------------------------#

sv_cmp_Questa:
	vlib $(work)
	vmap work $(work)
	vlog -work $(work) $(INC) $(SVTB2) $(SVTB1) 	
	
run_test_Questa: clean sv_cmp
	vsim  $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH1)  -l test1.log  -sv_seed random  work.top +UVM_TESTNAME=ram_single_addr_test
	
run_test1_Questa: clean sv_cmp
	vsim  $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH2)  -l test2.log  -sv_seed random  work.top +UVM_TESTNAME=ram_ten_addr_test
	
run_test2_Questa: clean sv_cmp
	vsim $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH3)   -l test3.log  -sv_seed random  work.top +UVM_TESTNAME=ram_odd_addr_test
	
run_test3_Questa: clean sv_cmp
	vsim $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH4)   -l test4.log  -sv_seed random  work.top +UVM_TESTNAME=ram_even_addr_test
		
clean_Questa: 
	rm -rf transcript* *log* fcover* covhtml* mem_cov* *.wlf modelsim.ini work
	clear

# ----------------------------- End of Definitions for Mentor's Questa Specific Targets -------------------------------#

# ----------------------------- Start of Definitions for Synopsys's VCS Specific Targets -------------------------------#

sv_cmp_VCS:
	vcs -l vcs.log -timescale=1ns/1ps -sverilog -ntb_opts uvm -debug_access+all -full64 $(INC) $(SVTB2) $(SVTB1)
	      
run_test_VCS:	clean  sv_cmp_VCS
	./simv -a test.log +ntb_random_seed_automatic +UVM_TESTNAME=ram_single_addr_test
	
run_test1_VCS: clean  sv_cmp_VCS	
	./simv -a test1.log +ntb_random_seed_automatic +UVM_TESTNAME=ram_ten_addr_test 	
	
run_test2_VCS: clean  sv_cmp_VCS	
	./simv -a test2.log +ntb_random_seed_automatic +UVM_TESTNAME=ram_odd_addr_test
	
run_test3_VCS: clean  sv_cmp_VCS	
	./simv -a test3.log +ntb_random_seed_automatic +UVM_TESTNAME=ram_even_addr_test 	
	
clean_VCS:
	rm -rf simv* csrc* *.tmp *.vdb *.key *.log *hdrs.h urgReport* novas* vdCov*
	clear

# ----------------------------- END of Definitions for Synopsys's VCS Specific Targets -------------------------------#
