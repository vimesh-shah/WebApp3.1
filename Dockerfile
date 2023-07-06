#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["WebApp3.1.csproj", "."]
RUN dotnet restore "./WebApp3.1.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "WebApp3.1.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "WebApp3.1.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "WebApp3.1.dll"]