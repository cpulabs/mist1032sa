

task task_disp_tag_info;
	begin
		//if(!TARGET.CORE_IF.CORE_PIPELINE.SATGE5_SCHEDULER1.oPREVIOUS_LOCK && TARGET.CORE_IF.CORE_PIPELINE.SATGE5_SCHEDULER1.oNEXT_0_INST_VALID)begin
		$display("[INFO]Time : %d, Core(SCHEDULER1) Register Pointer : %x", $time, TARGET.CORE_IF.CORE_PIPELINE.SATGE5_SCHEDULER1.w_register_pointer);
		$display("[INFO]Time : %d, Core(SCHEDULER1) Commit Pointer : %x", $time, TARGET.CORE_IF.CORE_PIPELINE.SATGE5_SCHEDULER1.w_commit_pointer);
		//end
	end
endtask
