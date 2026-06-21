CLASS zcl_bc_ccm_provider_func DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES: BEGIN OF provider,
             provider_id TYPE sca_ds_object_provider_id,
             group_id    TYPE zbc_ccm_group_id,
           END OF provider.
    TYPES providers TYPE SORTED TABLE OF provider WITH UNIQUE KEY provider_id.

    "! Read all local configured object providers for Custom Code Migration App
    "! @parameter result | All Configured Providers
    METHODS get_all_object_providers
      RETURNING VALUE(result) TYPE providers.

  PRIVATE SECTION.
    CONSTANTS custom_code_scenario TYPE string VALUE 'SAP_COM_0464'.
ENDCLASS.


CLASS zcl_bc_ccm_provider_func IMPLEMENTATION.
  METHOD get_all_object_providers.
    DATA(query) = VALUE if_com_arrangement_factory=>ty_query(
        cscn_id_range = VALUE #( ( sign = 'I' option = 'EQ' low = custom_code_scenario ) ) ).

    DATA(arrangement) = cl_com_arrangement_factory=>create_instance( ).
    arrangement->query_ca( EXPORTING is_query           = query
                           IMPORTING et_com_arrangement = DATA(systems) ).

    LOOP AT systems INTO DATA(system).
      DATA(properties) = system->get_properties( ).

      TRY.
          INSERT VALUE #( provider_id = properties[ name = 'OBJECT_PROVIDER' ]-values[ 1 ]
                          group_id    = properties[ name = 'SYSTEM_GROUP' ]-values[ 1 ] )
                 INTO TABLE result.

        CATCH cx_sy_itab_line_not_found.
          CONTINUE.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
