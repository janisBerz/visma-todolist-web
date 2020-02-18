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

### Build stage

In the build stage we compile our application, ideally run test and package the application.

