INTERFACE zif_bc_ccm_setup_step
  PUBLIC.

  TYPES step_type TYPE c LENGTH 2.
  TYPES:
    BEGIN OF ENUM steps STRUCTURE step BASE TYPE step_type,
      placeholder          VALUE IS INITIAL,
      setting          VALUE 'SE',
      provider_config  VALUE 'PC',
      comm_arrangement VALUE 'CA',
      cluster          VALUE 'CL',
    END OF ENUM steps STRUCTURE step.

  TYPES:
    BEGIN OF check_result,
      log     TYPE REF TO zif_bc_ccm_mini_log,
      message TYPE ZBC_R_CCMSetupSteps-StatusMessage,
      status  TYPE ZBC_R_CCMSetupSteps-StatusCriticality,
    END OF check_result.

  TYPES:
    BEGIN OF execute_result,
      log TYPE REF TO zif_bc_ccm_mini_log,
    END OF execute_result.

  TYPES:
    BEGIN OF navigation_result,
      object TYPE ZBC_R_CCMSetupSteps-NavigationObject,
      action TYPE ZBC_R_CCMSetupSteps-NavigationAction,
    END OF navigation_result.

  CONSTANTS:
    BEGIN OF status,
      ok      TYPE ZBC_R_CCMSetupSteps-StatusCriticality VALUE 3,
      changes TYPE ZBC_R_CCMSetupSteps-StatusCriticality VALUE 2,
      intial  TYPE ZBC_R_CCMSetupSteps-StatusCriticality VALUE 1,
    END OF status.

  "! Check the actual step for consistency
  "! @parameter result | Result of the check
  METHODS check
    RETURNING VALUE(result) TYPE check_result.

  "! Execute the step
  "! @parameter cid_ref | Reference ID
  "! @parameter result  | Result of the execution
  METHODS execute
    IMPORTING cid_ref       TYPE abp_behv_cid
    RETURNING VALUE(result) TYPE execute_result.

  "! Return description of the step
  "! @parameter result | Description
  METHODS get_description
    RETURNING VALUE(result) TYPE ZBC_R_CCMSetupSteps-StepDescription.

  "! Return step ID for the actual step
  "! @parameter result | ID of the Step in CHAR format
  METHODS get_step_id
    RETURNING VALUE(result) TYPE ZBC_R_CCMSetupSteps-StepID.

  "! Return Navigation object
  "! @parameter result | Navigation settings
  METHODS get_navigation
    RETURNING VALUE(result) TYPE navigation_result.
ENDINTERFACE.
