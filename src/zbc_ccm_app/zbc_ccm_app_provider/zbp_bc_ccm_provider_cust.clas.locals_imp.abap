CLASS lhc_providercustall DEFINITION INHERITING FROM cl_abap_behavior_handler FINAL.
  PUBLIC SECTION.
    CONSTANTS co_entity               TYPE abp_entity_name                        VALUE `ZBC_R_CCMPROVIDERCUSTS`.
    CONSTANTS co_transport_object     TYPE mbc_cp_api=>indiv_transaction_obj_name VALUE `ZBC_CCM_PROVIDER_CUST`.
    CONSTANTS co_authorization_entity TYPE abp_entity_name                        VALUE `ZBC_I_CCMPROVIDERCUST`.

  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES
              IMPORTING
                keys REQUEST requested_features FOR ProviderCustAll
              RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
              IMPORTING
                 REQUEST requested_authorizations FOR ProviderCustAll
              RESULT result.
    METHODS SyncAllProviders FOR MODIFY
      IMPORTING keys FOR ACTION ProviderCustAll~SyncAllProviders.
ENDCLASS.


CLASS lhc_providercustall IMPLEMENTATION.
  METHOD get_instance_features.
    mbc_cp_api=>rap_bc_api( )->get_instance_features( transport_object   = co_transport_object
                                                      entity             = co_entity
                                                      keys               = REF #( keys )
                                                      requested_features = REF #( requested_features )
                                                      result             = REF #( result )
                                                      failed             = REF #( failed )
                                                      reported           = REF #( reported ) ).
  ENDMETHOD.


  METHOD get_global_authorizations.
    mbc_cp_api=>rap_bc_api( )->get_global_authorizations( entity                   = co_authorization_entity
                                                          requested_authorizations = REF #( requested_authorizations )
                                                          result                   = REF #( result )
                                                          reported                 = REF #( reported ) ).
  ENDMETHOD.


  METHOD SyncAllProviders.
    DATA new_provider TYPE TABLE FOR CREATE ZBC_R_CCMProviderCustS\_ProviderCust.

    DATA(key) = keys[ 1 ].
    DATA(cust) = NEW zcl_bc_ccm_provider_func( ).
    DATA(system_poviders) = cust->get_all_object_providers( ).

    SELECT FROM ZBC_I_CCMProviderCust
      FIELDS *
      INTO TABLE @DATA(custom_providers).

    LOOP AT system_poviders INTO DATA(system_provider).
      IF line_exists( custom_providers[ ProviderId = system_provider-provider_id ] ).
        CONTINUE.
      ENDIF.

      INSERT VALUE #( %cid_ref    = key-%cid_ref
                      %is_draft   = key-%is_draft
                      SingletonID = key-SingletonID
                      %target     = VALUE #( ( %cid                = xco_cp=>uuid( )->value
                                               providerid          = system_provider-provider_id
                                               groupid             = system_provider-group_id
                                               active              = abap_true
                                               %control-providerid = if_abap_behv=>mk-on
                                               %control-groupid    = if_abap_behv=>mk-on
                                               %control-active     = if_abap_behv=>mk-on ) ) )
             INTO TABLE new_provider.
    ENDLOOP.

    MODIFY ENTITIES OF ZBC_R_CCMProviderCustS IN LOCAL MODE
           ENTITY ProviderCustAll
           CREATE BY \_ProviderCust FROM new_provider.

    INSERT new_message( id       = 'ZBC_CCM'
                        number   = '001'
                        severity = if_abap_behv_message=>severity-success ) INTO TABLE reported-%other.
  ENDMETHOD.
ENDCLASS.


CLASS lsc_providercustall DEFINITION INHERITING FROM cl_abap_behavior_saver FINAL.
  PROTECTED SECTION.
    METHODS
      save_modified REDEFINITION.
ENDCLASS.


CLASS lsc_providercustall IMPLEMENTATION.
  METHOD save_modified ##NEEDED.
  ENDMETHOD.
ENDCLASS.


CLASS lhc_providercust DEFINITION INHERITING FROM cl_abap_behavior_handler FINAL.
  PUBLIC SECTION.
    CONSTANTS co_entity TYPE abp_entity_name VALUE `ZBC_I_CCMPROVIDERCUST`.

  PRIVATE SECTION.
    METHODS get_global_features FOR GLOBAL FEATURES
              IMPORTING
                REQUEST requested_features FOR ProviderCust
              RESULT result.
ENDCLASS.


CLASS lhc_providercust IMPLEMENTATION.
  METHOD get_global_features.
    mbc_cp_api=>rap_bc_api( )->get_global_features( transport_object   = lhc_ProviderCustAll=>co_transport_object
                                                    entity             = co_entity
                                                    requested_features = REF #( requested_features )
                                                    result             = REF #( result )
                                                    reported           = REF #( reported ) ).
  ENDMETHOD.
ENDCLASS.
