# Patch management configuration
resource \"aws_ssm_patch_baseline\" \"default\" {
  name     = \"default-patch-baseline\"
  operating_system = \"Windows\"
  description = \"Default patch baseline for Windows\"
  approval_rules {
    patch_filter_group {
      patch_filters {
        key    = \"PRODUCT\"
        values = [\"WindowsServer2016\", \"WindowsServer2019\"]
      }
      patch_filters {
        key    = \"CLASSIFICATION\"
        values = [\"CriticalUpdates\", \"SecurityUpdates\"]
      }
    }
    approve_after_days = 7
    compliance_level   = \"CRITICAL\"
  }
}
