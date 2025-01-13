#!/bin/bash
export EULA=Y  # Set the EULA environment variable
/opt/mssql/bin/sqlservr &  # Start SQL Server in the background
sleep 50  # Wait for SQL Server to start
#/opt/mssql-tools18/bin/sqlcm -S localhost -U sa -P Your!Strong@Passw0rd -d master -i /usr/src/app/init.sql -C
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Your!Strong@Passw0rd -d master -i /usr/src/app/init.sql -C
wait  # Wait for SQL Server to finish
