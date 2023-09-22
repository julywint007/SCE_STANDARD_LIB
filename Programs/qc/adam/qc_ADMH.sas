/*****************************************************************************\
*  ____                  _
* |  _ \  ___  _ __ ___ (_)_ __   ___
* | | | |/ _ \| '_ ` _ \| | '_ \ / _ \
* | |_| | (_) | | | | | | | | | | (_) |
* |____/ \___/|_| |_| |_|_|_| |_|\___/
* ____________________________________________________________________________
* Sponsor              : Domino
* Study                : CDISC01
* Program              : ADMH.sas
* Purpose              : Create QC ADaM ADMH dummy dataset
* ____________________________________________________________________________
* DESCRIPTION
*
* Input files:  SDTM.MH
*				ADaM.ADMH
*               ADaMQC.ADSL
*
* Output files: ADaMQC.ADMH
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

data adamqc.admh;
	merge adamqc.adsl sdtm.mh (in = mh);
	by usubjid;
	if mh;
run;
