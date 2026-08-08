CLASS zcl_bc_ccm_provider_func DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES: BEGIN OF provider,
             provider_id TYPE sca_ds_object_provider_id,
             group_id    TYPE zbc_ccm_group_id,
             system_id   TYPE string,
           END OF provider.
    TYPES providers TYPE SORTED TABLE OF provider WITH UNIQUE KEY provider_id.

    CONSTANTS custom_code_scenario TYPE string VALUE 'SAP_COM_0464'.

    "! Read all local configured object providers for Custom Code Migration App
    "! @parameter scenario       | Scenario ID
    "! @parameter provider_field | Field to read the provider
    "! @parameter result         | All Configured Providers
    METHODS get_all_object_providers
      IMPORTING scenario       TYPE string DEFAULT custom_code_scenario
                provider_field TYPE string DEFAULT 'OBJECT_PROVIDER'
      RETURNING VALUE(result)  TYPE providers.
ENDCLASS.


CLASS zcl_bc_ccm_provider_func IMPLEMENTATION.
  METHOD get_all_object_providers.
    DATA(query) = VALUE if_com_arrangement_factory=>ty_query(
        cscn_id_range = VALUE #( ( sign = 'I' option = 'EQ' low = scenario ) ) ).

    DATA(arrangement) = cl_com_arrangement_factory=>create_instance( ).
    arrangement->query_ca( EXPORTING is_query           = query
                           IMPORTING et_com_arrangement = DATA(systems) ).

    LOOP AT systems INTO DATA(system).
      DATA(properties) = system->get_properties( ).

      TRY.
          INSERT VALUE #( provider_id = properties[ name = provider_field ]-values[ 1 ]
                          group_id    = VALUE #( properties[ name = 'SYSTEM_GROUP' ]-values[ 1 ] OPTIONAL )
                          system_id   = system->get_comm_system_id( ) )
                 INTO TABLE result.

        CATCH cx_sy_itab_line_not_found.
          CONTINUE.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
