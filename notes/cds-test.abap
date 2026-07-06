CLASS zcl_bs_demo_ac_objects DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_bs_demo_ac_objects IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    TYPES generic TYPE bal_lang_vrs_obj_active_aplo.

    DATA result TYPE STANDARD TABLE OF generic WITH EMPTY KEY.

    " Only from S/4HANA 2025
    SELECT FROM ars_lang_objtype
      FIELDS *
      WHERE     supports_sap_cloud_platform    = @abap_true
            AND does_not_have_language_version = @abap_false
      INTO TABLE @DATA(ac_objects).

    LOOP AT ac_objects INTO DATA(object) WHERE cds_view_for_active_objects IS NOT INITIAL.
      SELECT
        FROM (object-cds_view_for_active_objects)
        FIELDS *
        WHERE abap_language_version = '5'
        ORDER BY object_name DESCENDING
        INTO CORRESPONDING FIELDS OF TABLE @result
        UP TO 15 ROWS.

      out->write( |Type: { object-object_type }, Table: { object-table_name }| ).
      IF result IS NOT INITIAL.
        out->write( result ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.