CLASS ltc_json_github DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    METHODS load_remote_json FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltc_json_github IMPLEMENTATION.
  METHOD load_remote_json.
    DATA(cut) = zcl_bc_ccm_file_factory=>create_file_json( ).

    DATA(result) = cut->load_file(
        VALUE #(
            json_url = `https://raw.githubusercontent.com/Xexer/abap-ccm/refs/heads/main/test/custom-api-list.json` ) ).

    cl_abap_unit_assert=>assert_not_initial( result ).
  ENDMETHOD.
ENDCLASS.
