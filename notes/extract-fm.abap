FUNCTION z_ca_atc_level_a_objects
  IMPORTING
    VALUE(language_version) TYPE char1
  EXPORTING
    VALUE(objects) TYPE i.



  " Version 1.1.0

  TYPES: BEGIN OF configuration,
           types         TYPE string,
           handler_class TYPE ars_lang_objtype-handler_class_name,
           table         TYPE ars_lang_objtype-table_name,
           field         TYPE ars_lang_objtype-column_name,
           z_filter      TYPE string,
           e_filter      TYPE string,
         END OF configuration.

  TYPES: BEGIN OF counter,
           types  TYPE string,
           number TYPE i,
         END OF counter.

  TYPES: BEGIN OF filter,
           table TYPE ars_lang_objtype-table_name,
           field TYPE ars_lang_objtype-column_name,
           query TYPE string,
         END OF filter.

  DATA filters        TYPE SORTED TABLE OF filter WITH UNIQUE KEY table.
  DATA object_filter  TYPE string.
  DATA configurations TYPE STANDARD TABLE OF configuration WITH EMPTY KEY.
  DATA generic        TYPE REF TO data.
  DATA counters       TYPE STANDARD TABLE OF counter WITH EMPTY KEY.

  IF language_version <> '2' AND language_version <> '5'.
    RETURN.
  ENDIF.

  filters = VALUE #( ( table = 'REPOSRC' field = 'PROGNAME' )
                     ( table = 'PROGDIR' field = 'NAME' )
                     ( table = 'KTD_W_HEADER' field = 'NAME' )
                     ( table = 'DD02L' field = 'TABNAME' )
                     ( table = 'DD40L' field = 'TYPENAME' )
                     ( table = 'DD04L' field = 'ROLLNAME' )
                     ( table = 'DD01L' field = 'DOMNAME' )
                     ( table = 'DDDDLSRC' field = 'DDLNAME' )
                     ( table = 'DDDRTY_SOURCE' field = 'TYPE_NAME' )
                     ( table = 'DDLXSRC' field = 'DDLXNAME' )
                     ( table = 'DDDSFD_SOURCE' field = 'SCALAR_FUNCTION_NAME' )
                     ( table = 'APJ_W_JCE_ROOT' field = 'JOB_CATALOG_ENTRY_NAME' )
                     ( table = 'APJ_W_JT_ROOT' field = 'JOB_TEMPLATE_NAME' )
                     ( table = 'O2XSLTDESC' field = 'XSLTDESC' )
                     ( table = 'NONT_HEADER' field = 'NONT_NAME' )
                     ( table = 'RONT_HEADER' field = 'RONT_NAME' )
                     ( table = '/IWBEP/I_V4_MSGR' field = 'GROUP_ID' )
                     ( table = '/IWBEP/I_MGW_OHD' field = 'TECHNICAL_NAME' )
                     ( table = '/IWFND/I_MED_OHD' field = 'MODEL_IDENTIFIER' )
                     ( table = '/IWFND/I_MED_SRH' field = 'SRV_IDENTIFIER' )
                     ( table = '/IWBEP/I_MGW_SRH' field = 'TECHNICAL_NAME' )
                     ( table = '/IWBEP/I_MGW_VAH' field = 'TECHNICAL_NAME' )
                     ( table = 'ACMDCLSRC' field = 'DCLNAME' )
                     ( table = 'TCDRP' field = 'OBJECT' )
                     ( table = 'DDDESD_HEADER' field = 'SCHEMA_NAME' )
                     ( table = 'ABAP_DAEMON_DT' field = 'DAEMON_ID' )
                     ( table = 'DDDRAS_SOURCE' field = 'ASPECT_NAME' )
                     ( table = 'DDDSFI_SOURCE' field = 'IMPLEMENTATION_REFERENCE_NAME' )
                     ( table = 'DDDTDC_SOURCE' field = 'DTDC_NAME' )
                     ( table = 'DDDTEB_HEADER' field = 'BUFFER_NAME' )
                     ( table = 'AMC_APPL' field = 'APPLICATION_ID' )
                     ( table = 'APC_APPL' field = 'APPLICATION_ID' )
                     ( table = 'SPRV_HEAD' field = 'PRV_PRX_NAME' )
                     ( table = 'SRVB_HEAD' field = 'SRVB_NAME' )
                     ( table = 'SRVDSRC' field = 'SRVDNAME' )
                     ( table = 'VEPHEADER' field = 'VEPNAME' )
                     ( table = 'WMPC_DT' field = 'WMPC_ID' )
                     ( table = 'ARCH_OBJ' field = 'OBJECT' )
                     ( table = 'ENHSPOTHEADER' field = 'ENHSPOT' )
                     ( table = 'GSM_MD_PRV_W' field = 'PROVIDER_ID' )
                     ( table = 'TDEVC' field = 'DEVCLASS' )
                     ( table = 'CDB_OBJH' field = 'OBJ_NAME' )
                     ( table = 'SPROXHDR' field = 'OBJ_NAME' )
                     ( table = 'DD12L' field = 'SQLTAB' )
                     ( table = 'USOB_SM' query = | AND MODIFIER <> 'SAP' AND MODIFIER <> '!USOBHASH'| )
                     ( table = 'SIT2_BT' field = 'SITNBASETEMPLATEID' )
                     ( table = 'SIT2_CT' field = 'SITNCONFIGNTEMPLATEID' )
                     ( table = 'TMC1' field = 'GSTRU' )
                     ( table = 'T681' query = | AND SAPSY = 'CUSTOMER'| ) ).

  object_filter = SWITCH #( language_version
                            WHEN '2' THEN `supports_key_user = @abap_true`
                            WHEN '5' THEN `supports_sap_cloud_platform = @abap_true` ).

  SELECT FROM ars_lang_objtype
    FIELDS *
    WHERE     (object_filter)
          AND does_not_have_language_version = @abap_false
          AND table_name IS NOT INITIAL
    INTO TABLE @DATA(ac_objects).

  LOOP AT ac_objects INTO DATA(object).
    TRY.
        DATA(config) = REF #( configurations[ table = object-table_name ] ).
        config->types &&= |, { object-object_type }|.
        CONTINUE.

      CATCH cx_sy_itab_line_not_found.
        INSERT VALUE #( table         = object-table_name
                        types         = object-object_type
                        handler_class = object-handler_class_name
                        field         = object-column_name )
               INTO TABLE configurations REFERENCE INTO config.
    ENDTRY.

    config->z_filter = VALUE #( filters[ table = config->table ]-field OPTIONAL ).

    CASE config->table.
      WHEN 'SMIMLOIO'.
        config->field = 'PROP01'.
      WHEN 'DD25L'.
        config->e_filter = 'VIEWNAME'.
    ENDCASE.
  ENDLOOP.

  LOOP AT configurations INTO DATA(configuration).
    DATA(condition) = |{ configuration-field } = '{ language_version }'|.
    IF configuration-z_filter IS NOT INITIAL.
      condition &&= | AND ( { configuration-z_filter } LIKE 'Z%' OR { configuration-z_filter } LIKE 'Y%' )|.
    ENDIF.
    IF configuration-e_filter IS NOT INITIAL.
      condition &&= | AND ( { configuration-e_filter } LIKE 'EZ%' OR { configuration-e_filter } LIKE 'EY%' )|.
    ENDIF.
    DATA(query) = VALUE #( filters[ table = configuration-table ]-query OPTIONAL ).
    IF query IS NOT INITIAL.
      condition &&= query.
    ENDIF.

    SELECT
      FROM (configuration-table)
      FIELDS COUNT( * )
      WHERE (condition)
      INTO @DATA(number_of_entries).

*    CREATE DATA generic TYPE STANDARD TABLE OF (configuration-table).
*    SELECT
*      FROM (configuration-table)
*      FIELDS *
*      WHERE (condition)
*      INTO CORRESPONDING FIELDS OF TABLE @generic->*.
*    IF lines( generic->* ) > 0.
*      BREAK-POINT.
*    ENDIF.

    INSERT VALUE #( types  = configuration-types
                    number = number_of_entries ) INTO TABLE counters.
  ENDLOOP.

  LOOP AT counters INTO DATA(counter).
    objects += counter-number.
  ENDLOOP.
ENDFUNCTION.