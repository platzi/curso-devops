# Material para la clase 10

Este es el código que debes agregar para tu nueva Github Action

```yml
name: API Contactos CI/CD

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
        
      - name: Looking for files
        run: ls -a
        
      - name: Build Docker NET image
        run: | 
          docker build --platform linux -t $IMAGE_BASE_NAME .
```
