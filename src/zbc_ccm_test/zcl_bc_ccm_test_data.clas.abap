CLASS zcl_bc_ccm_test_data DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    METHODS delete_all_data.

    METHODS create_test_data
      IMPORTING create_config TYPE abap_boolean DEFAULT abap_false.

  PRIVATE SECTION.
    METHODS create_objects.
    METHODS create_config.
    METHODS create_provider.
    METHODS create_runs.
    METHODS create_cluster.
    METHODS create_documentation.

ENDCLASS.


CLASS zcl_bc_ccm_test_data IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    delete_all_data( ).
    create_test_data( abap_true ).
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

    COMMIT WORK.
  ENDMETHOD.


  METHOD create_test_data.
    IF create_config = abap_true.
      create_config( ).
    ENDIF.

    create_provider( ).
    create_runs( ).
    create_cluster( ).
    create_objects( ).
    create_documentation( ).

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
    DATA providers TYPE STANDARD TABLE OF zbc_ccm_prov WITH EMPTY KEY.

    providers = VALUE #( ( provider_id = 'F01'
                           group_id    = 'FI'
                           system_name = 'Finance'
                           active      = abap_true
                           only_scores = abap_false
                           ccap_id     = to_lower( xco_cp=>uuid( )->as( xco_cp_uuid=>format->c36 )->value ) )
                         ( provider_id = 'F02'
                           group_id    = 'FI'
                           system_name = 'Finance (small)'
                           active      = abap_true
                           only_scores = abap_true
                           ccap_id     = to_lower( xco_cp=>uuid( )->as( xco_cp_uuid=>format->c36 )->value ) )
                         ( provider_id = 'R01'
                           group_id    = 'RE'
                           system_name = 'Retail'
                           active      = abap_true
                           only_scores = abap_false
                           ccap_id     = to_lower( xco_cp=>uuid( )->as( xco_cp_uuid=>format->c36 )->value ) )
                         ( provider_id = 'W01'
                           group_id    = 'TM'
                           system_name = 'Warehouse'
                           active      = abap_false
                           only_scores = abap_false ) ).

    INSERT zbc_ccm_prov FROM TABLE @providers.
  ENDMETHOD.


  METHOD create_runs.
    DATA runs   TYPE STANDARD TABLE OF zbc_ccm_run WITH EMPTY KEY.
    DATA scores TYPE STANDARD TABLE OF zbc_ccm_score WITH EMPTY KEY.

    runs = VALUE #( run_status = 'F'
                    ( run_id      = xco_cp=>uuid( )->value
                      provider_id = 'F01'
                      run_period  = '26/01'
                      run_time    = '2026-01-15 06:30:00.0000000' )
                    ( run_id      = xco_cp=>uuid( )->value
                      provider_id = 'F02'
                      run_period  = '26/01'
                      run_time    = '2026-01-15 07:30:00.0000000' )
                    ( run_id      = xco_cp=>uuid( )->value
                      provider_id = 'R01'
                      run_period  = '26/01'
                      run_time    = '2026-01-15 08:30:00.0000000' )
                    ( run_id      = xco_cp=>uuid( )->value
                      provider_id = 'F01'
                      run_period  = '26/02'
                      run_time    = '2026-02-15 06:30:00.0000000' )
                    ( run_id      = xco_cp=>uuid( )->value
                      provider_id = 'F02'
                      run_period  = '26/02'
                      run_time    = '2026-02-15 07:30:00.0000000' )
                    ( run_id      = xco_cp=>uuid( )->value
                      provider_id = 'R01'
                      run_period  = '26/02'
                      run_time    = '2026-02-15 08:30:00.0000000' )
                    ( run_id      = xco_cp=>uuid( )->value
                      provider_id = 'F01'
                      run_period  = '26/03'
                      run_time    = '2026-03-15 06:30:00.0000000' )
                    ( run_id      = xco_cp=>uuid( )->value
                      provider_id = 'F02'
                      run_period  = '26/03'
                      run_time    = '2026-03-15 07:30:00.0000000' )
                    ( run_id      = xco_cp=>uuid( )->value
                      provider_id = 'R01'
                      run_period  = '26/03'
                      run_time    = '2026-03-15 08:30:00.0000000' )
                    ( run_id      = xco_cp=>uuid( )->value
                      provider_id = 'F01'
                      run_period  = '26/04'
                      run_time    = '2026-04-15 06:30:00.0000000' )
                    ( run_id      = xco_cp=>uuid( )->value
                      provider_id = 'F02'
                      run_period  = '26/04'
                      run_time    = '2026-04-15 07:30:00.0000000' )
                    ( run_id      = xco_cp=>uuid( )->value
                      provider_id = 'R01'
                      run_period  = '26/04'
                      run_time    = '2026-04-15 08:30:00.0000000' ) ).

    DATA(findings_a) = 70.
    DATA(findings_b) = 95.
    DATA(findings_c) = 450.
    DATA(findings_d) = 50.

    LOOP AT runs INTO DATA(run).
      INSERT VALUE #( run_id           = run-run_id
                      calculate_method = zif_bc_scoring=>calculation_methods-standard
                      level_a          = findings_a
                      level_b          = findings_b
                      level_c          = findings_c
                      level_d          = findings_d )
             INTO TABLE scores REFERENCE INTO DATA(single_score).

      single_score->debt_score = single_score->level_d * 10 + single_score->level_c * 5 + single_score->level_b * 1.

      findings_a += 20.
      findings_b += 1.
      findings_c -= 5.
      findings_d -= 1.
    ENDLOOP.

    INSERT zbc_ccm_run FROM TABLE @runs.
    INSERT zbc_ccm_score FROM TABLE @scores.
  ENDMETHOD.


  METHOD create_cluster.
    DATA clusters TYPE STANDARD TABLE OF zbc_ccm_clstr WITH EMPTY KEY.
    DATA assigns  TYPE STANDARD TABLE OF zbc_ccm_cassign WITH EMPTY KEY.

    DATA(team_fin) = xco_cp=>uuid( )->value.
    DATA(team_core) = xco_cp=>uuid( )->value.
    DATA(team_ware) = xco_cp=>uuid( )->value.

    clusters = VALUE #( ( cluster_id   = team_fin
                          cluster_name = 'Developer FIN' )
                        ( cluster_id   = team_core
                          cluster_name = 'Core Team' )
                        ( cluster_id   = team_ware
                          cluster_name = 'Warehouse Manager' ) ).

    assigns = VALUE #( obj_type = 'DEVC'
                       ( object_id   = xco_cp=>uuid( )->value
                         provider_id = 'F01'
                         obj_name    = 'ZFI_BOOKING'
                         cluster_id  = team_fin )
                       ( object_id   = xco_cp=>uuid( )->value
                         provider_id = 'F01'
                         obj_name    = 'ZFI_ACCOUNT'
                         cluster_id  = team_fin )
                       ( object_id   = xco_cp=>uuid( )->value
                         provider_id = 'F01'
                         obj_name    = 'ZBC_FILES'
                         cluster_id  = team_core )
                       ( object_id   = xco_cp=>uuid( )->value
                         provider_id = 'F01'
                         obj_name    = 'ZBC_CONFIG'
                         cluster_id  = team_core )
                       ( object_id   = xco_cp=>uuid( )->value
                         provider_id = 'F02'
                         obj_name    = 'ZBC_CONFIG'
                         cluster_id  = team_core )
                       ( object_id   = xco_cp=>uuid( )->value
                         provider_id = 'R01'
                         obj_name    = 'ZBC_CONFIG'
                         cluster_id  = team_core )
                       ( object_id   = xco_cp=>uuid( )->value
                         provider_id = 'R01'
                         obj_name    = 'ZRE_WAREHOUSE'
                         cluster_id  = team_ware ) ).

    INSERT zbc_ccm_clstr FROM TABLE @clusters.
    INSERT zbc_ccm_cassign FROM TABLE @assigns.
  ENDMETHOD.


  METHOD create_objects.
    TYPES msg_type TYPE STANDARD TABLE OF zbc_ccm_msg WITH EMPTY KEY.

    DATA objects  TYPE STANDARD TABLE OF zbc_ccm_obj WITH EMPTY KEY.
    DATA messages TYPE STANDARD TABLE OF zbc_ccm_msg WITH EMPTY KEY.

    CONSTANTS:
      BEGIN OF check_title,
        enha TYPE zbc_ccm_msg-check_title VALUE 'Allowed Enhancement Technologies',
        crit TYPE zbc_ccm_msg-check_title VALUE 'Critical Statements',
        api  TYPE zbc_ccm_msg-check_title VALUE 'Usage of APIs',
      END OF check_title.

    CONSTANTS:
      BEGIN OF check_message,
        enha     TYPE zbc_ccm_msg-check_message VALUE 'Enhancement technology not allowed',
        function TYPE zbc_ccm_msg-check_message VALUE 'Call System Function: ...',
        internal TYPE zbc_ccm_msg-check_message VALUE 'Usage of internal API',
        submit   TYPE zbc_ccm_msg-check_message VALUE 'SUBMIT program is not recommended',
        classic  TYPE zbc_ccm_msg-check_message VALUE 'Usage of classic API',
        succ     TYPE zbc_ccm_msg-check_message VALUE 'Usage of classic API (successor available)',
        no_api   TYPE zbc_ccm_msg-check_message VALUE 'Usage of API that must not be used (successor available)',
      END OF check_message.

    INSERT VALUE #( provider_id  = 'F01'
                    obj_type     = 'CLAS'
                    obj_name     = 'ZCL_FI_ACCOUNT_MANAGER'
                    package_name = 'ZFI_ACCOUNT' )
           INTO TABLE objects REFERENCE INTO DATA(object).

    INSERT LINES OF VALUE msg_type( provider_id = object->provider_id
                                    obj_type    = object->obj_type
                                    obj_name    = object->obj_name
                                    ( finding_id    = xco_cp=>uuid( )->value
                                      priority      = 'W'
                                      check_title   = check_title-api
                                      check_message = check_message-internal
                                      ref_obj_type  = 'CLAS'
                                      ref_obj_name  = 'CX_SDS_FILE_ERROR' )
                                    ( finding_id    = xco_cp=>uuid( )->value
                                      priority      = 'W'
                                      check_title   = check_title-enha
                                      check_message = check_message-enha
                                      ref_obj_type  = 'N/A'
                                      ref_obj_name  = 'N/A' )
                                    ( finding_id    = xco_cp=>uuid( )->value
                                      priority      = 'E'
                                      check_title   = check_title-api
                                      check_message = check_message-no_api
                                      ref_obj_type  = 'TABL'
                                      ref_obj_name  = 'T001' ) )
           INTO TABLE messages.

    INSERT VALUE #( provider_id  = 'F01'
                    obj_type     = 'CLAS'
                    obj_name     = 'ZCL_BC_FILE_HANDLER'
                    package_name = 'ZBC_FILES' )
           INTO TABLE objects REFERENCE INTO object.

    INSERT LINES OF VALUE msg_type( provider_id = object->provider_id
                                    obj_type    = object->obj_type
                                    obj_name    = object->obj_name
                                    check_title = check_title-api
                                    ( finding_id    = xco_cp=>uuid( )->value
                                      priority      = 'I'
                                      check_message = check_message-classic
                                      ref_obj_type  = 'TABL'
                                      ref_obj_name  = 'BUT000' ) )
           INTO TABLE messages.

    INSERT VALUE #( provider_id  = 'F01'
                    obj_type     = 'CLAS'
                    obj_name     = 'ZCL_FI_ACCOUNT_FILES'
                    package_name = 'ZFI_ACCOUNT' )
           INTO TABLE objects REFERENCE INTO object.

    INSERT LINES OF VALUE msg_type( provider_id = object->provider_id
                                    obj_type    = object->obj_type
                                    obj_name    = object->obj_name
                                    check_title = check_title-api
                                    ( finding_id    = xco_cp=>uuid( )->value
                                      priority      = 'W'
                                      check_message = check_message-internal
                                      ref_obj_type  = 'CLAS'
                                      ref_obj_name  = 'CX_SDS_FILE_ERROR' )
                                    ( finding_id    = xco_cp=>uuid( )->value
                                      priority      = 'I'
                                      check_message = check_message-classic
                                      ref_obj_type  = 'TABL'
                                      ref_obj_name  = 'BUT000' ) )
           INTO TABLE messages.

    INSERT VALUE #( provider_id  = 'F01'
                    obj_type     = 'CLAS'
                    obj_name     = 'ZCL_BC_FILE_PREVIEW'
                    package_name = 'ZBC_FILES' )
           INTO TABLE objects REFERENCE INTO object.

    INSERT LINES OF VALUE msg_type( provider_id = object->provider_id
                                    obj_type    = object->obj_type
                                    obj_name    = object->obj_name
                                    check_title = check_title-api
                                    ( finding_id    = xco_cp=>uuid( )->value
                                      priority      = 'E'
                                      check_message = check_message-no_api
                                      ref_obj_type  = 'FUNC'
                                      ref_obj_name  = 'RFC_READ_TABLE' ) )
           INTO TABLE messages.

    INSERT VALUE #( provider_id  = 'F01'
                    obj_type     = 'DDLS'
                    obj_name     = 'ZRE_I_DEFAULTCUBE'
                    package_name = 'ZRE_CUBE' )
           INTO TABLE objects REFERENCE INTO object.

    INSERT LINES OF VALUE msg_type( provider_id = object->provider_id
                                    obj_type    = object->obj_type
                                    obj_name    = object->obj_name
                                    ( finding_id    = xco_cp=>uuid( )->value
                                      priority      = 'W'
                                      check_title   = check_title-api
                                      check_message = check_message-internal
                                      ref_obj_type  = 'CLAS'
                                      ref_obj_name  = 'CX_SDS_FILE_ERROR' )
                                    ( finding_id    = xco_cp=>uuid( )->value
                                      priority      = 'W'
                                      check_title   = check_title-enha
                                      check_message = check_message-enha
                                      ref_obj_type  = 'N/A'
                                      ref_obj_name  = 'N/A' )
                                    ( finding_id    = xco_cp=>uuid( )->value
                                      priority      = 'I'
                                      check_title   = check_title-api
                                      check_message = check_message-classic
                                      ref_obj_type  = 'TABL'
                                      ref_obj_name  = 'BUT000' ) )
           INTO TABLE messages.

    INSERT VALUE #( provider_id  = 'F02'
                    obj_type     = 'DDLS'
                    obj_name     = 'ZRE_I_DEFAULTCUBE'
                    package_name = 'ZRE_CUBE' )
           INTO TABLE objects REFERENCE INTO object.

    INSERT LINES OF VALUE msg_type( provider_id = object->provider_id
                                    obj_type    = object->obj_type
                                    obj_name    = object->obj_name
                                    ( finding_id    = xco_cp=>uuid( )->value
                                      priority      = 'W'
                                      check_title   = check_title-api
                                      check_message = check_message-internal
                                      ref_obj_type  = 'CLAS'
                                      ref_obj_name  = 'CX_SDS_FILE_ERROR' )
                                    ( finding_id    = xco_cp=>uuid( )->value
                                      priority      = 'W'
                                      check_title   = check_title-enha
                                      check_message = check_message-enha
                                      ref_obj_type  = 'N/A'
                                      ref_obj_name  = 'N/A' )
                                    ( finding_id    = xco_cp=>uuid( )->value
                                      priority      = 'I'
                                      check_title   = check_title-api
                                      check_message = check_message-classic
                                      ref_obj_type  = 'TABL'
                                      ref_obj_name  = 'BUT000' ) )
           INTO TABLE messages.

    LOOP AT objects REFERENCE INTO object.
      LOOP AT messages REFERENCE INTO DATA(message) WHERE     provider_id = object->provider_id
                                                          AND obj_type    = object->obj_type
                                                          AND obj_name    = object->obj_name.
        CASE message->priority.
          WHEN 'E'.
            object->number_error += 1.
          WHEN 'W'.
            object->number_warning += 1.
          WHEN 'I'.
            object->number_info += 1.
        ENDCASE.
      ENDLOOP.

      IF object->number_error > 0.
        object->classification = 'D'.
      ELSEIF object->number_warning > 0.
        object->classification = 'C'.
      ELSEIF object->number_info > 0.
        object->classification = 'B'.
      ENDIF.

      object->debt_score = object->number_error * 10 + object->number_warning * 5 + object->number_info * 1.
    ENDLOOP.

    INSERT zbc_ccm_obj FROM TABLE @objects.
    INSERT zbc_ccm_msg FROM TABLE @messages.
  ENDMETHOD.


  METHOD create_documentation.
    DATA docs  TYPE STANDARD TABLE OF zbc_ccm_doc WITH EMPTY KEY.
    DATA links TYPE STANDARD TABLE OF zbc_ccm_dlink WITH EMPTY KEY.

    DATA(fin_enha) = xco_cp=>uuid( )->value.
    DATA(core_file) = xco_cp=>uuid( )->value.

    docs = VALUE #( ( document_id       = fin_enha
                      short_description = 'QP-1012: Financial Enhancement'
                      long_description  = '<p>Some new fields in T001</p>'
                      custom_score      = abap_false
                      deviating_score_b = 0
                      deviating_score_c = 0
                      deviating_score_d = 0 )
                    ( document_id       = core_file
                      short_description = 'QP-1015: File System'
                      long_description  = '<p>Core classes for File Handling</p>'
                      custom_score      = abap_true
                      deviating_score_b = 1
                      deviating_score_c = 2
                      deviating_score_d = 3 ) ).

    links = VALUE #( provider_id = 'F01'
                     ( link_id     = xco_cp=>uuid( )->value
                       obj_type    = 'DEVC'
                       obj_name    = 'ZFI_ACCOUNT'
                       document_id = fin_enha )
                     ( link_id     = xco_cp=>uuid( )->value
                       obj_type    = 'CLAS'
                       obj_name    = 'ZCL_BC_FILE_HANDLER'
                       document_id = core_file )
                     ( link_id     = xco_cp=>uuid( )->value
                       obj_type    = 'CLAS'
                       obj_name    = 'ZCL_BC_FILE_TYPES'
                       document_id = core_file ) ).

    INSERT zbc_ccm_doc FROM TABLE @docs.
    INSERT zbc_ccm_dlink FROM TABLE @links.
  ENDMETHOD.
ENDCLASS.
