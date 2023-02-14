FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build

WORKDIR /app

# Separate layers here to avoid redoing dependencies on code change.
COPY *.sln .
COPY *.csproj .
RUN dotnet restore

# Now the code.
COPY . .
RUN dotnet publish -r linux-musl-x64 --self-contained -c Release -o out

FROM mcr.microsoft.com/dotnet/runtime:6.0-alpine AS runtime
WORKDIR /app
COPY --from=build /app/out .

ENTRYPOINT ["./docker_exporter"]
