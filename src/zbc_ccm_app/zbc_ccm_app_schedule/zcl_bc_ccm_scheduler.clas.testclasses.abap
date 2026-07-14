CLASS ltc_runner DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    METHODS run_all_entries         FOR TESTING RAISING cx_static_check.
    METHODS convert_timestamp_month FOR TESTING RAISING cx_static_check.
    METHODS convert_timestamp_week  FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS zcl_bc_ccm_scheduler DEFINITION LOCAL FRIENDS ltc_runner.

CLASS ltc_runner IMPLEMENTATION.
  METHOD run_all_entries.
    DATA(log) = zcl_bc_ccm_mini_log_factory=>create_log( zif_bc_ccm_mini_log=>sub_objects-scheduler ).
    DATA(cut) = zcl_bc_ccm_scheduler_factory=>create_scheduler( ).

    cut->process_all_active_providers( log ).

    cl_abap_unit_assert=>fail( 'Implement your first test here' ).
  ENDMETHOD.


  METHOD convert_timestamp_month.
    DATA(double) = CAST zif_bc_ccm_config( cl_abap_testdouble=>create( 'zif_bc_ccm_config' ) ).
    cl_abap_testdouble=>configure_call( double )->ignore_all_parameters( )->returning( zif_bc_ccm_config=>periods-month ).
    double->get_value( double->config_option-period_unit ).
    zcl_bc_ccm_config_injector=>inject_config( double ).

    DATA(cut) = NEW zcl_bc_ccm_scheduler( ).

    DATA(result) = cut->get_period_from_timestamp( '2026-07-10 17:55:37.7245280' ).

    cl_abap_unit_assert=>assert_equals( exp = '26/07'
                                        act = result ).
  ENDMETHOD.


  METHOD convert_timestamp_week.
    DATA(double) = CAST zif_bc_ccm_config( cl_abap_testdouble=>create( 'zif_bc_ccm_config' ) ).
    cl_abap_testdouble=>configure_call( double )->ignore_all_parameters( )->returning( zif_bc_ccm_config=>periods-week ).
    double->get_value( double->config_option-period_unit ).
    zcl_bc_ccm_config_injector=>inject_config( double ).

    DATA(cut) = NEW zcl_bc_ccm_scheduler( ).

    DATA(result) = cut->get_period_from_timestamp( '2026-07-10 17:55:37.7245280' ).

    cl_abap_unit_assert=>assert_equals( exp = '26/W28'
                                        act = result ).
  ENDMETHOD.
ENDCLASS.
