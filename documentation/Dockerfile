FROM mcr.microsoft.com/dotnet/sdk:6.0 
#COPY /var/lib/docker/tmp/buildkit-mount402555870/ Dockerfile
RUN dotnet restore
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /Trial
