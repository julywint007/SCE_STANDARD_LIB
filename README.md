# SCE Standard Code Library

This repo is an example of how to support standard SAS code library in Domino.
To use this library, add this repo as a secondary repo to your SDTM AND RE SCE project templates.

When you create study projects by copying the SCE_XXX_TEMPLATE projects (e.g. SCE_RE_TEMPLATE, the
SCE_STANDARD_LIB repo is copyied as part of the project.

The `domino.sas` setup program checks whether your project is git backed (rather than Domino File System backed) and
if it is, then the SCE_STANDARD_LIB root and macros folder is added to SASAUTO

