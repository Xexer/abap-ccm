CLASS lhc_zbc_r_ccmcustomapis DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    TYPES new_api   TYPE ZBC_R_CCMCustomAPIs.
    TYPES new_apis  TYPE STANDARD TABLE OF new_api WITH EMPTY KEY.
    TYPES files     TYPE STANDARD TABLE OF ZBC_S_CCMFileUpload WITH EMPTY KEY.
    TYPES parameter TYPE STRUCTURE FOR HIERARCHY zbc_s_ccmloadcontent.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
              IMPORTING
                 REQUEST requested_authorizations FOR CustomAPI
              RESULT result.
    METHODS LoadContent FOR MODIFY
                  IMPORTING keys FOR ACTION CustomAPI~LoadContent.

    METHODS load_http_json_content
      IMPORTING http_path     TYPE zbc_s_ccmloadcontent-jsonfilepath
      RETURNING VALUE(result) TYPE new_apis.

    METHODS load_excel_file_content
      IMPORTING files         TYPE ZBC_S_CCMFileUpload
      RETURNING VALUE(result) TYPE new_apis.

    METHODS load_data_from_request
      IMPORTING !parameter TYPE parameter
                !log       TYPE REF TO zif_bc_ccm_mini_log.

    METHODS is_valid_input
      IMPORTING !parameter    TYPE parameter
                !log          TYPE REF TO zif_bc_ccm_mini_log
      RETURNING VALUE(result) TYPE abap_boolean.
ENDCLASS.


CLASS lhc_zbc_r_ccmcustomapis IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.


  METHOD LoadContent.
    DATA(log) = zcl_bc_ccm_mini_log_factory=>create_log( 'LOAD_CUSTOM' ).

    LOOP AT keys INTO DATA(key).
      DATA(parameter) = key-%param.

      load_data_from_request( parameter = parameter
                              log       = log ).
    ENDLOOP.
  ENDMETHOD.


  METHOD load_data_from_request.
    DATA loaded_apis TYPE new_apis.

    IF NOT is_valid_input( parameter = parameter
                           log       = log ).
      RETURN.
    ENDIF.

    IF parameter-JSONFilePath IS NOT INITIAL.
      loaded_apis = load_http_json_content( parameter-jsonfilepath ).
    ELSE.
      loaded_apis = load_excel_file_content( CORRESPONDING #( parameter-_files ) ).
    ENDIF.

    LOOP AT loaded_apis REFERENCE INTO DATA(loaded_api).
      IF parameter-OverwriteProvider IS NOT INITIAL.
        loaded_api->ProviderID = parameter-OverwriteProvider.
      ENDIF.

    ENDLOOP.

    ##TODO
  ENDMETHOD.


  METHOD is_valid_input.
  ENDMETHOD.


  METHOD load_http_json_content.
    TRY.
        DATA(destination) = cl_http_destination_provider=>create_by_url( http_path ).
        DATA(client) = cl_web_http_client_manager=>create_by_http_destination( destination ).
        DATA(response) = client->execute( i_method = if_web_http_client=>get ).

      CATCH cx_http_dest_provider_error cx_web_http_client_error.
        RETURN.
    ENDTRY.

    IF response->get_status( )-code <> 200.
      RETURN.
    ENDIF.

    DATA(raw_content) = response->get_text( ).
    /ui2/cl_json=>deserialize( EXPORTING json = raw_content
                               CHANGING  data = result ).
  ENDMETHOD.


  METHOD load_excel_file_content.
  ENDMETHOD.
ENDCLASS.
