INTERFACE zif_bc_scoring
  PUBLIC.

  TYPES objects  TYPE SORTED TABLE OF zbc_ccm_obj WITH UNIQUE KEY provider_id obj_type obj_name.
  TYPES messages TYPE SORTED TABLE OF zbc_ccm_msg WITH UNIQUE KEY provider_id obj_type obj_name finding_id.

  TYPES: BEGIN OF scoring_result,
           score    TYPE zbc_i_ccmscore,
           objects  TYPE objects,
           messages TYPE messages,
         END OF scoring_result.

  CONSTANTS: BEGIN OF calculation_methods,
               standard  TYPE zbc_ccm_calculate_method VALUE '',
               exemption TYPE zbc_ccm_calculate_method VALUE 'E',
             END OF calculation_methods.

  METHODS calculate_standard
    IMPORTING findings      TYPE zcl_bc_ccm_scheduler=>findings
    RETURNING VALUE(result) TYPE scoring_result.

  METHODS calculate_exemption
    IMPORTING findings      TYPE zcl_bc_ccm_scheduler=>findings
    RETURNING VALUE(result) TYPE scoring_result.

ENDINTERFACE.
