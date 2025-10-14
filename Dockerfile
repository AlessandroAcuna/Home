# Dockerfile per servire il sito statico con nginx
# Usa una immagine nginx leggera e aggiornata
## Uso un tag specifico (major.minor) per maggiore riproducibilità e per limitare warning di vulnerabilità
FROM nginx:1.25-alpine

# Rimuove il contenuto di default e copia i file del sito
RUN rm -rf /usr/share/nginx/html/*
COPY . /usr/share/nginx/html

# Espone porta 80
EXPOSE 80

# Comando di default
CMD ["nginx", "-g", "daemon off;"]