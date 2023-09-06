# Usa a imagem oficial do Node.js como base
FROM node:14

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia os arquivos de aplicação para o contêiner
COPY package*.json ./
COPY app.js ./ 
COPY frases.txt ./
COPY pm2.config.js ./

# Instala as dependências
RUN npm install

# Instala o PM2
RUN npm install -g pm2


# Exponha a porta em que o aplicativo irá rodar
EXPOSE 3000

# Comando para iniciar a aplicação quando o contêiner for executado
CMD [ "pm2-runtime", "start", "pm2.config.js" ]

