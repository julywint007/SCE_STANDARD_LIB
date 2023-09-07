import os
import requests 
import json
from time import sleep
from datetime import datetime

DOMINO_USER_API_KEY = os.environ['DOMINO_USER_API_KEY']
DOMINO_API_HOST = os.environ['DOMINO_API_HOST']
DOMINO_PROJECT_ID = os.environ['DOMINO_PROJECT_ID']
DOMINO_RUN_ID = os.environ['DOMINO_RUN_ID']
DOMINO_STARTING_USERNAME = os.environ['DOMINO_STARTING_USERNAME']


def get_project_datasets():
    headers = {
        'X-Domino-Api-Key': DOMINO_USER_API_KEY, 
    }
    endpoint = f'{DOMINO_API_HOST}/v4/datasetrw/datasets-v2?projectIdsToInclude={DOMINO_PROJECT_ID}'
    response = requests.request('GET', endpoint, headers = headers, data = '')

    try:
        return response.json()
    except:
        try:
            return response.text
        except:
            return response


def take_dataset_snapshot(dataset_id):
    headers = {
        'X-Domino-Api-Key': DOMINO_USER_API_KEY, 
        'Content-Type': 'application/json'
    }
    endpoint = f'{DOMINO_API_HOST}/v4/datasetrw/snapshot'
    data = { "relativeFilePaths":["."], "datasetId": dataset_id }
    response = requests.request('POST', endpoint, headers=headers, json=data)

    snapshot_response = response.text
    snapshot_id = json.loads(snapshot_response)['id']
    
    javascript_timestamp = json.loads(snapshot_response)['creationTime']
    dt = datetime.utcfromtimestamp(javascript_timestamp/1000.0)
    formatted_timestamp = str(dt.strftime('D%d-%b-%Y-T%H-%M-%S'))

    snapshot_status = ''
    while snapshot_status != 'Active':
        sleep(2)
        endpoint = f'{DOMINO_API_HOST}/v4/datasetrw/snapshot/{snapshot_id}'
        response = requests.request('GET', endpoint, headers = headers, data = '')
        snapshot_status = json.loads(response.text)['snapshot']['lifecycleStatus']    

    return snapshot_id, formatted_timestamp, snapshot_response


def tag_dataset_snapshot(dataset_id, snapshot_id, formatted_timestamp):
    headers = {
        'X-Domino-Api-Key': DOMINO_USER_API_KEY, 
    }
    endpoint = f'{DOMINO_API_HOST}/v4/datasetrw/dataset/{dataset_id}/tag'
    # {"message":"Tags must start with a letter and contain only alphanumeric, dashes, and hyphen characters","success":false}
    job_tag = f'JOB{DOMINO_RUN_ID}'
    tags = [ formatted_timestamp, job_tag ]
    for tag in tags:
        data = { "snapshotId": snapshot_id, "tag": tag }
        requests.request('POST', endpoint, headers = headers, json = data)


def format_snapshot_comment(snapshot_response, formatted_timestamp):
    snapshot_json = json.loads(snapshot_response)

    headers = {
        'X-Domino-Api-Key': DOMINO_USER_API_KEY, 
    }
    dataset_id = snapshot_json['datasetId']
    endpoint = f'{DOMINO_API_HOST}/v4/datasetrw/datasets/{dataset_id}'
    response = requests.request('GET', endpoint, headers = headers, data = '')
    dataset_name = json.loads(response.text)['name']

    snapshot_comment = \
        f"Controlled execution results snapshot:\\\n\\\n \
            Dataset ID: {snapshot_json['datasetId']}\\\n \
            Dataset name: {dataset_name}\\\n \
            Author MUD ID: {DOMINO_STARTING_USERNAME}\\\n \
            Creation time: {formatted_timestamp}"

    return snapshot_comment


def format_env_vars_comment():
    variables_comment = 'Project environment variables:\\\n'
    for env_var in os.environ:
        if env_var.startswith('DMV'):
            variables_comment += f'\\\n{env_var}: {os.environ[env_var]}'
    
    return variables_comment


def leave_comment_on_job(comment_text):
    headers = {
        'X-Domino-Api-Key': DOMINO_USER_API_KEY, 
    }
    endpoint = f'{DOMINO_API_HOST}/v4/jobs/{DOMINO_RUN_ID}/comment'
    data = { "comment": comment_text }
    requests.request('POST', endpoint, headers = headers, json = data)


def cleanup_datasets():
    project_datasets = get_project_datasets()
    for dataset in project_datasets:
        dataset_path = dataset['datasetRwDto']['datasetPath']
        PROTECTED_DIR = 'inputdata'
        for (root, dirs, files) in os.walk(dataset_path, topdown=True):
            for name in files:
                if PROTECTED_DIR not in root:
                    os.remove(os.path.join(root, name))


def full_cx():
    project_datasets = get_project_datasets()
    for dataset in project_datasets:
        dataset_id = dataset['datasetRwDto']['id']
        snapshot_id, formatted_timestamp, snapshot_response = take_dataset_snapshot(dataset_id)
        tag_dataset_snapshot(dataset_id, snapshot_id, formatted_timestamp)
        snapshot_comment = format_snapshot_comment(snapshot_response, formatted_timestamp)
        leave_comment_on_job(snapshot_comment)

    variables_comment = format_env_vars_comment()
    leave_comment_on_job(variables_comment)
