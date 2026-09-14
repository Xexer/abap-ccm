CLASS zcl_bc_ccm_approve_factory DEFINITION
  PUBLIC ABSTRACT FINAL
  CREATE PUBLIC
  GLOBAL FRIENDS zcl_bc_ccm_approve_injector.

  PUBLIC SECTION.
    CLASS-METHODS create_atc_approve
      RETURNING VALUE(result) TYPE REF TO zif_bc_ccm_approve.

  PRIVATE SECTION.
    CLASS-DATA double_atc_approve TYPE REF TO zif_bc_ccm_approve.
ENDCLASS.


CLASS zcl_bc_ccm_approve_factory IMPLEMENTATION.
  METHOD create_atc_approve.
    IF double_atc_approve IS BOUND.
      RETURN double_atc_approve.
    ELSE.
      RETURN NEW zcl_bc_ccm_approve( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
