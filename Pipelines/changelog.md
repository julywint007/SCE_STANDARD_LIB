# Changelog
All notable changes to this project will be documented in this file.

## [2023-09-18]
- .R scripts now execute using the `logrx` package to write a log file to `/mnt/data/{project_name}/logs/{script_name}.log`
- Converted several private v4 API calls to use public API endpoints
- New dependency validation prevents infinite loops caused by circular dependencies
- Controlled Execution ("CX") functionality has been merged into the main `multijob.py` script, and the `controlled_execution.py` script has been removed
- Improved error handling for all Domino REST API calls, with logging for failures that includes the endpoint, HTTP error code, request body (if applicable), and endpoint response text.

## [2023-05-22]
- Limit concurrent job submission to 10 to avoid flooding Domino message queue
- Moved CX and cleanup environment variable check to `multijob.py` to make the intended behavior more clear
- Fix for datasets API error in Domino 5.4+
- Revised the formatting of `controlled_execution.py` to be more consistent with `multijob.py`

## [2022-11-18]
- Added support for custom git refs

## [2022-07-25]
- Added support for controlled executions (CX)
