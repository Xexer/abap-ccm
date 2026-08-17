CLASS zcl_bc_ccm_test_logs DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_bc_ccm_test_logs IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    TRY.
        DATA(filter) = cl_bali_log_filter=>create( ).

        filter->set_descriptor( object    = 'ZBC_CCM'
                                subobject = 'BACKGROUND' ).

        DATA(logs) = cl_bali_log_db=>get_instance( )->load_logs_via_filter( filter = filter ).

        LOOP AT logs INTO FINAL(log).
          TRY.
              FINAL(items) = log->get_all_items( ).
            CATCH cx_root INTO DATA(error).
              out->write( error->get_text( ) ).
              CONTINUE.
          ENDTRY.

          LOOP AT items INTO FINAL(item).
            out->write( item-item->get_message_text( ) ).
          ENDLOOP.
        ENDLOOP.

      CATCH cx_root INTO error.
        out->write( error->get_text( ) ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
