CLASS zcl_bc_ccm_ac_objects DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_aco_proxy .

    METHODS constructor
      IMPORTING
        !destination TYPE REF TO if_rfc_dest
      RAISING
        cx_rfc_dest_provider_error .
    METHODS z_ca_atc_level_a_objects
      EXPORTING
        !objects TYPE i
      RAISING
        cx_aco_application_exception
        cx_aco_communication_failure
        cx_aco_system_failure .
  PROTECTED SECTION.

    DATA destination TYPE rfcdest .
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_bc_ccm_ac_objects IMPLEMENTATION.


  METHOD constructor.
    me->destination = destination->get_destination_name( ).
  ENDMETHOD.


  METHOD z_ca_atc_level_a_objects.
    DATA: _rfc_message_ TYPE aco_proxy_msg_type.
    CALL FUNCTION 'Z_CA_ATC_LEVEL_A_OBJECTS' DESTINATION me->destination
      IMPORTING
        objects               = objects
      EXCEPTIONS
        communication_failure = 1 MESSAGE _rfc_message_
        system_failure        = 2 MESSAGE _rfc_message_
        OTHERS                = 3.
    IF sy-subrc NE 0.
      DATA _save_subrc_ TYPE sy-subrc.
      DATA __textid TYPE aco_proxy_textid_type.
      _save_subrc_ = sy-subrc.
      __textid-msgid = sy-msgid.
      __textid-msgno = sy-msgno.
      __textid-attr1 = sy-msgv1.
      __textid-attr2 = sy-msgv2.
      __textid-attr3 = sy-msgv3.
      __textid-attr4 = sy-msgv4.
      CASE _save_subrc_.
        WHEN 1 .
          RAISE EXCEPTION TYPE cx_aco_communication_failure
            EXPORTING
              rfc_msg = _rfc_message_.
        WHEN 2 .
          RAISE EXCEPTION TYPE cx_aco_system_failure
            EXPORTING
              rfc_msg = _rfc_message_.
        WHEN 3 .
          RAISE EXCEPTION TYPE cx_aco_application_exception
            EXPORTING
              exception_id = 'OTHERS'
              textid       = __textid.
      ENDCASE.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
