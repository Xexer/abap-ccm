CLASS zcl_bc_ccm_dashboard_elem DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.

  PRIVATE SECTION.
    "! Format the number for output
    "! @parameter number | Number of objects
    "! @parameter result | Formatted format
    METHODS format_number
      IMPORTING !number       TYPE i
      RETURNING VALUE(result) TYPE zbc_c_ccmdashboard-changelevela.
ENDCLASS.


CLASS zcl_bc_ccm_dashboard_elem IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA original_data TYPE STANDARD TABLE OF ZBC_C_CCMDashboard WITH EMPTY KEY.
    DATA result_type   TYPE p LENGTH 10 DECIMALS 1.

    DATA(configuration) = zcl_bc_ccm_config_factory=>create_config( ).
    DATA(include_level_c) = xsdbool( configuration->get_value( configuration->config_option-include_level_c_findings ) = abap_true ).

    original_data = CORRESPONDING #( it_original_data ).

    LOOP AT original_data REFERENCE INTO DATA(original).
      SELECT FROM ZBC_R_CCMRun
        FIELDS RunID
        WHERE     ProviderID  = @original->ProviderID
              AND RunTime    <> @original->RunTime
        ORDER BY RunTime DESCENDING
        INTO @DATA(runid_before)
        PRIVILEGED ACCESS
        UP TO 1 ROWS.
      ENDSELECT.

      SELECT SINGLE FROM ZBC_I_CCMScore
        FIELDS *
        WHERE     RunID             = @runid_before
              AND CalculationMethod = @original->CalculationMethod
        INTO @DATA(run_before).

      original->CriticalityLevelA = 3.
      original->CriticalityLevelB = 5.
      original->CriticalityLevelC = 2.
      original->CriticalityLevelD = 1.

      DATA(sum) = original->LevelAObjects + original->LevelBObjects + original->LevelCObjects + original->LevelDObjects.
      result_type = ( original->LevelAObjects / sum ) * 100.
      original->CloudReady = |{ CONV i( result_type ) }%|.

      DATA(sum_for_clean_core) = original->LevelAObjects + original->LevelBObjects.
      IF include_level_c = abap_true.
        sum_for_clean_core += original->LevelCObjects.
      ENDIF.

      result_type = ( sum_for_clean_core ) / sum * 100.
      original->UpgradeStable       = |{ CONV i( result_type ) }%|.

      original->ChangeLevelA        = format_number( original->levelaobjects - run_before-levelaobjects ).
      original->ChangeLevelB        = format_number( original->LevelBObjects - run_before-LevelBObjects ).
      original->ChangeLevelC        = format_number( original->LevelCObjects - run_before-LevelCObjects ).
      original->ChangeLevelD        = format_number( original->LevelDObjects - run_before-LevelDObjects ).
      original->ChangeTechnicalDebt = format_number( original->TechnicalDebtScore - run_before-TechnicalDebtScore ).
      original->ChangeKeyUser       = format_number( original->KeyUserObjects - run_before-KeyUserObjects ).
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( original_data ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    et_requested_orig_elements = VALUE #( ( `LEVELAOBJECTS` )
                                          ( `LEVELBOBJECTS` )
                                          ( `LEVELCOBJECTS` )
                                          ( `LEVELDOBJECTS` )
                                          ( `PROVIDERID` )
                                          ( `RUNTIME` ) ).
  ENDMETHOD.


  METHOD format_number.
    DATA(text) = CONV string( number ).
    text = replace( val  = text
                    sub  = ` `
                    with = `` ).
    text = replace( val  = text
                    sub  = `.`
                    with = `` ).

    IF number > 0.
      RETURN |+{ text }|.
    ELSEIF number < 0.
      text = replace( val  = text
                      sub  = `-`
                      with = `` ).
      RETURN |-{ text }|.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
