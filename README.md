# Helm

![Build](https://github.com/lab42/Helm/actions/workflows/build.yml/badge.svg?branch=main)

Github docker action with Helm 3 and Kubectl. 

This action is automatically build to have the latest Helm 3 release every month. If you use this and need and update then you can reach out and we can dispatch a build.


## Usage

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    
    strategy:
      matrix:
        helm_packages: 
          - pkg1
          - pkg2
          - pkg3

    steps:
      - name: Helm version
        uses: lab42/Helm
        with:
          helm: version 

      - name: Kubectl version
        uses: lab42/Helm
        with:
          kubectl: version
          kubeconfig: '${{ secrets.KUBECONFIG }}'

      - name: Helm lint multiple
        uses: lab42/Helm
        with:
          helm: lint ${{ matrix.helm_packages }}

      - name: Helm package multiple
        uses: lab42/Helm
        with:
          helm: package ${{ matrix.helm_packages }} --destination build
      
      - name: Helm index
        uses: lab42/Helm
        with:
          helm: repo index build
      
      - name: Helm install with kubeconfig and custom repository
        uses: lab42/Helm
        with:
          helm: install example example
          repository: example https://example.tld/charts
          kubeconfig: '${{ secrets.KUBECONFIG }}'
```