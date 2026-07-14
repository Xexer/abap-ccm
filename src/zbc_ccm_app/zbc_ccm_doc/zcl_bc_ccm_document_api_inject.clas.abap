CLASS zcl_bc_ccm_document_api_inject DEFINITION
  PUBLIC ABSTRACT FINAL
  CREATE PUBLIC
  FOR TESTING.

  PUBLIC SECTION.
    CLASS-METHODS inject_document
      IMPORTING double TYPE REF TO zif_bc_ccm_document_api OPTIONAL.
ENDCLASS.


CLASS zcl_bc_ccm_document_api_inject IMPLEMENTATION.
  METHOD inject_document.
    zcl_bc_ccm_document_api_fact=>double_document = double.
  ENDMETHOD.
ENDCLASS.
