CLASS zcl_bc_ccm_atc_check DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES variant_name TYPE if_satc_api_factory=>ty_check_variant_name.

    TYPES:
      BEGIN OF check,
        technical_name TYPE if_satc_api_result=>ty_check_name,
        description    TYPE string,
      END OF check.
    TYPES checks TYPE SORTED TABLE OF check WITH UNIQUE KEY technical_name.

    TYPES:
      BEGIN OF message,
        check_name     TYPE check-technical_name,
        technical_name TYPE if_ci_atc_check=>ty_finding_code,
        description    TYPE string,
      END OF message.
    TYPES messages TYPE SORTED TABLE OF message WITH UNIQUE KEY check_name technical_name.

    METHODS constructor
      IMPORTING atc_variant_name TYPE zcl_bc_ccm_atc_check=>variant_name.

    "! Read the variant and extract all checks
    "! @parameter result  | List of checks
    METHODS get_variant_checks
      RETURNING VALUE(result) TYPE checks.

    "! Read the variant and extract all messages
    "! @parameter result  | List of messages
    METHODS get_variant_messages
      RETURNING VALUE(result) TYPE messages.

  PRIVATE SECTION.
    DATA atc_variant_name TYPE variant_name.

    "! Call standard API to determine all checks and messages
    "! @parameter result  | Standard information (Checks and messages)
    METHODS get_variant_standard
      RETURNING VALUE(result) TYPE  cl_satc_api_check_variant=>ty_checks_with_msg_priorities.

    "! Read the description text for the check
    "! @parameter check  | Class name of the check
    "! @parameter result | Description
    METHODS get_description_for_check
      IMPORTING !check        TYPE check-technical_name
      RETURNING VALUE(result) TYPE string.

    "! Read the description text for the message
    "! @parameter check   | Class name of the check
    "! @parameter message | Message ID
    "! @parameter result  | Description
    METHODS get_description_for_message
      IMPORTING !check        TYPE check-technical_name
                !message      TYPE message-technical_name
      RETURNING VALUE(result) TYPE string.
ENDCLASS.


