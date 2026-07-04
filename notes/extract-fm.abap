FUNCTION z_ca_atc_level_a_objects
  EXPORTING
    VALUE(objects) TYPE i.



  " Version 0.8.0

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

  DATA configurations TYPE STANDARD TABLE OF configuration WITH EMPTY KEY.
  DATA counters       TYPE STANDARD TABLE OF counter WITH EMPTY KEY.

  SELECT FROM ars_lang_objtype
    FIELDS *
    WHERE     supports_sap_cloud_platform    = @abap_true
          AND does_not_have_language_version = @abap_false
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

    CASE config->table.
      WHEN 'SMIMLOIO'.
        config->field = 'PROP01'.
      WHEN 'PROGDIR' OR 'KTD_W_HEADER'.
        config->z_filter = 'NAME'.
      WHEN 'DD02L'.
        config->z_filter = 'TABNAME'.
      WHEN 'DD40L'.
        config->z_filter = 'TYPENAME'.
      WHEN 'DD04L'.
        config->z_filter = 'ROLLNAME'.
      WHEN 'DD01L'.
        config->z_filter = 'DOMNAME'.
      WHEN 'DDDDLSRC'.
        config->z_filter = 'DDLNAME'.
      WHEN 'DDDRTY_SOURCE'.
        config->z_filter = 'TYPE_NAME'.
      WHEN 'DDLXSRC'.
        config->z_filter = 'DDLXNAME'.
      WHEN 'DDDSFD_SOURCE'.
        config->z_filter = 'SCALAR_FUNCTION_NAME'.
      WHEN 'DD25L'.
        config->e_filter = 'VIEWNAME'.
      WHEN 'APJ_W_JCE_ROOT'.
        config->z_filter = 'JOB_CATALOG_ENTRY_NAME'.
      WHEN 'APJ_W_JT_ROOT'.
        config->z_filter = 'JOB_TEMPLATE_NAME'.
      WHEN 'O2XSLTDESC'.
        config->z_filter = 'XSLTDESC'.
      WHEN 'NONT_HEADER'.
        config->z_filter = 'NONT_NAME'.
      WHEN 'RONT_HEADER'.
        config->z_filter = 'RONT_NAME'.
      WHEN '/IWBEP/I_V4_MSGR'.
        config->z_filter = 'GROUP_ID'.
      WHEN 'TDEVC'.
        config->z_filter = 'DEVCLASS'.
    ENDCASE.
  ENDLOOP.

  LOOP AT configurations INTO DATA(configuration).
    DATA(condition) = |{ configuration-field } = '5'|.
    IF configuration-z_filter IS NOT INITIAL.
      condition &&= | AND ( { configuration-z_filter } LIKE 'Z%' OR { configuration-z_filter } LIKE 'Y%' )|.
    ENDIF.
    IF configuration-e_filter IS NOT INITIAL.
      condition &&= | AND ( { configuration-e_filter } LIKE 'EZ%' OR { configuration-e_filter } LIKE 'EY%' )|.
    ENDIF.

    SELECT
      FROM (configuration-table)
      FIELDS COUNT( * )
      WHERE (condition)
      INTO @DATA(number_of_entries).

    INSERT VALUE #( types  = configuration-types
                    number = number_of_entries ) INTO TABLE counters.
  ENDLOOP.

  LOOP AT counters INTO DATA(counter).
    objects += counter-number.
  ENDLOOP.
ENDFUNCTION.