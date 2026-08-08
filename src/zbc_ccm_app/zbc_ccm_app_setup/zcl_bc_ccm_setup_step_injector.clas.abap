CLASS zcl_bc_ccm_setup_step_injector DEFINITION
  PUBLIC ABSTRACT FINAL
  CREATE PUBLIC
  FOR TESTING.

  PUBLIC SECTION.
    CLASS-METHODS inject_step
      IMPORTING double TYPE REF TO zif_bc_ccm_setup_step OPTIONAL.
ENDCLASS.


CLASS zcl_bc_ccm_setup_step_injector IMPLEMENTATION.
  METHOD inject_step.
    zcl_bc_ccm_setup_step_factory=>double_step = double.
  ENDMETHOD.
ENDCLASS.
