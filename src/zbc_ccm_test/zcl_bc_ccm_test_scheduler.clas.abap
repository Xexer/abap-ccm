CLASS zcl_bc_ccm_test_scheduler DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_bc_ccm_test_scheduler IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA(scheduler) = zcl_bc_ccm_scheduler_factory=>create_scheduler( ).
    scheduler->process_all_active_providers( ).

    COMMIT ENTITIES.
  ENDMETHOD.
ENDCLASS.
