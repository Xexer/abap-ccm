CLASS zcl_bc_ccm_mini_log_injector DEFINITION
  PUBLIC ABSTRACT FINAL
  CREATE PUBLIC
  FOR TESTING.

  PUBLIC SECTION.
    CLASS-METHODS inject_log
      IMPORTING double TYPE REF TO zif_bc_ccm_mini_log OPTIONAL.
ENDCLASS.


CLASS zcl_bc_ccm_mini_log_injector IMPLEMENTATION.
  METHOD inject_log.
    zcl_bc_ccm_mini_log_factory=>double_log = double.
  ENDMETHOD.
ENDCLASS.
