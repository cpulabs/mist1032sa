import subprocess;
import sys;

error_cnt = 0;
warning_cnt = 0;
error_str = "";
warning_str = "";


def error_check(line_text):
	global error_cnt;
	global error_str;
	line_list = line_text.split(' ');
        if(len(line_list) > 2):
                if(line_list[2] == "Error:"):
                        error_cnt = error_cnt + 1;
                        error_str = error_str + line_text;

def warning_check(line_text):
	global warning_cnt;
	global warning_str;
	line_list = line_text.split(' ');
        if(len(line_list) > 2):
                if(line_list[2] == "Warning"):
                        warning_cnt = warning_cnt + 1;
                        warning_str = warning_str + line_text;	

	
if __name__ == "__main__":	
	if(len(sys.argv) != 2):
		print("Error : Command missing");
		sys.exit();
	
	fh = open(sys.argv[1], 'r');
	for line in fh:
		error_check(line);
		warning_check(line);
		
	print("\n\n----------------------------------------------------------------------------------------\nCode Check Summary")
	print(warning_str);
	print(error_str);
	print("Code WARNING : " + str(warning_cnt));
	print("Code ERROR : " +  str(error_cnt));
	
	
