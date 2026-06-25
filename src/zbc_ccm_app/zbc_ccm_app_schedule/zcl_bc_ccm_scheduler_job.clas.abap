CLASS zcl_bc_ccm_scheduler_job DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_apj_rt_run.
ENDCLASS.


CLASS zcl_bc_ccm_scheduler_job IMPLEMENTATION.
  METHOD if_apj_rt_run~execute.
    DATA(scheduler) = zcl_bc_ccm_scheduler_factory=>create_scheduler( ).
    scheduler->process_all_active_providers( ).

    COMMIT WORK.
  ENDMETHOD.
ENDCLASS.
