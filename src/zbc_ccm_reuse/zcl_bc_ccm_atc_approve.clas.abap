CLASS zcl_bc_ccm_atc_approve DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES exemption  TYPE satc_exemptions_ddlv_ec1.
    TYPES exemptions TYPE SORTED TABLE OF exemption WITH UNIQUE KEY ExemptionID.

    TYPES:
      BEGIN OF approve_result,
        success TYPE abap_boolean,
        message TYPE string,
      END OF approve_result.

    "! Read open exemptions for approval
    "! @parameter result | List of open exemptions
    METHODS get_open_exemptions
      RETURNING VALUE(result) TYPE exemptions.

    "! Approve the exemption in ATC
    "! @parameter exemption_id | ID of the exemption
    "! @parameter comment      | Comment for approval
    "! @parameter result       | Approval info
    METHODS approve_exemption
      IMPORTING exemption_id  TYPE exemption-ExemptionID
                !comment      TYPE string
      RETURNING VALUE(result) TYPE approve_result.
ENDCLASS.


CLASS zcl_bc_ccm_atc_approve IMPLEMENTATION.
  METHOD get_open_exemptions.
    SELECT FROM satc_exemptions_ddlv_ec1
      FIELDS *
      WHERE ExemptionState = @i_satc_api_exemption_state_c1-open
      INTO TABLE @result.
  ENDMETHOD.


  METHOD approve_exemption.
    TRY.
        FINAL(atc_exemption) = cl_satc_api=>create_api_factory( )->get_exemption_controller( ).
      CATCH cx_satc_api.
        RETURN.
    ENDTRY.

    DATA(messages) = atc_exemption->approve_exemptions_by_id( VALUE #( ( exemption_id = exemption_id
                                                                         assessment   = comment ) ) ).

    result-success = xsdbool( messages IS INITIAL ).
  ENDMETHOD.
ENDCLASS.
