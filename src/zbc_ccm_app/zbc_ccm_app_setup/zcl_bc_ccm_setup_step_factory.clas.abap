CLASS zcl_bc_ccm_setup_step_factory DEFINITION
  PUBLIC ABSTRACT FINAL
  CREATE PUBLIC
  GLOBAL FRIENDS zcl_bc_ccm_setup_step_injector.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF step_configuration,
        step_id     TYPE zif_bc_ccm_setup_step=>steps,
        external_id TYPE ZBC_R_CCMSetupSteps-StepID,
        instance    TYPE REF TO zif_bc_ccm_setup_step,
      END OF step_configuration.
    TYPES step_configurations TYPE STANDARD TABLE OF step_configuration WITH EMPTY KEY.

    "! Create a step instance and return it
    "! @parameter step_id | Internal step id
    "! @parameter result  | Instance of the step
    CLASS-METHODS create_step
      IMPORTING step_id       TYPE zif_bc_ccm_setup_step=>steps
      RETURNING VALUE(result) TYPE REF TO zif_bc_ccm_setup_step.

    "! Return the full step configuration for setup and factory
    "! @parameter result | Table of steps and placeholders
    CLASS-METHODS get_step_configuration
      RETURNING VALUE(result) TYPE step_configurations.

  PRIVATE SECTION.
    CLASS-DATA double_step TYPE REF TO zif_bc_ccm_setup_step.
ENDCLASS.


CLASS zcl_bc_ccm_setup_step_factory IMPLEMENTATION.
  METHOD create_step.
    IF double_step IS BOUND.
      RETURN double_step.
    ELSE.
      FINAL(configuration) = get_step_configuration( ).

      TRY.
          RETURN configuration[ step_id = step_id ]-instance.
        CATCH cx_sy_itab_line_not_found.
          " Placeholder? -> Skip
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD get_step_configuration.
    result = VALUE #( ( step_id  = zif_bc_ccm_setup_step=>step-role
                        instance = NEW zcl_bc_ccm_step_role( ) )
                      ( step_id  = zif_bc_ccm_setup_step=>step-setting
                        instance = NEW zcl_bc_ccm_step_setting( ) )
                      ( step_id  = zif_bc_ccm_setup_step=>step-provider_config
                        instance = NEW zcl_bc_ccm_step_provider( ) )
                      ( step_id  = zif_bc_ccm_setup_step=>step-comm_arrangement
                        instance = NEW zcl_bc_ccm_step_comm_arr( ) )
                      ( step_id  = zif_bc_ccm_setup_step=>step-jobs
                        instance = NEW zcl_bc_ccm_step_jobs( ) )
                      ( step_id  = zif_bc_ccm_setup_step=>step-placeholder
                        instance = NEW zcl_bc_ccm_step_placeholder( ) )
                      ( step_id  = zif_bc_ccm_setup_step=>step-cluster
                        instance = NEW zcl_bc_ccm_step_cluster( ) ) ).

    LOOP AT result REFERENCE INTO DATA(step).
      step->external_id = step->instance->get_step_id( ).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
