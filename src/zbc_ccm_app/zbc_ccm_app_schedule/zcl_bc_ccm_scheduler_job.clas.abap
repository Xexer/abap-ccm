CLASS zcl_bc_ccm_scheduler_job DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_apj_rt_run.

  PRIVATE SECTION.
    METHODS send_email_notification
      IMPORTING !log TYPE REF TO zif_bc_ccm_mini_log.

    METHODS get_html_content
      RETURNING VALUE(result) TYPE string.
ENDCLASS.


CLASS zcl_bc_ccm_scheduler_job IMPLEMENTATION.
  METHOD if_apj_rt_run~execute.
    DATA(log) = zcl_bc_ccm_mini_log_factory=>create_log( zif_bc_ccm_mini_log=>sub_objects-scheduler ).

    DATA(scheduler) = zcl_bc_ccm_scheduler_factory=>create_scheduler( ).
    scheduler->process_all_active_providers( log ).

    send_email_notification( log ).

    log->save_with_job( ).
    COMMIT WORK.
  ENDMETHOD.


  METHOD send_email_notification.
    DATA(config) = zcl_bc_ccm_config_factory=>create_config( ).

    TRY.
        DATA(mail_client) = cl_bcs_mail_message=>create_instance( ).

        DATA(sender) = config->get_value( config->config_option-mail_sender ).
        IF sender IS NOT INITIAL.
          mail_client->set_sender( CONV #( sender ) ).
        ENDIF.

        DATA(receivers) = config->get_values( config->config_option-mail_receiver ).
        IF receivers IS INITIAL.
          MESSAGE s006(zbc_ccm) INTO log->message.
          log->add_message( ).
          RETURN.
        ENDIF.

        LOOP AT receivers INTO DATA(receiver).
          mail_client->add_recipient( CONV #( receiver ) ).
        ENDLOOP.

        mail_client->set_subject( TEXT-001 ).
        mail_client->set_main( cl_bcs_mail_textpart=>create_instance( iv_content      = get_html_content( )
                                                                      iv_content_type = 'text/html' ) ).
        mail_client->send( IMPORTING et_status = DATA(sender_status) ).

        LOOP AT sender_status INTO DATA(status) WHERE status = 'E'.
          MESSAGE e004(zbc_ccm) WITH status-recipient INTO log->message.
          log->add_message( ).
        ENDLOOP.

        MESSAGE s005(zbc_ccm) WITH status-recipient INTO log->message.
        log->add_message( ).

      CATCH cx_bcs_mail INTO DATA(mail_error).
        MESSAGE e003(zbc_ccm) WITH mail_error->get_text( ) INTO log->message.
        log->add_message( ).
    ENDTRY.
  ENDMETHOD.


  METHOD get_html_content.
    RETURN |<!DOCTYPE html lang="en">| &
         |<body>| &
         |  <h1>{ TEXT-001 }</h1><p>{ TEXT-002 }</p>| &
         |</body>| &
         |</html>|.
  ENDMETHOD.
ENDCLASS.
