# Copyright IBM Corp. 2018

import requests
import json
import hcl #python pip package is pyhcl
import os
utilizeVault = False
vaultURL = "http://sevault.hashidemos.io:8200"
secretLocation = "secret/adam/terraform"

#Configure Vault and grab secrets
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
TFEworkspace = "ExampleApplication1-test"
vcsOrganization = "AdamCavaliere"
vcsWorkspace = "terraform-demos"
vcsWorkingDirectory = "azure_ApplicationConfig"


#Base configurations
headers = {'Authorization': AtlasToken, 'Content-Type' : 'application/vnd.api+json'}
createWorkspaceURL = "https://app.terraform.io/api/v2/organizations/"+TFEorganization+"/workspaces"
createVariablesURL = "https://app.terraform.io/api/v2/vars"
tokenURL = 'https://app.terraform.io/api/v2/organizations/'+TFEorganization+'/oauth-tokens'
#todo: 404 - workspace not found, 422 variables already present

def getoAuthToken(organization):
  r = requests.get(tokenURL, headers=headers)
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

def createWorkspacePayload(vcsOrganization,vcsWorkspace,TFEworkspace,workingDirectory,tfeOrganization):
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
        "identifier": vcsOrganization+"/"+vcsWorkspace,
        "oauth-token-id": oAuthToken,
        "branch": "",
        "default-branch": "true"
      }
    },
    "type":"workspaces"
  }
  }
  return workspacePayload

def createWorkspace():
  payload = createWorkspacePayload(vcsOrganization,vcsWorkspace,TFEworkspace,vcsWorkingDirectory,TFEorganization)
  try:
    r = requests.post(createWorkspaceURL, headers=headers, data=json.dumps(payload))
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
        print r.text
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
    except:
      print r.status_code

 
createWorkspace()
setEnvVariables()
createVariables()

