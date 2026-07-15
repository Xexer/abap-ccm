CLASS zcl_bc_ccm_remote_objects DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    "! Read Level A objects from remote system
    "! @parameter provider_id | Provider ID
    "! @parameter result      | Number of entries
    METHODS get_level_a_objects_for_prov
      IMPORTING provider_id   TYPE sca_ds_object_provider_id
      RETURNING VALUE(result) TYPE i.

    "! Read Key User App objects from remote system
    "! @parameter provider_id | Provider ID
    "! @parameter result      | Number of entries
    METHODS get_key_user_objects_for_prov
      IMPORTING provider_id   TYPE sca_ds_object_provider_id
      RETURNING VALUE(result) TYPE i.

  PRIVATE SECTION.
    CONSTANTS:
      BEGIN OF language_version,
        abap_cloud TYPE zcl_bc_ccm_ac_objects=>char1 VALUE '5',
        key_user   TYPE zcl_bc_ccm_ac_objects=>char1 VALUE '2',
      END OF language_version.

    "! Create destination for customized provider
    "! @parameter provider_id                | Provider ID
    "! @parameter result                     | Destination
    "! @raising   cx_rfc_dest_provider_error | No configuration found
    METHODS get_destination_for_provider
      IMPORTING provider_id   TYPE sca_ds_object_provider_id
      RETURNING VALUE(result) TYPE REF TO if_rfc_dest
      RAISING   cx_rfc_dest_provider_error.

    "! Read remote objects for language version
    "! @parameter provider_id      | Provider ID for destination
    "! @parameter language_version | Language version
    "! @parameter result           | Number of objects
    METHODS call_remote_function
      IMPORTING provider_id      TYPE sca_ds_object_provider_id
                language_version TYPE zcl_bc_ccm_ac_objects=>char1
      RETURNING VALUE(result)    TYPE i.
ENDCLASS.


CLASS zcl_bc_ccm_remote_objects IMPLEMENTATION.
  METHOD get_level_a_objects_for_prov.
    RETURN call_remote_function( provider_id      = provider_id
                                 language_version = language_version-abap_cloud ).
  ENDMETHOD.


  METHOD get_key_user_objects_for_prov.
    RETURN call_remote_function( provider_id      = provider_id
                                 language_version = language_version-key_user ).
  ENDMETHOD.


  METHOD get_destination_for_provider.
    DATA(query) = VALUE if_com_arrangement_factory=>ty_query(
        cscn_id_range = VALUE #( ( sign = 'I' option = 'EQ' low = 'ZBC_CCM_REMOTE_OBJECTS' ) )
        ca_property   = VALUE #( ( name = 'PROVIDER_ID' values = VALUE #( ( provider_id ) ) ) ) ).

    DATA(arrangement) = cl_com_arrangement_factory=>create_instance( ).
    arrangement->query_ca( EXPORTING is_query           = query
                           IMPORTING et_com_arrangement = DATA(systems) ).

    TRY.
        DATA(system) = systems[ 1 ].
      CATCH cx_sy_itab_line_not_found.
        RAISE EXCEPTION NEW cx_rfc_dest_provider_error( ).
    ENDTRY.

    result = cl_rfc_destination_provider=>create_by_comm_arrangement( comm_scenario  = 'ZBC_CCM_REMOTE_OBJECTS'
                                                                      comm_system_id = system->get_comm_system_id( ) ).
  ENDMETHOD.


  METHOD call_remote_function.
    TRY.
        DATA(destination) = get_destination_for_provider( provider_id ).
      CATCH cx_rfc_dest_provider_error.
        RETURN 0.
    ENDTRY.

    TRY.
        DATA(service) = NEW zcl_bc_ccm_ac_objects( destination ).
        service->z_ca_atc_level_a_objects( EXPORTING language_version = language_version
                                           IMPORTING objects          = result ).

      CATCH cx_rfc_dest_provider_error cx_aco_application_exception
            cx_aco_communication_failure cx_aco_system_failure.
        RETURN 0.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
