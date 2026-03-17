# LDaCA Binder

This repository is the Binder wrapper for the LDaCA web application. The application source now lives in the `ldaca_web_app` submodule; the root repository keeps only the files needed to build and launch the Binder environment.

## Repository layout

- `binder/` contains the repo2docker environment and post-build setup.
- `ldaca_web_app/` is the application submodule that provides the backend, frontend, and desktop code.
- `ldaca_web_app_launch.ipynb` is the Binder notebook entry point for starting the app inside Jupyter.

## Binder launch

- [![Binder](https://mybinder.org/badge_logo.svg)](https://binderhub.rc.nectar.org.au/v2/gh/Australian-Text-Analytics-Platform/ldaca_web_app_binder/main?labpath=ldaca_web_app_launch.ipynb)

## Local maintenance

- Initialize nested submodules with `git submodule update --init --recursive` before syncing the local environment.
- Sync the Binder wrapper environment with `uv sync`.
- Update the application code in `ldaca_web_app/`, not from the repository root.
- Keep root-level documentation and automation Binder-specific; application docs live in the submodule.
