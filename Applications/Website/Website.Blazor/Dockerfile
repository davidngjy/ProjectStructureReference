#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# To access ADO private feed
ARG FEED_URL=https://pkgs.dev.azure.com/ScorpiusWHACK2021/_packaging/ScorpiusWHACK2021/nuget/v3/index.json
ARG PAT=
ENV NUGET_CREDENTIALPROVIDER_SESSIONTOKENCACHE_ENABLED true
ENV VSS_NUGET_EXTERNAL_FEED_ENDPOINTS "{\"endpointCredentials\": [{\"endpoint\":\"${FEED_URL}\", \"password\":\"${PAT}\"}]}"
RUN wget -q -O - https://raw.githubusercontent.com/Microsoft/artifacts-credprovider/master/helpers/installcredprovider.sh | bash

WORKDIR /src
COPY ["Website.Blazor/Website.Blazor.csproj", "Website.Blazor/"]
RUN dotnet restore "Website.Blazor/Website.Blazor.csproj" -s https://api.nuget.org/v3/index.json -s ${FEED_URL}
COPY . .
WORKDIR "/src/Website.Blazor"
RUN dotnet build "Website.Blazor.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Website.Blazor.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Website.Blazor.dll"]