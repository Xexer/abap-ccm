CLASS zcl_bc_ccm_step_role DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_bc_ccm_setup_step.
ENDCLASS.


CLASS zcl_bc_ccm_step_role IMPLEMENTATION.
  METHOD zif_bc_ccm_setup_step~check.
    result = VALUE #(
        status  = zif_bc_ccm_setup_step=>status-ok
        message = ''
        log     = zcl_bc_ccm_mini_log_factory=>create_log( zif_bc_ccm_mini_log=>sub_objects-step_execute ) ).
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~execute.
    result-log = zcl_bc_ccm_mini_log_factory=>create_log( zif_bc_ccm_mini_log=>sub_objects-step_execute ).


  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~get_description.
    RETURN TEXT-001.
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~get_navigation.
    RETURN VALUE #( object = `BusinessUserRole`
                    action = `maintainNew` ).
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~get_step_id.
    RETURN CONV #( zif_bc_ccm_setup_step=>step-role ).
  ENDMETHOD.
ENDCLASS.
