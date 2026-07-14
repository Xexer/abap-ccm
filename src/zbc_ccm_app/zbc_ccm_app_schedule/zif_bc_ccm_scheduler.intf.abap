INTERFACE zif_bc_ccm_scheduler
  PUBLIC.

  "! Process all active Object Providers
  "! @parameter log | Mini Log
  METHODS process_all_active_providers
    IMPORTING !log TYPE REF TO zif_bc_ccm_mini_log.
ENDINTERFACE.
