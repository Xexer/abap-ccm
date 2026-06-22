CLASS ltc_runner DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    METHODS run_all_entries FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltc_runner IMPLEMENTATION.
  METHOD run_all_entries.
    DATA(cut) = zcl_bc_ccm_scheduler_factory=>create_scheduler( ).

    cut->process_all_active_providers( ).

    cl_abap_unit_assert=>fail( 'Implement your first test here' ).
  ENDMETHOD.
ENDCLASS.
