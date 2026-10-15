CLASS zcl_bc_ccm_test_data DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    METHODS constructor.

    METHODS delete_all_data.

    METHODS create_test_data
      IMPORTING create_config TYPE abap_boolean DEFAULT abap_false.

  PRIVATE SECTION.
    TYPES provider_list   TYPE STANDARD TABLE OF zbc_ccm_prov WITH EMPTY KEY.
    TYPES object_list     TYPE STANDARD TABLE OF zbc_ccm_obj WITH EMPTY KEY.
    TYPES message_list    TYPE STANDARD TABLE OF zbc_ccm_msg WITH EMPTY KEY.
    TYPES document_list   TYPE STANDARD TABLE OF zbc_ccm_doc WITH EMPTY KEY.
    TYPES custom_api_list TYPE STANDARD TABLE OF zbc_ccm_custom WITH EMPTY KEY.

    TYPES: BEGIN OF reference,
             obj_type TYPE zbc_ccm_msg-ref_obj_type,
             obj_name TYPE zbc_ccm_msg-ref_obj_name,
           END OF reference.
    TYPES reference_list TYPE STANDARD TABLE OF reference WITH EMPTY KEY.

    TYPES: BEGIN OF atc_message,
             check_name   TYPE zbc_ccm_atcmsg-check_name,
             check_text   TYPE zbc_ccm_atcchk-check_text,
             message_name TYPE zbc_ccm_atcmsg-message_name,
             message_text TYPE zbc_ccm_atcmsg-message_text,
             priority     TYPE zbc_ccm_msg-priority,
             references   TYPE reference_list,
           END OF atc_message.
    TYPES atc_message_list TYPE STANDARD TABLE OF atc_message WITH EMPTY KEY.

    TYPES: BEGIN OF average_debt,
             level_b TYPE zbc_ccm_obj-debt_score,
             level_c TYPE zbc_ccm_obj-debt_score,
             level_d TYPE zbc_ccm_obj-debt_score,
           END OF average_debt.

    TYPES: BEGIN OF level_change,
             level_a TYPE i,
             level_b TYPE i,
             level_c TYPE i,
             level_d TYPE i,
           END OF level_change.

    CONSTANTS random_seed        TYPE i                       VALUE 20261015.
    CONSTANTS runs_per_provider  TYPE i                       VALUE 10.
    CONSTANTS max_messages       TYPE i                       VALUE 8.
    CONSTANTS link_rate          TYPE i                       VALUE 20.
    CONSTANTS custom_api_rate    TYPE i                       VALUE 60.
    CONSTANTS objects_per_scale  TYPE i                       VALUE 100.
    CONSTANTS max_error_findings TYPE i                       VALUE 150.
    CONSTANTS degrading_provider TYPE zbc_ccm_obj-provider_id VALUE 'H01'.

    CONSTANTS: BEGIN OF message_priority,
                 error   TYPE zbc_ccm_msg-priority VALUE 'E',
                 warning TYPE zbc_ccm_msg-priority VALUE 'W',
                 info    TYPE zbc_ccm_msg-priority VALUE 'I',
               END OF message_priority.

    CONSTANTS: BEGIN OF classification,
                 a TYPE zbc_ccm_obj-classification VALUE 'A',
                 b TYPE zbc_ccm_obj-classification VALUE 'B',
                 c TYPE zbc_ccm_obj-classification VALUE 'C',
                 d TYPE zbc_ccm_obj-classification VALUE 'D',
               END OF classification.

    CONSTANTS: BEGIN OF score_weight,
                 info    TYPE i VALUE 1,
                 warning TYPE i VALUE 5,
                 error   TYPE i VALUE 10,
               END OF score_weight.

    CONSTANTS: BEGIN OF atc_check,
                 api_usage   TYPE zbc_ccm_atcmsg-check_name VALUE 'CL_YCM_CC_CHECK_API_USAGE',
                 enhancement TYPE zbc_ccm_atcmsg-check_name VALUE 'CL_CI_TEST_ADMISSIBLE_ENHANCM',
                 critical    TYPE zbc_ccm_atcmsg-check_name VALUE 'CL_CI_TEST_CRITICAL_STATEMENTS',
               END OF atc_check.

    CONSTANTS: BEGIN OF package_area,
                 core       TYPE string VALUE `CORE`,
                 reporting  TYPE string VALUE `REPORTING`,
                 interface  TYPE string VALUE `INTERFACE`,
                 masterdata TYPE string VALUE `MASTERDATA`,
                 process    TYPE string VALUE `PROCESS`,
               END OF package_area.

    DATA random       TYPE REF TO cl_abap_random.
    DATA providers    TYPE provider_list.
    DATA objects      TYPE object_list.
    DATA messages     TYPE message_list.
    DATA atc_messages TYPE atc_message_list.

    METHODS create_config.
    METHODS create_provider.
    METHODS create_atc_customizing.
    METHODS create_objects.
    METHODS create_runs.
    METHODS create_cluster.
    METHODS create_documentation.
    METHODS create_custom.

    METHODS create_object
      IMPORTING provider_id  TYPE zbc_ccm_obj-provider_id
                obj_type     TYPE zbc_ccm_obj-obj_type
                obj_name     TYPE zbc_ccm_obj-obj_name
                package_name TYPE zbc_ccm_obj-package_name.

    METHODS create_messages
      IMPORTING !object       TYPE zbc_ccm_obj
      RETURNING VALUE(result) TYPE message_list.

    METHODS create_message
      IMPORTING !object            TYPE zbc_ccm_obj
                requested_priority TYPE zbc_ccm_msg-priority
      RETURNING VALUE(result)      TYPE zbc_ccm_msg.

    METHODS count_findings
      IMPORTING object_messages TYPE message_list
      CHANGING  !object         TYPE zbc_ccm_obj.

    METHODS limit_error_findings
      IMPORTING selected_provider TYPE zbc_ccm_obj-provider_id.

    METHODS replace_with_warning
      IMPORTING message_index TYPE i.

    METHODS get_classification
      IMPORTING !object       TYPE zbc_ccm_obj
      RETURNING VALUE(result) TYPE zbc_ccm_obj-classification.

    METHODS calculate_debt_score
      IMPORTING !object       TYPE zbc_ccm_obj
      RETURNING VALUE(result) TYPE zbc_ccm_obj-debt_score.

    METHODS get_highest_priority
      IMPORTING degrading     TYPE abap_boolean
      RETURNING VALUE(result) TYPE zbc_ccm_msg-priority.

    METHODS is_degrading
      IMPORTING selected_provider TYPE zbc_ccm_obj-provider_id
      RETURNING VALUE(result)     TYPE abap_boolean.

    METHODS get_random_priority
      IMPORTING highest_priority TYPE zbc_ccm_msg-priority
      RETURNING VALUE(result)    TYPE zbc_ccm_msg-priority.

    METHODS build_object_name
      IMPORTING obj_type      TYPE csequence
                !area         TYPE csequence
                topic         TYPE csequence
      RETURNING VALUE(result) TYPE zbc_ccm_obj-obj_name.

    METHODS get_object_count
      IMPORTING selected_provider TYPE zbc_ccm_obj-provider_id
      RETURNING VALUE(result)     TYPE i.

    METHODS calculate_current_score
      IMPORTING selected_provider TYPE zbc_ccm_obj-provider_id
      RETURNING VALUE(result)     TYPE zbc_ccm_score.

    METHODS calculate_average_debt
      IMPORTING selected_provider TYPE zbc_ccm_obj-provider_id
      RETURNING VALUE(result)     TYPE average_debt.

    METHODS get_average_debt_for_level
      IMPORTING selected_provider TYPE zbc_ccm_obj-provider_id
                !level            TYPE zbc_ccm_obj-classification
      RETURNING VALUE(result)     TYPE zbc_ccm_obj-debt_score.

    METHODS get_previous_score
      IMPORTING !score        TYPE zbc_ccm_score
                average_debt  TYPE average_debt
                degrading     TYPE abap_boolean
                !scale        TYPE i
      RETURNING VALUE(result) TYPE zbc_ccm_score.

    METHODS get_improving_change
      RETURNING VALUE(result) TYPE level_change.

    METHODS get_degrading_change
      RETURNING VALUE(result) TYPE level_change.

    METHODS get_run_date
      IMPORTING months_back   TYPE i
      RETURNING VALUE(result) TYPE d.

    METHODS get_run_time
      IMPORTING run_date      TYPE d
                hour          TYPE i
      RETURNING VALUE(result) TYPE utclong.

    METHODS get_atc_messages
      RETURNING VALUE(result) TYPE atc_message_list.

    METHODS get_topics
      RETURNING VALUE(result) TYPE string_table.

    METHODS get_object_types
      RETURNING VALUE(result) TYPE string_table.

    METHODS get_package_areas
      RETURNING VALUE(result) TYPE string_table.

    METHODS get_random_developer
      RETURNING VALUE(result) TYPE zbc_ccm_obj-person_responsible.

    METHODS get_documents
      RETURNING VALUE(result) TYPE document_list.

    METHODS get_custom_api_templates
      RETURNING VALUE(result) TYPE custom_api_list.

    METHODS random_number
      IMPORTING !low          TYPE i
                !high         TYPE i
      RETURNING VALUE(result) TYPE i.
