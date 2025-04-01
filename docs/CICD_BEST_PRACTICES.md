# Ghid de Bune Practici CI/CD

Acest document conține ghidul de bune practici pentru CI/CD în cadrul proiectului SchoolBus, oferind îndrumări dezvoltatorilor pentru a asigura o integrare continuă și un deployment continuu eficient și sigur.

## Principii generale

1. **Fast Feedback**: Testele ar trebui să ruleze cât mai rapid posibil pentru a oferi feedback rapid dezvoltatorilor.
2. **Fail Fast**: Dacă există o problemă, pipeline-ul ar trebui să eșueze cât mai devreme în proces.
3. **Reproducibilitate**: Fiecare build ar trebui să fie reproductibil - aceleași input-uri ar trebui să producă aceleași output-uri.
4. **Automatizare**: Automatizați tot ce poate fi automatizat în procesul de build, test și deployment.
5. **Vizibilitate**: Starea build-urilor și a deployment-urilor ar trebui să fie vizibilă pentru toată echipa.

## Structura branch-urilor

1. **main/master**: Branch-ul principal conține codul stabil și gata pentru producție
2. **develop**: Branch-ul de dezvoltare unde se integrează noile funcționalități
3. **feature/***:  Branch-uri pentru noi funcționalități (ex: `feature/user-authentication`)
4. **bugfix/***:  Branch-uri pentru rezolvarea bug-urilor
5. **release/***:  Branch-uri pentru pregătirea unei noi versiuni
6. **hotfix/***:  Branch-uri pentru rezolvări urgente de bug-uri în producție

## Workflow GitHub

### Pull Requests

1. Toate schimbările trebuie făcute printr-un Pull Request (PR), niciodată direct pe `main` sau `develop`
2. Fiecare PR trebuie să rezolve un ticket/issue specific
3. Titlul PR-ului trebuie să includă ID-ul issue-ului (ex: `[SB-123] Implementare autentificare cu Google`)
4. Descrierea PR-ului trebuie să conțină:
   - Ce schimbări au fost făcute și de ce
   - Cum pot fi testate aceste schimbări
   - Screenshots (pentru schimbări vizuale)
   - Link către issue-ul corespunzător
5. PR-urile trebuie să treacă toate verificările automate înainte de a fi revizuite
6. PR-urile trebuie să fie revizuite de cel puțin un alt dezvoltator

### Code Review

1. Revizuiți codul pentru:
   - Funcționalitate
   - Securitate
   - Performanță
   - Lizibilitate
   - Respectarea standardelor de cod
2. Oferiți feedback constructiv
3. Aprobați doar dacă sunteți convinși că codul este gata pentru producție

## Configurarea workflow-urilor

### Workflow-ul pentru microservicii

Fiecare microserviciu ar trebui să aibă un workflow GitHub Actions care include:

1. **Build și teste**:
   ```yaml
   name: CI

   on:
     push:
       branches: [ develop, main ]
     pull_request:
       branches: [ develop, main ]

   jobs:
     build-and-test:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v3
         - name: Set up language environment
           # ...
         - name: Install dependencies
           # ...
         - name: Run linter
           # ...
         - name: Run tests
           # ...
         - name: Build
           # ...
   ```

2. **Deployment**:
   ```yaml
   name: CD

   on:
     push:
       branches: [ main ]
       
   jobs:
     deploy:
       runs-on: ubuntu-latest
       needs: build-and-test
       steps:
         - uses: actions/checkout@v3
         - name: Set up Docker Buildx
           # ...
         - name: Login to Container Registry
           # ...
         - name: Build and push Docker image
           # ...
         - name: Update Kubernetes deployment
           # ...
   ```

## Teste în CI/CD

### Tipuri de teste care ar trebui să ruleze în pipeline

1. **Teste unitare**: Testează funcționalitatea unei unități individuale de cod
2. **Teste de integrare**: Testează interacțiunea între diferite componente
3. **Teste de sistem**: Testează întregul sistem ca un întreg
4. **Teste de performanță**: Verifică performanța aplicației

### Recomandări pentru teste

1. Fiecare PR trebuie să includă teste pentru noua funcționalitate
2. Testele ar trebui să ruleze automat la fiecare commit
3. Code coverage ar trebui să fie monitorizat și menținut la un nivel acceptabil (>80%)
4. Testele ar trebui să ruleze izolat, fără a depinde de starea anterioară sau de conexiuni externe

## Managementul secretelor

1. Nu stocați niciodată secrete în codul sursă
2. Utilizați GitHub Secrets pentru stocarea credențialelor
3. Pentru secretele de mediu, folosiți Environment Secrets
4. Rotiți secretele periodic
5. Folosiți script-ul `setup-github-secrets.sh` pentru a configura secretele în mod automat

## Construirea imaginilor Docker

1. Folosiți multi-stage builds pentru a reduce dimensiunea imaginilor
2. Includeți doar fișierele necesare în imagine
3. Nu stocați secrete în imagini
4. Versiunați imaginile cu tag-uri specifice (nu folosiți `latest`)
5. Scanați imaginile pentru vulnerabilități

## Deployment în Kubernetes

1. Folosiți strategia de deployment "Rolling Update" pentru a evita downtime
2. Configurați readiness și liveness probes pentru a asigura că aplicația funcționează corect
3. Setați limitele de resurse pentru a preveni consumul excesiv de resurse
4. Folosiți namespace-uri separate pentru medii diferite
5. Implementați rollback automat în caz de eșec

## Monitorizare

1. Monitorizați performanța aplicației
2. Configurați alerte pentru probleme critice
3. Colectați și analizați log-urile
4. Implementați tracing distribuit pentru a urmări cererile prin toate microserviciile

## Promovarea codului între medii

1. Codul ar trebui să treacă prin toate mediile (dev → test → staging → prod)
2. Promovarea între medii ar trebui să fie automată sau semi-automată
3. Același artifact (imagine Docker) ar trebui să fie promovat între medii, fără reconstruire
4. Configurația specifică mediului ar trebui să fie separată de cod

## Recuperare în caz de dezastru

1. Backup-uri regulate ale datelor
2. Planuri de recuperare testate periodic
3. Documentație clară a procedurilor de recuperare

## Automatizarea infrastructurii (IaC)

1. Toată infrastructura ar trebui să fie definită ca și cod (Terraform)
2. Schimbările de infrastructură ar trebui să treacă prin același proces de PR ca și codul
3. Starea Terraform ar trebui stocată într-un backend remote securizat
4. Folosiți module Terraform pentru a reutiliza configurații comune

---

Acest ghid ar trebui revizuit și actualizat periodic, pe măsură ce practicile evoluează și procesele se îmbunătățesc.