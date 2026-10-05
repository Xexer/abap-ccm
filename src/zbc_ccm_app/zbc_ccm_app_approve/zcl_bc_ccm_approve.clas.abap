CLASS zcl_bc_ccm_approve DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE
  GLOBAL FRIENDS zcl_bc_ccm_approve_factory.

  PUBLIC SECTION.
    INTERFACES zif_bc_ccm_approve.

    CONSTANTS:
      BEGIN OF approver_option,
        approve TYPE zbc_ccm_auto_approve_setting VALUE 'A',
        reject  TYPE zbc_ccm_auto_approve_setting VALUE 'R',
      END OF approver_option.

    METHODS constructor.

  PRIVATE SECTION.
    DATA config                TYPE REF TO zif_bc_ccm_config.
    DATA approve_min_length    TYPE i.
    DATA approve_allow_package TYPE abap_boolean.
    DATA approve_message       TYPE string.

    "! Get open exemptions from the system
    "! @parameter result | List of exemptions
    METHODS get_exemptions
      RETURNING VALUE(result) TYPE zcl_bc_ccm_atc_approve=>exemptions.

    "! Check if the exemption is relevant for the Auto Approver
    "! @parameter open_exemptions | Full exemption dataset
    "! @parameter result          | X = Relevant for Approving, '' = Not relevant
    METHODS is_exemption_relevant
      IMPORTING open_exemptions TYPE satc_exemptions_ddlv_ec1
      RETURNING VALUE(result)   TYPE abap_bool.

    "! Get the Validation date for the given object provider
    "! @parameter provider_id | Object Provider
    "! @parameter result      | Date that should be checked
    METHODS get_valid_date_for_provider
      IMPORTING provider_id   TYPE ZBC_I_CCMProviderCust-ProviderId
      RETURNING VALUE(result) TYPE d.

    "! Get Auto approval setting for the check and message
    "! @parameter class   | Class of the ATC check
    "! @parameter message | Message ID
    "! @parameter result  | Auto Approval Mode
    METHODS get_auto_approval_setting
      IMPORTING !class        TYPE ZBC_I_CCMATCMessage-CheckName
                !message      TYPE ZBC_I_CCMATCMessage-MessageName
      RETURNING VALUE(result) TYPE ZBC_I_CCMATCMessage-AutoApprovalSetting.
ENDCLASS.


CLASS zcl_bc_ccm_approve IMPLEMENTATION.
  METHOD constructor.
    config = zcl_bc_ccm_config_factory=>create_config( ).

    approve_min_length = config->get_value( config->config_option-approve_min_length ).
    approve_message = config->get_value( config->config_option-approve_message ).

    IF config->get_value( config->config_option-approve_allow_package ).
      approve_allow_package = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD zif_bc_ccm_approve~main.
    result = zcl_bc_ccm_mini_log_factory=>create_log( zif_bc_ccm_mini_log=>sub_objects-approver ).

    FINAL(relevant_exemptions) = get_exemptions( ).
    FINAL(atc_api) = NEW zcl_bc_ccm_atc_approve( ).

    LOOP AT relevant_exemptions INTO FINAL(relevant_exemption).
      DATA(auto_approval) = get_auto_approval_setting( class   = relevant_exemption-CheckClass
                                                       message = CONV #( relevant_exemption-CheckCode ) ).

      CASE auto_approval.
        WHEN approver_option-approve.
          DATA(approval_result) = atc_api->approve_exemption( exemption_id = relevant_exemption-ExemptionID
                                                              comment      = approve_message ).
        WHEN OTHERS.
          CONTINUE.
      ENDCASE.

      IF approval_result-success = abap_true.
        MESSAGE s036(zbc_ccm) WITH relevant_exemption-ExemptionID INTO result->message.
        result->add_message( ).
      ELSE.
        MESSAGE e037(zbc_ccm) WITH relevant_exemption-ExemptionID INTO result->message.
        result->add_message( ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_exemptions.
    FINAL(atc_api) = NEW zcl_bc_ccm_atc_approve( ).
    FINAL(all_open_exemptions) = atc_api->get_open_exemptions( ).

    LOOP AT all_open_exemptions INTO FINAL(open_exemptions).
      IF NOT is_exemption_relevant( open_exemptions ).
        CONTINUE.
      ENDIF.

      INSERT open_exemptions INTO TABLE result.
    ENDLOOP.
  ENDMETHOD.


  METHOD is_exemption_relevant.
    FINAL(check_date) = get_valid_date_for_provider( open_exemptions-DataSourceID ).
    IF check_date IS NOT INITIAL AND open_exemptions-ExemptionValidUntil <> check_date.
      RETURN abap_false.
    ENDIF.

    FINAL(auto_approval) = get_auto_approval_setting( class   = open_exemptions-CheckClass
                                                      message = CONV #( open_exemptions-CheckCode ) ).
    IF auto_approval <> approver_option-approve AND auto_approval <> approver_option-reject.
      RETURN abap_false.
    ENDIF.

    IF approve_min_length > 0 AND strlen( open_exemptions-ExemptionApplicantComment ) < approve_min_length.
      RETURN abap_false.
    ENDIF.

    IF open_exemptions-FindingObjectScope = i_satc_api_object_scope-package AND approve_allow_package = abap_false.
      RETURN abap_false.
    ENDIF.

    result = abap_true.
  ENDMETHOD.


  METHOD get_valid_date_for_provider.
    SELECT SINGLE FROM ZBC_I_CCMProviderCust
      FIELDS CentralATCValidDate
      WHERE ProviderId = @provider_id
      INTO @result
      PRIVILEGED ACCESS.
    IF sy-subrc <> 0.
      CLEAR result.
    ENDIF.
  ENDMETHOD.


  METHOD get_auto_approval_setting.
    SELECT SINGLE FROM ZBC_I_CCMATCMessage
      FIELDS AutoApprovalSetting
      WHERE     CheckName   = @class
            AND MessageName = @message
      INTO @result
      PRIVILEGED ACCESS.
    IF sy-subrc <> 0.
      CLEAR result.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
