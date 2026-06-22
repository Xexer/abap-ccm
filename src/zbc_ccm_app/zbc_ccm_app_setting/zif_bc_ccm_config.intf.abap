INTERFACE zif_bc_ccm_config
  PUBLIC.

  TYPES key         TYPE zbc_ccm_setting_key.
  TYPES value       TYPE zbc_ccm_setting_value.
  TYPES values      TYPE STANDARD TABLE OF value WITH EMPTY KEY.
  TYPES value_range TYPE RANGE OF value.

  CONSTANTS: BEGIN OF config_option,
               mail_sender     TYPE key VALUE 'MAIL_SEND',
               mail_receiver   TYPE key VALUE 'MAIL_RECV',
               default_score_b TYPE key VALUE 'SCORE_B',
               default_score_c TYPE key VALUE 'SCORE_C',
               default_score_d TYPE key VALUE 'SCORE_D',
             END OF config_option.

  "! Get value for the key
  "! @parameter key    | Key for the setting
  "! @parameter result | Single Value
  METHODS get_value
    IMPORTING !key          TYPE key
    RETURNING VALUE(result) TYPE value.

  "! Get all values for the key
  "! @parameter key    | Key for the setting
  "! @parameter result | Value table
  METHODS get_values
    IMPORTING !key          TYPE key
    RETURNING VALUE(result) TYPE values.

  "! Get Range for the key
  "! @parameter key    | Key for the setting
  "! @parameter result | Range for the value
  METHODS get_range
    IMPORTING !key          TYPE key
    RETURNING VALUE(result) TYPE value_range.
ENDINTERFACE.
