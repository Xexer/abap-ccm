CLASS zcl_bc_scoring DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE
  GLOBAL FRIENDS zcl_bc_scoring_factory.

  PUBLIC SECTION.
    INTERFACES zif_bc_scoring.

    METHODS constructor.

  PRIVATE SECTION.
    DATA default_b TYPE i.
    DATA default_c TYPE i.
    DATA default_d TYPE i.

    METHODS get_score_b
      RETURNING VALUE(result) TYPE i.

    METHODS get_score_c
      RETURNING VALUE(result) TYPE i.

    METHODS get_score_d
      RETURNING VALUE(result) TYPE i.
ENDCLASS.


CLASS zcl_bc_scoring IMPLEMENTATION.
  METHOD constructor.
    DATA(configuration) = zcl_bc_ccm_config_factory=>create_config( ).
    default_b = configuration->get_value( configuration->config_option-default_score_b ).
    default_c = configuration->get_value( configuration->config_option-default_score_c ).
    default_d = configuration->get_value( configuration->config_option-default_score_d ).
  ENDMETHOD.


  METHOD zif_bc_scoring~calculate_standard.
    result-score-CalculationMethod = zif_bc_scoring=>calculation_methods-standard.

    LOOP AT findings INTO FINAL(finding).
      TRY.
          DATA(actual_object) = REF #( result-objects[ obj_type = finding-obj_type
                                                       obj_name = finding-obj_name ] ).
        CATCH cx_sy_itab_line_not_found.
          INSERT VALUE #( obj_type = finding-obj_type
                          obj_name = finding-obj_name ) INTO TABLE result-objects REFERENCE INTO actual_object.

          actual_object->package_name       = finding-package_name.
          actual_object->person_responsible = finding-person_responsible.
      ENDTRY.

      INSERT VALUE #( obj_type      = finding-obj_type
                      obj_name      = finding-obj_name
                      finding_id    = xco_cp=>uuid( )->value
                      check_title   = finding-check_title
                      check_message = finding-check_message
                      ref_obj_type  = finding-referenced_object_type
                      ref_obj_name  = finding-referenced_object_name )
             INTO TABLE result-messages REFERENCE INTO DATA(message).

      CASE finding-priority.
        WHEN i_satc_api_priority-error.
          actual_object->number_error += 1.
          message->priority = 'E'.
        WHEN i_satc_api_priority-warning.
          actual_object->number_warning += 1.
          message->priority = 'W'.
        WHEN i_satc_api_priority-information.
          actual_object->number_info += 1.
          message->priority = 'I'.
      ENDCASE.
    ENDLOOP.

    LOOP AT result-objects REFERENCE INTO DATA(calulated_object).
      IF calulated_object->number_error > 0.
        result-score-LevelDObjects += 1.
        calulated_object->classification = 'D'.
      ELSEIF calulated_object->number_warning > 0.
        result-score-LevelCObjects += 1.
        calulated_object->classification = 'C'.
      ELSEIF calulated_object->number_info > 0.
        result-score-LevelBObjects += 1.
        calulated_object->classification = 'B'.
      ENDIF.

      calulated_object->debt_score = calulated_object->number_info * default_b
        + calulated_object->number_warning * default_c + calulated_object->number_error * default_d.
      result-score-TechnicalDebtScore += calulated_object->debt_score.
    ENDLOOP.
  ENDMETHOD.


  METHOD zif_bc_scoring~calculate_exemption.
  ENDMETHOD.


  METHOD get_score_b.
    RETURN default_b.
  ENDMETHOD.


  METHOD get_score_c.
    RETURN default_c.
  ENDMETHOD.


  METHOD get_score_d.
    RETURN default_d.
  ENDMETHOD.
ENDCLASS.
