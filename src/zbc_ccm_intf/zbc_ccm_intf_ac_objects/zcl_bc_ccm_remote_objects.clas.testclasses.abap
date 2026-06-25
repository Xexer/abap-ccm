CLASS ltc_determination DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    METHODS get_destination_available     FOR TESTING RAISING cx_static_check.
    METHODS get_destination_not_available FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS zcl_bc_ccm_remote_objects DEFINITION LOCAL FRIENDS ltc_determination.

CLASS ltc_determination IMPLEMENTATION.
  METHOD get_destination_available.
    DATA(cut) = NEW zcl_bc_ccm_remote_objects( ).

    DATA(result) = cut->get_destination_for_provider( 'TEST' ).

    cl_abap_unit_assert=>assert_bound( result ).
  ENDMETHOD.


  METHOD get_destination_not_available.
    DATA(cut) = NEW zcl_bc_ccm_remote_objects( ).

    TRY.
        cut->get_destination_for_provider( 'BLA' ).

        cl_abap_unit_assert=>fail( 'Implement your first test here' ).

      CATCH cx_root.
        cl_abap_unit_assert=>assert_true( abap_true ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
