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
