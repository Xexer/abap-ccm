CLASS zcl_bc_ccm_data_job DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_apj_rt_run.

    DATA delete TYPE abap_boolean.
    DATA insert TYPE abap_boolean.

  PRIVATE SECTION.
    "! Handle the test data settings for the job
    "! @parameter log | Logging object
    METHODS handle_test_data
      IMPORTING !log TYPE REF TO zif_bc_ccm_mini_log.
ENDCLASS.


CLASS zcl_bc_ccm_data_job IMPLEMENTATION.
  METHOD if_apj_rt_run~execute.
    DATA(log) = zcl_bc_ccm_mini_log_factory=>create_log( zif_bc_ccm_mini_log=>sub_objects-data ).
    DATA(config) = zcl_bc_ccm_config_factory=>create_config( ).

    IF config->is_active( config->config_option-test_mode ).
      handle_test_data( log ).
    ELSE.
      MESSAGE e011(zbc_ccm) INTO log->message.
      log->add_message( ).
    ENDIF.

    log->save_with_job( ).
    COMMIT WORK.
  ENDMETHOD.


  METHOD handle_test_data.
    DATA(test_data_handler) = NEW zcl_bc_ccm_test_data( ).

    IF delete = abap_true.
      test_data_handler->delete_all_data( ).

      MESSAGE s009(zbc_ccm) INTO log->message.
      log->add_message( ).
    ENDIF.

    IF insert = abap_true.
      test_data_handler->create_test_data( ).

      MESSAGE s010(zbc_ccm) INTO log->message.
      log->add_message( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
