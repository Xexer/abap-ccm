CLASS zcl_bc_ccm_auth_injector DEFINITION
  PUBLIC ABSTRACT FINAL
  CREATE PUBLIC
  FOR TESTING.

  PUBLIC SECTION.
    CLASS-METHODS inject_auth
      IMPORTING double TYPE REF TO zif_bc_ccm_auth OPTIONAL.
ENDCLASS.


CLASS zcl_bc_ccm_auth_injector IMPLEMENTATION.
  METHOD inject_auth.
    zcl_bc_ccm_auth_factory=>double_auth = double.
  ENDMETHOD.
ENDCLASS.
