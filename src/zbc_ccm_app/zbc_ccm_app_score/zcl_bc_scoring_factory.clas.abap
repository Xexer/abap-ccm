CLASS zcl_bc_scoring_factory DEFINITION
  PUBLIC ABSTRACT FINAL
  CREATE PUBLIC
  GLOBAL FRIENDS zcl_bc_scoring_injector.

  PUBLIC SECTION.
    CLASS-METHODS create_scoring
      RETURNING VALUE(result) TYPE REF TO zif_bc_scoring.

  PRIVATE SECTION.
    CLASS-DATA double_scoring TYPE REF TO zif_bc_scoring.
ENDCLASS.


CLASS zcl_bc_scoring_factory IMPLEMENTATION.
  METHOD create_scoring.
    IF double_scoring IS BOUND.
      RETURN double_scoring.
    ELSE.
      RETURN NEW zcl_bc_scoring( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
