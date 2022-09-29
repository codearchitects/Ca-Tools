# Cos'è CAEP
**`Code Architects Enterprise Platform`** è un ambiente di sviluppo creato da Code Architects.
Esso è integrato in Visual Studio e Visual Studio Code, gli IDE di sviluppo Microsoft.

## Requisiti minimi

- Windows 10 <sup>`1`</sup> o Windows 10 in Hyper-V<sup>`2`</sup>
- RAM 16 GB
- CPU quad-core (1,85 GHz)
- SSD con 40 GB di spazio disponibile <sup>`3`</sup>

<sup>`1`</sup> Esclusa la versione Windows Insider. \
<sup>`2`</sup> Vedi [Ambienti virtualizzati](#ambienti-virtualizzati)
<sup>`3`</sup> Escluso lo spazio su disco da dedicare ai progetti di sviluppo.

<div style="page-break-after: always"></div>

# CAEP Installer

Prima di installare il CAEP, l'installer andrà a soddisfare una serie di requisiti:

**Tools**
- Git
- Node.js - npm
- DotNet Core - Visual Studio - Visual Studio Code
- Una distribuzione Linux ( Ubuntu di default )
- Docker Desktop


**Windows Features**
- Windows Subsystem for Linux ( WSL 2 )
- Virtual Machine Platform       

**Variabili d'ambiente**
- PATH
  - C:\windows                           
  - C:\windows\system32                 
  - C:\windows\system32\wbem                                      
  - C:\windows\system32\windowspowershell\v1.0

Puoi visualizzare tali env var digitando su Powershell:
```Powershell
$env:PATH
```

<div style="page-break-after: always"></div>

# Prima di iniziare

<b>assicurarsi che:</b>
- vi sia una connessione ad internet attiva.
- l'utente abbia i permessi di Amministratore della macchina.
- il repository di Code Architects sia raggiungibile sulla porta TCP 444 in modalità HTTPS.
- i registry pubblici di Nuget ed NPM siano raggiungibili.
- non vi siano antivirus e/o firewall che blocchino il processo di installazione e successivamente, l'uso dei programmi installati.

<b>ma soprattutto che:</b>

<b>1.</b> L'utente sia stato abilitato da Code Architects:
  - gli siano stati forniti **`username`** e **`password`** su Azure DevOps.
  - abbia cambiato la **password di default** a <a href="https://passcore.codearchitects.com">questo link</a>.
    - La password deve essere cambiata **ogni 90 giorni**.
    - L'utente riceverà una mail da serviceaccount@codearchitects.com **15 giorni prima** della scadenza.
    - Se entro 15 giorni non eseguirà questa operazione, l'**account verrà bloccato**.


<b>2.</b> Abbia generato un **`token`** valido a <a href="https://devops.codearchitects.com:444/Code\%20Architects/_usersSettings/tokens">questo link</a>.

<div style="page-break-after: always"></div>

# Azure DevOps Token

L’uso dei registry privati su Azure DevOps è concesso solo a chi ha diritti di accesso e quindi, credenziali valide grazie all'utilizzo di token.

### Controllo dello stato del Token
Per controllare se un token è stato generato correttamente o scaduto, accedere a <a href="https://devops.codearchitects.com:444/Code\%20Architects/_usersSettings/tokens">questo link</a>.
  <img src="./img/testToken.jpg" alt="drawing" width="500"/>

### Generazione del Token

**1.** Per creare un nuovo token, nella stessa schermata cliccare su **`+ NEW TOKEN`**

**2.** Configurarlo con i seguenti parametri:
- **Name:** `nomeToken`
- **Organization:** `All Accessible Organizations`
- **Expiration (UTC):** `Custom defined` (estendere la durata ad **1 anno**)
- **Scopes:** `Custom defined`
- **Packaging:** `Read`
  <img src="./img/createToken.jpg" alt="drawing" width="500"/>

**3.** Cliccare **`CREATE`** per confermare.

**4. ATTENZIONE!**
- Al termine, assicurarsi di **copiare e salvare il token** in un posto sicuro, servirà in seguito!
- Per motivi di sicurezza il token **NON** verrà più visualizzato.

<div style="page-break-after: always"></div>

# Ambienti virtualizzati
E' supportata l'installazione in ambiente virtualizzato, purchè sia Microsoft **`Hyper-V`** e sia stata abilitata la funzionalità **`Nested Virtualization`** sulla macchina host:

- **Assicurarsi che la Macchina Virtuale sia spenta!**
- Lanciare il seguente comando sulla macchina host:
  ```Powershell
  Set-VMProcessor -VMName <VMName> -ExposeVirtualizationExtensions $true
  ```
  sostituendo **`<VMName>`** con il nome della Virtual Machine su cui si intende installare CAEP.

# Powershell setup
E' necessario abilitare la macchina (sui cui si andrà ad Installare CAEP) all'esecuzione degli script Powershell.

- Lanciare il seguente comando:
  ```Powershell
  Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
  ```
- Per evitare che l'output si blocchi:
   1. Aprire Powershell come amministratore

  
   2. Cliccare sulla barra in alto col tasto destro e quindi su Properties
    <img src="./img/psProperties.png" alt="drawing" width="250"/>
      
   3. Disabilitare i flag **`QuickEdit Mode`** e **`Insert Mode`**
    <img src="./img/psOptions.jpg" alt="drawing" width="300"/>

<div style="page-break-after: always"></div>

# Download e run dell'installer

**1.**  Scaricare il file .zip da <a href="https://github.com/codearchitects/Ca-Tools/archive/refs/heads/main.zip">questo link</a>.
**2.** Cliccare col tasto destro sulla cartella scaricata e scegliere **Estrai tutto...** <br> <img src="./img/extractAll.jpg" alt="drawing" width="120"/>
**3.** Scegliere una destinazione (es. Desktop) e cliccare **Estrai**.

**4.** Aprire Powershell come Amministratore.
**5.** Spostarsi all'interno della cartella estratta con il comando `cd`.

**6.** Lanciare il seguente comando Powershell per avviare l'installer:
  ```Powershell
  .\caep-installer.ps1
  ```
   - In caso venga eseguito per la prima volta sarà necessario autorizzare l’esecuzione del software (si consiglia di scegliere l'opzione `A`).

<div style="page-break-after: always"></div>

# Installazione dei Requirement

**1.** Avviato l'installer apparirà una finestra con i **Requirement**, una serie di tool necessari al funzionamento di CAEP:

| Stato Requirement | Risultato |
| :---: | :---: |
|**`OK`**| Requisito soddisfatto, l'applicativo è già installato. |
|**`KO`**| Requisito non soddisfatto, l'applicativo deve essere installato. |

- Cliccando su **`NEXT`** in basso a destra dell'interfaccia, si procederà con l'installazione dei soli requisiti che presentano lo stato **KO**.

**2.** Ogni requisito chiederà una conferma di download e installazione:

| Pulsante | Output |
| :---:    | :--:
|**`ACCEPT `**| Accetta il download e l'installazione automatica del requisito.
|**`DECLINE`**| Rifiuta il download e l'installazione automatica del requisito.

- Nel caso si decida di declinare l'installazione di un requirement, bisognerà installarlo a mano.
- In alternativa, bisogna rilanciare l'installer e accettare l'installazione automatica.

**3.** Requirement come **Windows Subsystem su Linux** e **Virtual Machine Platform** richiedono il riavvio del sistema.

| Pulsante | Output |
| :--:     | :---:  |
|**`RESTART`**| Riavvia il sistema per abilitare con successo la relativa Windows Feature. |
 - Dopo il riavvio del sistema lo script verrà eseguito automaticamente con i permessi di amministratore, pertanto comparirà un alert per la sua esecuzione: dare quindi conferma.
 - Avviato lo script si noterà che gli status **KO** precedenti sono stati sostituiti da un **OK**.

**4.** Dopo l'update di **WSL 2**, cliccare su **`ACCEPT`** alla richiesta di installazione di **Ubuntu 20.04**.

- **Per installare una distribuzione Linux differente:**
  - Cliccare il tasto **`DECLINE`** per rifiutare l'installazione di Ubuntu 20.04.
  - Aprire un'altra sessione di terminale (CMD o Powershell) e lanciare il comando:

    ```Powershell
    wsl -l -o
    ```
  - Una volta scelta la distro, la si può installare utilizzando il comando:
  
    ```Powershell
    wsl --install -d <DistroLinux>
    ```
e sostituendo **`<DistroLinux>`** con il nome della distribuzione scelta.

**A prescindere dalla scelta, apparirà automaticamente la shell relativa e richiederà la creazione di un account locale per la distro WSL:**
- Inserire username e password a scelta.
- Dopo la creazione dell’account, si potrà chiudere la shell relativa alla distro Linux.

**5.** Una volta installato **Docker Desktop**, sarà necessario:
- Cliccare sul tasto **`LOGOUT`** che apparirà in basso a destra dell'installer per disconnettere l'utente.
- Al **login** successivo verrà automaticamente avviato lo script di installazione.

- Se si dispone di un Proxy sarà necessario settarlo nelle impostazioni di **Docker Desktop** in:
  ```Powershell
  Settings > Resources > Proxies
  ```
  <img src="./img/dockerProxy.jpg" alt="drawing" width="400"/>

<div style="page-break-after: always"></div>

# Installazione di CA-Tools

A Requirement soddisfatti, si passerà all'installazione del CAEP.
- L'installer cercherà le credenziali di Azure DevOps sulla macchina.
- Se non le trova, andranno inseriti manualmente **`username`** e **`token`**.

  <img src="./img/azureLogin.jpg" alt="drawing" width="300"/>

L' **`username`** è quello fornito da Code Architects per l'autenticazione in Azure DevOps.
  - **Input corretto:** mrossi
  - **Input errati:** mrossi@azienda.x **;** COLLABORATION\mrossi

Il **`token`** è quello generato nelle fasi iniziali ( vedi [Azure DevOps Token](#azure-devops-token) )
  - Deve essere stato settato correttamente e non deve essere scaduto.

<div style="page-break-after: always"></div>
