import sys
import subprocess
import os
import shutil


#python single_check.py [modelsim/riviera] [instruction name(Ex, add)]
if __name__ == "__main__":
	if len(sys.argv) != 3:
		print("Parameter count error")
		sys.exit();
	if os.path.exists("./bin/" + sys.argv[2] + ".bin") == False:
		print('Parameter error, Not found "' + sys.argv[2] + '" instruction');
		sys.exit();


	#Syntax Check
	print("Syntax Check\n--------------------------------------------------------------------------------");
	if(sys.argv[1] == "modelsim"):
		subprocess.call("python gen_tcl.py 0 modelsim tb_inst_level ./sim_list.txt ../../com/src_list.txt ../../com/inc_list.txt code_check.log code_check.tcl", shell=True);
		subprocess.call("vsim -do code_check.tcl", shell=True);
	elif(sys.argv[1] == "riviera"):
		subprocess.call("python gen_tcl.py 0 riviera tb_inst_level ./sim_list.txt ../../com/src_list.txt ../../com/inc_list.txt code_check.log code_check.tcl", shell=True);
		subprocess.call("vsimsa -do code_check.tcl", shell=True);
	else:
		print("Parameter error, argv[1] : modelsim or riviera")
		sys.exit();
	subprocess.call("python code_check_summary.py code_check.log", shell=True);

	#Code Simulation
	if os.path.exists("bin_single") == True:
		shutil.rmtree("bin_single")	#folder remove
	os.mkdir("bin_single")
	subprocess.call("cp bin/" + sys.argv[2] + ".bin bin_single/" + sys.argv[2] + ".bin", shell=True);
	shutil.rmtree("sim")	#folder remove
	os.mkdir("sim")

	print("\nSimulation\n--------------------------------------------------------------------------------");
	if(sys.argv[1] == "modelsim"):
		subprocess.call("python sim_run.py code_check.log modelsim tb_inst_level tb_inst_test.hex ./sim_list.txt ../../com/src_list.txt ../../com/inc_list.txt bin_single/", shell=True);
	elif(sys.argv[1] == "riviera"):
		subprocess.call("python sim_run.py code_check.log modelsim tb_inst_level tb_inst_test.hex ./sim_list.txt ../../com/src_list.txt ../../com/inc_list.txt bin_single/", shell=True);
	else:
		print("Parameter error, argv[1] : modelsim or riviera")
		sys.exit();
	shutil.rmtree("bin_single")	#folder remove

	subprocess.call("python sim_summary.py sim/", shell=True);