ENDCLASS.


CLASS zcl_bc_ccm_test_data IMPLEMENTATION.
  METHOD constructor.
    random = cl_abap_random=>create( random_seed ).
    atc_messages = get_atc_messages( ).
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    delete_all_data( ).
    create_test_data( abap_false ).
  ENDMETHOD.


  METHOD delete_all_data.
    DELETE FROM zbc_ccm_prov.
    DELETE FROM zbc_ccm_run.
    DELETE FROM zbc_ccm_score.
    DELETE FROM zbc_ccm_clstr.
    DELETE FROM zbc_ccm_cassign.
    DELETE FROM zbc_ccm_obj.
    DELETE FROM zbc_ccm_msg.
    DELETE FROM zbc_ccm_doc.
    DELETE FROM zbc_ccm_dlink.
    DELETE FROM zbc_ccm_custom.

    COMMIT WORK.
  ENDMETHOD.


  METHOD create_test_data.
    IF create_config = abap_true.
      create_config( ).
    ENDIF.

    CLEAR: providers, objects, messages.

    create_atc_customizing( ).
    create_provider( ).
    create_objects( ).
    create_runs( ).
    create_cluster( ).
    create_documentation( ).
    create_custom( ).

    COMMIT WORK.
  ENDMETHOD.


  METHOD create_config.
    DATA settings TYPE STANDARD TABLE OF zbc_ccm_sett WITH EMPTY KEY.

    settings = VALUE #( ( setting_uuid  = xco_cp=>uuid( )->value
                          setting_key   = zif_bc_ccm_config=>config_option-default_score_d
                          setting_value = '10' )
                        ( setting_uuid  = xco_cp=>uuid( )->value
                          setting_key   = zif_bc_ccm_config=>config_option-default_score_c
                          setting_value = '5' )
                        ( setting_uuid  = xco_cp=>uuid( )->value
                          setting_key   = zif_bc_ccm_config=>config_option-default_score_b
                          setting_value = '1' )
                        ( setting_uuid  = xco_cp=>uuid( )->value
                          setting_key   = zif_bc_ccm_config=>config_option-default_atc_variant
                          setting_value = 'ABAP_CLEAN_CORE_READINESS' )
                        ( setting_uuid  = xco_cp=>uuid( )->value
                          setting_key   = zif_bc_ccm_config=>config_option-include_level_c_findings
                          setting_value = '' )
                        ( setting_uuid  = xco_cp=>uuid( )->value
                          setting_key   = zif_bc_ccm_config=>config_option-test_mode
                          setting_value = 'X' )
                        ( setting_uuid  = xco_cp=>uuid( )->value
                          setting_key   = zif_bc_ccm_config=>config_option-period_unit
                          setting_value = 'M' )
                        ( setting_uuid  = xco_cp=>uuid( )->value
                          setting_key   = zif_bc_ccm_config=>config_option-mail_sender
                          setting_value = '' )
                        ( setting_uuid  = xco_cp=>uuid( )->value
                          setting_key   = zif_bc_ccm_config=>config_option-mail_receiver
                          setting_value = '' ) ).

    DELETE FROM zbc_ccm_sett.
    INSERT zbc_ccm_sett FROM TABLE @settings.
  ENDMETHOD.


  METHOD create_provider.
    providers = VALUE #( active      = abap_true
                         only_scores = abap_false
                         ( provider_id = 'F01' group_id = 'FI' system_name = 'Finance' )
                         ( provider_id = 'C01' group_id = 'CO' system_name = 'Controlling' )
                         ( provider_id = 'R01' group_id = 'RE' system_name = 'Retail' )
                         ( provider_id = 'W01' group_id = 'TM' system_name = 'Warehouse' )
                         ( provider_id = 'H01' group_id = 'HR' system_name = 'Human Resources' ) ).

    LOOP AT providers REFERENCE INTO DATA(provider).
      provider->ccap_id = to_lower( xco_cp=>uuid( )->as( xco_cp_uuid=>format->c36 )->value ).
    ENDLOOP.

    INSERT zbc_ccm_prov FROM TABLE @providers.
  ENDMETHOD.


  METHOD create_atc_customizing.
    DATA timestamp           TYPE timestampl.
    DATA checks              TYPE STANDARD TABLE OF zbc_ccm_atcchk WITH EMPTY KEY.
    DATA customized_messages TYPE STANDARD TABLE OF zbc_ccm_atcmsg WITH EMPTY KEY.

    GET TIME STAMP FIELD timestamp.
    DATA(user) = cl_abap_context_info=>get_user_technical_name( ).

    LOOP AT atc_messages INTO DATA(atc_message).
      IF NOT line_exists( checks[ check_name = atc_message-check_name ] ).
        INSERT VALUE #( check_name = atc_message-check_name
                        check_text = atc_message-check_text )
               INTO TABLE checks.
      ENDIF.

      INSERT VALUE #( check_name            = atc_message-check_name
                      message_name          = atc_message-message_name
                      message_text          = atc_message-message_text
                      auto_approval_setting = COND #( WHEN atc_message-priority = message_priority-info
                                                      THEN zcl_bc_ccm_approve=>approver_option-approve )
                      local_created_by      = user
                      local_created_at      = timestamp
                      local_last_changed_by = user
                      local_last_changed_at = timestamp
                      last_changed_at       = timestamp )
             INTO TABLE customized_messages.
    ENDLOOP.

    INSERT zbc_ccm_atcchk FROM TABLE @checks ACCEPTING DUPLICATE KEYS.
    INSERT zbc_ccm_atcmsg FROM TABLE @customized_messages ACCEPTING DUPLICATE KEYS.
  ENDMETHOD.


  METHOD get_atc_messages.
    result = VALUE #( check_name = atc_check-api_usage
                      check_text = 'Usage of Released APIs'
                      ( message_name = 'NOAPI'
                        message_text = 'Usage of not released API'
                        priority     = message_priority-error
                        references   = VALUE #( ( obj_type = 'TABL' obj_name = 'T001' )
                                                ( obj_type = 'TABL' obj_name = 'BKPF' )
                                                ( obj_type = 'TABL' obj_name = 'MARA' )
                                                ( obj_type = 'TABL' obj_name = 'PA0001' )
                                                ( obj_type = 'FUNC' obj_name = 'RFC_READ_TABLE' ) ) )
                      ( message_name = 'NOAPI_SUC'
                        message_text = 'Not released API with released successor'
                        priority     = message_priority-error
                        references   = VALUE #( ( obj_type = 'TABL' obj_name = 'KNA1' )
                                                ( obj_type = 'TABL' obj_name = 'LFA1' )
                                                ( obj_type = 'FUNC' obj_name = 'RFC_READ_TABLE' )
                                                ( obj_type = 'FUNC' obj_name = 'BAPI_ACC_DOCUMENT_POST' )
                                                ( obj_type = 'FUNC' obj_name = 'HR_READ_INFOTYPE' ) ) )
                      ( message_name = 'INTRNL'
                        message_text = 'Usage of internal SAP API'
                        priority     = message_priority-warning
                        references   = VALUE #( obj_type = 'CLAS'
                                                ( obj_name = 'CX_SDS_FILE_ERROR' )
                                                ( obj_name = 'CL_GUI_FRONTEND_SERVICES' )
                                                ( obj_name = 'CL_SALV_TABLE' ) ) )
                      ( message_name = 'DEPRECATD'
                        message_text = 'Usage of deprecated API'
                        priority     = message_priority-warning
                        references   = VALUE #( obj_type = 'FUNC'
                                                ( obj_name = 'POPUP_TO_CONFIRM' )
                                                ( obj_name = 'GUI_UPLOAD' )
                                                ( obj_name = 'REUSE_ALV_GRID_DISPLAY' ) ) )
                      ( message_name = 'CLSSIC_SUC'
                        message_text = 'Classic API with released successor'
                        priority     = message_priority-warning
                        references   = VALUE #( obj_type = 'FUNC'
                                                ( obj_name = 'BAPI_PO_CREATE1' )
                                                ( obj_name = 'BAPI_SALESORDER_CREATEFROMDAT2' )
                                                ( obj_name = 'BAPI_MATERIAL_SAVEDATA' ) ) )
                      ( message_name = 'CLSSIC'
                        message_text = 'Usage of classic API'
                        priority     = message_priority-info
                        references   = VALUE #( ( obj_type = 'TABL' obj_name = 'BUT000' )
                                                ( obj_type = 'FUNC' obj_name = 'BAPI_TRANSACTION_COMMIT' )
                                                ( obj_type = 'FUNC' obj_name = 'CONVERSION_EXIT_ALPHA_INPUT' )
                                                ( obj_type = 'CLAS' obj_name = 'CL_BCS' ) ) )
                      check_name = atc_check-enhancement
                      check_text = 'Admissible Enhancement Technologies'
                      ( message_name = 'ENHINVALD'
                        message_text = 'Enhancement technology not admissible'
                        priority     = message_priority-warning
                        references   = VALUE #( ( obj_type = 'N/A' obj_name = 'N/A' ) ) )
                      ( message_name = 'IMPLCT_ENH'
                        message_text = 'Implicit enhancement of SAP code'
                        priority     = message_priority-warning
                        references   = VALUE #( obj_type = 'PROG'
                                                ( obj_name = 'SAPLMEPO' )
                                                ( obj_name = 'SAPMV45A' ) ) )
                      ( message_name = 'MODIFICAT'
                        message_text = 'Modification of SAP object'
                        priority     = message_priority-error
                        references   = VALUE #( obj_type = 'PROG'
                                                ( obj_name = 'MV45AFZZ' )
                                                ( obj_name = 'RV60AFZZ' ) ) )
                      check_name = atc_check-critical
                      check_text = 'Critical Statements'
                      ( message_name = '001'
                        message_text = 'Call of critical function module'
                        priority     = message_priority-warning
                        references   = VALUE #( obj_type = 'FUNC'
                                                ( obj_name = 'SXPG_COMMAND_EXECUTE' )
                                                ( obj_name = 'TH_SERVER_LIST' ) ) )
                      ( message_name = 'SBMT_PROG'
                        message_text = 'SUBMIT of a report'
                        priority     = message_priority-warning
                        references   = VALUE #( obj_type = 'PROG'
                                                ( obj_name = 'RFBIBL00' )
                                                ( obj_name = 'RM07DOCS' )
                                                ( obj_name = 'RHINTE00' ) ) )
                      ( message_name = 'NATIVE_SQL'
                        message_text = 'Usage of Native SQL'
                        priority     = message_priority-error
                        references   = VALUE #( ( obj_type = 'N/A' obj_name = 'N/A' ) ) )
                      ( message_name = 'SYS_CALL'
                        message_text = 'Usage of system call'
                        priority     = message_priority-error
                        references   = VALUE #( ( obj_type = 'N/A' obj_name = 'N/A' ) ) )
                      ( message_name = 'DB_COMMIT'
                        message_text = 'Explicit database commit'
                        priority     = message_priority-info
                        references   = VALUE #( ( obj_type = 'N/A' obj_name = 'N/A' ) ) ) ).
  ENDMETHOD.


  METHOD create_runs.
    DATA runs   TYPE STANDARD TABLE OF zbc_ccm_run WITH EMPTY KEY.
    DATA scores TYPE STANDARD TABLE OF zbc_ccm_score WITH EMPTY KEY.

    LOOP AT providers INTO DATA(provider).
      DATA(run_hour) = 5 + sy-tabix.
      DATA(score) = calculate_current_score( provider-provider_id ).
      DATA(average_debt) = calculate_average_debt( provider-provider_id ).
      DATA(degrading) = is_degrading( provider-provider_id ).
      DATA(scale) = nmax( val1 = 1
                          val2 = get_object_count( provider-provider_id ) DIV objects_per_scale ).

      DO runs_per_provider TIMES.
        DATA(run_date) = get_run_date( sy-index - 1 ).

        INSERT VALUE #( run_id      = xco_cp=>uuid( )->value
                        provider_id = provider-provider_id
                        run_period  = |{ run_date+2(2) }/{ run_date+4(2) }|
                        run_time    = get_run_time( run_date = run_date
                                                    hour     = run_hour )
                        run_status  = 'F' )
               INTO TABLE runs REFERENCE INTO DATA(run).

        score-run_id = run->run_id.
        INSERT score INTO TABLE scores.

        score = get_previous_score( score        = score
                                    average_debt = average_debt
                                    degrading    = degrading
                                    scale        = scale ).
      ENDDO.
    ENDLOOP.

    INSERT zbc_ccm_run FROM TABLE @runs.
    INSERT zbc_ccm_score FROM TABLE @scores.
  ENDMETHOD.


  METHOD calculate_current_score.
    result-calculate_method = zif_bc_scoring=>calculation_methods-standard.
    result-key_user_objects = random_number( low  = 20
                                             high = 60 ).

    LOOP AT objects INTO DATA(object) WHERE provider_id = selected_provider.
      CASE object-classification.
        WHEN classification-a.
          result-level_a += 1.
        WHEN classification-b.
          result-level_b += 1.
        WHEN classification-c.
          result-level_c += 1.
        WHEN classification-d.
          result-level_d += 1.
      ENDCASE.

      result-debt_score += object-debt_score.
    ENDLOOP.
  ENDMETHOD.


  METHOD calculate_average_debt.
    RETURN VALUE #( level_b = get_average_debt_for_level( selected_provider = selected_provider
                                                          level             = classification-b )
                    level_c = get_average_debt_for_level( selected_provider = selected_provider
                                                          level             = classification-c )
                    level_d = get_average_debt_for_level( selected_provider = selected_provider
                                                          level             = classification-d ) ).
  ENDMETHOD.


  METHOD get_average_debt_for_level.
    DATA total_debt   TYPE zbc_ccm_obj-debt_score.
    DATA object_count TYPE i.

    LOOP AT objects INTO DATA(object) WHERE provider_id = selected_provider AND classification = level.
      total_debt += object-debt_score.
      object_count += 1.
    ENDLOOP.

    IF object_count > 0.
      result = total_debt DIV object_count.
    ENDIF.
  ENDMETHOD.


  METHOD get_previous_score.
    DATA(change) = COND #( WHEN degrading = abap_true
                           THEN get_degrading_change( )
                           ELSE get_improving_change( ) ).

    result = score.
    result-level_a          = nmax( val1 = 0
                                    val2 = score-level_a + change-level_a * scale ).
    result-level_b          = nmax( val1 = 0
                                    val2 = score-level_b + change-level_b * scale ).
    result-level_c          = nmax( val1 = 0
                                    val2 = score-level_c + change-level_c * scale ).
    result-level_d          = nmax( val1 = 0
                                    val2 = score-level_d + change-level_d * scale ).
    result-key_user_objects = nmax( val1 = 0
                                    val2 = score-key_user_objects - random_number( low  = 0
                                                                                   high = 4 ) ).

    result-debt_score       = nmax( val1 = 0
                                    val2 = result-level_b * average_debt-level_b
                                         + result-level_c * average_debt-level_c
                                         + result-level_d * average_debt-level_d
                                         + random_number( low  = -20
                                                          high = 20 ) ).
  ENDMETHOD.


  METHOD get_improving_change.
    RETURN VALUE #( level_a = - random_number( low  = 0
                                               high = 3 )
                    level_b = - random_number( low  = -1
                                               high = 3 )
                    level_c = - random_number( low  = -1
                                               high = 5 )
                    level_d = random_number( low  = -1
                                             high = 3 ) ).
  ENDMETHOD.


  METHOD get_degrading_change.
    RETURN VALUE #( level_a = random_number( low  = -1
                                             high = 2 )
                    level_b = random_number( low  = -1
                                             high = 2 )
                    level_c = - random_number( low  = -1
                                               high = 3 )
                    level_d = - random_number( low  = 1
                                               high = 5 ) ).
  ENDMETHOD.


  METHOD get_run_date.
    DATA(today) = cl_abap_context_info=>get_system_date( ).
    DATA(month_index) = CONV i( today(4) ) * 12 + CONV i( today+4(2) ) - 1 - months_back.

    RETURN |{ month_index DIV 12 WIDTH = 4 ALIGN = RIGHT PAD = '0' }{ month_index MOD 12 + 1 WIDTH = 2 ALIGN = RIGHT PAD = '0' }01|.
  ENDMETHOD.


  METHOD get_run_time.
    DATA(run_clock) = CONV t( hour * 3600 + 1800 ).

    CONVERT DATE run_date TIME run_clock INTO UTCLONG result TIME ZONE 'UTC'.
  ENDMETHOD.


  METHOD create_cluster.
    DATA clusters TYPE STANDARD TABLE OF zbc_ccm_clstr WITH EMPTY KEY.
    DATA assigns  TYPE STANDARD TABLE OF zbc_ccm_cassign WITH EMPTY KEY.

    DATA(package_areas) = get_package_areas( ).
    DATA(core_team) = xco_cp=>uuid( )->value.

    INSERT VALUE #( cluster_id   = core_team
                    cluster_name = 'Core Team' )
           INTO TABLE clusters.

    LOOP AT providers INTO DATA(provider).
      DATA(provider_team) = xco_cp=>uuid( )->value.

      INSERT VALUE #( cluster_id   = provider_team
                      cluster_name = |Developer { provider-system_name }| )
             INTO TABLE clusters.

      LOOP AT package_areas INTO DATA(area) WHERE table_line <> package_area-masterdata.
        INSERT VALUE #( object_id   = xco_cp=>uuid( )->value
                        provider_id = provider-provider_id
                        obj_type    = 'DEVC'
                        obj_name    = |Z{ provider-group_id }_{ area }|
                        cluster_id  = COND #( WHEN area = package_area-core THEN core_team ELSE provider_team ) )
               INTO TABLE assigns.
      ENDLOOP.
    ENDLOOP.

    INSERT zbc_ccm_clstr FROM TABLE @clusters.
    INSERT zbc_ccm_cassign FROM TABLE @assigns.
  ENDMETHOD.


  METHOD create_objects.
    DATA(topics) = get_topics( ).
    DATA(object_types) = get_object_types( ).
    DATA(package_areas) = get_package_areas( ).

    LOOP AT providers INTO DATA(provider).
      DATA(object_count) = get_object_count( provider-provider_id ).

      DO object_count TIMES.
        DATA(combination) = sy-index - 1.
        DATA(type_index) = combination MOD lines( object_types ) + 1.
        DATA(topic_index) = ( combination DIV lines( object_types ) ) MOD lines( topics ) + 1.
        DATA(variant) = combination DIV ( lines( object_types ) * lines( topics ) ).
        DATA(area_index) = ( topic_index - 1 ) MOD lines( package_areas ) + 1.

        DATA(topic) = COND string( WHEN variant = 0
                                   THEN topics[ topic_index ]
                                   ELSE |{ topics[ topic_index ] }_{ variant + 1 }| ).

        create_object( provider_id  = provider-provider_id
                       obj_type     = CONV #( object_types[ type_index ] )
                       obj_name     = build_object_name( obj_type = object_types[ type_index ]
                                                         area     = provider-group_id
                                                         topic    = topic )
                       package_name = CONV #( |Z{ provider-group_id }_{ package_areas[ area_index ] }| ) ).
      ENDDO.

      limit_error_findings( provider-provider_id ).
    ENDLOOP.

    INSERT zbc_ccm_obj FROM TABLE @objects.
    INSERT zbc_ccm_msg FROM TABLE @messages.
  ENDMETHOD.


  METHOD limit_error_findings.
    DATA error_positions TYPE STANDARD TABLE OF i WITH EMPTY KEY.

    LOOP AT messages TRANSPORTING NO FIELDS WHERE     provider_id = selected_provider
                                                  AND priority    = message_priority-error.
      INSERT sy-tabix INTO TABLE error_positions.
    ENDLOOP.

    WHILE lines( error_positions ) > max_error_findings.
      DATA(position_index) = random_number( low  = 1
                                            high = lines( error_positions ) ).

      replace_with_warning( error_positions[ position_index ] ).
      DELETE error_positions INDEX position_index.
    ENDWHILE.
  ENDMETHOD.


  METHOD replace_with_warning.
    DATA(message) = REF #( messages[ message_index ] ).
    DATA(object) = REF #( objects[ provider_id = message->provider_id
                                   obj_type    = message->obj_type
                                   obj_name    = message->obj_name ] ).

    message->* = create_message( object             = object->*
                                 requested_priority = message_priority-warning ).

    object->number_error   -= 1.
    object->number_warning += 1.
    object->classification  = get_classification( object->* ).
    object->debt_score      = calculate_debt_score( object->* ).
  ENDMETHOD.


  METHOD create_object.
    DATA(object) = VALUE zbc_ccm_obj( provider_id        = provider_id
                                      obj_type           = obj_type
                                      obj_name           = obj_name
                                      package_name       = package_name
                                      person_responsible = get_random_developer( ) ).

    DATA(object_messages) = create_messages( object ).

    count_findings( EXPORTING object_messages = object_messages
                    CHANGING  object          = object ).

    object-classification = get_classification( object ).
    object-debt_score     = calculate_debt_score( object ).

    INSERT object INTO TABLE objects.
    INSERT LINES OF object_messages INTO TABLE messages.
  ENDMETHOD.


  METHOD create_messages.
    DATA(highest_priority) = get_highest_priority( is_degrading( object-provider_id ) ).
    IF highest_priority IS INITIAL.
      RETURN.
    ENDIF.

    INSERT create_message( object             = object
                           requested_priority = highest_priority )
           INTO TABLE result.

    DATA(additional_messages) = random_number( low  = 0
                                               high = max_messages - 1 ).

    DO additional_messages TIMES.
      INSERT create_message( object             = object
                             requested_priority = get_random_priority( highest_priority ) )
             INTO TABLE result.
    ENDDO.

    DATA(warning_count) = REDUCE i( INIT count = 0
                                    FOR message IN result WHERE ( priority = message_priority-warning )
                                    NEXT count += 1 ).

    DO warning_count TIMES.
      INSERT create_message( object             = object
                             requested_priority = message_priority-warning )
             INTO TABLE result.
    ENDDO.
  ENDMETHOD.


  METHOD create_message.
    DATA(candidates) = VALUE atc_message_list( FOR candidate IN atc_messages
                                               WHERE ( priority = requested_priority )
                                               ( candidate ) ).

    DATA(message_index) = random_number( low  = 1
                                         high = lines( candidates ) ).
    DATA(atc_message) = candidates[ message_index ].

    DATA(reference_index) = random_number( low  = 1
                                           high = lines( atc_message-references ) ).
    DATA(reference) = atc_message-references[ reference_index ].

    RETURN VALUE #( provider_id   = object-provider_id
                    obj_type      = object-obj_type
                    obj_name      = object-obj_name
                    finding_id    = xco_cp=>uuid( )->value
                    priority      = atc_message-priority
                    check_name    = atc_message-check_name
                    message_name  = atc_message-message_name
                    check_title   = atc_message-check_text
                    check_message = atc_message-message_text
                    ref_obj_type  = reference-obj_type
                    ref_obj_name  = reference-obj_name ).
  ENDMETHOD.


  METHOD count_findings.
    LOOP AT object_messages INTO DATA(message).
      CASE message-priority.
        WHEN message_priority-error.
          object-number_error += 1.
        WHEN message_priority-warning.
          object-number_warning += 1.
        WHEN message_priority-info.
          object-number_info += 1.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_classification.
    IF object-number_error > 0.
      RETURN classification-d.
    ELSEIF object-number_warning > 0.
      RETURN classification-c.
    ELSEIF object-number_info > 0.
      RETURN classification-b.
    ENDIF.

    RETURN classification-a.
  ENDMETHOD.


  METHOD calculate_debt_score.
    RETURN object-number_error * score_weight-error
         + object-number_warning * score_weight-warning
         + object-number_info * score_weight-info.
  ENDMETHOD.


  METHOD get_highest_priority.
    DATA(percentage) = random_number( low  = 1
                                      high = 100 ).

    IF degrading = abap_true.
      RETURN COND #( WHEN percentage <= 8  THEN VALUE #( )
                     WHEN percentage <= 20 THEN message_priority-info
                     WHEN percentage <= 55 THEN message_priority-warning
                     ELSE                       message_priority-error ).
    ENDIF.

    RETURN COND #( WHEN percentage <= 15 THEN VALUE #( )
                   WHEN percentage <= 40 THEN message_priority-info
                   WHEN percentage <= 85 THEN message_priority-warning
                   ELSE                       message_priority-error ).
  ENDMETHOD.


  METHOD is_degrading.
    RETURN xsdbool( selected_provider = degrading_provider ).
  ENDMETHOD.


  METHOD get_random_priority.
    DATA(severity_levels) = SWITCH i( highest_priority
                                      WHEN message_priority-error   THEN 3
                                      WHEN message_priority-warning THEN 2
                                      ELSE                               1 ).

    RETURN SWITCH #( random_number( low  = 1
                                    high = severity_levels )
                     WHEN 3 THEN message_priority-error
                     WHEN 2 THEN message_priority-warning
                     ELSE        message_priority-info ).
  ENDMETHOD.


  METHOD build_object_name.
    RETURN SWITCH #( obj_type
                     WHEN 'CLAS' THEN |ZCL_{ area }_{ topic }|
                     WHEN 'INTF' THEN |ZIF_{ area }_{ topic }|
                     WHEN 'DDLS' THEN |Z{ area }_I_{ topic }|
                     WHEN 'PROG' THEN |Z{ area }_R_{ topic }|
                     ELSE             |Z{ area }_{ topic }| ).
  ENDMETHOD.


  METHOD get_object_count.
    RETURN SWITCH #( selected_provider
                     WHEN 'F01' OR 'C01' THEN 500
                     WHEN 'H01'          THEN 250
                     ELSE                     100 ).
  ENDMETHOD.


  METHOD get_topics.
    RETURN VALUE #( ( `BOOKING` )
                    ( `POSTING` )
                    ( `DOCUMENT` )
                    ( `PARTNER` )
                    ( `MASTER` )
                    ( `REPORT` )
                    ( `EXPORT` )
                    ( `IMPORT` )
                    ( `UPLOAD` )
                    ( `VALIDATE` )
                    ( `MAPPING` )
                    ( `NOTIFY` )
                    ( `ARCHIVE` )
                    ( `CALC` )
                    ( `ANALYTICS` )
                    ( `WORKFLOW` )
                    ( `PRINT` )
                    ( `AUDIT` )
                    ( `CONFIG` )
                    ( `HELPER` )
                    ( `PLANNING` )
                    ( `BATCH` ) ).
  ENDMETHOD.


  METHOD get_object_types.
    RETURN VALUE #( ( `CLAS` ) ( `INTF` ) ( `DDLS` ) ( `PROG` ) ( `FUGR` ) ).
  ENDMETHOD.


  METHOD get_package_areas.
    RETURN VALUE #( ( package_area-core )
                    ( package_area-reporting )
                    ( package_area-interface )
                    ( package_area-masterdata )
                    ( package_area-process ) ).
  ENDMETHOD.


  METHOD get_random_developer.
    DATA(developers) = VALUE string_table( ( `MMILLER` )
                                           ( `SSCHMIDT` )
                                           ( `JJOHNSON` )
                                           ( `KWAGNER` )
                                           ( `LGARCIA` )
                                           ( `TNGUYEN` ) ).

    DATA(developer_index) = random_number( low  = 1
                                           high = lines( developers ) ).

    RETURN developers[ developer_index ].
  ENDMETHOD.


  METHOD create_documentation.
    DATA links TYPE STANDARD TABLE OF zbc_ccm_dlink WITH EMPTY KEY.

    DATA(documents) = get_documents( ).

    LOOP AT objects INTO DATA(object).
      IF random_number( low  = 1
                        high = 100 ) > link_rate.
        CONTINUE.
      ENDIF.

      DATA(document_index) = random_number( low  = 1
                                            high = lines( documents ) ).

      INSERT VALUE #( link_id     = xco_cp=>uuid( )->value
                      provider_id = object-provider_id
                      obj_type    = object-obj_type
                      obj_name    = object-obj_name
                      document_id = documents[ document_index ]-document_id )
             INTO TABLE links.
    ENDLOOP.

    LOOP AT providers INTO DATA(provider).
      INSERT VALUE #( link_id     = xco_cp=>uuid( )->value
                      provider_id = provider-provider_id
                      obj_type    = 'DEVC'
                      obj_name    = |Z{ provider-group_id }_{ package_area-core }|
                      document_id = documents[ 2 ]-document_id )
             INTO TABLE links.
    ENDLOOP.

    INSERT zbc_ccm_doc FROM TABLE @documents.
    INSERT zbc_ccm_dlink FROM TABLE @links.
  ENDMETHOD.


  METHOD get_documents.
    result = VALUE #(
        ( short_description = 'QP-1012: Financial Enhancement'
          long_description  = |<p>The company code table <strong>T001</strong> was extended with <em>additional customer fields</em> |
                           && |to support the <u>local tax reporting</u> in the subsidiaries.</p>|
                           && |<p><strong>Background:</strong> The standard did not offer the required fields at the time of the |
                           && |implementation. The fields are filled by a <em>BAdI implementation</em> during the posting process.</p>|
                           && |<p><u>Clean Core Assessment:</u> The extension uses a <strong>classic append structure</strong> and |
                           && |is therefore classified as <em>not upgrade-stable</em>. A replacement with <strong>Key User Extensibility</strong> |
                           && |(custom fields) is planned for the next release wave.</p>| )
        ( short_description = 'QP-1015: File System'
          long_description  = |<p>The <strong>core classes for file handling</strong> encapsulate the upload, download and archiving of |
                           && |files on the application server.</p>|
                           && |<p><strong>Reason for deviation:</strong> The access to the file system is only possible with |
                           && |<em>not released APIs</em>. There is <u>no released successor</u> available for the on-premise system.</p>|
                           && |<p><u>Decision:</u> The architecture board accepted the findings with a <strong>reduced score</strong>, |
                           && |because all accesses are <em>centralized in one package</em> and can be replaced in a single step.</p>|
          custom_score      = abap_true
          deviating_score_b = 1
          deviating_score_c = 2
          deviating_score_d = 3 )
        ( short_description = 'QP-1020: Legacy Banking Interfaces'
          long_description  = |<p>The <strong>interfaces to the house banks</strong> are implemented with classic function modules |
                           && |and <em>file based communication</em>.</p>|
                           && |<p><strong>Current state:</strong> Payment files are created by <u>custom reports</u> and transferred |
                           && |by a middleware. Bank statements are imported in the night via <em>background jobs</em>.</p>|
                           && |<p><u>Roadmap:</u> All interfaces will be replaced by the <strong>new payment hub</strong>. Until then |
                           && |the findings are rated with a <em>deviating score</em> to avoid distortion of the KPI.</p>|
          custom_score      = abap_true
          deviating_score_b = 0
          deviating_score_c = 2
          deviating_score_d = 5 )
        ( short_description = 'QP-1031: Controlling Allocation Cycle'
          long_description  = |<p>The <strong>monthly allocation cycle</strong> distributes the costs of the shared service |
                           && |cost centers to the <em>profit centers</em> of the business units.</p>|
                           && |<p><strong>Custom logic:</strong> The distribution keys are calculated by a <u>custom program</u> |
                           && |based on headcount and floor space. The results are stored in a <em>custom table</em>.</p>|
                           && |<p><u>Next steps:</u> Evaluate the standard <strong>allocation with statistical key figures</strong> |
                           && |to remove the custom calculation completely.</p>| )
        ( short_description = 'QP-1044: Retail Price Calculation'
          long_description  = |<p>The <strong>sales price calculation</strong> for articles in the stores uses a <em>custom pricing |
                           && |engine</em> with special rules for promotions and regional prices.</p>|
                           && |<p><strong>Reason for deviation:</strong> The pricing engine accesses the condition tables |
                           && |<u>directly on the database</u> to reach the required performance during the night run.</p>|
                           && |<p><u>Agreement:</u> The findings are accepted with a <strong>deviating score</strong> until the |
                           && |<em>new pricing service</em> is available in the cloud.</p>|
          custom_score      = abap_true
          deviating_score_b = 1
          deviating_score_c = 3
          deviating_score_d = 6 )
        ( short_description = 'QP-1050: Warehouse Label Printing'
          long_description  = |<p>Labels for <strong>handling units</strong> and <strong>pallets</strong> are printed with |
                           && |<em>classic print programs</em> and SAPscript forms.</p>|
                           && |<p><strong>Problem:</strong> The forms use <u>not released function modules</u> and direct |
                           && |printer commands for the barcode generation.</p>|
                           && |<p><u>Solution:</u> Migration to <strong>Adobe Forms</strong> with the <em>output management</em> |
                           && |of the warehouse is planned in the second quarter.</p>| )
        ( short_description = 'QP-1063: HR Payroll Extensions'
          long_description  = |<p>The <strong>payroll schema</strong> was extended with <em>custom rules and operations</em> to |
                           && |cover the collective wage agreements.</p>|
                           && |<p><strong>Reason for deviation:</strong> The payroll framework only offers <u>classic enhancement |
                           && |techniques</u>. Additional infotypes are read with <em>not released function modules</em>.</p>|
                           && |<p><u>Decision:</u> Because of the <strong>legal requirements</strong> the extensions cannot be |
                           && |removed. The findings are rated with a <em>reduced score</em>.</p>|
          custom_score      = abap_true
          deviating_score_b = 0
          deviating_score_c = 1
          deviating_score_d = 4 )
        ( short_description = 'QP-1071: Reporting with Classic ALV'
          long_description  = |<p>Many <strong>classic reports</strong> with <em>ALV grid output</em> are still used by the |
                           && |business departments.</p>|
                           && |<p><strong>Current state:</strong> The reports read the data <u>directly from the tables</u> and |
                           && |use selection screens and dynpro based user interfaces.</p>|
                           && |<p><u>Target:</u> Replace the reports with <strong>analytical Fiori apps</strong> based on |
                           && |<em>released CDS views</em> and the analytical query engine.</p>| )
        ( short_description = 'QP-1088: Data Migration Programs'
          long_description  = |<p>The <strong>data migration programs</strong> were created for the initial load of |
                           && |<em>master data and open items</em> from the legacy system.</p>|
                           && |<p><strong>Note:</strong> The programs are <u>only used once</u> during the go-live and will be |
                           && |deleted afterwards. Therefore only a <em>minimal score</em> is applied.</p>|
                           && |<p><u>Owner:</u> The <strong>migration team</strong> is responsible for the deletion after the |
                           && |hypercare phase.</p>|
          custom_score      = abap_true
          deviating_score_b = 0
          deviating_score_c = 0
          deviating_score_d = 2 )
        ( short_description = 'QP-1095: Mass Data Processing'
          long_description  = |<p>The <strong>mass data processing</strong> uses <em>parallel processing</em> with |
                           && |background jobs to handle millions of records in the night.</p>|
                           && |<p><strong>Technical details:</strong> The framework splits the workload into <u>packages</u> |
                           && |and starts asynchronous RFC calls on the available servers.</p>|
                           && |<p><u>Recommendation:</u> Switch to the released <strong>application jobs</strong> and the |
                           && |<em>bgPF framework</em> to become cloud ready.</p>| ) ).

    LOOP AT result REFERENCE INTO DATA(document).
      document->document_id = xco_cp=>uuid( )->value.
    ENDLOOP.
  ENDMETHOD.


  METHOD create_custom.
    DATA custom_apis TYPE custom_api_list.

    DATA(templates) = get_custom_api_templates( ).

    LOOP AT providers INTO DATA(provider).
      LOOP AT templates INTO DATA(template).
        IF random_number( low  = 1
                          high = 100 ) > custom_api_rate.
          CONTINUE.
        ENDIF.

        template-provider_id = provider-provider_id.
        INSERT template INTO TABLE custom_apis.
      ENDLOOP.
    ENDLOOP.

    INSERT zbc_ccm_custom FROM TABLE @custom_apis.
  ENDMETHOD.


  METHOD get_custom_api_templates.
    RETURN VALUE #(
        obj_type = 'CLAS'
        ( obj_name = 'CL_DATA_VOLUME'          short_description = 'Define the volume of the whole data and run it' )
        ( obj_name = 'CL_ACCOUNTING_RULES'     short_description = 'Access to the rules of the calculation in the accounting world' )
        ( obj_name = 'CL_DATE_FUNCTIONS'       short_description = 'Special date functions for timeline calculation' )
        ( obj_name = 'CL_FI_DOCUMENT_READER'   short_description = 'Read accounting documents with header and items' )
        ( obj_name = 'CL_CO_ALLOCATION_ENGINE' short_description = 'Execute allocation cycles for cost centers' )
        ( obj_name = 'CL_RETAIL_PRICE_CALC'    short_description = 'Calculate sales prices for retail articles' )
        ( obj_name = 'CL_WM_LABEL_PRINTER'     short_description = 'Print labels for handling units' )
        ( obj_name = 'CL_HR_PAYROLL_RESULT'    short_description = 'Read payroll results of an employee' )
        ( obj_name = 'CL_MAIL_SENDER'          short_description = 'Send mails with attachments' )
        ( obj_name = 'CL_PDF_RENDERER'         short_description = 'Render PDF documents from form templates' )
        ( obj_name = 'CL_EXCEL_EXPORT'         short_description = 'Export internal tables to spreadsheet files' )
        ( obj_name = 'CL_NUMBER_RANGE_BUFFER'  short_description = 'Buffered access to number ranges' )
        ( obj_name = 'CL_APPLICATION_LOGGER'   short_description = 'Write and read application logs' )
        ( obj_name = 'CL_CURRENCY_CONVERTER'   short_description = 'Convert amounts between currencies' )
        obj_type = 'DDLS'
        ( obj_name = 'I_ACCOUNTINGMESSAGE'     short_description = 'Data to read messages from accounting module' )
        ( obj_name = 'I_COSTCENTERPLANDATA'    short_description = 'Plan data of cost centers per fiscal period' )
        ( obj_name = 'I_INTERNALORDERSTATUS'   short_description = 'Status information of internal orders' )
        ( obj_name = 'I_STOREASSORTMENT'       short_description = 'Assortment of articles per retail store' )
        ( obj_name = 'I_STORAGEBINSTOCK'       short_description = 'Stock information per storage bin' )
        ( obj_name = 'I_EMPLOYEEORGASSIGNMENT' short_description = 'Organizational assignment of employees' )
        ( obj_name = 'I_BUSINESSPARTNERADDR'   short_description = 'Address data of business partners' )
        ( obj_name = 'I_MATERIALVALUATION'     short_description = 'Valuation data of materials per plant' )
        ( obj_name = 'I_SALESDOCUMENTFLOW'     short_description = 'Document flow of sales documents' )
        ( obj_name = 'I_BANKSTATEMENTITEM'     short_description = 'Items of electronic bank statements' )
        obj_type = 'INTF'
        ( obj_name = 'IF_WM_TRANSFER_ORDER'    short_description = 'Create and confirm transfer orders' )
        ( obj_name = 'IF_HR_ABSENCE_HANDLER'   short_description = 'Create and approve absences' )
        ( obj_name = 'IF_FILE_STORAGE'         short_description = 'Store and read files in the document store' )
        ( obj_name = 'IF_APPROVAL_WORKFLOW'    short_description = 'Start and monitor approval workflows' ) ).
  ENDMETHOD.


  METHOD random_number.
    RETURN random->intinrange( low  = low
                               high = high ).
  ENDMETHOD.
ENDCLASS.
