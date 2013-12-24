####################################################################
# Simulator Target
####################################################################
#Riviera-Pro
default: riviera_code_check riviera_sim_run sim_summary


#Model-sim
#default: modelsim_code_check modelsim_sim_run sim_summary

####################################################################



########## Modelsim ##########
modelsim_code_check:
	python gen_tcl.py 0 modelsim tb_func_level ./sim_list.txt ../../com/src_list.txt ../../com/inc_list.txt code_check.log code_check.tcl
	echo ----------------------------------------------------------------------------------------
	echo Start Code Check

	vsim -do code_check.tcl
	python code_check_summary.py code_check.log

modelsim_sim_run:
	python sim_run.py code_check.log modelsim tb_func_level tb_func_test.hex ./sim_list.txt ../../com/src_list.txt ../../com/inc_list.txt bin/


########## Riviera ##########
riviera_code_check:
	python gen_tcl.py 0 riviera tb_func_level ./sim_list.txt ../../com/src_list.txt ../../com/inc_list.txt code_check.log code_check.tcl
	echo ----------------------------------------------------------------------------------------
	echo Start Code Check

	vsimsa -do code_check.tcl
	python code_check_summary.py code_check.log

riviera_sim_run:
	python sim_run.py code_check.log riviera tb_func_level tb_func_test.hex ./sim_list.txt ../../com/src_list.txt ../../com/inc_list.txt bin/


########## Simulation Summary ##########
sim_summary:
	python sim_summary.py sim/
	
