CLASS zcl_bc_ccm_mini_log DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE
  GLOBAL FRIENDS zcl_bc_ccm_mini_log_factory.

  PUBLIC SECTION.
    INTERFACES zif_bc_ccm_mini_log.

    METHODS constructor
      IMPORTING sub_object TYPE cl_bali_header_setter=>ty_subobject.

  PRIVATE SECTION.
    TYPES message_reference TYPE REF TO if_bali_message_setter.

    DATA log      TYPE REF TO if_bali_log.
    DATA messages TYPE STANDARD TABLE OF message_reference WITH EMPTY KEY.
ENDCLASS.


CLASS zcl_bc_ccm_mini_log IMPLEMENTATION.
  METHOD constructor.
    TRY.
        DATA(bal_header) = cl_bali_header_setter=>create( object      = 'ZBC_CCM'
                                                          subobject   = sub_object
                                                          external_id = CONV #( xco_cp=>uuid( )->value ) ).

        log = cl_bali_log=>create( ).
        log->set_header( bal_header ).

      CATCH cx_bali_runtime INTO DATA(bali_error).
        RAISE EXCEPTION NEW zcx_bc_ccm_general_error( previous = bali_error ).
    ENDTRY.

    bal_header->set_expiry( expiry_date = CONV #( cl_abap_context_info=>get_system_date( ) + 30 ) ).
  ENDMETHOD.


  METHOD zif_bc_ccm_mini_log~add_message.
    CLEAR zif_bc_ccm_mini_log~message.

    TRY.
        DATA(message) = cl_bali_message_setter=>create_from_sy( ).
        log->add_item( message ).
        INSERT message INTO TABLE messages.

      CATCH cx_bali_runtime INTO DATA(bali_error).
        RAISE EXCEPTION NEW zcx_bc_ccm_general_error( previous = bali_error ).
    ENDTRY.
  ENDMETHOD.


  METHOD zif_bc_ccm_mini_log~save.
    TRY.
        cl_bali_log_db=>get_instance( )->save_log( log ).

      CATCH cx_bali_runtime INTO DATA(bali_error).
        RAISE EXCEPTION NEW zcx_bc_ccm_general_error( previous = bali_error ).
    ENDTRY.
  ENDMETHOD.


  METHOD zif_bc_ccm_mini_log~save_with_job.
    TRY.
        cl_bali_log_db=>get_instance( )->save_log( log                        = log
                                                   assign_to_current_appl_job = abap_true ).

      CATCH cx_bali_runtime INTO DATA(bali_error).
        RAISE EXCEPTION NEW zcx_bc_ccm_general_error( previous = bali_error ).
    ENDTRY.
  ENDMETHOD.


  METHOD zif_bc_ccm_mini_log~save_with_2nd_connection.
    TRY.
        cl_bali_log_db=>get_instance( )->save_log( log                   = log
                                                   use_2nd_db_connection = abap_true ).

      CATCH cx_bali_runtime INTO DATA(bali_error).
        RAISE EXCEPTION NEW zcx_bc_ccm_general_error( previous = bali_error ).
    ENDTRY.
  ENDMETHOD.


  METHOD zif_bc_ccm_mini_log~get_all_messages.
    LOOP AT messages INTO DATA(item).
      item->get_all_values( IMPORTING severity   = DATA(message_type)
                                      id         = DATA(message_class)
                                      number     = DATA(message_number)
                                      variable_1 = DATA(message_v1)
                                      variable_2 = DATA(message_v2)
                                      variable_3 = DATA(message_v3)
                                      variable_4 = DATA(message_v4) ).

      INSERT zcx_bc_ccm_rap_message=>new_message( class  = message_class
                                                  number = message_number
                                                  type   = message_type
                                                  v1     = message_v1
                                                  v2     = message_v2
                                                  v3     = message_v3
                                                  v4     = message_v4 )
             INTO TABLE result.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
