CLASS zcl_bc_ccm_dash_score_elem DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
ENDCLASS.


CLASS zcl_bc_ccm_dash_score_elem IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA original_data TYPE STANDARD TABLE OF ZBC_C_CCMDashboardScore WITH EMPTY KEY.

    original_data = CORRESPONDING #( it_original_data ).

    LOOP AT original_data REFERENCE INTO DATA(original).
      cl_abap_utclong=>to_system_timestamp( EXPORTING utc_tstmp   = original->RunTime
                                            IMPORTING system_date = DATA(date) ).

      original->YearAndMonth = substring( val = date
                                          len = 6 ).
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( original_data ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    et_requested_orig_elements = VALUE #( ( `RUNTIME` ) ).
  ENDMETHOD.
ENDCLASS.
