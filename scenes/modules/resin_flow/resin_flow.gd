extends Control


# =========================================
# UI REFERENCES
# =========================================

@onready var resin_selector = $MainVBox/MainSplit/LeftPanel/LeftVBox/ResinPanel/ResinVBox/resin_selector

@onready var strategy_selector = $MainVBox/MainSplit/LeftPanel/LeftVBox/ResinPanel/ResinVBox/StrategyPanel/StrategyVBox/strategy_selector

@onready var insight_text = $MainVBox/MainSplit/LeftPanel/LeftVBox/ResinPanel/ResinVBox/InsightPanel/InsightVBox/insight_text

@onready var status_label = $MainVBox/BottomStatusBar/HBoxContainer/status_label


# =========================================
# RESULT LABELS
# =========================================

@onready var label_resin_state = $MainVBox/MainSplit/ResultsPanel/ResultsVBox/GridContainer/label_resin_state

@onready var label_viscosity = $MainVBox/MainSplit/ResultsPanel/ResultsVBox/GridContainer/label_viscosity

@onready var label_gelation = $MainVBox/MainSplit/ResultsPanel/ResultsVBox/GridContainer/label_gelation

@onready var label_stability = $MainVBox/MainSplit/ResultsPanel/ResultsVBox/GridContainer/label_stability

@onready var label_voids = $MainVBox/MainSplit/ResultsPanel/ResultsVBox/GridContainer/label_voids
@onready var label_cure = $MainVBox/MainSplit/ResultsPanel/ResultsVBox/GridContainer/label_cure

@onready var label_lock = $MainVBox/MainSplit/ResultsPanel/ResultsVBox/GridContainer/label_lock

@onready var label_compression = $MainVBox/MainSplit/ResultsPanel/ResultsVBox/GridContainer/label_compression


# =========================================
# RESIN DATABASE
# =========================================

var resin_database = {

	"Fast Flow Epoxy": {
		"viscosity": "Rapid Shear Thinning",
		"gelation": "Moderate",
		"stability": "Stable Front",
		"voids": "Low",
		"cure": "Controlled",
		"lock": "Low Risk",
		"compression": "Uniform Compression",
		"state": "Highly Flowable",

		"insight":
		"[color=cyan]Fast filling epoxy with excellent cavity penetration.[/color]\n\n" +
		"Low resistance to edge flow.\n" +
		"Minimal instability observed.\n" +
		"Suitable for thin-wall compression molding."
	},


	"Structural Epoxy": {
		"viscosity": "Gradual Increase",
		"gelation": "Slow",
		"stability": "Highly Stable",
		"voids": "Very Low",
		"cure": "Balanced",
		"lock": "Minimal",
		"compression": "Dense Consolidation",
		"state": "Controlled Flow",

		"insight":
		"[color=orange]Structural resin optimized for dimensional stability.[/color]\n\n" +
		"Flow progression remains controlled.\n" +
		"Excellent compression uniformity.\n" +
		"Low internal stress generation."
	},


	"Filled Phenolic": {
		"viscosity": "Rapid Rise",
		"gelation": "Aggressive",
		"stability": "Front Distortion",
		"voids": "Moderate",
		"cure": "Rapid Cure",
		"lock": "High Risk",
		"compression": "Filler Resistance",
		"state": "Restricted Flow",

		"insight":
		"[color=red]High filler loading causing unstable front movement.[/color]\n\n" +
		"Compression resistance increasing.\n" +
		"Premature gelation likely near edges.\n" +
		"Potential cavity lock formation detected."
	},


	"Carbon Epoxy": {
		"viscosity": "Pressure Sensitive",
		"gelation": "Moderate",
		"stability": "Directional Flow",
		"voids": "Elevated",
		"cure": "Advanced",
		"lock": "Moderate",
		"compression": "Fiber Dominated",
		"state": "Anisotropic Flow",

		"insight":
		"[color=yellow]Carbon-filled resin exhibiting directional flow behavior.[/color]\n\n" +
		"Fiber interaction affecting flow front.\n" +
		"Localized void probability increasing.\n" +
		"Compression gradients detected."
	},


	"Silicone Resin": {
		"viscosity": "Stable",
		"gelation": "Very Slow",
		"stability": "Excellent",
		"voids": "Very Low",
		"cure": "Slow Cure",
		"lock": "Negligible",
		"compression": "Elastic Response",
		"state": "Smooth Flow",

		"insight":
		"[color=green]Silicone resin maintaining highly stable rheology.[/color]\n\n" +
		"Uniform cavity progression observed.\n" +
		"Excellent edge conformity.\n" +
		"Minimal cure advancement during compression."
	},


	"Vinyl Ester": {
		"viscosity": "Low Initial Viscosity",
		"gelation": "Moderate",
		"stability": "Fast Front Movement",
		"voids": "Low",
		"cure": "Accelerated",
		"lock": "Low",
		"compression": "Rapid Consolidation",
		"state": "Reactive Flow",

		"insight":
		"[color=lime]Vinyl ester showing rapid cavity coverage.[/color]\n\n" +
		"Excellent initial flow progression.\n" +
		"Early cure acceleration detected.\n" +
		"Compression saturation developing uniformly."
	},


	"High Tg Epoxy": {
		"viscosity": "High Resistance",
		"gelation": "Controlled",
		"stability": "Stable",
		"voids": "Moderate",
		"cure": "Slow Advancement",
		"lock": "Moderate",
		"compression": "Rigid Consolidation",
		"state": "Dense Flow",

		"insight":
		"[color=orange]High Tg epoxy exhibiting dense rheological behavior.[/color]\n\n" +
		"Compression force increasing.\n" +
		"Flow progression controlled.\n" +
		"Thermal stability remains excellent."
	},


	"Low Shrink Polyester": {
		"viscosity": "Moderate",
		"gelation": "Balanced",
		"stability": "Stable Front",
		"voids": "Low",
		"cure": "Balanced Cure",
		"lock": "Low",
		"compression": "Smooth Consolidation",
		"state": "Consistent Flow",

		"insight":
		"[color=skyblue]Low shrink polyester optimized for dimensional accuracy.[/color]\n\n" +
		"Uniform cavity expansion.\n" +
		"Minimal volumetric instability.\n" +
		"Excellent surface conformity observed."
	}
}



