# ----------------------------------------------------------------------
# 1. BUILD STAGE: Compile the application (large .NET SDK base)
# ----------------------------------------------------------------------
# Start with the .NET SDK image for compiling the application.
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy the project file(s) and restore packages. 
# This layer is cached efficiently and only rebuilt if the .csproj changes.
COPY ["ProductApi.csproj", "."] 
RUN dotnet restore

# Copy the rest of the application source code.
# This layer is rebuilt whenever the source code changes.
COPY . .

# Publish the application in Release mode. 
# The '--no-restore' flag has been removed to ensure the publish command 
# forces a complete package resolution and restore if necessary.
RUN dotnet publish "ProductApi.csproj" -c Release -o /app/publish

# ----------------------------------------------------------------------
# 2. FINAL STAGE: Run the application (small ASP.NET runtime base)
# ----------------------------------------------------------------------
# Switch to the small, lightweight ASP.NET runtime image for the final container.
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

# Copy the published output (the DLLs and assets) from the 'build' stage 
# into the small 'final' image.
COPY --from=build /app/publish .

# Inform Docker that the container will listen on port 8080.
EXPOSE 8080

# Define the command that runs the application when the container starts.
ENTRYPOINT ["dotnet", "ProductApi.dll"]
