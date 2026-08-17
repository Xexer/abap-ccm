CLASS zcl_bc_ccm_setup_background DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_serializable_object.
    INTERFACES if_bgmc_operation.
    INTERFACES if_bgmc_op_single_tx_uncontr.

    METHODS constructor
      IMPORTING roles TYPE zcl_bc_ccm_business_role=>role_settings.

  PRIVATE SECTION.
    DATA roles TYPE zcl_bc_ccm_business_role=>role_settings.

    "! Create new business role in the system
    "! @parameter log | Logging
    METHODS create_new_role
      IMPORTING !log TYPE REF TO zif_bc_ccm_mini_log.
ENDCLASS.


CLASS zcl_bc_ccm_setup_background IMPLEMENTATION.
  METHOD constructor.
    me->roles = roles.
  ENDMETHOD.


  METHOD if_bgmc_op_single_tx_uncontr~execute.
    DATA(log) = zcl_bc_ccm_mini_log_factory=>create_log( zif_bc_ccm_mini_log=>sub_objects-background ).

    IF roles IS NOT INITIAL.
      create_new_role( log ).
    ENDIF.

    log->save( ).
  ENDMETHOD.


  METHOD create_new_role.
    DATA(created) = abap_false.

    LOOP AT roles INTO FINAL(role).
      FINAL(business_role) = NEW zcl_bc_ccm_business_role( role ).

      IF NOT business_role->create_role( ).
        log->add_message( ).
        CONTINUE.
      ENDIF.

      IF business_role->save( ).
        created = abap_true.
      ELSE.
        log->add_message( ).
      ENDIF.
    ENDLOOP.

    IF created = abap_true.
      MESSAGE s032(zbc_ccm) INTO log->message.
      log->add_message( ).
    ELSE.
      MESSAGE e033(zbc_ccm) INTO log->message.
      log->add_message( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
