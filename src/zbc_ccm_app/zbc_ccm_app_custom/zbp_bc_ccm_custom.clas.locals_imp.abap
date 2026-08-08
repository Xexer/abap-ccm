CLASS lhc_zbc_r_ccmcustomapis DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    TYPES result_messages TYPE STANDARD TABLE OF REF TO if_abap_behv_message WITH EMPTY KEY.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
              IMPORTING
                 REQUEST requested_authorizations FOR CustomAPI
              RESULT result.

    METHODS LoadContentViaExcel FOR MODIFY
      IMPORTING keys FOR ACTION CustomAPI~LoadContentViaExcel.

    METHODS LoadContentViaJSON FOR MODIFY
      IMPORTING keys FOR ACTION CustomAPI~LoadContentViaJSON.
ENDCLASS.


CLASS lhc_zbc_r_ccmcustomapis IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.


  METHOD LoadContentViaExcel.
    DATA(handler) = NEW zcl_bc_ccm_file_api_handler( ).

    LOOP AT keys INTO DATA(key).
      DATA(parameter) = key-%param.

      handler->load_excel_file( VALUE #( overwrite_provider         = parameter-OverwriteProvider
                                         mode                       = parameter-UploadMode
                                         file-excel_file-MimeType   = parameter-_files-MimeType
                                         file-excel_file-Filename   = parameter-_files-Filename
                                         file-excel_file-Attachment = parameter-_files-Attachment ) ).
    ENDLOOP.

    reported-%other = handler->log->get_all_messages( ).
  ENDMETHOD.


  METHOD LoadContentViaJSON.
    DATA(handler) = NEW zcl_bc_ccm_file_api_handler( ).

    LOOP AT keys INTO DATA(key).
      DATA(parameter) = key-%param.

      handler->load_json_file( VALUE #( overwrite_provider = parameter-OverwriteProvider
                                        mode               = parameter-UploadMode
                                        file-json_url      = parameter-JSONFilePath ) ).
    ENDLOOP.

    reported-%other = handler->log->get_all_messages( ).
  ENDMETHOD.
ENDCLASS.
