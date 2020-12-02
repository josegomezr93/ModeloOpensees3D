proc ReadVector {filename Data nPts} {

		upvar $Data THData
		upvar $nPts StepN
		
		set THFileName $filename
		set fp [open "$THFileName" r]
		set THData [split [read $fp] "\n"]
		set StepN [llength $THData] 
		close $fp
}