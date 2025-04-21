# Material para la clase 8

Aquí está la action que vas a necesitar para evluar que tu código está funcionando bien

```yaml
name: Run Tests on Pull Request

on:
  pull_request:
    branches:
      - main 

jobs:
  build-and-test:
    runs-on: ubuntu-latest

    steps:

      - name: Checkout code
        uses: actions/checkout@v3


      - name: Setup .NET
        uses: actions/setup-dotnet@v3
        with:
          dotnet-version: '8.0'


      - name: Restore dependencies
        run: dotnet restore
        working-directory: src


      - name: Build the project
        run: dotnet build --no-restore --configuration Release
        working-directory: src


      - name: Run tests
        run: dotnet test --no-build --configuration Release --logger "trx;LogFileName=test-results.trx"
        working-directory: src
```
