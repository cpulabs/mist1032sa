/*************************************************************************************************************
Files that are included in this project is deliverable by all Open Design Computer Project.
http://open-arch.org

All files included in this project have been allocated in the BSD licence.	
Open Design Computer Project @Takahiro Ito (Twitter : @cpu_labs)

If you do instruction-level or function-level check, you will need to select the Normal-Simulation Mode.

*************************************************************************************************************/

`ifdef MIST1032SA_SYNTH
        //Synthesize Mode
        `define MIST1032SA_INST_L1_CACHE
        //`define MIST1032SA_DATA_L1_CACHE
        //`define MIST1032SA_BRANCH_PREDICT
`elsif MIST1032SA_SIM_FST
        //First Simulation Mode
        `define MIST1032SA_FIRST_SIM
`else
        //Normal Simulation Mode
`endif