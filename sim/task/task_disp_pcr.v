

task task_disp_pcr;
	begin
		if(!TARGET.CORE_IF.CORE_PIPELINE.STAGE1_FETCH.oPREVIOUS_LOCK && TARGET.CORE_IF.CORE_PIPELINE.STAGE1_FETCH.oNEXT_0_INST_VALID)begin
			$display("[INFO]Time : %d, Core(FETCH) Program Count Register(Pipe0) : %x", $time, TARGET.CORE_IF.CORE_PIPELINE.STAGE1_FETCH.b_pc_out);
		end
	end
endtask
