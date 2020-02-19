# Automation

## Git

Git is an open-source distributed version control system. Meaning you do not need a central server to track the changes made to you project.

![DVCS](https://latesthackingnews.com/wp-content/uploads/2018/06/Distributed-Version-Control-System-Workflow-What-Is-Git-Edureka.png)

### Basic commands

- Clone remote repository

  ```bash
  git clone https://github.com/janisBerz/visma-todolist-web.git
  ```

- Check local repository's status. It will let you know if you are behind the remote branch and if there modified files that are not staged.

  ```bash
  git status
  ```

  Response:

  ```bash
  Your branch is up to date with 'origin/master'.

        modified:   ../../README.md
        modified:   ../../azure-pipelines.yml
  ```

- Stage changed files

  ```bash
  git add ../../README.md
  ```

  or

  ```bash
  git add .
  ```

- Commit the changes to your local repository

  ```bash
  git commit -m 'Updated readme file'
  ```

- Push the changed to remote repository (origin)

  ```bash
  git push
  ```

## .Net Core

Use the below commands to build and run your application from a command line.

### .Net Core requirements

- [.Net Core 3.1.1](https://dotnet.microsoft.com/download/dotnet-core/3.1)
- [Entity Framework Core tools](https://docs.microsoft.com/en-us/ef/core/miscellaneous/cli/dotnet)
  - Install tools by running the following command form PowerShell

    ```powershell
    dotnet tool install --global dotnet-ef
    ```

  - Verify if the EF Core CLI tools are installed

    ```powershell
    dotnet restore
    ```

    ```powershell
    dotnet ef
    ```

### Build and run your application

The following commands need to be executed from the root where the .csproj file is located -> `./src/ToDoList`

#### Restore dependencies

```powershell
dotnet restore
```

#### Run database migration

```powershell
dotnet ef database update
```

#### Start the application

```powershell
dotnet run
```

##### Some extras

- Add a solution file

  ```powershell
  dotnet new sln
  ```

- Add project file to solution

  ```powershell
  dotnet new add .\src\ToDoList\ToDoList.csproj
  ```

## Pipeline

You can find the pipeline code in `azure-pipelines.yml` YAML file. This file contains all the necessary steps to build, package and deploy the application and infrastructure. Pipeline schema can be found [here](https://docs.microsoft.com/en-us/azure/devops/pipelines/yaml-schema?view=azure-devops&tabs=schema)

### Example Build and deploy pipeline code

```yaml
variables:
  buildConfiguration: 'Release'
  pool: 'windows-latest'
  azureSubscriptionName: 'mySubscription'
  WebAppName: 'my-web-app'

stages:
- stage: Build
  jobs:
  - job:
    steps:

      - task: DotNetCoreCLI@2
        displayName: 'DotNet Core build'
        inputs:
          command: build
          projects: '**/*.sln'

- stage: Deployment_Dev
  jobs:
  - deployment: deployment_dev
    displayName: 'Dev'
    pool:
      vmImage: '$(pool)'
    environment: 'dev'
    strategy:
      runOnce:
        deploy:
          steps:

          - task: AzureRmWebAppDeployment@4
            displayName: 'Deploy Web App'
            inputs:
              appType: webApp
              ConnectedServiceName: '$(azureSubscriptionName)'
              WebAppName: '$(WebAppName)'
              package: '$(Pipeline.Workspace)/app/*.zip'
```

### Build stage

In the build stage we compile our application, ideally run test and package the application as an artifact that will get consumed by the pipeline in the deployment stage.

### Deployment stage

During this stage a new release is created automatically after a successful build. The artifacts that got created in the build stage are passed over to deployment stage and the application is deployed automatically.

## Infrastructure as code

For this exercise we will be using Microsoft Azure public cloud and their Infrastructure as code technology is [Azure Resource Manager](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/overview).

[Quick start templates](https://github.com/Azure/azure-quickstart-templates)

ARM template snippet:

```json
{
"resources": [
    {
      "type": "Microsoft.KeyVault/vaults",
      "name": "[parameters('keyVaultName')]",
      "apiVersion": "2018-02-14",
      "location": "[parameters('location')]",
      "properties": {
        "enabledForDeployment": "[parameters('enabledForDeployment')]",
        "enabledForDiskEncryption": "[parameters('enabledForDiskEncryption')]",
        "enabledForTemplateDeployment": "[parameters('enabledForTemplateDeployment')]",
        "tenantId": "[parameters('tenantId')]",
        "accessPolicies": [
          {
            "objectId": "[parameters('objectId')]",
            "tenantId": "[parameters('tenantId')]",
            "permissions": {
              "keys": "[parameters('keysPermissions')]",
              "secrets": "[parameters('secretsPermissions')]"
            }
          }
        ],
        "sku": {
          "name": "[parameters('skuName')]",
          "family": "A"
        },
        "networkAcls": {
            "defaultAction": "Allow",
            "bypass": "AzureServices"
        }
      }
    },
    {
      "type": "Microsoft.KeyVault/vaults/secrets",
      "name": "[concat(parameters('keyVaultName'), '/', parameters('secretName'))]",
      "apiVersion": "2018-02-14",
      "location": "[parameters('location')]",
      "dependsOn": [
        "[resourceId('Microsoft.KeyVault/vaults', parameters('keyVaultName'))]"
      ],
      "properties": {
        "value": "[parameters('secretValue')]"
      }
    }
  ]
}
  ```
