# Material para la clase 9

En el archivo Dockerfile agrega lo siguiente:

```docker
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build 
WORKDIR /src
COPY ApiContactos.csproj .
RUN dotnet restore
COPY . .

RUN dotnet build "ApiContactos.csproj" -c Release -o /app/build

RUN dotnet publish -c release -o /app

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app .
ENTRYPOINT ["dotnet", "ApiContactos.dll"]
```

Ejecuta los comandos:

```bash
docker build -t aminespinoza/apicontactos .

docker run -it --rm --name apicontactos -p 8080:8080 aminespinoza/apicontactos
```
