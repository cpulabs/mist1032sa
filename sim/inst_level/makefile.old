default: code_check sim_run sim_summary


code_check:
	python code_check_set.py compile_list.txt code_check.tcl
	
	vsimsa -do code_check.tcl
	python code_check_result.py code_check.log


sim_run:
	python sim.py code_check.log compile_list.txt bin/

sim_summary:
	python sim_summary.py sim/
	
