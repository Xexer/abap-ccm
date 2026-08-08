CLASS zcl_bc_ccm_setup_step_factory DEFINITION
  PUBLIC ABSTRACT FINAL
  CREATE PUBLIC
  GLOBAL FRIENDS zcl_bc_ccm_setup_step_injector.

  PUBLIC SECTION.
    CLASS-METHODS create_step
      IMPORTING step_id       TYPE zif_bc_ccm_setup_step=>steps
      RETURNING VALUE(result) TYPE REF TO zif_bc_ccm_setup_step.

  PRIVATE SECTION.
    CLASS-DATA double_step TYPE REF TO zif_bc_ccm_setup_step.
ENDCLASS.


CLASS zcl_bc_ccm_setup_step_factory IMPLEMENTATION.
  METHOD create_step.
    IF double_step IS BOUND.
      RETURN double_step.
    ELSE.
      RETURN SWITCH #( step_id
                       WHEN zif_bc_ccm_setup_step=>step-setting         THEN NEW zcl_bc_ccm_step_setting( )
                       WHEN zif_bc_ccm_setup_step=>step-provider_config THEN NEW zcl_bc_ccm_step_provider( )
                       WHEN zif_bc_ccm_setup_step=>step-comm_arrangement THEN NEW zcl_bc_ccm_step_comm_arr( ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
