CLASS zcl_bc_ccm_test_data DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_bc_ccm_test_data IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA objects TYPE STANDARD TABLE OF zbc_ccm_obj WITH EMPTY KEY.

    objects = VALUE #( provider_id  = 'TEST'
                       obj_type     = 'CLAS'
                       package_name = 'ZBS_DEMO_LANGUAGE'
                       ( obj_name       = 'ZCL_BS_DEMO_ATC_APPROVE' classification = 'C' )
                       ( obj_name       = 'ZCL_BS_DEMO_LANGU_FINAL' classification = 'D' )
                       ( obj_name       = 'ZCL_BS_DEMO_LANGU_FINAL1' classification = 'B' )
                       ( obj_name       = 'ZCL_BS_DEMO_LANGU_FINAL2' classification = 'D' )
                       package_name = 'ZBS_DEMO_OUTSIDE'
                       ( obj_name       = 'ZCL_BS_DEMO_OUTSIDE' classification = 'B' )
                       package_name = 'ZBS_DEMO_OUTSIDE2'
                       ( obj_name       = 'ZCL_BS_DEMO_OUTSIDE2' classification = 'D' ) ).

    DELETE FROM zbc_ccm_obj.
    INSERT zbc_ccm_obj FROM TABLE @objects.

    COMMIT WORK.
  ENDMETHOD.
ENDCLASS.
