/*****************************************************************************\
*  ____                  _
* |  _ \  ___  _ __ ___ (_)_ __   ___
* | | | |/ _ \| '_ ` _ \| | '_ \ / _ \
* | |_| | (_) | | | | | | | | | | (_) |
* |____/ \___/|_| |_| |_|_|_| |_|\___/
* ____________________________________________________________________________
* Sponsor              : Domino
* Study                : CDISC01
* Program              : ADCM.sas
* Purpose              : Create ADaM ADCM dummy dataset
* ____________________________________________________________________________
* DESCRIPTION
*
* Input files:  SDTM.CM
*               ADaM.ADSL
*
* Output files: ADaM.ADCM
*
* Macros:       None
*
* Assumptions:
*
* ____________________________________________________________________________
* PROGRAM HISTORY
*  10MAY2023  | Megan Harries  | Original
* ----------------------------------------------------------------------------
\*****************************************************************************/

*********;
** Setup environment including libraries for this reporting effort;
%include "/mnt/code/domino.sas";
*********;

data adam.adcm;
	merge adam.adsl sdtm.cm (in = cm);
	by usubjid;
	if cm;
run;
