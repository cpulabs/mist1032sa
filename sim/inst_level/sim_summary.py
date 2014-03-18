import subprocess;
import sys;
import glob;
import datetime;
import locale;
import shutil;
import os;
import os.path;
import re

check_list = [];


def check_listup(f_dir):
	global check_list;
	for line in glob.glob(f_dir + '*.result'):
		#line = line.replace(f_dir, "");
		#line = line.replace(".result", "");
		check_list.append(line);


def check_file(f_name):
	fh = open(f_name, 'r');
	for line in fh:
		if(line.find("[SIM-OK]Simulation Finished.") != -1):
			return 0;
	return -1;

def get_sim_time(f_name):
	time = 0
	r = re.compile("Time: ([0-9]*) ns");
	fh = open(f_name, 'r');
	for line in fh:
		m = r.search(line);
		if(m != None):
			return int(m.group(1))
		#if(line.find("[SIM-OK]Simulation Finished.") != -1):
	return time




if __name__ == "__main__":	
	print("\n\n----------------------------------------------------------------------------------------\nSimulation Summary");
	if(len(sys.argv) != 2):
		print("Error : Command missing.");
		sys.exit();
	
	check_listup(sys.argv[1]);

	if(len(check_list) == 0):
		print("Check file not found.");
		sys.exit();

	print("Checked file : " + str(len(check_list)) + "\n");

	cnt = 0;
	for line in check_list:
		mnemonic = line.replace(sys.argv[1], "");
		mnemonic = mnemonic.replace(".result", "");
		if(check_file(line) == 0):
			print(str(cnt) + " : " + mnemonic + " -> Simulation OK, Time : " + str(get_sim_time(line)));
		else:
			#print(str(cnt) + " : " + mnemonic + " -> Error Show " + line);
			print(str(cnt) + " : " + mnemonic + " -> Error");
		cnt = cnt + 1

	print("\ndone");

