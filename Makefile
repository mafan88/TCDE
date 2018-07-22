include TCDE_ENV.mk

default: help
help:
	@echo "----------------------------------------------------------------"
	@echo "  TestCase Design Environment  "
	@echo "  Based on Reference Methodology Flow  "
	@echo "----------------------------------------------------------------"
	@echo "  to be edited."
	@echo "----------------------------------------------------------------"
	@echo "  How to run?"
	@echo "  make: Print this help message"
	@echo "  make help_more: Print the README file for design and DFT plan description"
	@echo "  make clean: Empty the testcase"
	@echo "  make risc_core.dc_dft: Run synthesis and dft insertion on RISC_CORE"
	@echo "----------------------------------------------------------------"

help_more:
	cat README

.PHONY: clean qsub_config dc_dft debug_target

debug_target:
	echo $(TCDE_FLOW_DIR)
	/bin/sh $(TCDE_FLOW_DIR)/debug.sh
	. /global/etc/modules.sh && module load syn && dc_shell -f $(TCDE_FLOW_DIR)/debug.tcl

qsub_config:
	rm -f $(TCDE_FLOW_DIR)/qrun.*.sh
	printf "#!/bin/tcsh\n\n" > $(TCDE_FLOW_DIR)/$(TCDE_QSUB_DC_DFT_FILE)
	printf "module unload syn\n" >> $(TCDE_FLOW_DIR)/$(TCDE_QSUB_DC_DFT_FILE)
	printf "module load syn/$(TCDE_DC_DFT_TMAX_VER)\n\n" >> $(TCDE_FLOW_DIR)/$(TCDE_QSUB_DC_DFT_FILE)
	printf "setenv TCDE_DESIGN_NAME $(TCDE_DESIGN_NAME)\n" >> $(TCDE_FLOW_DIR)/$(TCDE_QSUB_DC_DFT_FILE)
	printf "dc_shell -topo -f $(TCDE_SCRIPT_DIR)/rm_dc_scripts/dc.tcl | tee -i $(TCDE_LOG_DIR)/$(TCDE_DESIGN_NAME).dc_dft.log\n" >> $(TCDE_FLOW_DIR)/$(TCDE_QSUB_DC_DFT_FILE)
	printf "#!/bin/tcsh\n\n" > $(TCDE_FLOW_DIR)/$(TCDE_QSUB_TMAX_FILE)
	printf "module unload syn\n" >> $(TCDE_FLOW_DIR)/$(TCDE_QSUB_TMAX_FILE)
	printf "module load syn/$(TCDE_DC_DFT_TMAX_VER)\n\n" >> $(TCDE_FLOW_DIR)/$(TCDE_QSUB_TMAX_FILE)
	printf "tmax -s $(TCDE_SCRIPT_DIR)/rm_tmax_scripts/tmax.tcl\n" >> $(TCDE_FLOW_DIR)/$(TCDE_QSUB_TMAX_FILE)


dc_dft: qsub_config
	$(TCDE_QSUB_CMD) $(TCDE_FLOW_DIR)/$(TCDE_QSUB_DC_DFT_FILE)

tmax: results/$(TCDE_DESIGN_NAME).scanned.scan.spf
	$(TCDE_QSUB_CMD) $(TCDE_FLOW_DIR)/$(TCDE_QSUB_TMAX_FILE)

clean:
	rm -f $(TCDE_LOG_DIR)/*.log WORK/*.* 
	rm -rf *_LIB/ results/*.* reports/*.*
	rm -f *.svf *.log qrun*.*
