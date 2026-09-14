CLASS zcl_bc_ccm_approve DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE
  GLOBAL FRIENDS zcl_bc_ccm_approve_factory.

  PUBLIC SECTION.
    INTERFACES zif_bc_ccm_approve.

    METHODS constructor.

  PRIVATE SECTION.
    DATA config TYPE REF TO zif_bc_ccm_config.

    METHODS get_exemptions
      RETURNING VALUE(result) TYPE zcl_bc_ccm_atc_approve=>exemptions.

    METHODS is_exemption_relevant
      IMPORTING open_exemptions TYPE satc_exemptions_ddlv_ec1
      RETURNING VALUE(result)   TYPE abap_bool.
ENDCLASS.


CLASS zcl_bc_ccm_approve IMPLEMENTATION.
  METHOD constructor.
    config = zcl_bc_ccm_config_factory=>create_config( ).
  ENDMETHOD.


  METHOD zif_bc_ccm_approve~main.
    result = zcl_bc_ccm_mini_log_factory=>create_log( zif_bc_ccm_mini_log=>sub_objects-approver ).

    FINAL(relevant_exemptions) = get_exemptions( ).
    FINAL(atc_api) = NEW zcl_bc_ccm_atc_approve( ).

    LOOP AT relevant_exemptions INTO FINAL(relevant_exemption).
      DATA(approval_result) = atc_api->approve_exemption( exemption_id = relevant_exemption-ExemptionID
                                                          comment      = `` ).

      IF approval_result-success = abap_true.

      ELSE.

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
    " Check: ExemptionApplicantComment (length), FindingObjectScope (no package),
    " CheckClass/CheckCode for Approval, ExemptionValidUntil (correct date)
  ENDMETHOD.
ENDCLASS.
