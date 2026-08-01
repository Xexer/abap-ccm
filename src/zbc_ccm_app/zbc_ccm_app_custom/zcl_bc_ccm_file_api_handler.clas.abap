CLASS zcl_bc_ccm_file_api_handler DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC
  FOR BEHAVIOR OF ZBC_R_CCMCustomAPIs.

  PUBLIC SECTION.
    TYPES valid_types  TYPE RANGE OF zbc_ccm_object_type.
    TYPES message_type TYPE c LENGTH 200.

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

    "! Creates handler and initializes the log
    METHODS constructor.

    "! Loads and processes custom APIs from an Excel file
    "! @parameter config | File data, upload mode, and optional provider override
    METHODS load_excel_file
      IMPORTING config TYPE handle_data.

    "! Loads and processes custom APIs from a JSON file
    "! @parameter config | File data, upload mode, and optional provider override
    METHODS load_json_file
      IMPORTING config TYPE handle_data.

    "! Returns the range of valid ABAP object types (CLAS, INTF, FUNC, DDLS)
    "! @parameter result | Range table of valid object types
    METHODS get_valid_object_types
      RETURNING VALUE(result) TYPE valid_types.

  PRIVATE SECTION.
    "! Validates provider existence and object types of all loaded entries
    "! @parameter provider       | Provider ID to validate against customizing
    "! @parameter loaded_content | Custom API entries to validate
    "! @parameter result         | abap_true if all entries are valid
    METHODS is_valid_input
      IMPORTING provider       TYPE sca_ds_object_provider_id
                loaded_content TYPE zif_bc_ccm_file=>custom_apis
      RETURNING VALUE(result)  TYPE abap_boolean.

    "! Applies provider override and persists custom APIs according to upload mode
    "! @parameter overwrite_provider | Optional provider ID to assign to all entries
    "! @parameter mode               | Upload mode: test (no write), add, or replace
    "! @parameter loaded_content     | Custom API entries to process
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

    IF ( sy-subrc <> 0 OR found_provider IS INITIAL ) AND provider IS NOT INITIAL.
      MESSAGE e012(zbc_ccm) WITH provider INTO log->message.
      log->add_message( ).
      CLEAR result.
    ENDIF.

    DATA(valid_types) = get_valid_object_types( ).

    LOOP AT loaded_content INTO DATA(check_line) WHERE ObjectType NOT IN valid_types.
      MESSAGE e013(zbc_ccm) WITH check_line-ObjectType INTO log->message.
      log->add_message( ).
      CLEAR result.
    ENDLOOP.
  ENDMETHOD.


  METHOD handle_new_apis.
    DATA create_new_apis TYPE TABLE FOR CREATE ZBC_R_CCMCustomAPIs.
    DATA delete_old_apis TYPE TABLE FOR DELETE ZBC_R_CCMCustomAPIs.

    DATA(new_apis) = loaded_content.
    LOOP AT new_apis REFERENCE INTO DATA(new_api).
      IF overwrite_provider IS NOT INITIAL.
        new_api->ProviderID = overwrite_provider.
      ENDIF.

      SELECT SINGLE FROM ZBC_R_CCMCustomAPIs
        FIELDS ProviderID, ObjectType, ObjectName
        WHERE     ProviderID = @new_api->ProviderID
              AND ObjectType = @new_api->ObjectType
              AND ObjectName = @new_api->ObjectName
        INTO @DATA(db_entry)
        PRIVILEGED ACCESS.
      IF ( sy-subrc = 0 OR db_entry IS NOT INITIAL ) AND mode = modes-add.
        MESSAGE e014(zbc_ccm) WITH new_api->ProviderID new_api->ObjectType new_api->ObjectName INTO log->message.
        log->add_message( ).
        CONTINUE.
      ENDIF.

      INSERT VALUE #( %cid             = xco_cp=>uuid( )->value
                      ProviderID       = new_api->ProviderID
                      ObjectType       = new_api->ObjectType
                      ObjectName       = new_api->ObjectName
                      ShortDescription = new_api->ShortDescription )
             INTO TABLE create_new_apis.
    ENDLOOP.

    IF mode = modes-test.
      MESSAGE s016(zbc_ccm) INTO log->message.
      log->add_message( ).
      RETURN.

    ELSEIF mode = modes-replace.
      SELECT FROM ZBC_R_CCMCustomAPIs
        FIELDS ProviderID, ObjectType, ObjectName
        INTO TABLE @DATA(actual_entities)
        PRIVILEGED ACCESS.

      LOOP AT actual_entities INTO DATA(actual_entity).
        INSERT CORRESPONDING #( actual_entity ) INTO TABLE delete_old_apis.
      ENDLOOP.
    ENDIF.

    DATA(number_of_deletes) = lines( delete_old_apis ).
    MESSAGE s017(zbc_ccm) WITH number_of_deletes INTO log->message.
    log->add_message( ).

    DATA(number_of_creates) = lines( create_new_apis ).
    MESSAGE s018(zbc_ccm) WITH number_of_creates INTO log->message.
    log->add_message( ).

    MODIFY ENTITIES OF ZBC_R_CCMCustomAPIs IN LOCAL MODE
           ENTITY CustomAPI
           DELETE FROM delete_old_apis
           ENTITY CustomAPI
           CREATE FIELDS ( ProviderID ObjectType ObjectName ShortDescription )
           WITH create_new_apis
           REPORTED DATA(reported_lines).

    LOOP AT reported_lines-customapi INTO DATA(reported_api).
      DATA(msg) = CONV message_type( reported_api-%msg->if_message~get_text( ) ).
      MESSAGE e015(zbc_ccm) WITH msg+0(50) msg+50(50) msg+100(50) msg+150(50) INTO log->message.
      log->add_message( ).
    ENDLOOP.
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
