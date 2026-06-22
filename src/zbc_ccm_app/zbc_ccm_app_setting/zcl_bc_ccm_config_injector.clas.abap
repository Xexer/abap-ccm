CLASS zcl_bc_ccm_config_injector DEFINITION
  PUBLIC ABSTRACT FINAL
  CREATE PUBLIC
  FOR TESTING.

  PUBLIC SECTION.
    CLASS-METHODS inject_config
      IMPORTING double TYPE REF TO zif_bc_ccm_config OPTIONAL.
ENDCLASS.


CLASS zcl_bc_ccm_config_injector IMPLEMENTATION.
  METHOD inject_config.
    zcl_bc_ccm_config_factory=>double_config = double.
  ENDMETHOD.
ENDCLASS.
