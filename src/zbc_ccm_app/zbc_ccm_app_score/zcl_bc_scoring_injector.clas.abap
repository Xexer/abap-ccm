CLASS zcl_bc_scoring_injector DEFINITION
  PUBLIC ABSTRACT FINAL
  CREATE PUBLIC
  FOR TESTING.

  PUBLIC SECTION.
    CLASS-METHODS inject_scoring
      IMPORTING double TYPE REF TO zif_bc_scoring OPTIONAL.
ENDCLASS.


CLASS zcl_bc_scoring_injector IMPLEMENTATION.
  METHOD inject_scoring.
    zcl_bc_scoring_factory=>double_scoring = double.
  ENDMETHOD.
ENDCLASS.
