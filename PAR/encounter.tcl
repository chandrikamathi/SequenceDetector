###################################
# Run the design through Encounter
###################################

# Setup design and create floorplan
loadConfig ./encounter.conf 
commitConfig

# Create Initial Floorplan
floorplan -r 1.0 0.6 40 40 40 40

# Create Power structures
addRing -spacing_bottom 9.9 -width_left 9.9 -width_bottom 9.9 -width_top 9.9 -spacing_top 9.9 -layer_bottom metal4 -width_right 9.9 -around core -center 1 -layer_top metal4 -spacing_right 9.9 -spacing_left 9.9 -layer_right metal5 -layer_left metal5 -offset_top 1.5 -offset_bottom 1.5 -offset_left 1.5 -offset_right 1.5 -nets { gnd vdd }
addStripe  -set_to_set_distance 99 -spacing 4.5 -xleft_offset 45 -layer metal5 -width 4.95 -nets { gnd vdd }

# Place standard cells
setPlaceMode -congEffort high
placeDesign

# Route power nets
sroute -noBlockPins -noPadRings

# Specify Pin layers
#setPinConstraint -layer text

# Perform trial route and get initial timing results
trialroute
buildTimingGraph
setCteReport
report_timing -nworst  10 -net > timing.rep.1.placed

# Run Clock Tree Synthesis
createClockTreeSpec -output encounter.cts -bufFootprint buf -invFootprint inv
specifyClockTree -clkfile encounter_clk.ctstch
ckSynthesis -rguide cts.rguide -report report.ctsrpt -macromodel report.ctsmdl -fix_added_buffers

# Output Results of CTS
trialRoute -highEffort -guide cts.rguide
extractRC
reportClockTree -postRoute -localSkew -report skew.post_troute_local.ctsrpt
reportClockTree -postRoute -report report.post_troute.ctsrpt

# Run Post-CTS Timing analysis
setAnalysisMode -setup -async -skew -autoDetectClockTree
buildTimingGraph
setCteReport
report_timing -nworst  10 -net > timing.rep.3.cts


# Fix all remaining violations
setExtractRCMode -detail -assumeMetFill
extractRC
if {[isDRVClean -maxTran -maxCap -maxFanout] != 1} {
fixDRCViolation -maxTran -maxCap -maxFanout
}

endECO
cleanupECO

# Run Post IPO-2 timing analysis
buildTimingGraph
setCteReport
report_timing -nworst  10 -net > timing.rep.4.ipo2

# Add filler cells
addFiller -cell FILL -prefix FILL -fillBoundary

# Connect all new cells to VDD/GND
globalNetConnect vdd -type tiehi
globalNetConnect vdd -type pgpin -pin vdd -override
globalNetConnect gnd -type tielo
globalNetConnect gnd -type pgpin -pin gnd -override

# Run global Routing
globalDetailRoute

# Get final timing results
setExtractRCMode -detail -noReduce
extractRC
buildTimingGraph
setCteReport
report_timing -nworst  10 -net > timing.rep.5.final

# Output GDSII
streamOut final.gds2 -mapFile gds2_encounter.map -stripes 1 -units 1000 -mode ALL
saveNetlist -excludeLeafCell final.v

# Output DSPF RC Data
rcout -spf final.dspf

# Run DRC and Connection checks
verifyGeometry
verifyConnectivity -type all

puts "**************************************"
puts "* Encounter script finished          *"
puts "*                                    *"
puts "* Results:                           *"
puts "* --------                           *"
puts "* Layout:  final.gds2                *"
puts "* Netlist: final.v                   *"
puts "* Timing:  timing.rep.5.final        *"
puts "*                                    *"
puts "* Type 'win' to get the Main Window  *"
puts "* or type 'exit' to quit             *"
puts "*                                    *"
puts "**************************************"
