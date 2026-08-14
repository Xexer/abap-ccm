CLASS zcl_bc_ccm_step_jobs DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_bc_ccm_setup_step.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF found_job,
        project_id TYPE c LENGTH 32,
        periodic   TYPE abap_boolean,
        status     TYPE cl_apj_rt_api=>ty_job_status,
      END OF found_job.
    TYPES found_jobs TYPE STANDARD TABLE OF found_job WITH EMPTY KEY.

    TYPES providers  TYPE STANDARD TABLE OF ZBC_I_CCMProviderCust WITH EMPTY KEY.

    "! Get all active CCM jobs in the system
    "! @parameter result | List of running and scheduled jobs
    METHODS get_active_ccm_jobs
      RETURNING VALUE(result) TYPE found_jobs.

    "! Read all configured providers from the system
    "! @parameter result | Provider Configuration
    METHODS get_all_active_providers
      RETURNING VALUE(result) TYPE providers.
ENDCLASS.


CLASS zcl_bc_ccm_step_jobs IMPLEMENTATION.
  METHOD zif_bc_ccm_setup_step~check.
    result = VALUE #(
        status  = zif_bc_ccm_setup_step=>status-ok
        message = ''
        log     = zcl_bc_ccm_mini_log_factory=>create_log( zif_bc_ccm_mini_log=>sub_objects-step_execute ) ).
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~execute.
*    result-log = zcl_bc_ccm_mini_log_factory=>create_log( zif_bc_ccm_mini_log=>sub_objects-step_execute ).
*    MESSAGE s029(zbc_ccm) INTO result-log->message.
*    result-log->add_message( ).

    FINAL(active_jobs) = get_active_ccm_jobs( ).
    FINAL(active_providers) = get_all_active_providers( ).

    LOOP AT active_providers INTO FINAL(active_provider) WHERE CustomCodeProjectID IS NOT INITIAL.
      TRY.
          FINAL(internal_id) = xco_cp_uuid=>format->c36->to_uuid( to_upper( active_provider-CustomCodeProjectID ) )->value.
          FINAL(active_job) = active_jobs[ project_id = internal_id ].

        CATCH cx_sy_itab_line_not_found.

          CONTINUE.
      ENDTRY.

      IF active_job-periodic = abap_false.

      ENDIF.

      IF active_job-status <> cl_apj_rt_api=>status_scheduled.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~get_description.
    RETURN TEXT-001.
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~get_navigation.
    RETURN VALUE #( object = `ApplicationJob`
                    action = `show` ).
  ENDMETHOD.


  METHOD zif_bc_ccm_setup_step~get_step_id.
    RETURN CONV #( zif_bc_ccm_setup_step=>step-jobs ).
  ENDMETHOD.


  METHOD get_active_ccm_jobs.
    TRY.
        FINAL(found_jobs) = cl_apj_rt_api=>find_jobs_with_jce( iv_catalog_name = 'SYCM_START_PROJECT_RUN' ).
      CATCH cx_apj_rt.
        RETURN.
    ENDTRY.

    LOOP AT found_jobs INTO FINAL(found_job).
      TRY.
          FINAL(parameters) = cl_apj_rt_api=>get_job_param_values( iv_jobname  = found_job-jobname
                                                                   iv_jobcount = found_job-jobcount ).
        CATCH cx_apj_rt.
          CONTINUE.
      ENDTRY.

      TRY.
          FINAL(ccm_project_id) = parameters[ name = 'P_PRJ_ID' ]-t_value[ 1 ]-low.

          INSERT VALUE #( project_id = ccm_project_id
                          periodic   = found_job-periodic
                          status     = found_job-status )
                 INTO TABLE result.

        CATCH cx_sy_itab_line_not_found.
          CONTINUE.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_all_active_providers.
    SELECT FROM ZBC_I_CCMProviderCust
      FIELDS *
      WHERE Active = @abap_true
      INTO TABLE @result
      PRIVILEGED ACCESS.
  ENDMETHOD.
ENDCLASS.
