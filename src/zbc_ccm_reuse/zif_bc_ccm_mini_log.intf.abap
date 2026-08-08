INTERFACE zif_bc_ccm_mini_log
  PUBLIC.

  TYPES rap_message_type TYPE REF TO if_abap_behv_message.
  TYPES rap_messages     TYPE STANDARD TABLE OF rap_message_type WITH EMPTY KEY.

  CONSTANTS:
    BEGIN OF sub_objects,
      scheduler    TYPE cl_bali_header_setter=>ty_subobject VALUE 'SCHEDULE',
      data         TYPE cl_bali_header_setter=>ty_subobject VALUE 'DATA',
      load_custom  TYPE cl_bali_header_setter=>ty_subobject VALUE 'LOAD_CUSTOM',
      step_execute TYPE cl_bali_header_setter=>ty_subobject VALUE 'STEPS',
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
  "! @parameter result | Message in RAP format
  METHODS get_all_messages
    RETURNING VALUE(result) TYPE rap_messages.
ENDINTERFACE.
