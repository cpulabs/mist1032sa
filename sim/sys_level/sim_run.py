import subprocess;
import sys;
import glob;
import datetime;
import locale;
import shutil;
import os;
import os.path;
import gen_tcl;
import bin2hex;


check_list = [];


def error_check(line_text):
	error_cnt = 0;
	line_list = line_text.split(' ');
	if(len(line_list) > 2):
			if(line_list[2] == "Error:"):
					error_cnt = error_cnt + 1;
	return error_cnt;
						
						
def check_listup(f_dir):
	global check_list;
	for line in glob.glob(f_dir + '*.bin'):
		line = line.replace(f_dir, "");
		line = line.replace(".bin", "");
		check_list.append(line);



def sim_start(simulator, top_name, hex_name, tb_model_list, srclist, inclist):
	global check_list;
	cnt = 0;

	#Message
	message = "Check Instruction : ";
	for instlist in check_list:
		message = message + instlist + " ";
	print(message);
	
	#Sim Dir Make
	if(os.path.exists("sim") != True):
		subprocess.call("mkdir sim", shell=True);
	
	#Simulation Loop
	for line in check_list:
		#Start Time
		date = datetime.datetime.today();
		print("-[" + str(cnt) + "]Start : [" + line + "] : " + date.strftime("%Y-%m-%d %H:%M:%S"));

		#Generate TCL
		gen_tcl.generate_tcl(1, simulator, top_name, tb_model_list, srclist, inclist, "sim/" + line + ".result\n", "sim_run.tcl");
		#python gen_tcl.py 0 modelsim tb_func_level ./sim_list.txt ../../com/src_list.txt ../../com/inc_list.txt code_check.log code_check.tcl

		#Binary 2 Hex
		fr = open("./bin/" + line + ".bin", "rb");
		read_data = fr.read();
		result_hex = bin2hex.bin2hex(read_data);
		fw = open(hex_name, 'w');
		fw.write(result_hex);
		fr.close();
		fw.close();

		#Start Sim
		if(simulator == "modelsim"):
			subprocess.call('vsim -c -voptargs="+acc" ' + top_name + " -do sim_run.tcl", shell=True);
		elif(simulator == "riviera"):
			subprocess.call("vsimsa -do sim_run.tcl", shell=True);
		else:
			print("Simulation Error");
			sys.exit();

		#End Time
		date = datetime.datetime.today();
		print("-[" + str(cnt) + "]Finish : [" + line + "] : " + date.strftime("%Y-%m-%d %H:%M:%S"));
		cnt = cnt + 1;

		#Tempfile Remove
		os.remove(hex_name);
		os.remove("sim_run.tcl");


#args[1]=code_check.log, srgv[2]=sourcelist.txt args[3]=bin/	
if __name__ == "__main__":	
	print("\n\n----------------------------------------------------------------------------------------\nSimulation Start\n");
	if(len(sys.argv) != 9):
		print("Error : Command missing");
		sys.exit();

	#Code Error Check	
	fh = open(sys.argv[1], 'r');
	error_cnt = 0;
	for line in fh:
		error_cnt = error_check(line);

	if(error_cnt != 0):
			print("Code Error, Stop");
			sys.exit();

	#Simulation Start
	print("Do Check");
	check_listup(sys.argv[8]);
	if(len(check_list) != 0):
		sim_start(sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5], sys.argv[6], sys.argv[7]);
		print("Simulation Finished");
	else:
		print("Simulation Error.\nNot found binary file.");

