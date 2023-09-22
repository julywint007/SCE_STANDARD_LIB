/*****************************************************************************\
*  ____                  _
* |  _ \  ___  _ __ ___ (_)_ __   ___
* | | | |/ _ \| '_ ` _ \| | '_ \ / _ \
* | |_| | (_) | | | | | | | | | | (_) |
* |____/ \___/|_| |_| |_|_|_| |_|\___/
* ____________________________________________________________________________
* Sponsor              : Domino
* Study                : CDISC01
* Program              : ADVS.sas
* Purpose              : Create QC ADaM ADSL dummy dataset
* ____________________________________________________________________________
* DESCRIPTION
*
* Input files:  SDTM.VS
*				ADaM.ADVS
*               ADaMQC.ADSL
*
* Output files: ADaMQC.ADVS
*
* Macros:       None
*
* Assumptions:
*
* ____________________________________________________________________________
* PROGRAM HISTORY
*  09MAY2023  | Megan Harries  | Original
* ----------------------------------------------------------------------------
\*****************************************************************************/

*********;
** Setup environment including libraries for this reporting effort;
%include "/mnt/code/domino.sas";
*********;

data adamqc.advs;
	merge adamqc.adsl sdtm.vs (in = v);
		by usubjid;
	if v;
run;