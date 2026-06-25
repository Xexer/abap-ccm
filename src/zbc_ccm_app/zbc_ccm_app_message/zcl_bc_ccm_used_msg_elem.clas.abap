CLASS zcl_bc_ccm_used_msg_elem DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_bc_ccm_used_msg_elem IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA original_data TYPE STANDARD TABLE OF ZBC_C_CCMUsedMessage WITH EMPTY KEY.

    original_data = CORRESPONDING #( it_original_data ).

    LOOP AT original_data REFERENCE INTO DATA(original).
      CASE original->Priority.
        WHEN 'I'.
          original->PriorityIcon = 5.
        WHEN 'W'.
          original->PriorityIcon = 2.
        WHEN 'E'.
          original->PriorityIcon = 1.
      ENDCASE.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( original_data ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    et_requested_orig_elements = VALUE #( ( `PRIORITY` ) ).
  ENDMETHOD.
ENDCLASS.
