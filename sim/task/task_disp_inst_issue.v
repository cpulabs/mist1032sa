

task task_disp_inst_issue;
	begin
		if(!TARGET.CORE_IF.CORE_PIPELINE.STAGE1_FETCH.oPREVIOUS_LOCK)begin
			if(TARGET.CORE_IF.CORE_PIPELINE.STAGE1_FETCH.oNEXT_0_INST_VALID)begin
				$display("[INFO]Time : %d, Core(FETCH) Instruction Issue - Pipe0 : %x", $time, TARGET.CORE_IF.CORE_PIPELINE.STAGE1_FETCH.oNEXT_0_INST);
			end
			if(TARGET.CORE_IF.CORE_PIPELINE.STAGE1_FETCH.oNEXT_1_INST_VALID)begin
				$display("[INFO]Time : %d, Core(FETCH) Instruction Issue - Pipe1 : %x", $time, TARGET.CORE_IF.CORE_PIPELINE.STAGE1_FETCH.oNEXT_1_INST);
			end
		end
	end
endtask