CLASS zcl_bc_ccm_atc_check IMPLEMENTATION.
  METHOD constructor.
    me->atc_variant_name = atc_variant_name.
  ENDMETHOD.


  METHOD get_variant_checks.
    FINAL(checks) = get_variant_standard( ).

    LOOP AT checks INTO FINAL(check).
      INSERT VALUE #( technical_name = check-check
                      description    = get_description_for_check( check-check ) )
             INTO TABLE result.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_variant_messages.
    FINAL(checks) = get_variant_standard( ).

    LOOP AT checks INTO FINAL(check).
      LOOP AT check-priorities INTO FINAL(priority).
        INSERT VALUE #( check_name     = check-check
                        technical_name = priority-message_code
                        description    = get_description_for_message( check   = check-check
                                                                      message = priority-message_code ) )
               INTO TABLE result.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_variant_standard.
    TRY.
        FINAL(atc_api) = cl_satc_api=>create_api_factory( ).
        FINAL(check_variant) = atc_api->get_check_variant_by_name( atc_variant_name ).
        RETURN check_variant->get_check_messages( ).

      CATCH cx_satc_api INTO FINAL(error).
        RAISE EXCEPTION NEW zcx_bc_ccm_general_error( previous = error ).
    ENDTRY.
  ENDMETHOD.


  METHOD get_description_for_check.
    FINAL(checks) = VALUE checks( ( technical_name = 'CL_CI_TEST_ADMISSIBLE_ENHANCM'
                                    description    = `Allowed Enhancement Technologies` )
                                  ( technical_name = 'CL_CI_TEST_CRITICAL_STATEMENTS'
                                    description    = `Critical statements` )
                                  ( technical_name = 'CL_CI_TEST_CUST_MODIFICATIONS'
                                    description    = `Search customer modifications` )
                                  ( technical_name = 'CL_YCM_CC_CHECK_API_USAGE'
                                    description    = `Usage of APIs` ) ).

    RETURN VALUE #( checks[ technical_name = check ]-description OPTIONAL ).
  ENDMETHOD.


  METHOD get_description_for_message.
    FINAL(messages) = VALUE messages(
        ( check_name     = 'CL_CI_TEST_ADMISSIBLE_ENHANCM'
          technical_name = 'ENHINVALD'
          description    = `Enhancement technology not allowed` )
        ( check_name     = 'CL_CI_TEST_ADMISSIBLE_ENHANCM'
          technical_name = '__RFCERR__'
          description    = `Error occurred calling remote API ... (..., ... ...)` )
        ( check_name     = 'CL_CI_TEST_CRITICAL_STATEMENTS'
          technical_name = '0001'
          description    = `Call System Function: ...` )
        ( check_name     = 'CL_CI_TEST_CRITICAL_STATEMENTS'
          technical_name = '0002'
          description    = `Call Transaction ...` )
        ( check_name     = 'CL_CI_TEST_CRITICAL_STATEMENTS'
          technical_name = '0003'
          description    = `Use of a SYSTEM-CALL` )
        ( check_name     = 'CL_CI_TEST_CRITICAL_STATEMENTS'
          technical_name = '0004'
          description    = `Call Editor` )
        ( check_name     = 'CL_CI_TEST_CRITICAL_STATEMENTS'
          technical_name = '0005'
          description    = `Call Executable Program ...` )
        ( check_name     = 'CL_CI_TEST_CRITICAL_STATEMENTS'
          technical_name = '0006'
          description    = `Use of Native SQL` )
        ( check_name     = 'CL_CI_TEST_CRITICAL_STATEMENTS'
          technical_name = '0007'
          description    = `Use of ROLLBACK WORK` )
        ( check_name     = 'CL_CI_TEST_CRITICAL_STATEMENTS'
          technical_name = '0008'
          description    = `Use of Database Hint: ...` )
        ( check_name     = 'CL_CI_TEST_CRITICAL_STATEMENTS'
          technical_name = '0009'
          description    = `Dynamic Programming with GENERATE ...` )
        ( check_name     = 'CL_CI_TEST_CRITICAL_STATEMENTS'
          technical_name = '0010'
          description    = `Read a report/text pool` )
        ( check_name     = 'CL_CI_TEST_CRITICAL_STATEMENTS'
          technical_name = '0011'
          description    = `Write/delete a report/text pool` )
        ( check_name     = 'CL_CI_TEST_CRITICAL_STATEMENTS'
          technical_name = '0012'
          description    = `Read a dynpro` )
        ( check_name     = 'CL_CI_TEST_CRITICAL_STATEMENTS'
          technical_name = '0013'
          description    = `Write/delete a dynpro` )
        ( check_name     = 'CL_CI_TEST_CRITICAL_STATEMENTS'
          technical_name = '0014'
          description    = `Read NAMETAB` )
        ( check_name     = 'CL_CI_TEST_CRITICAL_STATEMENTS'
          technical_name = '0015'
          description    = `Write NAMETAB` )
        ( check_name     = 'CL_CI_TEST_CUST_MODIFICATIONS'
          technical_name = 'MOD'
          description    = `Object is modified` )
        ( check_name     = 'CL_CI_TEST_CUST_MODIFICATIONS'
          technical_name = '_GENFLAG'
          description    = `-No text-` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'AMDP'
          description    = `-No text-` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'AMDP_SUC'
          description    = `-No text-` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'ATTRIBUTE'
          description    = `-No text-` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'CLSSIC'
          description    = `Usage of classic API` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'CLSSIC_SUC'
          description    = `Usage of classic API (successor available)` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'DB_TAB_CDS'
          description    = `Usage of DDIC database tables in CDS views is not recommended` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'DB_TAB_SUC'
          description    = `Usage of DDIC database tables in CDS views is not recommended (successor available)` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'DPRCTD'
          description    = `Usage of deprecated API` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'DPRCTD_SUC'
          description    = `Usage of deprecated API (successor available)` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'INTRNL'
          description    = `Usage of internal API` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'INTRNL_SUC'
          description    = `Usage of internal API (successor available)` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'NOAPI'
          description    = `Usage of API that must not be used` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'NOAPI_SUC'
          description    = `Usage of API that must not be used (successor available)` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'PRFRM_PROG'
          description    = `PERFORM program is not allowed` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'PRVIDR_ERR'
          description    = `Data provider failed to fetch required data: ...` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'RFC_ERROR'
          description    = `Failed to call RFC function module: ...` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'SBMT_PROG'
          description    = `SUBMIT program is not recommended` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'SELECT'
          description    = `Reading from DDIC database tables or DDIC table views is not recommended` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'SELECT_SUC'
          description    = `Reading from DDIC database tables or DDIC table views is not recommended (successor available)` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'SPRVIDR_ER'
          description    = `Cannot read released apis in checked system: ...` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'TC_CLA'
          description    = `Usage of transactional-consistent classic API` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'TC_CLA_SUC'
          description    = `Usage of transactional-consistent classic API (successor available)` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'UPDATE'
          description    = `Updating DDIC database tables or DDIC table views is not allowed` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'UPDATE_SUC'
          description    = `Updating DDIC database tables or DDIC table views is not allowed (successor available)` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'U_ADD'
          description    = `Object usage found.` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'U_ALL'
          description    = `Object usage found.` )
        ( check_name     = 'CL_YCM_CC_CHECK_API_USAGE'
          technical_name = 'U_STD'
          description    = `Object usage found.` ) ).

    RETURN VALUE #( messages[ check_name     = check
                              technical_name = message ]-description OPTIONAL ).
  ENDMETHOD.
ENDCLASS.
