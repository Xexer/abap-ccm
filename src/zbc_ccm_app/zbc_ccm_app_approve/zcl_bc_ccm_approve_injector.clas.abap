CLASS zcl_bc_ccm_approve_injector DEFINITION
  PUBLIC ABSTRACT FINAL
  CREATE PUBLIC
  FOR TESTING.

  PUBLIC SECTION.
    CLASS-METHODS inject_atc_approve
      IMPORTING double TYPE REF TO zif_bc_ccm_approve OPTIONAL.
ENDCLASS.


CLASS zcl_bc_ccm_approve_injector IMPLEMENTATION.
  METHOD inject_atc_approve.
    zcl_bc_ccm_approve_factory=>double_atc_approve = double.
  ENDMETHOD.
ENDCLASS.
