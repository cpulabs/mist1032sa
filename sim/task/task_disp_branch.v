

task task_disp_branch;
	begin
		if(!TARGET.CORE_IF.CORE_PIPELINE.SATGE7_EX_PORT0.oJUMP_ACTIVE)begin
			$display("[INFO]Time : %d, Core(EX0) Branch : %x(PCR) -> %x(PCR)", $time, TARGET.CORE_IF.CORE_PIPELINE.SATGE7_EX_PORT0.b_pcr, TARGET.CORE_IF.CORE_PIPELINE.SATGE7_EX_PORT0.oJUMP_ADDR);
		end
	end
endtask