# =========================================
# READY
# =========================================

func _ready():

	var run_button = $MainVBox/TopToolbar/ToolbarHBox/btn_run
	var reset_button = $MainVBox/TopToolbar/ToolbarHBox/btn_reset

	run_button.pressed.connect(run_analysis)
	reset_button.pressed.connect(reset_analysis)

	status_label.text = "Resin Flow Intelligence Ready"



# =========================================
# RUN ANALYSIS
# =========================================

func run_analysis():

	var selected_resin = resin_selector.get_item_text(
		resin_selector.selected
	)

	var selected_strategy = strategy_selector.get_item_text(
		strategy_selector.selected
	)

	var data = resin_database[selected_resin]


	# -------------------------------------
	# UPDATE RESULT PANEL
	# -------------------------------------

	label_resin_state.text = data["state"]
	label_viscosity.text = data["viscosity"]
	label_gelation.text = data["gelation"]
	label_stability.text = data["stability"]
	label_voids.text = data["voids"]
	label_cure.text = data["cure"]
	label_lock.text = data["lock"]
	label_compression.text = data["compression"]


	# -------------------------------------
	# STRATEGY MODIFIERS
	# -------------------------------------

	var strategy_text = ""

	match selected_strategy:
		"Balanced Fill":
			strategy_text = "\n\n[color=white]Balanced cavity progression active.[/color]"
			
		"Fast Production":
			label_voids.text = "Elevated"
			label_gelation.text = "Accelerated"
			strategy_text = "\n\n[color=yellow]High-speed compression increasing instability risk.[/color]"
		
		"Void Reduction":
			label_voids.text = "Minimal"
			label_stability.text = "Highly Stable"
			strategy_text = "\n\n[color=green]Controlled compression minimizing air entrapment.[/color]"
			
		"Precision Flow":
			label_stability.text = "Precision Controlled"
			label_compression.text = "Uniform Pressure"
			strategy_text = "\n\n[color=cyan]Precision-controlled flow front stabilization active.[/color]"
			
		"Low Stress Fill":
			label_cure.text = "Slow Advancement"
			label_lock.text = "Very Low"
			strategy_text = "\n\n[color=orange]Reduced stress compression strategy applied.[/color]"


	# -------------------------------------
	# UPDATE INSIGHT PANEL
	# -------------------------------------

	insight_text.bbcode_enabled = true
	insight_text.text = data["insight"] + strategy_text


	# -------------------------------------
	# STATUS BAR
	# -------------------------------------

	status_label.text = "Resin intelligence analysis completed."



# =========================================
# RESET ANALYSIS
# =========================================

func reset_analysis():

	label_resin_state.text = "--"
	label_viscosity.text = "--"
	label_gelation.text = "--"
	label_stability.text = "--"
	label_voids.text = "--"
	label_cure.text = "--"
	label_lock.text = "--"
	label_compression.text = "--"

	insight_text.text = "Select resin profile and run analysis."

	status_label.text = "System Reset Complete"
