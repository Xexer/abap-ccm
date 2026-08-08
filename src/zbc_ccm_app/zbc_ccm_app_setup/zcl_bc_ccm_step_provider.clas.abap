CLASS zcl_bc_ccm_step_provider DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE
  GLOBAL FRIENDS zcl_bc_ccm_setup_step_factory.

  PUBLIC SECTION.
    INTERFACES zif_bc_ccm_setup_step.

  PRIVATE SECTION.
    TYPES providers TYPE STANDARD TABLE OF ZBC_I_CCMProviderCust WITH EMPTY KEY.

    "! Read all configured providers from the system
    "! @parameter result | Provider Configuration
    METHODS get_all_providers
      RETURNING VALUE(result) TYPE providers.
ENDCLASS.


CLASS zcl_bc_ccm_step_provider IMPLEMENTATION.
  METHOD zif_bc_ccm_setup_step~check.
    result = VALUE #(
        status  = zif_bc_ccm_setup_step=>status-ok
        message = ''
        log     = zcl_bc_ccm_mini_log_factory=>create_log( zif_bc_ccm_mini_log=>sub_objects-step_execute ) ).

    DATA(all_providers) = get_all_providers( ).

    IF all_providers IS INITIAL.
      result-message = TEXT-002.
      result-status  = zif_bc_ccm_setup_step=>status-intial.
    ENDIF.

    LOOP AT all_providers INTO DATA(provider) WHERE     Active = abap_true
                                                    AND ( CustomCodeProjectID IS INITIAL OR SystemName IS INITIAL ).
      IF provider-CustomCodeProjectID IS INITIAL.
        MESSAGE e019(zbc_ccm) WITH provider-ProviderId INTO result-log->message.
        result-log->add_message( ).
      ENDIF.

      IF provider-SystemName IS INITIAL.
        MESSAGE e020(zbc_ccm) WITH provider-ProviderId INTO result-log->message.
        result-log->add_message( ).
      ENDIF.
    ENDLOOP.

    IF sy-subrc = 0.
      result-message = TEXT-003.
      result-status  = zif_bc_ccm_setup_step=>status-changes.
    ENDIF.

    IF all_providers IS INITIAL.
      RETURN.
    ENDIF.

    DATA(system_poviders) = NEW zcl_bc_ccm_provider_func( )->get_all_object_providers( ).
    LOOP AT system_poviders INTO DATA(system_provider).
      TRY.
          provider = all_providers[ ProviderId = system_provider-provider_id ].
        CATCH cx_sy_itab_line_not_found.
          MESSAGE e021(zbc_ccm) WITH system_provider-provider_id INTO result-log->message.
          result-log->add_message( ).

          result-message = TEXT-004.
          result-status  = zif_bc_ccm_setup_step=>status-changes.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~execute.
    DATA new_provider TYPE TABLE FOR CREATE ZBC_R_CCMProviderCustS\_ProviderCust.

    result-log = zcl_bc_ccm_mini_log_factory=>create_log( zif_bc_ccm_mini_log=>sub_objects-step_execute ).

    DATA(system_poviders) = NEW zcl_bc_ccm_provider_func( )->get_all_object_providers( ).
    DATA(custom_providers) = get_all_providers( ).

    LOOP AT system_poviders INTO DATA(system_provider).
      IF line_exists( custom_providers[ ProviderId = system_provider-provider_id ] ).
        CONTINUE.
      ENDIF.

      INSERT VALUE #( %cid_ref    = cid_ref
                      %is_draft   = if_abap_behv=>mk-off
                      SingletonID = 1
                      %target     = VALUE #( ( %cid                = xco_cp=>uuid( )->value
                                               providerid          = system_provider-provider_id
                                               groupid             = system_provider-group_id
                                               active              = abap_true
                                               %control-providerid = if_abap_behv=>mk-on
                                               %control-groupid    = if_abap_behv=>mk-on
                                               %control-active     = if_abap_behv=>mk-on ) ) )
             INTO TABLE new_provider.
    ENDLOOP.

    MODIFY ENTITIES OF ZBC_R_CCMProviderCustS
           ENTITY ProviderCustAll
           CREATE BY \_ProviderCust FROM new_provider.

    MESSAGE s001(zbc_ccm) INTO result-log->message.
    result-log->add_message( ).
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~get_description.
    RETURN TEXT-001.
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~get_step_id.
    RETURN CONV #( zif_bc_ccm_setup_step=>step-provider_config ).
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~get_navigation.
    RETURN VALUE #( object = `BusinessConfiguration`
                    action = `maintain` ).
  ENDMETHOD.


  METHOD get_all_providers.
    SELECT FROM ZBC_I_CCMProviderCust
      FIELDS *
      INTO TABLE @result
      PRIVILEGED ACCESS.
  ENDMETHOD.
ENDCLASS.
