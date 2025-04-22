# Material de la clase 14

Aquí tienes el material para la clase 14

El formato de JSON que necesitas para tus credenciales es el siguiente:

```json
{
    "clientSecret":  "<password>",
    "subscriptionId":  "<subscriptionId>",
    "tenantId":  "<tenant>",
    "clientId":  "<appId>"
}
```

Luego sigue el código para actualizar la Github Action

```yml
name: API Contactos CI/CD

on:
  push:
    branches: [ "main" ]

env:
  IMAGE_BASE_NAME: aminespinoza/apicontactos:latest
  RESOURCE_GROUP: rg--warm-wren
  ENVIRONMENT_NAME: devops-env

jobs:
  API_Image:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: src/ApiContactos
    steps:
      - name: Check out the repo
        uses: actions/checkout@v3
        
      - name: Azure Login
        uses: Azure/login@v1.4.6
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }} 
        
      - name: Install az containerapp extension
        run: |
          az config set extension.use_dynamic_install=yes_without_prompt
          
      - name: Build Docker NET image
        run: | 
          docker build --platform linux -t $IMAGE_BASE_NAME .
          
      - name: Login to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Deploy image to hub
        run: |
          docker push $IMAGE_BASE_NAME
          
      - name: Deploy Container App
        run: |
          az containerapp up --name contactosapi --image $IMAGE_BASE_NAME --resource-group $RESOURCE_GROUP --environment $ENVIRONMENT_NAME --ingress external --target-port 8080
```
