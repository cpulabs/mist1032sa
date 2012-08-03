/***********************************
Parameter
	- Clock				:	50MHz
	- CAS Latency		:	2
	- Speed Grade		:	7nS
	- Reflesh Timing	:	15uS
***********************************/

/*When you make changes to the clock rewrite*/
`define		REFLESH_TIMING		(750)		//Reflesh Rate(ns)	:	Example 750 = 15000(Refrash Rate) / 20(Clock ns)
`define		CAS_LATENCY			(3'h2)
`define		ROW_BIT				(13)		
`define		COLUMN_BIT			(10)
`define		IO_BIT				(32)
`define		DQM_BIT				(4)

`define		WAITCOUNT_INIT1US	(50)		//1uS Wait Count	:	Example 50 = 1000(1uS) / 20(Clock ns)
`define		WAITCOUNT_INIT200US	(10000)		//200uS Wait Count	:	Example 200000(200uS) / 20(Clock ns)
/*END When you make changes to the clock rewrite*/


/*When you make changes to the device rewrite*/
`define		WAITCOUNT_RP		(2)
`define		WAITCOUNT_RC		(7)
`define		WAITCOUNT_MRD		(2)
`define		WAITCOUNT_RAS		(5)
`define		WAITCOUNT_RCD		(2)
`define		WAITCOUNT_DPL		(2)
/*END When you make changes to the device rewrite*/


/*Do not change*/
`define		TOPSTT_INIT			(0)
`define		TOPSTT_IDLE			(1)
`define		TOPSTT_ACTIVE		(2)
`define		TOPSTT_READ			(3)
`define		TOPSTT_WRITE		(4)
`define		TOPSTT_PRECHARGE  	(5)
`define		TOPSTT_REFRESH		(6)

`define		SUBSTT_CKACTIVE		(0)
`define		SUBSTT_WAIT200US	(1)
`define		SUBSTT_PALL			(2)
`define		SUBSTT_REF			(3)
`define		SUBSTT_MRS			(4)
`define		SUBSTT_NOP			(5)
`define		SUBSTT_ACT			(6)
`define		SUBSTT_READ			(7)
`define		SUBSTT_WRITE		(8)
`define		SUBSTT_PRE			(9)

`define		WAITSTT_SUBSTT		(0)
/*END Do not change*/
