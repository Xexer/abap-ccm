CLASS zcl_bc_ccm_step_atc_messages DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_bc_ccm_setup_step.

  PRIVATE SECTION.
    CONSTANTS atc_clean_core_variant TYPE string VALUE 'ABAP_CLEAN_CORE_READINESS'.

    TYPES checks   TYPE STANDARD TABLE OF zbc_ccm_atcchk WITH EMPTY KEY.
    TYPES messages TYPE STANDARD TABLE OF ZBC_I_CCMATCMessage WITH EMPTY KEY.

    "! Read all configured messages from the system
    "! @parameter result | Message Configuration
    METHODS get_all_messages
      RETURNING VALUE(result) TYPE messages.

    "! Read all configured checks from the system
    "! @parameter result | ATC Checks
    METHODS get_all_checks
      RETURNING VALUE(result) TYPE checks.

    "! Read all configured ATC Messages from the system
    "! @parameter result | All messages
    METHODS get_system_messages
      RETURNING VALUE(result) TYPE zcl_bc_ccm_atc_check=>messages.

    "! Read all configured ATC Checks from the system
    "! @parameter result | All Checks
    METHODS get_system_checks
      RETURNING VALUE(result) TYPE zcl_bc_ccm_atc_check=>checks.

    "! Update the messages via EML
    "! @parameter cid_ref | CID Reference
    "! @parameter log     | Logging Object
    METHODS update_messages
      IMPORTING cid_ref TYPE abp_behv_cid
                !log    TYPE REF TO zif_bc_ccm_mini_log.

    "! Update checks via insert
    "! @parameter log | Logging Object
    METHODS update_checks
      IMPORTING !log TYPE REF TO zif_bc_ccm_mini_log.
ENDCLASS.


CLASS zcl_bc_ccm_step_atc_messages IMPLEMENTATION.
  METHOD zif_bc_ccm_setup_step~check.
    result = VALUE #(
        status  = zif_bc_ccm_setup_step=>status-ok
        message = ''
        log     = zcl_bc_ccm_mini_log_factory=>create_log( zif_bc_ccm_mini_log=>sub_objects-step_execute ) ).
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~execute.
    result-log = zcl_bc_ccm_mini_log_factory=>create_log( zif_bc_ccm_mini_log=>sub_objects-step_execute ).

    update_messages( cid_ref = cid_ref
                     log     = result-log ).
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~execute_save.
    result = zcl_bc_ccm_mini_log_factory=>create_log( zif_bc_ccm_mini_log=>sub_objects-step_execute ).
    update_checks( result ).
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~get_description.
    RETURN TEXT-001.
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~get_navigation.
    RETURN VALUE #( object = `BusinessConfiguration`
                    action = `maintain` ).
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~get_step_id.
    RETURN CONV #( zif_bc_ccm_setup_step=>step-atc_messages ).
  ENDMETHOD.


  METHOD get_all_messages.
    SELECT FROM ZBC_I_CCMATCMessage
      FIELDS *
      INTO TABLE @result
      PRIVILEGED ACCESS.
  ENDMETHOD.


  METHOD get_system_messages.
    FINAL(config) = zcl_bc_ccm_config_factory=>create_config( ).
    DATA(variant_name) = config->get_value( config->config_option-default_atc_variant ).

    " Overwrite ATM
    variant_name = atc_clean_core_variant.

    RETURN NEW zcl_bc_ccm_atc_check( CONV #( variant_name ) )->get_variant_messages( ).
  ENDMETHOD.


  METHOD get_all_checks.
    SELECT FROM zbc_ccm_atcchk
      FIELDS *
      INTO TABLE @result
      PRIVILEGED ACCESS.
  ENDMETHOD.


  METHOD get_system_checks.
    FINAL(config) = zcl_bc_ccm_config_factory=>create_config( ).
    DATA(variant_name) = config->get_value( config->config_option-default_atc_variant ).

    " Overwrite ATM
    variant_name = atc_clean_core_variant.

    RETURN NEW zcl_bc_ccm_atc_check( CONV #( variant_name ) )->get_variant_checks( ).
  ENDMETHOD.


  METHOD update_checks.
    " TODO: parameter LOG is never used (ABAP cleaner)

    DATA new_checks TYPE checks.

    DATA(system_checks) = get_system_checks( ).
    DATA(custom_checks) = get_all_checks( ).

    LOOP AT system_checks INTO DATA(system_check).
      IF line_exists( custom_checks[ check_name = system_check-technical_name ] ).
        CONTINUE.
      ENDIF.

      INSERT VALUE #( check_name = system_check-technical_name
                      check_text = system_check-description )
             INTO TABLE new_checks.
    ENDLOOP.

    INSERT zbc_ccm_atcchk FROM TABLE @new_checks.
  ENDMETHOD.


  METHOD update_messages.
    DATA new_messages TYPE TABLE FOR CREATE ZBC_R_CCMATCMessageS\_ATCMessage.

    DATA(system_messages) = get_system_messages( ).
    DATA(custom_messages) = get_all_messages( ).

    LOOP AT system_messages INTO DATA(system_message).
      IF line_exists( custom_messages[ CheckName   = system_message-check_name
                                       MessageName = system_message-technical_name ] ).
        CONTINUE.
      ENDIF.

      INSERT VALUE #( %cid_ref    = cid_ref
                      %is_draft   = if_abap_behv=>mk-off
                      SingletonID = 1
                      %target     = VALUE #( ( %cid                 = xco_cp=>uuid( )->value
                                               CheckName            = system_message-check_name
                                               MessageName          = system_message-technical_name
                                               MessageText          = system_message-description
                                               %control-CheckName   = if_abap_behv=>mk-on
                                               %control-MessageName = if_abap_behv=>mk-on
                                               %control-MessageText = if_abap_behv=>mk-on ) ) )
             INTO TABLE new_messages.
    ENDLOOP.

    MODIFY ENTITIES OF ZBC_R_CCMATCMessageS
           ENTITY ATCMessageAll
           CREATE BY \_ATCMessage FROM new_messages.

    MESSAGE s035(zbc_ccm) INTO log->message.
    log->add_message( ).
  ENDMETHOD.
ENDCLASS.
