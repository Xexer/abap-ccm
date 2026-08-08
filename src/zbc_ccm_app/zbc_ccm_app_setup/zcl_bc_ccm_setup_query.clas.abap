CLASS zcl_bc_ccm_setup_query DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

  PRIVATE SECTION.
    TYPES step_filter_type TYPE RANGE OF ZBC_R_CCMSetupSteps-StepID.
    TYPES:
      BEGIN OF config,
        step_id TYPE ZBC_R_CCMSetupSteps-StepID,
        step    TYPE REF TO zif_bc_ccm_setup_step,
      END OF config.
    TYPES configs TYPE STANDARD TABLE OF config WITH EMPTY KEY.

    "! Get configured steps for the setup
    "! @parameter result | List of steps
    METHODS get_configuration
      RETURNING VALUE(result) TYPE configs.

    METHODS get_filter_and_call_request
      IMPORTING !request      TYPE REF TO if_rap_query_request
      RETURNING VALUE(result) TYPE step_filter_type.
ENDCLASS.


CLASS zcl_bc_ccm_setup_query IMPLEMENTATION.
  METHOD if_rap_query_provider~select.
    DATA steps TYPE STANDARD TABLE OF ZBC_R_CCMSetupSteps WITH EMPTY KEY.

    DATA(step_filter) = get_filter_and_call_request( io_request ).
    DATA(configs) = get_configuration( ).

    LOOP AT configs INTO DATA(config) WHERE step_id IN step_filter.
      DATA(table_line_number) = sy-tabix.

      IF io_request->is_data_requested( ).
        DATA(check_result) = config-step->check( ).
      ENDIF.

      DATA(navigation) = config-step->get_navigation( ).

      INSERT VALUE #( StepID            = config-step->get_step_id( )
                      StepDescription   = |{ table_line_number }. { config-step->get_description( ) }|
                      StatusCriticality = check_result-status
                      StatusMessage     = check_result-message
                      NavigationObject  = navigation-object
                      NavigationAction  = navigation-action )
             INTO TABLE steps.
    ENDLOOP.

    IF sy-subrc <> 0 AND step_filter IS NOT INITIAL.
      LOOP AT step_filter INTO DATA(filter).
        INSERT VALUE #( StepID            = filter-low
                        StatusCriticality = 5 )
               INTO TABLE steps.
      ENDLOOP.
    ENDIF.

    IF io_request->is_data_requested( ).
      io_response->set_data( steps ).
    ENDIF.

    IF io_request->is_total_numb_of_rec_requested( ).
      io_response->set_total_number_of_records( lines( steps ) ).
    ENDIF.
  ENDMETHOD.


  METHOD get_filter_and_call_request.
    request->get_sort_elements( ).
    request->get_paging( ).

    TRY.
        DATA(odata_filter) = request->get_filter( )->get_as_ranges( ).
        result = CORRESPONDING #( odata_filter[ name = 'STEPID' ]-range ).

      CATCH cx_rap_query_filter_no_range cx_sy_itab_line_not_found.
        CLEAR result.
    ENDTRY.
  ENDMETHOD.


  METHOD get_configuration.
    DATA(placeholder) = CAST zif_bc_ccm_setup_step( NEW zcl_bc_ccm_step_placeholder( ) ).

    DATA(setting) = zcl_bc_ccm_setup_step_factory=>create_step( zif_bc_ccm_setup_step=>step-setting ).
    DATA(provider) = zcl_bc_ccm_setup_step_factory=>create_step( zif_bc_ccm_setup_step=>step-provider_config ).
    DATA(arrangement) = zcl_bc_ccm_setup_step_factory=>create_step( zif_bc_ccm_setup_step=>step-comm_arrangement ).

    RETURN VALUE #( ( step_id = setting->get_step_id( ) step = setting )
                    ( step_id = provider->get_step_id( ) step = provider )
                    ( step_id = arrangement->get_step_id( ) step = arrangement )
                    ( step_id = placeholder->get_step_id( ) step = placeholder ) ).
  ENDMETHOD.
ENDCLASS.
