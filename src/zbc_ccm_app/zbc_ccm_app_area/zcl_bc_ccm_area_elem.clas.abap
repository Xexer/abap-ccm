CLASS zcl_bc_ccm_area_elem DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
ENDCLASS.


CLASS zcl_bc_ccm_area_elem IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA original_data TYPE STANDARD TABLE OF ZBC_C_CCMClusterArea WITH EMPTY KEY.

    original_data = CORRESPONDING #( it_original_data ).

    LOOP AT original_data REFERENCE INTO DATA(original).
      original->LevelBCriticality = 5.
      original->LevelCCriticality = 2.
      original->LevelDCriticality = 1.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( original_data ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.
ENDCLASS.
