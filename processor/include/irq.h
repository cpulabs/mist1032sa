/****************************************
	Core Interrupt Request Header File
	- 
	
	
	Make	:	2012/07/07
	Update	:	
****************************************/


/******************************************
Interrupt Number
******************************************/
//Fault
`define		INT_NUM_DIVIDER_ERROR			7'd51	
`define		INT_NUM_PRIVILEGE_ERRPR			7'd40
`define		INT_NUM_INSTRUCTION_INVALID		7'd41
`define		INT_NUM_PAGEFAULT				7'd42
`define		INT_NUM_TSS_INVALID				7'd50
`define		INT_NUM_DOUBLE_FAULT			7'd63


