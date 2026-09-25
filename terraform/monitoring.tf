# =========================================================
# Monitoring infrastructure (Task 10.2D)
# =========================================================
#
# This file provisions the Azure-side infrastructure that supports
# monitoring, separate from the in-cluster Prometheus/Grafana stack
# (which is deployed via Helm in the pipeline, not Terraform - see
# .github/workflows/05-deploy-monitoring.yml).
#
# - Log Analytics Workspace: collects AKS control-plane logs and,
#   via Container Insights, node/pod resource metrics.
# - Diagnostic Setting: routes the AKS cluster's category groups
#   (audit + all logs) into that workspace.
# - oms_agent add-on (see kubernetes_serivce.tf) enables Container
#   Insights on the cluster itself.

resource "azurerm_log_analytics_workspace" "monitoring" {
  name                = "${var.aks_cluster_name}-law"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku               = "PerGB2018"
  retention_in_days = 30

  tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}

resource "azurerm_monitor_diagnostic_setting" "aks_diagnostics" {
  name                       = "${var.aks_cluster_name}-diagnostics"
  target_resource_id         = azurerm_kubernetes_cluster.aks.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.monitoring.id

  enabled_log {
    category_group = "audit"
  }

  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
