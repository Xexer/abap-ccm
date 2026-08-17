CLASS zcl_bc_ccm_step_role DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_bc_ccm_setup_step.

    TYPES role_name TYPE if_iam_business_role=>ty_id.

    CONSTANTS:
      BEGIN OF default_role_names,
        admin   TYPE role_name VALUE 'ZBC_CCM_ADMIN',
        process TYPE role_name VALUE 'ZBC_CCM_PROCESS',
        viewer  TYPE role_name VALUE 'ZBC_CCM_VIEWER',
      END OF default_role_names.

  PRIVATE SECTION.
    DATA new_roles TYPE zcl_bc_ccm_business_role=>role_settings.

    METHODS test_role_creation
      IMPORTING setting TYPE zcl_bc_ccm_business_role=>role_setting
                !log    TYPE REF TO zif_bc_ccm_mini_log.

    METHODS get_role_name_admin
      RETURNING VALUE(result) TYPE role_name.

    METHODS get_role_name_process
      RETURNING VALUE(result) TYPE role_name.

    METHODS get_role_name_viewer
      RETURNING VALUE(result) TYPE role_name.
ENDCLASS.


CLASS zcl_bc_ccm_step_role IMPLEMENTATION.
  METHOD zif_bc_ccm_setup_step~check.
    DATA role_filters TYPE if_iam_business_role_factory=>tt_id.

    result = VALUE #(
        status  = zif_bc_ccm_setup_step=>status-ok
        message = ''
        log     = zcl_bc_ccm_mini_log_factory=>create_log( zif_bc_ccm_mini_log=>sub_objects-step_execute ) ).

    role_filters = VALUE #( ( get_role_name_admin( ) )
                            ( get_role_name_process( ) )
                            ( get_role_name_viewer( ) ) ).

    FINAL(iam_role) = cl_iam_business_role_factory=>create_instance( ).

    iam_role->get_business_roles_by_id( EXPORTING it_id            = role_filters
                                        IMPORTING et_business_role = DATA(found_roles) ).

    IF found_roles IS INITIAL.
      result-status  = zif_bc_ccm_setup_step=>status-intial.
      result-message = TEXT-002.
      RETURN.
    ENDIF.

    LOOP AT role_filters INTO FINAL(role_name).
      DATA(found) = abap_false.
      LOOP AT found_roles INTO FINAL(found_role).
        IF found_role->get_id( ) = role_name.
          found = abap_true.
        ENDIF.
      ENDLOOP.

      IF found = abap_false.
        result-status  = zif_bc_ccm_setup_step=>status-changes.
        result-message = TEXT-003.

        MESSAGE e034(zbc_ccm) WITH role_name INTO result-log->message.
        result-log->add_message( ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~execute.
    result-log = zcl_bc_ccm_mini_log_factory=>create_log( zif_bc_ccm_mini_log=>sub_objects-step_execute ).

    test_role_creation( setting = VALUE #( role_name        = get_role_name_admin( )
                                           description      = 'CCM: Administrator'
                                           business_catalog = 'ZBC_CCM_ADMIN'
                                           assign_role      = abap_true )
                        log     = result-log ).

    test_role_creation( setting = VALUE #( role_name        = get_role_name_process( )
                                           description      = 'CCM: Process Manager (All)'
                                           business_catalog = 'ZBC_CCM_ADMIN' )
                        log     = result-log ).

    test_role_creation( setting = VALUE #( role_name        = get_role_name_viewer( )
                                           description      = 'CCM: Viewer (All)'
                                           business_catalog = 'ZBC_CCM_ADMIN' )
                        log     = result-log ).
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~execute_save.
    DATA operation TYPE REF TO if_bgmc_op_single_tx_uncontr.

    result = zcl_bc_ccm_mini_log_factory=>create_log( zif_bc_ccm_mini_log=>sub_objects-step_execute ).

    operation = NEW zcl_bc_ccm_setup_background( new_roles ).

    TRY.
        DATA(background_process) = cl_bgmc_process_factory=>get_default( )->create( ).
        background_process->set_name( 'Role Creation' )->set_operation_tx_uncontrolled( operation ).
        background_process->save_for_execution( ).

        MESSAGE s031(zbc_ccm) INTO result->message.
        result->add_message( ).

      CATCH cx_bgmc.
        MESSAGE e030(zbc_ccm) INTO result->message.
        result->add_message( ).
    ENDTRY.
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


  METHOD test_role_creation.
    DATA(role) = NEW zcl_bc_ccm_business_role( setting ).

    IF NOT role->create_role( ).
      log->add_message( ).
    ELSE.
      INSERT role->get_setting( ) INTO TABLE new_roles.
    ENDIF.
  ENDMETHOD.


  METHOD get_role_name_admin.
    FINAL(config) = zcl_bc_ccm_config_factory=>create_config( ).
    result = config->get_value( config->config_option-role_admin ).

    IF result IS INITIAL.
      result = default_role_names-admin.
    ENDIF.
  ENDMETHOD.


  METHOD get_role_name_process.
    FINAL(config) = zcl_bc_ccm_config_factory=>create_config( ).
    result = config->get_value( config->config_option-role_process ).

    IF result IS INITIAL.
      result = default_role_names-process.
    ENDIF.
  ENDMETHOD.


  METHOD get_role_name_viewer.
    FINAL(config) = zcl_bc_ccm_config_factory=>create_config( ).
    result = config->get_value( config->config_option-role_viewer ).

    IF result IS INITIAL.
      result = default_role_names-viewer.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
