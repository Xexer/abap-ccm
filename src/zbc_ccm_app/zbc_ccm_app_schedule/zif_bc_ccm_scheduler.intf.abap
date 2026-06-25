INTERFACE zif_bc_ccm_scheduler
  PUBLIC.

  CONSTANTS atc_variant TYPE satc_api_result_headers-CheckVariant VALUE `ABAP_CLEAN_CORE_READINESS`.

  "! Process all active Object Providers
  METHODS process_all_active_providers.
ENDINTERFACE.
