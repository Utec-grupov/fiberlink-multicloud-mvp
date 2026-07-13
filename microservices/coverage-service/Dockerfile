# Dockerfile — Cotizador Seguros Pro
# Imagen base: Node.js 24
FROM node:24

# Directorio de trabajo dentro del contenedor
WORKDIR /usr/src/app

# Copiar dependencias primero (mejor uso del cache de capas Docker)
COPY package*.json ./
RUN npm install

# Copiar el resto del código fuente
COPY ./ .

# Azure Container Apps enruta tráfico al puerto 8080 por defecto.
# Debe coincidir con app.listen(8080) en index.js.
EXPOSE 8080

CMD ["node", "index.js"]