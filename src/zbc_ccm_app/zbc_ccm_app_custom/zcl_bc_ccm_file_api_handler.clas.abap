CLASS zcl_bc_ccm_file_api_handler DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC
  FOR BEHAVIOR OF ZBC_R_CCMCustomAPIs.

  PUBLIC SECTION.
    TYPES valid_types TYPE RANGE OF zbc_ccm_object_type.

    TYPES:
      BEGIN OF handle_data,
        overwrite_provider TYPE sca_ds_object_provider_id,
        mode               TYPE zbc_ccm_upload_mode,
        file               TYPE zif_bc_ccm_file=>file,
      END OF handle_data.

    CONSTANTS:
      BEGIN OF modes,
        test    TYPE zbc_ccm_upload_mode VALUE '',
        add     TYPE zbc_ccm_upload_mode VALUE 'A',
        replace TYPE zbc_ccm_upload_mode VALUE 'R',
      END OF modes.

    DATA log TYPE REF TO zif_bc_ccm_mini_log READ-ONLY.

    METHODS constructor.

    METHODS load_excel_file
      IMPORTING config TYPE handle_data.

    METHODS load_json_file
      IMPORTING config TYPE handle_data.

    METHODS get_valid_object_types
      RETURNING VALUE(result) TYPE valid_types.

  PRIVATE SECTION.
    METHODS is_valid_input
      IMPORTING provider       TYPE sca_ds_object_provider_id
                loaded_content TYPE zif_bc_ccm_file=>custom_apis
      RETURNING VALUE(result)  TYPE abap_boolean.

    METHODS handle_new_apis
      IMPORTING overwrite_provider TYPE sca_ds_object_provider_id
                !mode              TYPE zbc_ccm_upload_mode
                loaded_content     TYPE zif_bc_ccm_file=>custom_apis.
ENDCLASS.


CLASS zcl_bc_ccm_file_api_handler IMPLEMENTATION.
  METHOD constructor.
    log = zcl_bc_ccm_mini_log_factory=>create_log( zif_bc_ccm_mini_log=>sub_objects-load_custom ).
  ENDMETHOD.


  METHOD load_excel_file.
    DATA(loaded_content) = zcl_bc_ccm_file_factory=>create_file_excel( )->load_file( config-file ).

    IF NOT is_valid_input( provider       = config-overwrite_provider
                           loaded_content = loaded_content ).
      RETURN.
    ENDIF.

    handle_new_apis( overwrite_provider = config-overwrite_provider
                     mode               = config-mode
                     loaded_content     = loaded_content ).
  ENDMETHOD.


  METHOD load_json_file.
    DATA(loaded_content) = zcl_bc_ccm_file_factory=>create_file_json( )->load_file( config-file ).

    IF NOT is_valid_input( provider       = config-overwrite_provider
                           loaded_content = loaded_content ).
      RETURN.
    ENDIF.

    handle_new_apis( overwrite_provider = config-overwrite_provider
                     mode               = config-mode
                     loaded_content     = loaded_content ).
  ENDMETHOD.


  METHOD is_valid_input.
    result = abap_true.

    SELECT SINGLE FROM ZBC_I_CCMProviderCust
      FIELDS ProviderId
      WHERE ProviderId = @provider
      INTO @DATA(found_provider)
      PRIVILEGED ACCESS.

    IF sy-subrc <> 0 OR found_provider IS INITIAL.
      MESSAGE e012(zbc_ccm) WITH provider INTO log->message.
      log->add_message( ).
      CLEAR result.
    ENDIF.

    DATA(valid_types) = get_valid_object_types( ).

    LOOP AT loaded_content INTO DATA(check_line).
      IF check_line-ObjectType NOT IN valid_types.
        MESSAGE e013(zbc_ccm) WITH check_line-ObjectType INTO log->message.
        log->add_message( ).
        CLEAR result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD handle_new_apis.
    DATA(new_apis) = loaded_content.
    LOOP AT new_apis REFERENCE INTO DATA(new_api).
      IF overwrite_provider IS NOT INITIAL.
        new_api->ProviderID = overwrite_provider.
      ENDIF.

    ENDLOOP.

    IF mode = modes-test.
      RETURN.
    ENDIF.
  ENDMETHOD.


  METHOD get_valid_object_types.
    RETURN VALUE #( sign   = 'I'
                    option = 'EQ'
                    ( low = 'CLAS' )
                    ( low = 'INTF' )
                    ( low = 'FUNC' )
                    ( low = 'DDLS' ) ).
  ENDMETHOD.
ENDCLASS.
