﻿# Delete old migrations
rm -r Migrations
# Recreate migrations
dotnet ef migrations add InitialCreate

# Set connection string to production database
# PowerShell
$env:ConnectionStrings:dbConnectionString="<dbConnectionString>"

# Run migrations
dotnet ef database update