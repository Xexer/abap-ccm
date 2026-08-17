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
    FINAL(placeholder) = NEW zcl_bc_ccm_step_placeholder( ).

    FINAL(role) = NEW zcl_bc_ccm_step_role( ).
    FINAL(setting) = NEW zcl_bc_ccm_step_setting( ).
    FINAL(provider) = NEW zcl_bc_ccm_step_provider( ).
    FINAL(arrangement) = NEW zcl_bc_ccm_step_comm_arr( ).
    FINAL(cluster) = NEW zcl_bc_ccm_step_cluster( ).
    FINAL(job) = NEW zcl_bc_ccm_step_jobs( ).

    RETURN VALUE #( ( step_id     = zif_bc_ccm_setup_step=>step-role
                      external_id = role->zif_bc_ccm_setup_step~get_step_id( )
                      instance    = role )
                    ( step_id     = zif_bc_ccm_setup_step=>step-setting
                      external_id = setting->zif_bc_ccm_setup_step~get_step_id( )
                      instance    = setting )
                    ( step_id     = zif_bc_ccm_setup_step=>step-provider_config
                      external_id = provider->zif_bc_ccm_setup_step~get_step_id( )
                      instance    = provider )
                    ( step_id     = zif_bc_ccm_setup_step=>step-comm_arrangement
                      external_id = arrangement->zif_bc_ccm_setup_step~get_step_id( )
                      instance    = arrangement )
                    ( step_id     = zif_bc_ccm_setup_step=>step-jobs
                      external_id = job->zif_bc_ccm_setup_step~get_step_id( )
                      instance    = job )
                    ( step_id     = zif_bc_ccm_setup_step=>step-placeholder
                      external_id = placeholder->zif_bc_ccm_setup_step~get_step_id( )
                      instance    = placeholder )
                    ( step_id     = zif_bc_ccm_setup_step=>step-cluster
                      external_id = cluster->zif_bc_ccm_setup_step~get_step_id( )
                      instance    = cluster ) ).
  ENDMETHOD.
ENDCLASS.
