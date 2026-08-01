CLASS zcl_bc_ccm_file_factory DEFINITION
  PUBLIC ABSTRACT FINAL
  CREATE PUBLIC
  GLOBAL FRIENDS zcl_bc_ccm_file_injector.

  PUBLIC SECTION.
    "! Create file reader for JSON stream
    "! @parameter result | Instance for JSON
    CLASS-METHODS create_file_json
      RETURNING VALUE(result) TYPE REF TO zif_bc_ccm_file.

    "! Create file reader for Excel stream
    "! @parameter result | Instance for Excel
    CLASS-METHODS create_file_excel
      RETURNING VALUE(result) TYPE REF TO zif_bc_ccm_file.

  PRIVATE SECTION.
    CLASS-DATA double_file_json  TYPE REF TO zif_bc_ccm_file.
    CLASS-DATA double_file_excel TYPE REF TO zif_bc_ccm_file.
ENDCLASS.


CLASS zcl_bc_ccm_file_factory IMPLEMENTATION.
  METHOD create_file_json.
    IF double_file_json IS BOUND.
      RETURN double_file_json.
    ELSE.
      RETURN NEW zcl_bc_ccm_file_json( ).
    ENDIF.
  ENDMETHOD.


  METHOD create_file_excel.
    IF double_file_excel IS BOUND.
      RETURN double_file_excel.
    ELSE.
      RETURN NEW zcl_bc_ccm_file_excel( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
