CLASS zcl_bc_ccm_atc_run DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    TYPES: BEGIN OF jobinfo,
             jobname  TYPE cl_apj_rt_api=>ty_jobname,
             jobcount TYPE cl_apj_rt_api=>ty_jobcount,
             messages TYPE STANDARD TABLE OF bapiret2 WITH EMPTY KEY,
           END OF jobinfo.

    "! Start the defined Custom Code Run
    "! @parameter run_id  | ID of the Run
    "! @parameter ccap_id | Predefined CCAP ID
    "! @parameter result  | Job ID and messages
    METHODS start_ccap_run
      IMPORTING run_id        TYPE zbc_ccm_run_id
                ccap_id       TYPE string
      RETURNING VALUE(result) TYPE jobinfo.

    "! Get Status for the Job
    "! @parameter jobinfo | Job ID
    "! @parameter result  | Job Informations
    METHODS get_ccap_status
      IMPORTING jobinfo       TYPE jobinfo
      RETURNING VALUE(result) TYPE cl_apj_rt_api=>ty_job_info.
ENDCLASS.


CLASS zcl_bc_ccm_atc_run IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA(info) = start_ccap_run( run_id  = 'B65D2E8914081FD0A3E7DE558B9F5CB1'
                                 ccap_id = `b65d2e89-1408-1fd0-a3e7-de558b9f5cb1` ).

    out->write( info ).
  ENDMETHOD.


  METHOD start_ccap_run.
    DATA(uuid) = xco_cp_uuid=>format->c36->to_uuid( to_upper( ccap_id ) ).

    DATA(parameters) = VALUE cl_apj_rt_api=>tt_job_parameter_value(
        ( name = 'P_PRJ_ID' t_value = VALUE #( ( sign = 'I' option = 'EQ' low = uuid->value ) ) ) ).

    DATA(start_parameter) = VALUE cl_apj_rt_api=>ty_start_info( start_immediately = abap_true ).

    TRY.
        cl_apj_rt_api=>schedule_job( EXPORTING iv_job_template_name   = 'SYCM_START_PROJECT_RUN'
                                               iv_job_text            = |CCM: Run ID { run_id }|
                                               is_start_info          = start_parameter
                                               it_job_parameter_value = parameters
                                     IMPORTING ev_jobname             = result-jobname
                                               ev_jobcount            = result-jobcount
                                               et_message             = result-messages ).
      CATCH cx_apj_rt INTO DATA(apj_error).
        INSERT apj_error->get_bapiret2( ) INTO TABLE result-messages.
    ENDTRY.
  ENDMETHOD.


  METHOD get_ccap_status.
    TRY.
        result = cl_apj_rt_api=>get_job_details( iv_jobname  = jobinfo-jobname
                                                 iv_jobcount = jobinfo-jobcount ).
      CATCH cx_apj_rt.
        CLEAR result.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
