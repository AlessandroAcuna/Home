# Deploy del sito su Kubernetes usando l'immagine GHCR

1) Build e push automatico
- La GitHub Action `.github/workflows/docker-publish.yml` builda e pusha l'immagine su `ghcr.io/<OWNER>/home:latest` quando fai push su `main`.

2) Aggiornare i manifest
- Modifica `k8s/deployment.yaml` e sostituisci `OWNER` con il tuo GitHub username (o l'organization) se l'immagine è privata.

3) Secrets per cluster privato
- Se l'immagine è privata, crea un secret per il pull:
  kubectl create secret docker-registry ghcr-secret --docker-server=ghcr.io --docker-username=<USERNAME> --docker-password=<PERSONAL_ACCESS_TOKEN> --docker-email=<EMAIL>
- Poi aggiungi nello `spec.template.spec` del deployment:
  imagePullSecrets:
  - name: ghcr-secret

4) Deploy sul cluster
- Assicurati di essere connesso al cluster (kubectl config use-context ...)
- Applica i manifest:
  kubectl apply -f k8s/deployment.yaml
  kubectl apply -f k8s/service.yaml

5) Nota su permissions GHCR
- Se usi `GITHUB_TOKEN` per pushare pacchetti, assicurati di abilitare il `permissions: packages: write` nelle settings del workflow e che il repository abbia Packages abilitati.

Se il push fallisce
- Usa un Personal Access Token (PAT) con scope `write:packages` come secret `GHCR_PAT` e modifica lo step di login nella action per usare `password: ${{ secrets.GHCR_PAT }}` al posto di `GITHUB_TOKEN`.

I permessi del workflow
- Lo YAML di esempio include:
  permissions:
    contents: read
    packages: write
    id-token: write

Questo è sufficiente per pushare immagini private su GHCR se il repository appartiene all'utente. Per organizzazioni, potresti dover configurare permessi aggiuntivi.

