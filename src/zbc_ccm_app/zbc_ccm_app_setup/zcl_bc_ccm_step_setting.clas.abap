CLASS zcl_bc_ccm_step_setting DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_bc_ccm_setup_step.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF config_id,
        key     TYPE zif_bc_ccm_config=>key,
        default TYPE zif_bc_ccm_config=>value,
      END OF config_id.
    TYPES config_ids TYPE STANDARD TABLE OF config_id WITH EMPTY KEY.
    TYPES settings   TYPE STANDARD TABLE OF ZBC_I_CCMSettings WITH EMPTY KEY.

    METHODS get_config_ids
      RETURNING VALUE(result) TYPE config_ids.

    METHODS get_all_settings
      RETURNING VALUE(result) TYPE settings.
ENDCLASS.


CLASS zcl_bc_ccm_step_setting IMPLEMENTATION.
  METHOD zif_bc_ccm_setup_step~check.
    result = VALUE #(
        status  = zif_bc_ccm_setup_step=>status-ok
        message = ''
        log     = zcl_bc_ccm_mini_log_factory=>create_log( zif_bc_ccm_mini_log=>sub_objects-step_execute ) ).

    DATA(all_settings) = get_all_settings( ).
    DATA(default_settings) = get_config_ids( ).

    IF all_settings IS INITIAL.
      result-message = TEXT-002.
      result-status  = zif_bc_ccm_setup_step=>status-intial.
    ENDIF.

    IF all_settings IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT default_settings INTO DATA(default_setting).
      IF line_exists( all_settings[ SettingKey = default_setting-key ] ).
        CONTINUE.
      ENDIF.

      MESSAGE e022(zbc_ccm) WITH default_setting-key INTO result-log->message.
      result-log->add_message( ).

      result-message = TEXT-003.
      result-status  = zif_bc_ccm_setup_step=>status-changes.
    ENDLOOP.
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~execute.
    DATA new_settings TYPE TABLE FOR CREATE ZBC_R_CCMSettingsS\_Settings.

    result-log = zcl_bc_ccm_mini_log_factory=>create_log( zif_bc_ccm_mini_log=>sub_objects-step_execute ).

    DATA(default_configs) = get_config_ids( ).
    DATA(system_configs) = get_all_settings( ).

    LOOP AT default_configs INTO DATA(default_config).
      IF line_exists( system_configs[ SettingKey = default_config-key ] ).
        CONTINUE.
      ENDIF.

      INSERT VALUE #( %cid_ref    = cid_ref
                      %is_draft   = if_abap_behv=>mk-off
                      SingletonID = 1
                      %target     = VALUE #( ( %cid                  = xco_cp=>uuid( )->value
                                               SettingKey            = default_config-key
                                               SettingValue          = default_config-default
                                               %control-SettingKey   = if_abap_behv=>mk-on
                                               %control-SettingValue = if_abap_behv=>mk-on ) ) )
             INTO TABLE new_settings.
    ENDLOOP.

    MODIFY ENTITIES OF ZBC_R_CCMSettingsS
           ENTITY SettingsAll
           CREATE BY \_Settings FROM new_settings.

    MESSAGE s023(zbc_ccm) INTO result-log->message.
    result-log->add_message( ).
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~get_description.
    RETURN TEXT-001.
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~get_navigation.
    RETURN VALUE #( object = `BusinessConfiguration`
                    action = `maintain` ).
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~get_step_id.
    RETURN CONV #( zif_bc_ccm_setup_step=>step-setting ).
  ENDMETHOD.


  METHOD get_config_ids.
    RETURN VALUE #( ( key = zif_bc_ccm_config=>config_option-mail_sender default = '' )
                    ( key = zif_bc_ccm_config=>config_option-mail_receiver default = '' )
                    ( key = zif_bc_ccm_config=>config_option-default_score_b default = '1' )
                    ( key = zif_bc_ccm_config=>config_option-default_score_c default = '5' )
                    ( key = zif_bc_ccm_config=>config_option-default_score_d default = '10' )
                    ( key = zif_bc_ccm_config=>config_option-default_atc_variant default = 'ABAP_CLEAN_CORE_READINESS' )
                    ( key = zif_bc_ccm_config=>config_option-include_level_c_findings default = abap_true )
                    ( key = zif_bc_ccm_config=>config_option-period_unit default = zif_bc_ccm_config=>periods-month )
                    ( key = zif_bc_ccm_config=>config_option-test_mode default = abap_false ) ).
  ENDMETHOD.


  METHOD get_all_settings.
    SELECT FROM ZBC_I_CCMSettings
      FIELDS *
      INTO TABLE @result
      PRIVILEGED ACCESS.
  ENDMETHOD.
ENDCLASS.
