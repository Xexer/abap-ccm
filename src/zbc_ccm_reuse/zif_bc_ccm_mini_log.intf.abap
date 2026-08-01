INTERFACE zif_bc_ccm_mini_log
  PUBLIC.

  TYPES message_type TYPE bapiret2.
  TYPES messages     TYPE STANDARD TABLE OF message_type WITH EMPTY KEY.

  CONSTANTS:
    BEGIN OF sub_objects,
      scheduler   TYPE cl_bali_header_setter=>ty_subobject VALUE 'SCHEDULE',
      data        TYPE cl_bali_header_setter=>ty_subobject VALUE 'DATA',
      load_custom TYPE cl_bali_header_setter=>ty_subobject VALUE 'LOAD_CUSTOM',
    END OF sub_objects.

  " Dummy variable for message
  DATA message TYPE string.

  "! Add a message from system (use message var for this)
  METHODS add_message.

  "! Normal save of the log
  METHODS save.

  "! Save the log with the job
  METHODS save_with_job.

  "! Save with second connection
  METHODS save_with_2nd_connection.

  "! Return all messages
  "! @parameter result | Message in BAPIRET2 format
  METHODS get_all_messages
    RETURNING VALUE(result) TYPE messages.

  "! Map message type to BALI severity
  "! @parameter type   | Type for the message
  "! @parameter result | Severity of the message
  METHODS map_type_to_severity
    IMPORTING !type         TYPE message_type-type
    RETURNING VALUE(result) TYPE if_abap_behv_message=>t_severity.
ENDINTERFACE.
