resource "azurerm_resource_group" "res-0" {
  location = "eastus2"
  name     = "rg-HoyaHacks-Team41-use2"
}
resource "azurerm_cognitive_account" "res-1" {
  custom_subdomain_name = "llama-query"
  kind                  = "OpenAI"
  location              = "northcentralus"
  name                  = "llama-query"
  resource_group_name   = "rg-HoyaHacks-Team41-use2"
  sku_name              = "S0"
  tags = {
    Env = "Dev"
  }
  network_acls {
    default_action = "Allow"
  }
}
resource "azurerm_cognitive_deployment" "res-2" {
  cognitive_account_id = "/subscriptions/be5797da-b65d-454f-ae56-6be94c168ce0/resourceGroups/rg-HoyaHacks-Team41-use2/providers/Microsoft.CognitiveServices/accounts/llama-query"
  name                 = "embedding"
  rai_policy_name      = "Microsoft.Default"
  model {
    format  = "OpenAI"
    name    = "text-embedding-ada-002"
    version = "2"
  }
  scale {
    capacity = 120
    type     = "Standard"
  }
  depends_on = [
    azurerm_cognitive_account.res-1,
  ]
}
resource "azurerm_cognitive_deployment" "res-3" {
  cognitive_account_id = "/subscriptions/be5797da-b65d-454f-ae56-6be94c168ce0/resourceGroups/rg-HoyaHacks-Team41-use2/providers/Microsoft.CognitiveServices/accounts/llama-query"
  name                 = "test"
  rai_policy_name      = "Microsoft.Default"
  model {
    format  = "OpenAI"
    name    = "gpt-35-turbo"
    version = "0613"
  }
  scale {
    capacity = 40
    type     = "Standard"
  }
  depends_on = [
    azurerm_cognitive_account.res-1,
  ]
}
resource "azurerm_kubernetes_cluster" "res-4" {
  automatic_channel_upgrade        = "patch"
  dns_prefix                       = "hoyastest-dns"
  http_application_routing_enabled = true
  location                         = "eastus"
  name                             = "hoyastest"
  resource_group_name              = "rg-HoyaHacks-Team41-use2"
  default_node_pool {
    enable_auto_scaling = true
    max_count           = 5
    min_count           = 2
    name                = "agentpool"
    os_disk_type        = "Ephemeral"
    vm_size             = "Standard_D4ds_v5"
  }
  identity {
    type = "SystemAssigned"
  }
}
resource "azurerm_kubernetes_cluster_node_pool" "res-5" {
  enable_auto_scaling   = true
  kubernetes_cluster_id = "/subscriptions/be5797da-b65d-454f-ae56-6be94c168ce0/resourceGroups/rg-HoyaHacks-Team41-use2/providers/Microsoft.ContainerService/managedClusters/hoyastest"
  max_count             = 5
  min_count             = 2
  mode                  = "System"
  name                  = "agentpool"
  os_disk_type          = "Ephemeral"
  vm_size               = "Standard_D4ds_v5"
  depends_on = [
    azurerm_kubernetes_cluster.res-4,
  ]
}
