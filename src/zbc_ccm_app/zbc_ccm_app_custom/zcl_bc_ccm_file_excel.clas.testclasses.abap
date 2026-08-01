CLASS ltc_json_github DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    DATA remote_file TYPE string VALUE `https://raw.githubusercontent.com/Xexer/abap-ccm/refs/heads/main/test/custom-api-list.xlsx`.

    METHODS load_remote_stream
      RETURNING VALUE(result) TYPE xstring.

    METHODS load_excel FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltc_json_github IMPLEMENTATION.
  METHOD load_remote_stream.
    TRY.
        DATA(destination) = cl_http_destination_provider=>create_by_url( remote_file ).
        DATA(client) = cl_web_http_client_manager=>create_by_http_destination( destination ).
        DATA(response) = client->execute( i_method = if_web_http_client=>get ).

      CATCH cx_http_dest_provider_error cx_web_http_client_error.
        RETURN.
    ENDTRY.

    IF response->get_status( )-code = 200.
      RETURN response->get_binary( ).
    ENDIF.
  ENDMETHOD.


  METHOD load_excel.
    DATA(file_stream) = load_remote_stream( ).
    DATA(cut) = zcl_bc_ccm_file_factory=>create_file_excel( ).

    DATA(result) = cut->load_file( VALUE #( excel_file-Attachment = file_stream ) ).

    cl_abap_unit_assert=>assert_not_initial( result ).
  ENDMETHOD.
ENDCLASS.
