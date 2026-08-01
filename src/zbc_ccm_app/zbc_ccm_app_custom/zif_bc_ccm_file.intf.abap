INTERFACE zif_bc_ccm_file
  PUBLIC.

  TYPES:
    BEGIN OF file,
      json_url   TYPE string,
      excel_file TYPE ZBC_S_CCMFileUpload,
    END OF file.

  TYPES custom_api  TYPE ZBC_R_CCMCustomAPIs.
  TYPES custom_apis TYPE STANDARD TABLE OF custom_api WITH EMPTY KEY.

  "! Load file from source
  "! @parameter file   | File source and data
  "! @parameter result | Extracted data
  METHODS load_file
    IMPORTING !file         TYPE file
    RETURNING VALUE(result) TYPE custom_apis.
ENDINTERFACE.
