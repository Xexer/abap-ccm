CLASS zcl_bc_ccm_scoping DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_bc_ccm_scoping IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA scopes TYPE if_aps_bc_scope_change_api=>tt_object_scope_sorted.

    DATA(scope_api) = cl_aps_bc_scope_change_api=>create_instance( ).

    INSERT VALUE #( pgmid       = if_aps_bc_scope_change_api=>gc_tadir_pgmid-r3tr
                    scope_state = if_aps_bc_scope_change_api=>gc_scope_state-on
                    object      = if_aps_bc_scope_change_api=>gc_tadir_object-uist
                    obj_name    = 'ZBC_CCM_SPACE' ) INTO TABLE scopes.

    INSERT VALUE #( pgmid       = if_aps_bc_scope_change_api=>gc_tadir_pgmid-r3tr
                    scope_state = if_aps_bc_scope_change_api=>gc_scope_state-on
                    object      = if_aps_bc_scope_change_api=>gc_tadir_object-uipg
                    obj_name    = 'ZBC_CCM_START_PAGE' ) INTO TABLE scopes.

    scope_api->scope( EXPORTING it_object_scope  = scopes
                                iv_simulate      = abap_false
                                iv_force         = abap_true
                      IMPORTING et_object_result = DATA(object_results) ).

    out->write( object_results ).
  ENDMETHOD.
ENDCLASS.
