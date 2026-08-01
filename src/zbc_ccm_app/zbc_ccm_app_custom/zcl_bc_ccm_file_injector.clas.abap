CLASS zcl_bc_ccm_file_injector DEFINITION
  PUBLIC ABSTRACT FINAL
  CREATE PUBLIC
  FOR TESTING.

  PUBLIC SECTION.
    CLASS-METHODS inject_file_json
      IMPORTING double TYPE REF TO zif_bc_ccm_file OPTIONAL.

    CLASS-METHODS inject_file_excel
      IMPORTING double TYPE REF TO zif_bc_ccm_file OPTIONAL.
ENDCLASS.


CLASS zcl_bc_ccm_file_injector IMPLEMENTATION.
  METHOD inject_file_json.
    zcl_bc_ccm_file_factory=>double_file_json = double.
  ENDMETHOD.


  METHOD inject_file_excel.
    zcl_bc_ccm_file_factory=>double_file_excel = double.
  ENDMETHOD.
ENDCLASS.
