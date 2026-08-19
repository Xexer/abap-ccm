CLASS zcl_bc_ccm_test_atc_checks DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_bc_ccm_test_atc_checks IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA(atc) = NEW zcl_bc_ccm_atc_check( 'ABAP_CLEAN_CORE_READINESS' ).

    out->write( atc->get_variant_checks( ) ).
    out->write( atc->get_variant_messages( ) ).
  ENDMETHOD.
ENDCLASS.
