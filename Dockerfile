# Utilizza l'immagine base di Nginx
FROM nginx:alpine

# Rimuove i file di default di Nginx
RUN rm -rf /usr/share/nginx/html/*

# Copia i file dell'applicazione nella directory di Nginx
COPY build/web /usr/share/nginx/html

# Espone la porta 80 per il traffico HTTP
EXPOSE 80

# Comando di avvio per Nginx
CMD ["nginx", "-g", "daemon off;"]
