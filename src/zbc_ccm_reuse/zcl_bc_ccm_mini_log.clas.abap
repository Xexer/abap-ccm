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
    DATA bapi_message TYPE zif_bc_ccm_mini_log=>message_type.

    LOOP AT messages INTO DATA(item).
      CLEAR bapi_message.
      item->get_all_values( IMPORTING severity   = bapi_message-type
                                      id         = bapi_message-id
                                      number     = bapi_message-number
                                      variable_1 = bapi_message-message_v1
                                      variable_2 = bapi_message-message_v2
                                      variable_3 = bapi_message-message_v3
                                      variable_4 = bapi_message-message_v4 ).

      INSERT bapi_message INTO TABLE result.
    ENDLOOP.
  ENDMETHOD.


  METHOD zif_bc_ccm_mini_log~map_type_to_severity.
    RETURN SWITCH #( type
                     WHEN 'A' THEN if_abap_behv_message=>severity-error
                     WHEN 'X' THEN if_abap_behv_message=>severity-error
                     WHEN 'E' THEN if_abap_behv_message=>severity-error
                     WHEN 'W' THEN if_abap_behv_message=>severity-warning
                     WHEN 'I' THEN if_abap_behv_message=>severity-information
                     WHEN 'S' THEN if_abap_behv_message=>severity-success
                     ELSE          if_abap_behv_message=>severity-none ).
  ENDMETHOD.
ENDCLASS.
