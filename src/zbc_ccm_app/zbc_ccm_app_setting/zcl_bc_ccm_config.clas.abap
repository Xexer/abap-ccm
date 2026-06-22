CLASS zcl_bc_ccm_config DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE
  GLOBAL FRIENDS zcl_bc_ccm_config_factory.

  PUBLIC SECTION.
    INTERFACES zif_bc_ccm_config.
ENDCLASS.


CLASS zcl_bc_ccm_config IMPLEMENTATION.
  METHOD zif_bc_ccm_config~get_range.
    DATA(values) = zif_bc_ccm_config~get_values( key ).

    LOOP AT values INTO DATA(value).
      INSERT VALUE #( sign   = 'I'
                      option = 'EQ'
                      low    = value ) INTO TABLE result.
    ENDLOOP.
  ENDMETHOD.


  METHOD zif_bc_ccm_config~get_value.
    DATA(values) = zif_bc_ccm_config~get_values( key ).

    TRY.
        result = values[ 1 ].

      CATCH cx_sy_itab_line_not_found.
        CLEAR result.
    ENDTRY.
  ENDMETHOD.


  METHOD zif_bc_ccm_config~get_values.
    SELECT FROM ZBC_I_CCMSettings
      FIELDS SettingValue
      WHERE SettingKey = @key
      INTO TABLE @result.
  ENDMETHOD.
ENDCLASS.
