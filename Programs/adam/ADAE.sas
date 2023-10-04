/*****************************************************************************\
*  ____                  _
* |  _ \  ___  _ __ ___ (_)_ __   ___
* | | | |/ _ \| '_ ` _ \| | '_ \ / _ \
* | |_| | (_) | | | | | | | | | | (_) |
* |____/ \___/|_| |_| |_|_|_| |_|\___/
* ____________________________________________________________________________
* Sponsor              : Domino
* Study                : CDISC01
* Program              : ADAE.sas
* Purpose              : Create ADaM ADAE dummy dataset
* ____________________________________________________________________________
* DESCRIPTION
*
* Input files:  SDTM.AE
*				SDTM.EX
*               ADaM.ADSL
*
* Output files: ADaM.ADAE
*
* Macros:       None
*
* Assumptions: 
*
* ____________________________________________________________________________
* PROGRAM HISTORY
*  10MAY2023  | Megan Harries  | Original
*  19SEP2023  | Petter Olsson  | Added this comment
*  19SEP2023  | Petter Olsson  | Added this comment as a second comment
* ----------------------------------------------------------------------------
\*****************************************************************************/

*********;
** Setup environment including libraries for this reporting effort;
%include "/mnt/code/domino.sas";
*********;

data adae;
	merge adam.adsl sdtm.ae (in = ae);
		by usubjid;
	if ae;
	if 1 <= aestdy < 13 then visitnum = 3;
	else if 13 <= aestdy < 161 then visitnum = 4;
	else if 162 <= aestdy then visitnum = 12;
run;

proc sort data = adae out = adae_s;
	by usubjid visitnum;
run;

data adam.adae;
	merge adae_s (in = ae) sdtm.ex;
	by usubjid visitnum;
	if ae;
run;
