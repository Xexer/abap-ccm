CLASS zcl_bc_ccm_scheduler_injector DEFINITION
  PUBLIC ABSTRACT FINAL
  CREATE PUBLIC
  FOR TESTING.

  PUBLIC SECTION.
    CLASS-METHODS inject_scheduler
      IMPORTING double TYPE REF TO zif_bc_ccm_scheduler OPTIONAL.
ENDCLASS.


CLASS zcl_bc_ccm_scheduler_injector IMPLEMENTATION.
  METHOD inject_scheduler.
    zcl_bc_ccm_scheduler_factory=>double_scheduler = double.
  ENDMETHOD.
ENDCLASS.
