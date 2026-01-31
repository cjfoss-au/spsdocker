Quick GHCR build & publish

This repo builds the `shairport-sync` Docker image via GitHub Actions and publishes it to GHCR (GitHub Container Registry).

Steps to publish:

1. Create a GitHub repository (via UI or `gh repo create`).
2. Push this project to GitHub and ensure your default branch is `main`.

Local git commands (run from repository root):

```bash
git init
git add .
git commit -m "Add Dockerfile and GHCR workflow"
git branch -M main
git remote add origin https://github.com/<YOUR_USER_OR_ORG>/<REPO_NAME>.git
git push -u origin main
```

What happens next

- On each push to `main`, GitHub Actions will run `.github/workflows/build-ghcr.yml`, build the image, and push to `ghcr.io/<YOUR_USER_OR_ORG>/shairport-sync:latest`.

Pulling the image on the Ubuntu target

- If the package is public:

```bash
docker pull ghcr.io/<YOUR_USER_OR_ORG>/shairport-sync:latest
```

- If the package is private, authenticate first (use a personal access token with `write:packages`/`read:packages` as needed):

```bash
echo $CR_PAT | docker login ghcr.io -u <YOUR_GITHUB_USERNAME> --password-stdin
docker pull ghcr.io/<YOUR_USER_OR_ORG>/shairport-sync:latest
```

Want me to run the local `git` commands and push (I will ask for the remote URL)?
