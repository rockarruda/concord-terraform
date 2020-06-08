X- remove azurerm_key_vault_secret if not required
X- make a directory called aks and put your aks resources in there
X- azurerm_kubernetes_cluster
X  - variable: default node pool name
X  - variable: default node pool count
X  - variable: default node pool vm_size
X  - variable: tags
X- make a directory called vnet and make resources like:
X  - vnet-main.tf
X  - vnet-variables.tf
X  - vnet-outputs
X  - to separate out the network build from the aks build
X- azurerm_virtual_network
X  - variable: name (base name of the network name)
X- azurerm_subnet
X  - variable: name (base name of the network name)
X- azurerm_network_security_group
X  - variable: name (base name of the networkname)
X- use the resource name "main" wherever you can to match what we have
X- separate out the DNS resources as well in their own directory if they can live on their own. we might reuse them
- start researching the AKS specific controllers to install in AKS:
  - https://github.com/kubernetes-sigs/azuredisk-csi-driver
  - other standard add-ons that people generally install into the cluster

- security for administrating a cluster and security for apps using OIDC:
  - https://github.com/dexidp/dex
