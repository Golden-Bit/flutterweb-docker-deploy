# flutterweb-docker-deploy

---

### **Prerequisiti**

Prima di iniziare, assicurati di avere installato sul tuo sistema:

1. **Flutter SDK**

   - **Download**: Scarica Flutter SDK dal sito ufficiale [flutter.dev](https://flutter.dev/docs/get-started/install).
   - **Installazione**: Segui le istruzioni specifiche per il tuo sistema operativo:
     - **Windows**: [Guida all'installazione su Windows](https://flutter.dev/docs/get-started/install/windows).
     - **macOS**: [Guida all'installazione su macOS](https://flutter.dev/docs/get-started/install/macos).
     - **Linux**: [Guida all'installazione su Linux](https://flutter.dev/docs/get-started/install/linux).
   - **Configurazione del PATH**: Aggiungi la directory `flutter/bin` alla variabile d'ambiente `PATH` per poter utilizzare i comandi Flutter da qualsiasi posizione nel terminale.

2. **Docker**

   - **Download e installazione**: Scarica e installa Docker Desktop dal sito ufficiale [docker.com](https://www.docker.com/get-started).
   - **Avvio di Docker**: Assicurati che Docker sia in esecuzione sul tuo sistema. Puoi verificarlo eseguendo `docker --version` nel terminale.

3. **Editor di testo o IDE**

   - **Consigliato**: Visual Studio Code con estensioni Flutter e Dart per una migliore esperienza di sviluppo.

4. **Connessione Internet**

   - Necessaria per scaricare dipendenze e immagini Docker.

---

### **Passo 1: Verificare l'installazione di Flutter**

1. **Apri il terminale** o il prompt dei comandi.
2. **Verifica la versione di Flutter** eseguendo:

   ```bash
   flutter --version
   ```

   - Dovresti vedere l'output con la versione corrente di Flutter installata.

3. **Aggiorna Flutter (opzionale ma consigliato)**:

   ```bash
   flutter upgrade
   ```

   - Questo comando aggiornerà Flutter all'ultima versione stabile.

---

### **Passo 2: Abilitare il supporto per il web in Flutter**

1. **Abilita il supporto web**:

   ```bash
   flutter channel stable
   flutter upgrade
   flutter config --enable-web
   ```

   - Questo commuta Flutter al canale stabile, aggiorna Flutter e abilita il supporto per il web.

2. **Verifica i dispositivi disponibili**:

   ```bash
   flutter devices
   ```

   - Dovresti vedere dispositivi come **Chrome** e **Web Server** nell'elenco.

---

### **Passo 3: Creare un nuovo progetto Flutter**

1. **Crea un nuovo progetto chiamato `flutter_project`**:

   ```bash
   flutter create flutter_project
   ```

   - Questo comando genera un nuovo progetto Flutter con la struttura di directory standard.

2. **Naviga nella directory del progetto**:

   ```bash
   cd flutter_project
   ```

3. **Apri il progetto nel tuo editor preferito** (ad esempio, Visual Studio Code):

   ```bash
   code .
   ```

---

### **Passo 4: Eseguire l'applicazione Flutter nel browser (opzionale ma consigliato)**

1. **Esegui l'applicazione nel browser per testarla**:

   ```bash
   flutter run -d chrome
   ```

   - Questo avvierà l'applicazione in Chrome. Dovresti vedere l'applicazione predefinita di Flutter con un contatore incrementabile.

2. **Interrompi l'applicazione** premendo `q` nel terminale.

---

### **Passo 5: Personalizzare l'applicazione "Hello World"**

1. **Apri il file `lib/main.dart`** nel tuo editor.
2. **Modifica il codice per visualizzare "Hello World"**. Esempio:

   ```dart
   import 'package:flutter/material.dart';

   void main() {
     runApp(MyApp());
   }

   class MyApp extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       return MaterialApp(
         title: 'Flutter Web Hello World',
         home: Scaffold(
           appBar: AppBar(
             title: Text('Hello World App'),
           ),
           body: Center(
             child: Text(
               'Hello World!',
               style: TextStyle(fontSize: 24),
             ),
           ),
         ),
       );
     }
   }
   ```

3. **Salva le modifiche**.

4. **Riesegui l'applicazione nel browser** per vedere le modifiche:

   ```bash
   flutter run -d chrome
   ```

   - Dovresti vedere la scritta "Hello World!" al centro dello schermo.

---

### **Passo 6: Costruire l'applicazione per il web**

1. **Costruisci l'applicazione per la produzione**:

   ```bash
   flutter build web
   ```

   - Questo comando genera i file statici ottimizzati per il web all'interno della cartella `build/web`.

2. **Verifica il contenuto della cartella `build/web`**:

   - Dovresti vedere file come `index.html`, `main.dart.js`, `flutter_service_worker.js`, ecc.

---

### **Passo 7: Creare un Dockerfile per l'applicazione**

1. **Nella directory principale del progetto**, crea un nuovo file chiamato `Dockerfile` (senza estensione).
2. **Inserisci il seguente contenuto nel `Dockerfile`**:

   ```dockerfile
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
   ```

   - Questo Dockerfile utilizza una piccola immagine di Nginx basata su Alpine Linux per servire i file statici dell'applicazione Flutter.

3. **Salva il `Dockerfile`**.

---

### **Passo 8: Costruire l'immagine Docker dell'applicazione**

1. **Assicurati di essere nella directory principale del progetto**, dove si trova il `Dockerfile`.
2. **Costruisci l'immagine Docker** assegnandole un tag (ad esempio, `flutter_web_app`):

   ```bash
   docker build -t flutter_web_app .
   ```

   - Il punto `.` indica che Docker deve utilizzare il `Dockerfile` nella directory corrente.

3. **Attendi il completamento della build**:

   - Docker eseguirà ogni istruzione nel `Dockerfile` per creare l'immagine.
   - Se tutto va bene, vedrai un messaggio che indica la creazione dell'immagine con successo.

---

### **Passo 9: Eseguire il container Docker**

1. **Esegui il container a partire dall'immagine creata**, mappando la porta 80 del container alla porta 8080 del tuo host:

   ```bash
   docker run -d -p 8080:80 flutter_web_app
   ```

   - **-d**: esegue il container in modalità detached (in background).
   - **-p 8080:80**: mappa la porta 80 del container (dove Nginx serve l'applicazione) alla porta 8080 del tuo sistema locale.

2. **Verifica che il container sia in esecuzione**:

   ```bash
   docker ps
   ```

   - Dovresti vedere il container `flutter_web_app` nell'elenco dei container attivi.

---

### **Passo 10: Testare l'applicazione nel browser**

1. **Apri il tuo browser web preferito**.
2. **Accedi all'indirizzo**:

   ```
   http://localhost:8080
   ```

   - Dovresti vedere la tua applicazione Flutter "Hello World" visualizzata correttamente.
   - Se stai utilizzando Docker su una macchina virtuale o su un server remoto, sostituisci `localhost` con l'indirizzo IP appropriato.

---

### **Passo 11: Risoluzione dei problemi comuni**

- **Porta già in uso**:

  - Se ricevi un errore che indica che la porta 8080 è già in uso, puoi scegliere un'altra porta:

    ```bash
    docker run -d -p 9090:80 flutter_web_app
    ```

    - Ora l'app sarà accessibile su `http://localhost:9090`.

- **Problemi con Docker Desktop su Windows/macOS**:

  - Assicurati che Docker Desktop sia in esecuzione.
  - Verifica che la condivisione dei file sia abilitata per la directory del progetto.

- **Errori durante la build dell'immagine Docker**:

  - Verifica che il `Dockerfile` sia corretto e che i percorsi siano esatti.
  - Assicurati che la cartella `build/web` esista e contenga i file buildati.

---

### **Passo 12: Aggiornare l'applicazione e ricostruire l'immagine Docker**

Se apporti modifiche all'applicazione Flutter, dovrai ricostruire l'app e l'immagine Docker:

1. **Modifica il codice Flutter** nel file `lib/main.dart` o in altri file.
2. **Ricostruisci l'applicazione per il web**:

   ```bash
   flutter build web
   ```

3. **Ricostruisci l'immagine Docker**, utilizzando lo stesso tag o un nuovo tag:

   ```bash
   docker build -t flutter_web_app .
   ```

4. **Fermare il container in esecuzione** (se utilizzi lo stesso tag):

   ```bash
   docker stop $(docker ps -q --filter ancestor=flutter_web_app)
   ```

5. **Eseguire nuovamente il container**:

   ```bash
   docker run -d -p 8080:80 flutter_web_app
   ```

6. **Verifica le modifiche nel browser** accedendo nuovamente a `http://localhost:8080`.

---

### **Passo 13: Distribuire l'immagine Docker su un repository (opzionale)**

Per condividere l'immagine Docker o distribuirla su un server remoto:

1. **Accedi a Docker Hub** o ad un altro registry Docker:

   ```bash
   docker login
   ```

2. **Tagga l'immagine** con il tuo nome utente e il nome del repository:

   ```bash
   docker tag flutter_web_app tuo_utente/flutter_web_app
   ```

3. **Pusha l'immagine** sul registry:

   ```bash
   docker push tuo_utente/flutter_web_app
   ```

4. **Sul server remoto**, puoi ora eseguire:

   ```bash
   docker pull tuo_utente/flutter_web_app
   docker run -d -p 80:80 tuo_utente/flutter_web_app
   ```

---

### **Passo 14: Miglioramenti e considerazioni aggiuntive**

- **Utilizzare Docker Compose**:

  - Per configurazioni più complesse o per gestire più container, considera l'utilizzo di Docker Compose.

- **Ottimizzare l'immagine Docker**:

  - Creare immagini Docker più leggere utilizzando immagini base più piccole o multistage builds.

- **Implementare HTTPS**:

  - Per applicazioni in produzione, configurare Nginx per servire il traffico HTTPS.

- **Monitoraggio e logging**:

  - Configurare strumenti di monitoraggio per tracciare le performance dell'applicazione.

- **Gestione delle variabili d'ambiente**:

  - Utilizzare variabili d'ambiente per configurazioni specifiche dell'ambiente (es. API endpoint).

---