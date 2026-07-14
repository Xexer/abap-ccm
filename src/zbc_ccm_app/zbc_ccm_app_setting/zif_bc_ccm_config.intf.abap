INTERFACE zif_bc_ccm_config
  PUBLIC.

  TYPES key         TYPE zbc_ccm_setting_key.
  TYPES value       TYPE zbc_ccm_setting_value.
  TYPES values      TYPE STANDARD TABLE OF value WITH EMPTY KEY.
  TYPES value_range TYPE RANGE OF value.

  CONSTANTS: BEGIN OF config_option,
               mail_sender              TYPE key VALUE 'MAIL_SEND',
               mail_receiver            TYPE key VALUE 'MAIL_RECV',
               default_score_b          TYPE key VALUE 'SCORE_B',
               default_score_c          TYPE key VALUE 'SCORE_C',
               default_score_d          TYPE key VALUE 'SCORE_D',
               default_atc_variant      TYPE key VALUE 'ATC_VARI',
               include_level_c_findings TYPE key VALUE 'INCL_C',
               period_unit              TYPE key VALUE 'PERIOD',
             END OF config_option.

  CONSTANTS: BEGIN OF periods,
               month TYPE value VALUE 'M',
               week  TYPE value VALUE 'W',
             END OF periods.

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

  "! Check that key is active (ABAP_TRUE)
  "! @parameter key    | Key for the setting
  "! @parameter result | X = Active, '' = Inactive
  METHODS is_active
    IMPORTING !key          TYPE key
    RETURNING VALUE(result) TYPE abap_boolean.
ENDINTERFACE.
