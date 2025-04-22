# Material de la clase 14

Aquí tienes el material para la clase 14

El formato de JSON que necesitas para tus credenciales es el siguiente:

```json
{
    "clientSecret":  "8Fb8Q~GjVXFAIFmQEJW0EUtQQkAYPH.NOdzYPdB3",
    "subscriptionId":  "30a83aff-7a8b-4ca3-aa48-ab93268b5a8b",
    "tenantId":  "0fe86da7-ca5d-4cc6-8c3c-a91b0c4b50ba",
    "clientId":  "8d7f71a2-a600-4129-ab60-6e153b0848cc"
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
