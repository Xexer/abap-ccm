CLASS zcl_bc_ccm_auth_factory DEFINITION
  PUBLIC ABSTRACT FINAL
  CREATE PUBLIC
  GLOBAL FRIENDS zcl_bc_ccm_auth_injector.

  PUBLIC SECTION.
    CLASS-METHODS create_auth
      RETURNING VALUE(result) TYPE REF TO zif_bc_ccm_auth.

  PRIVATE SECTION.
    CLASS-DATA double_auth TYPE REF TO zif_bc_ccm_auth.
ENDCLASS.


CLASS zcl_bc_ccm_auth_factory IMPLEMENTATION.
  METHOD create_auth.
    IF double_auth IS BOUND.
      RETURN double_auth.
    ELSE.
      RETURN NEW zcl_bc_ccm_auth( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
