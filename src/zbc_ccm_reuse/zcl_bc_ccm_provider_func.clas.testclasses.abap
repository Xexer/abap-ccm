CLASS ltc_provider DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    METHODS read_providers_local FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltc_provider IMPLEMENTATION.
  METHOD read_providers_local.
    DATA(cut) = NEW zcl_bc_ccm_provider_func( ).

    DATA(result) = cut->get_all_object_providers( ).

    cl_abap_unit_assert=>assert_not_initial( result ).
  ENDMETHOD.
ENDCLASS.
