CLASS zcl_bc_ccm_scheduler_factory DEFINITION
  PUBLIC ABSTRACT FINAL
  CREATE PUBLIC
  GLOBAL FRIENDS zcl_bc_ccm_scheduler_injector.

  PUBLIC SECTION.
    CLASS-METHODS create_scheduler
      RETURNING VALUE(result) TYPE REF TO zif_bc_ccm_scheduler.

  PRIVATE SECTION.
    CLASS-DATA double_scheduler TYPE REF TO zif_bc_ccm_scheduler.
ENDCLASS.


CLASS zcl_bc_ccm_scheduler_factory IMPLEMENTATION.
  METHOD create_scheduler.
    IF double_scheduler IS BOUND.
      RETURN double_scheduler.
    ELSE.
      RETURN NEW zcl_bc_ccm_scheduler( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
