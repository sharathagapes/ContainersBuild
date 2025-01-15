Database Service Configuration
The service model in Git workflows, particularly in GitHub Actions, provides a powerful way to integrate external services into CI/CD pipelines. Here Service's run inside Docker containers that provide a simple and portable way to host services required for testing or operating applications within a workflow where applications often need to interact with various external services.

This service outlines the configuration of SQL Server and MongoDB Atlas services in the Continuous Integration (CI) build process using GitHub Actions which are essential for running database-enabled unit tests in a controlled environment.

Service Configuration
SQL Server and MongoDB Atlas
services:
  sqlserver:
    image: mcr.microsoft.com/mssql/server:2022-latest
    env:
      MSSQL_SA_PASSWORD: ${{ secrets.MSSQL_SA_PASSWORD }}
      ACCEPT_EULA: Y  
    ports:
      - "1433:1433"  

  mongodb-atlas:
    image: mongodb/mongodb-atlas-local:latest    
    ports:
      - "27017:27017" 
Description
SQL Server Service:

Image: Utilizes the latest SQL Server 2022 Docker image from Microsoft's container registry.
Environment Variables:
MSSQL_SA_PASSWORD: Password for the SQL Server SA account, securely stored in GitHub Secrets.
ACCEPT_EULA: Set to Y to accept the End User License Agreement.
Ports: Exposes port 1433 for client connections.
MongoDB Atlas Service:

Image: Utilizes the latest MongoDB Atlas Docker image for local development.
Ports: Exposes port 27017 for client connections.
Environment Variables Configuration
Environment Variables
env:
  MONGODB_DATABASE: metarisknextproject
  MONGODB_UNITTEST_DATABASE: metarisknextprojectunittest
  MONGODB_URI: mongodb://localhost:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.3.0
  MSSQL_SA_PASSWORD: ${{ secrets.MSSQL_SA_PASSWORD }}
  METARISK_CLOUD_DB: "Server=localhost,1433;Database=MetaRiskCloud;User Id=sa;Password=${{ secrets.MSSQL_SA_PASSWORD }};Encrypt=False;TrustServerCertificate=True;"
MongoDB Environment Variables
MONGODB_DATABASE: Specifies the name of the primary MongoDB database used by the application.

MONGODB_UNITTEST_DATABASE: Defines the name of the MongoDB database specifically for unit testing, ensuring tests do not interfere with production data.

MONGODB_URI: Connection string for MongoDB, specifying the host, port, and connection options for the application to connect to the MongoDB instance.

SQL Server Environment Variables
MSSQL_SA_PASSWORD: The password for the SQL Server system administrator (SA) account, securely stored to protect sensitive information.

METARISK_CLOUD_DB: Connection string for SQL Server, allowing the application to connect to the specified database using the SA account, including parameters for encryption and trust settings.

Workflow Detail:
Job: Set Root Path (Run Test Prerequisite)
- name: Set Root Path (Run Test prerequisite)
  id: get-root-path
  run: echo "rootPath=$(dirname ${{ inputs.Solution_Name }})" >> $GITHUB_ENV
Purpose
Sets the root path of the solution based on the provided input, serving as a prerequisite for subsequent jobs that require knowledge of the solution's directory structure. Stores the result in the GITHUB_ENV variable rootPath, making it accessible to later jobs.

Job: Run init.sql Script (Run Test Prerequisite)
- name: Run init.sql script (Run Test prerequisite)
  if: startsWith(env.rootPath, 'src/Clients') || startsWith(env.rootPath, 'src/Users')
  run: |
    echo "Running init.sql script..."
    docker cp init.sql $(docker ps -q --filter "name=sqlserver"):/opt/
    docker exec $(docker ps -q --filter "name=sqlserver") /bin/bash -c "/opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P '$MSSQL_SA_PASSWORD' -C -i /opt/init.sql"
    sleep 10
Purpose
Executes an SQL initialization script (init.sql) to set up the database schema and any necessary initial data, ensuring the database is in the correct state before running tests.

Explanation
Condition: Runs only if the rootPath indicates that the solution is located in either the src/Clients or src/Users directories.
Docker Commands:
Copy Command: Copies the init.sql script into the SQL Server container.
Execution Command: Executes the script inside the SQL Server container using sqlcmd.
Sleep Command: Includes a brief pause to allow the database to process the initialization.
Job: Run Tests (Release)
- name: Run Tests (Release)
  if: ${{ inputs.Run_Unit_Tests == 'true'}}
  run: |
    SolutionShortname=$(basename "${{ inputs.Solution_Name }}" .sln)
    echo "SolutionShortname: $SolutionShortname"
    log="${{ inputs.API_Proj_Dir }}/logs/${SolutionShortname}_Release"
    rootPath=$(dirname ${{ inputs.Solution_Name }})
                
    dotnet test ${{ inputs.Solution_Name }} -c Release -l "trx;LogFilePrefix=${log}" | tee "$log"

    projectName=$(basename "$rootPath")
    echo "projectName=$projectName" >> $GITHUB_ENV
    echo "rootPath=$rootPath" >> $GITHUB_ENV
  shell: bash 
Purpose
Runs the unit tests for the application in Release configuration, validating the functionality of the application against the initialized database.

Explanation
Condition: Runs only if the Run_Unit_Tests input is set to true.
Test Execution:
Derives the SolutionShortname from the Solution_Name input.
Executes the dotnet test command to run the unit tests, logging results in TRX format.
Uses the tee command to display output in the console while saving it to a log file.
Environment Variables: Stores the project name and root path in GITHUB_ENV for use in subsequent jobs.
Job: Upload Test Results
- name: Upload Test Results
  if: ${{ inputs.Run_Unit_Tests == 'true'}}
  uses: actions/upload-artifact@v4
  with:
    name: "${{ env.projectName }}-test-logs"
    path: |
      ${{ env.rootPath }}/**/*.trx
Purpose
Artifact Upload: Uses the actions/upload-artifact action to upload all TRX files generated during the test run for analysis.
Summary
Each job in the CI build process plays a critical role in ensuring that the application is tested effectively against a real database environment. The service model used in this configuration automatically manages the lifecycle of the containers, including their termination after the jobs are completed. The jobs are designed to set up the necessary environment, run tests, and provide access to the results, facilitating a robust testing workflow.
