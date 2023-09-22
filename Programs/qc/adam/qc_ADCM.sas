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
* Purpose              : Create QC ADaM ADCM dummy dataset
* ____________________________________________________________________________
* DESCRIPTION
*
* Input files:  SDTM.CM
*				ADaM.ADCM
*               ADaMQC.ADSL
*
* Output files: ADaMQC.ADCM
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

data adamqc.adcm;
	merge adamqc.adsl sdtm.cm (in = cm);
	by usubjid;
	if cm;
run;
