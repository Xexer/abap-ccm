INTERFACE zif_bc_ccm_mini_log
  PUBLIC.

  CONSTANTS:
    BEGIN OF sub_objects,
      scheduler TYPE cl_bali_header_setter=>ty_subobject VALUE 'SCHEDULE',
      data      TYPE cl_bali_header_setter=>ty_subobject VALUE 'DATA',
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
ENDINTERFACE.
