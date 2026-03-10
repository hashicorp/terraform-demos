#!/usr/bin/env python
# Copyright IBM Corp. 2018

import requests
import json
import hcl #python pip package is pyhcl
import os
# Populate if you want to utilize Vault 
utilizeVault = False
vaultURL = "http://sevault.hashidemos.io:8200"
secretLocation = "secret/adam/terraform"

#Will run against vault and grab secrets if the utilizeVault variable is set to True, else it will look for your TFE Org's Atlas Token 
#as an environment variable.
if utilizeVault == True:
  import hvac
  client = hvac.Client(url=vaultURL, token=os.environ['VAULT_TOKEN'])
  terraform_secrets = client.read(secretLocation)
  ts = terraform_secrets['data']
  AtlasToken = "Bearer " + ts['AtlasToken']
else:
  AtlasToken = "Bearer " + os.environ['ATLAS_TOKEN']

#User Configurable Vars - if utilizing Vault, replace the ts['foo'] values.
TFEorganization = "azc"
TFEworkspace = "Vault"
vcsOrganization = "AdamCavaliere"
vcsRepo = "terraform-demos" #This is the repo which you are linking to your TFE workspace
vcsWorkingDirectory = "" #This can be blank - only needed to be specified if you are using a sub-directory in your repo.


#Base configurations
headers = {'Authorization': AtlasToken, 'Content-Type' : 'application/vnd.api+json'}
createWorkspaceURL = "https://app.terraform.io/api/v2/organizations/"+TFEorganization+"/workspaces"
createVariablesURL = "https://app.terraform.io/api/v2/vars"
tokenURL = 'https://app.terraform.io/api/v2/organizations/'+TFEorganization+'/oauth-tokens'
#todo: 404 - workspace not found, 422 variables already present

def getoAuthToken(organization):
  r = requests.get(tokenURL, headers=headers)
  validateRun(r)
  response = json.loads(r.text)
  return response['data'][0]['id']

def createVarPayload(varName,defaultVal,TFEorganization,TFEworkspace,category,sensitive):
  varPayload = {
  "data": {
    "type":"vars",
    "attributes": {
      "key":varName,
      "value":defaultVal,
      "category":category,
      "hcl":"false",
      "sensitive":sensitive
     }
  },
  "filter": {
    "organization": {
      "name":TFEorganization
    },
    "workspace": {
      "name":TFEworkspace
    }
  }
  }
  return varPayload

def createWorkspacePayload(vcsOrganization,vcsRepo,TFEworkspace,workingDirectory,tfeOrganization):
  oAuthToken = getoAuthToken(tfeOrganization)
  try:
    workingDirectory
  except:
    workingDirectory = ""
  workspacePayload = {
  "data": {
    "attributes": {
      "name":TFEworkspace,
      "working-directory": workingDirectory,
      "vcs-repo": {
        "identifier": vcsOrganization+"/"+vcsRepo,
        "oauth-token-id": oAuthToken,
        "branch": "",
        "default-branch": "true"
      }
    },
    "type":"workspaces"
  }
  }
  return workspacePayload

def validateRun(runResponse):
  if not (runResponse.status_code == 201 or runResponse.status_code == 200):
    print str(runResponse.status_code) + ": " + str(runResponse.text) 

def createWorkspace():
  payload = createWorkspacePayload(vcsOrganization,vcsRepo,TFEworkspace,vcsWorkingDirectory,TFEorganization)
  try:
    r = requests.post(createWorkspaceURL, headers=headers, data=json.dumps(payload))
    validateRun(r)
  except:
    print r.status_code()

def createVariables():
  noFile = False
  try:
    with open('variables.tf', 'r') as fp:
        obj = hcl.load(fp)
  except:
    noFile = True

  if noFile == False:
    for k, v in obj['variable'].items():
      varName = k
      defaultVal = ""
      for k2, v2 in v.items():
        if k2 == 'default':
          defaultVal = v2
      payload = createVarPayload(varName,defaultVal,TFEorganization,TFEworkspace,"terraform","false")
      try:
        r = requests.post(createVariablesURL, headers=headers, data=json.dumps(payload))
        validateRun(r)
      except:
        print r.status_code()

def setEnvVariables():
  if utilizeVault == False:
    with open('/Users/adam/SynologyDrive/HashiDemos/terraform-aws-examples/application-config/envVars.json', 'r') as fp:
      obj = json.load(fp)
  else:
    obj = json.loads(ts['envVars'])
  for k,v in obj['data'].items():  
    payload = createVarPayload(k,v['value'],TFEorganization,TFEworkspace,v['vartype'],v['sensitive'])
    try:
      r = requests.post(createVariablesURL, headers=headers, data=json.dumps(payload))
      validateRun(r)
    except:
      print r.status_code

 
createWorkspace()
setEnvVariables()
createVariables()

