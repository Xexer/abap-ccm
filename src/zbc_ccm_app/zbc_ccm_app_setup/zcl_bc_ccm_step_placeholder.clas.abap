CLASS zcl_bc_ccm_step_placeholder DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_bc_ccm_setup_step.

  PRIVATE SECTION.
    CLASS-DATA instance_counter TYPE i.
ENDCLASS.


CLASS zcl_bc_ccm_step_placeholder IMPLEMENTATION.
  METHOD zif_bc_ccm_setup_step~check.
    result = VALUE #( status  = 5 ).
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~execute.
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~get_description.
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~get_navigation.
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~get_step_id.
    instance_counter += 1.
    RETURN |{ CONV string( instance_counter ) ALPHA = IN }|.
  ENDMETHOD.
ENDCLASS.
