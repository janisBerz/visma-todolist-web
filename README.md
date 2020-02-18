# DevOps and Automation

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

#### Run unit test during the build stage

### Release stage

During this stage a new release is created automatically based on the 