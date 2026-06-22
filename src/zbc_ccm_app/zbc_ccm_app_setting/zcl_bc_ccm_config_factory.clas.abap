CLASS zcl_bc_ccm_config_factory DEFINITION
  PUBLIC ABSTRACT FINAL
  CREATE PUBLIC
  GLOBAL FRIENDS zcl_bc_ccm_config_injector.

  PUBLIC SECTION.
    CLASS-METHODS create_config
      RETURNING VALUE(result) TYPE REF TO zif_bc_ccm_config.

  PRIVATE SECTION.
    CLASS-DATA double_config TYPE REF TO zif_bc_ccm_config.
ENDCLASS.


CLASS zcl_bc_ccm_config_factory IMPLEMENTATION.
  METHOD create_config.
    IF double_config IS BOUND.
      RETURN double_config.
    ELSE.
      RETURN NEW zcl_bc_ccm_config( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
