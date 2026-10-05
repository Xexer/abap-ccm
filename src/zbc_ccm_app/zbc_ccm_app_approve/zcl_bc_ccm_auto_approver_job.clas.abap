CLASS zcl_bc_ccm_auto_approver_job DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_apj_rt_run.
ENDCLASS.


CLASS zcl_bc_ccm_auto_approver_job IMPLEMENTATION.
  METHOD if_apj_rt_run~execute.
    FINAL(approver) = zcl_bc_ccm_approve_factory=>create_atc_approve( ).
    FINAL(log) = approver->main( ).

    log->save_with_job( ).
    COMMIT WORK.
  ENDMETHOD.
ENDCLASS.
