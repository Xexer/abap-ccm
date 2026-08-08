CLASS lhc_StetupSteps DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR StetupSteps RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE StetupSteps.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE StetupSteps.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE StetupSteps.

    METHODS read FOR READ
      IMPORTING keys FOR READ StetupSteps RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK StetupSteps.

    METHODS ExecuteStep FOR MODIFY
      IMPORTING keys FOR ACTION StetupSteps~ExecuteStep.
    METHODS CheckStep FOR MODIFY
      IMPORTING keys FOR ACTION StetupSteps~CheckStep.

ENDCLASS.


CLASS lhc_StetupSteps IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.


  METHOD create.
  ENDMETHOD.


  METHOD update.
  ENDMETHOD.


  METHOD delete.
  ENDMETHOD.


  METHOD read.
  ENDMETHOD.


  METHOD lock.
  ENDMETHOD.


  METHOD ExecuteStep.
    LOOP AT keys INTO DATA(key).
      IF key-StepID CO '0123456789'.
        CONTINUE.
      ENDIF.

      DATA(step) = zcl_bc_ccm_setup_step_factory=>create_step( CONV #( key-StepID ) ).
      DATA(step_result) = step->execute( key-%cid_ref ).
      INSERT LINES OF step_result-log->get_all_messages( ) INTO TABLE reported-%other.
    ENDLOOP.
  ENDMETHOD.


  METHOD CheckStep.
    LOOP AT keys INTO DATA(key).
      IF key-StepID CO '0123456789'.
        CONTINUE.
      ENDIF.

      DATA(step) = zcl_bc_ccm_setup_step_factory=>create_step( CONV #( key-StepID ) ).
      DATA(step_result) = step->check( ).
      INSERT LINES OF step_result-log->get_all_messages( ) INTO TABLE reported-%other.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.


CLASS lsc_ZBC_R_CCMSETUPSTEPS DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS
      finalize REDEFINITION.

    METHODS
      check_before_save REDEFINITION.

    METHODS
      save REDEFINITION.

    METHODS
      cleanup REDEFINITION.

    METHODS
      cleanup_finalize REDEFINITION.

ENDCLASS.


CLASS lsc_ZBC_R_CCMSETUPSTEPS IMPLEMENTATION.
  METHOD finalize.
  ENDMETHOD.


  METHOD check_before_save.
  ENDMETHOD.


  METHOD save.
  ENDMETHOD.


  METHOD cleanup.
  ENDMETHOD.


  METHOD cleanup_finalize.
  ENDMETHOD.
ENDCLASS.
