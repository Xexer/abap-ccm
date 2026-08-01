CLASS zcl_bc_ccm_file_json DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE
  GLOBAL FRIENDS zcl_bc_ccm_file_factory.

  PUBLIC SECTION.
    INTERFACES zif_bc_ccm_file.

  PRIVATE SECTION.
    "! Get the stream from the URL
    "! @parameter file   | Configuration
    "! @parameter result | Stream as String
    METHODS get_raw_stream
      IMPORTING !file         TYPE zif_bc_ccm_file=>file
      RETURNING VALUE(result) TYPE string.
ENDCLASS.


CLASS zcl_bc_ccm_file_json IMPLEMENTATION.
  METHOD zif_bc_ccm_file~load_file.
    DATA(raw_content) = get_raw_stream( file ).
    IF raw_content IS INITIAL.
      RETURN.
    ENDIF.

    /ui2/cl_json=>deserialize( EXPORTING json = raw_content
                               CHANGING  data = result ).
  ENDMETHOD.


  METHOD get_raw_stream.
    TRY.
        DATA(destination) = cl_http_destination_provider=>create_by_url( file-json_url ).
        DATA(client) = cl_web_http_client_manager=>create_by_http_destination( destination ).
        DATA(response) = client->execute( i_method = if_web_http_client=>get ).

      CATCH cx_http_dest_provider_error cx_web_http_client_error.
        RETURN.
    ENDTRY.

    IF response->get_status( )-code = 200.
      RETURN response->get_text( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
