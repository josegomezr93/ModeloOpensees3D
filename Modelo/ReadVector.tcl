proc ReadVector {filename} {
		
		global StepN 

		set THFileName "$filename";
		set fp [open "$THFileName" r];
		set THData [split [read $fp] "\n"];
		set StepN [llength $THData] ;
		close $fp;
		return $StepN;
}