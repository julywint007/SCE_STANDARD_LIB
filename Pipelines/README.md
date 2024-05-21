# Multijob.py
This script uses the Domino API to execute multiple jobs, either concurrently or sequentially.

## Prerequisites
This script requires Python 3.x and a valid .cfg file as described in the "Configuration" section.

## Configuration
Modify the jobs.cfg file as needed to add as many jobs as desired. Each job entry must follow this format:

```
[job2]
tier: Medium
environment: 61f1574701b8062cc1bed9d9
command: script.sh
depends: job1 test
project_repo_git_ref: ref_type,ref_value
imported_repo_git_refs: imported_repo_1,ref_type,ref_value imported_repo_2,ref_type,ref_value
```

- `[job2]` - Required. This is the job name, which is referenced without brackets elsewhere. A valid section name can be any string that does not contain `\n` or `]`.

- `tier:` - Optional. Valid values include the name of any hardware tier that the executing user has access to. If not specified, the job will use the project's default hardware tier.

- `environment:` - Optional. Valid values include the ID of any compute environment that the executing user has access to. Environment IDs can be found in the URL of an environment definition (such as https://domino-dev.gsk.com/environments/61f1574701b8062cc1bed9d9). If not specified, the job will use the project's default hardware tier.

- `command:` - Required. This must be a valid path to an executable starting from `/mnt/` (Domino File System projects) or `/mnt/code/` (git-based projects), and can include arguments passed into the executable. For example, `script.sh arg1 arg2`.

- `depends:` - Optional. Valid values include any other defined job in the jobs.cfg file, including multiple job names separated by a single comma `,`. If present, the job will not start until the specified jobs have completed.

- `project_repo_git_ref` - Optional. An alternative git ref can be specified for the project repo. Only 1 value is valid, which is a comma separated list consisting of the reference type and the reference value. 

- `imported_repo_git_refs` - Optional. Alternative git refs can be specified for each imported repo. Each imported repo to configure should be separated by a single space, and should be formatted as a comma separated list consisting of the repo name, the git ref type, and the git ref value.

### Supported Git Ref Types
If specifying custom git refs in the Multijob configuration, the following values should be used for git refs:

- `head` when using the repo's default branch. Do not specify a value when using this ref type.
- `branches` when specifying a branch
- `tags` when specfiying a tag
- `commitId` when specifying a commit
- `ref` when specifying a custom git ref

### Comments
.cfg files support comments that won't be read by the Multijob script. Prepend a line with a `#` character to make that line a comment. For example:

```
[job47]
# This job needs a Medium tier because Small doesn't have enough memory
tier: Medium
# This environment is the Domino Standard Environment
environment: 61f1574701b8062cc1bed9d9
# This script does a lot of stuff
command: big_job.py
```

## Usage
To use the Multijob script:

1. Ensure the `space-tech-util` repo is imported into the project, and that the desired .cfg files are in the project repo or artifacts.
2. Start a job that runs the multijob.py script and specifies the .cfg file as the only argument to the script. For example: `/mnt/imported/code/space-tech-util/multijob.py configs/dry-run.cfg`

### Controlled Execution (CX)
Multijob supports additional functions needed to perform a controlled execution (CX). These functions run automatically if the Domino project environment variable `DMV_ISCX` is set to `true`. With this value set, when Multijob completes all jobs in the config file, it will:

1. Take a snapshot of every Domino dataset that belongs to the project
2. Tag each snapshot it creates with the ID of the job that created it (`JOB645a511eae2d206838c95dc3`) as well as the timestamp (`D12-May-2023-T18-20-57`) it was created.
3. Leave 1 comment on the multijob.py job per dataset with each snapshot's information:

```
Controlled execution results snapshot:

Dataset ID: 636555b7070f163050fc068d
Dataset name: multijob-gsk
Author MUD ID: dray
Creation time: D12-May-2023-T18-20-57
```

4. Leave a comment on the multijob.py job with a list of all environment variables starting with `DMV` and their values:

```
Project environment variables:

DMV_ISCX: true
DMV_PREP: true
```

### Pre-run Dataset Cleanup
Prior to starting any jobs defined in the config file, Multijob will check for a project environment variable called `DMV_PREP` and whether it is set to `true`. If so, for each project dataset (not shared datasets), any files not in the root `inputdata` folder will be deleted. The contents of any subfolders outside of `inputdata` will be deleted, but the folders themselves will not be, leaving the directory structure intact.
