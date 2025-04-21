# Material para la clase 11

Para esta clase necesitas modifcar tu Action ya existente:

```yaml
name: API Contactos CD/CD

on:
  push:
    branches: [ "main" ]

env:
  IMAGE_BASE_NAME: aminespinoza/apicontactos

jobs:
  API_Image:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: src/ApiContactos
    steps:
      - name: Check out the repo
        uses: actions/checkout@v3
        
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
          docker push $IMAGE_BASE_NAME:latest
```

No olvides obtener los secretos de tu cuenta de Docker Hub.
