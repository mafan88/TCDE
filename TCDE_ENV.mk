##################################################
# File and Directory Locations
##################################################
TCDE_LOG_DIR = logs
TCDE_SCRIPT_DIR = scripts
TCDE_FLOW_DIR = $(TCDE_SCRIPT_DIR)/flow
TCDE_QSUB_DC_DFT_FILE = qrun.dc_dft.sh
TCDE_QSUB_TMAX_FILE = qrun.tmax.sh
TCDE_QSUB_PT_FILE = qrun.pt.sh

##################################################
# Tool Version
##################################################
TCDE_DC_DFT_TMAX_VER = 2018.06
TCDE_PT_VER = 2016.06-SP2
TCDE_VCS_VER = default
TCDE_VERDI_VER = default

##################################################
# Job Submission
##################################################
TCDE_QSUB_CMD = qsub -cwd -P bnormal \
				-l "qsc=l|m|n|o,arch=glinux,cputype=emt64,mem_avail=50G"

##################################################
# Design Definitions
# Design Name:
#   STOTO		super mini design from DC CES Lab
#   RISC_CORE	the risc core block from ORCA design
##################################################
export TCDE_DESIGN_NAME = RISC_CORE

