CLASS zcl_bc_ccm_scheduler DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE
  GLOBAL FRIENDS zcl_bc_ccm_scheduler_factory.

  PUBLIC SECTION.
    INTERFACES zif_bc_ccm_scheduler.

    TYPES finding  TYPE sycm_aps_atc_findings.
    TYPES findings TYPE STANDARD TABLE OF finding WITH EMPTY KEY.

  PRIVATE SECTION.
    TYPES provider  TYPE ZBC_I_CCMProviderCust.
    TYPES providers TYPE SORTED TABLE OF provider WITH UNIQUE KEY ProviderId.

    METHODS select_active_providers
      RETURNING VALUE(result) TYPE providers.

    METHODS search_and_write_new_run
      IMPORTING provider TYPE provider
      RAISING   zcx_bc_ccm_schedule_error.

    METHODS select_and_validate_findings
      IMPORTING provider      TYPE provider
      RETURNING VALUE(result) TYPE findings
      RAISING   zcx_bc_ccm_schedule_error.

    METHODS save_objects
      IMPORTING provider TYPE zbc_i_ccmprovidercust
                !score   TYPE zif_bc_scoring=>scoring_result.

    METHODS save_score
      IMPORTING provider TYPE zbc_i_ccmprovidercust
                !score   TYPE zif_bc_scoring=>scoring_result.
ENDCLASS.


CLASS zcl_bc_ccm_scheduler IMPLEMENTATION.
  METHOD zif_bc_ccm_scheduler~process_all_active_providers.
    DATA(active_providers) = select_active_providers( ).

    LOOP AT active_providers INTO DATA(provider).
      TRY.
          search_and_write_new_run( provider ).

        CATCH zcx_bc_ccm_schedule_error.
          CONTINUE.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.


  METHOD select_active_providers.
    SELECT FROM ZBC_I_CCMProviderCust
      FIELDS ProviderId, OnlyScores, CustomCodeProjectID
      WHERE Active = @abap_true
      INTO CORRESPONDING FIELDS OF TABLE @result
      PRIVILEGED ACCESS.
  ENDMETHOD.


  METHOD search_and_write_new_run.
    DATA(findings) = select_and_validate_findings( provider ).

    DATA(scoring) = zcl_bc_scoring_factory=>create_scoring( ).
    DATA(score_standard) = scoring->calculate_standard( findings ).
    save_objects( provider = provider
                  score    = score_standard ).
    save_score( provider = provider
                score    = score_standard ).
  ENDMETHOD.


  METHOD select_and_validate_findings.
    DATA(project_id) = xco_cp_uuid=>format->c36->to_uuid( to_upper( provider-CustomCodeProjectID ) )->value.

    SELECT SINGLE FROM sycm_aps_project
      FIELDS project_id, atc_run_series
      WHERE project_id = @project_id
      INTO @DATA(project).
    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW zcx_bc_ccm_schedule_error( zcx_bc_ccm_schedule_error=>fail-project_not_found ).
    ENDIF.

    SELECT FROM satc_api_result_headers
      FIELDS ScheduledOnTimestamp,
             ObjectProvider,
             CheckVariant,
             IsCentralRun,
             IsComplete
      WHERE RunSeries = @project-atc_run_series
      ORDER BY ScheduledOnTimestamp DESCENDING
      " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
      INTO @DATA(last_run)
      UP TO 1 ROWS.
    ENDSELECT.

*    IF last_run-CheckVariant <> zif_bc_ccm_scheduler=>atc_variant.
*      RAISE EXCEPTION NEW zcx_bc_ccm_schedule_error( zcx_bc_ccm_schedule_error=>fail-wrong_variant ).
*    ELSEIF last_run-ObjectProvider <> provider-ProviderId.
*      RAISE EXCEPTION NEW zcx_bc_ccm_schedule_error( zcx_bc_ccm_schedule_error=>fail-wrong_provider ).
*    ELSEIF last_run-IsCentralRun <> abap_false.
*      RAISE EXCEPTION NEW zcx_bc_ccm_schedule_error( zcx_bc_ccm_schedule_error=>fail-no_central_run ).
*    ELSEIF last_run-IsComplete <> abap_false.
*      RAISE EXCEPTION NEW zcx_bc_ccm_schedule_error( zcx_bc_ccm_schedule_error=>fail-not_completed ).
*    ELSEIF 0 = 1 ##TODO. " Check Date
*      RAISE EXCEPTION NEW zcx_bc_ccm_schedule_error( zcx_bc_ccm_schedule_error=>fail-no_actual_run ).
*    ENDIF.

    SELECT FROM sycm_aps_atc_findings
      FIELDS *
      WHERE project_id = @project-project_id
      INTO CORRESPONDING FIELDS OF TABLE @result.
  ENDMETHOD.


  METHOD save_objects.
    DATA objects  TYPE STANDARD TABLE OF zbc_ccm_obj WITH EMPTY KEY.
    DATA messages TYPE STANDARD TABLE OF zbc_ccm_msg WITH EMPTY KEY.

    objects = CORRESPONDING #( score-objects ).
    LOOP AT objects REFERENCE INTO DATA(object).
      object->provider_id = provider-ProviderId.
    ENDLOOP.

    messages = CORRESPONDING #( score-messages ).
    LOOP AT messages REFERENCE INTO DATA(message).
      message->provider_id = provider-ProviderId.
    ENDLOOP.

    DELETE FROM zbc_ccm_obj WHERE provider_id = @provider-ProviderId.
    DELETE FROM zbc_ccm_msg WHERE provider_id = @provider-ProviderId.
    INSERT zbc_ccm_obj FROM TABLE @objects.
    INSERT zbc_ccm_msg FROM TABLE @messages.
  ENDMETHOD.


  METHOD save_score.
    MODIFY ENTITIES OF ZBC_R_CCMRun
           ENTITY Runs
           CREATE FROM VALUE #( ( %cid                = provider-ProviderId
                                  ProviderID          = provider-ProviderId
                                  RunStatus           = 'F'
                                  RunTime             = utclong_current( )
                                  %control-ProviderID = if_abap_behv=>mk-on
                                  %control-RunStatus  = if_abap_behv=>mk-on
                                  %control-RunTime    = if_abap_behv=>mk-on ) )
           ENTITY Runs
           CREATE BY \_Score FROM VALUE #(
               ( %cid_ref = provider-ProviderId
                 %target  = VALUE #( ( %cid                        = xco_cp=>uuid( )->value
                                       CalculationMethod           = score-score-CalculationMethod
                                       LevelAObjects               = score-score-LevelAObjects
                                       LevelBObjects               = score-score-LevelBObjects
                                       LevelCObjects               = score-score-LevelCObjects
                                       LevelDObjects               = score-score-LevelDObjects
                                       TechnicalDebtScore          = score-score-TechnicalDebtScore
                                       %control-CalculationMethod  = if_abap_behv=>mk-on
                                       %control-LevelAObjects      = if_abap_behv=>mk-on
                                       %control-LevelBObjects      = if_abap_behv=>mk-on
                                       %control-LevelCObjects      = if_abap_behv=>mk-on
                                       %control-LevelDObjects      = if_abap_behv=>mk-on
                                       %control-TechnicalDebtScore = if_abap_behv=>mk-on ) ) ) ).
  ENDMETHOD.
ENDCLASS.
