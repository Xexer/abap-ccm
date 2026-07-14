CLASS zcl_bc_ccm_mini_log_factory DEFINITION
  PUBLIC ABSTRACT FINAL
  CREATE PUBLIC
  GLOBAL FRIENDS zcl_bc_ccm_mini_log_injector.

  PUBLIC SECTION.
    CLASS-METHODS create_log
      IMPORTING sub_object    TYPE cl_bali_header_setter=>ty_subobject
      RETURNING VALUE(result) TYPE REF TO zif_bc_ccm_mini_log.

  PRIVATE SECTION.
    CLASS-DATA double_log TYPE REF TO zif_bc_ccm_mini_log.
ENDCLASS.


CLASS zcl_bc_ccm_mini_log_factory IMPLEMENTATION.
  METHOD create_log.
    IF double_log IS BOUND.
      RETURN double_log.
    ELSE.
      RETURN NEW zcl_bc_ccm_mini_log( sub_object ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
