# SCE Standard Code Library

This repo is an example of how to support standard SAS code library in Domino.
To use this library, two things need to be implemented in the host project:
- Add the repo to the project (in the Code screen)
- The path to the imported code needs added to the SASAUTOS path

When you copy a SCE_XXX_TEMPLATE project (e.g. SCE_RE_TEMPLATE) and then the
SCE_STANDARD_LIB repo is copyied as part of the project.

The `domino.sas` setup program checks whether the project is gat backed and
if it is, then the SCE_STANDARD_LIB root and macros folder is added to SASAUTO

