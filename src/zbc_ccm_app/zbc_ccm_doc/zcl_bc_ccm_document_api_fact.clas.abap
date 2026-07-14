CLASS zcl_bc_ccm_document_api_fact DEFINITION
  PUBLIC ABSTRACT FINAL
  CREATE PUBLIC
  GLOBAL FRIENDS zcl_bc_ccm_document_api_inject.

  PUBLIC SECTION.
    CLASS-METHODS create_document
      RETURNING VALUE(result) TYPE REF TO zif_bc_ccm_document_api.

  PRIVATE SECTION.
    CLASS-DATA double_document TYPE REF TO zif_bc_ccm_document_api.
ENDCLASS.


CLASS zcl_bc_ccm_document_api_fact IMPLEMENTATION.
  METHOD create_document.
    IF double_document IS BOUND.
      RETURN double_document.
    ELSE.
      RETURN NEW zcl_bc_ccm_document_api( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
