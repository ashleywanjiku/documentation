FROM mcr.microsoft.com/dotnet/sdk:6.0 As build env
WORKDIR /app

RUN dotnet restore
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
