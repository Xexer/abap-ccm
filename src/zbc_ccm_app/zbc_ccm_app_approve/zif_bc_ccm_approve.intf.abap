INTERFACE zif_bc_ccm_approve
  PUBLIC.

  "! Start main process for approval
  "! @parameter result | Result messages
  METHODS main
    RETURNING VALUE(result) TYPE REF TO zif_bc_ccm_mini_log.
ENDINTERFACE.
