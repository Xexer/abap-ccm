CLASS zcl_bc_ccm_step_cluster DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_bc_ccm_setup_step.
ENDCLASS.


CLASS zcl_bc_ccm_step_cluster IMPLEMENTATION.
  METHOD zif_bc_ccm_setup_step~check.
    result = VALUE #(
        status  = zif_bc_ccm_setup_step=>status-ok
        message = ''
        log     = zcl_bc_ccm_mini_log_factory=>create_log( zif_bc_ccm_mini_log=>sub_objects-step_execute ) ).

    SELECT FROM ZBC_R_CCMCluster
      FIELDS COUNT( * )
      INTO @DATA(number_of_cluster).
    IF number_of_cluster = 0.
      result-status  = zif_bc_ccm_setup_step=>status-intial.
      result-message = TEXT-002.
      RETURN.
    ENDIF.

    SELECT FROM ZBC_I_CCMNotAssignedPackages
      FIELDS COUNT( * )
      WHERE IsAssigned = @abap_false
      INTO @DATA(number_of_open_packages).
    IF number_of_open_packages > 0.
      result-status  = zif_bc_ccm_setup_step=>status-changes.
      result-message = TEXT-003.
      RETURN.
    ENDIF.
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~execute.
    result-log = zcl_bc_ccm_mini_log_factory=>create_log( zif_bc_ccm_mini_log=>sub_objects-step_execute ).
    MESSAGE s029(zbc_ccm) INTO result-log->message.
    result-log->add_message( ).
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~get_description.
    RETURN TEXT-001.
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~get_navigation.
    RETURN VALUE #( object = `ZBC_CCM_CLUSTER`
                    action = `manage` ).
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~get_step_id.
    RETURN CONV #( zif_bc_ccm_setup_step=>step-cluster ).
  ENDMETHOD.
ENDCLASS.
