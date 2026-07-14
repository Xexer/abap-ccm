CLASS zcl_bc_ccm_document_api DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE
  GLOBAL FRIENDS zcl_bc_ccm_document_api_fact.

  PUBLIC SECTION.
    INTERFACES zif_bc_ccm_document_api.
ENDCLASS.


CLASS zcl_bc_ccm_document_api IMPLEMENTATION.
  METHOD zif_bc_ccm_document_api~get_documentation.
    SELECT SINGLE FROM ZBC_I_CCMDocLink
      FIELDS DocumentId
      WHERE     ProviderId = @filter-provider_id
            AND ObjectType = @filter-object_type
            AND ObjectName = @filter-object_name
      INTO @DATA(document_id)
      PRIVILEGED ACCESS.

    IF sy-subrc <> 0.
      SELECT SINGLE FROM ZBC_I_CCMDocLink
        FIELDS DocumentId
        WHERE     ProviderId = @filter-provider_id
              AND ObjectType = 'DEVC'
              AND ObjectName = @filter-package
        INTO @document_id
        PRIVILEGED ACCESS.
    ENDIF.

    IF document_id IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE FROM ZBC_R_CCMDocument
      FIELDS *
      WHERE DocumentID = @document_id
      INTO CORRESPONDING FIELDS OF @result.
  ENDMETHOD.
ENDCLASS.
