CLASS zcl_bc_ccm_test_scheduler DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_bc_ccm_test_scheduler IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA(log) = zcl_bc_ccm_mini_log_factory=>create_log( zif_bc_ccm_mini_log=>sub_objects-scheduler ).

    DATA(scheduler) = zcl_bc_ccm_scheduler_factory=>create_scheduler( ).
    scheduler->process_all_active_providers( log ).

    COMMIT WORK.
  ENDMETHOD.
ENDCLASS.
