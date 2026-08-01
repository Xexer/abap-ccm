CLASS zcl_bc_ccm_file_excel DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE
  GLOBAL FRIENDS zcl_bc_ccm_file_factory.

  PUBLIC SECTION.
    INTERFACES zif_bc_ccm_file.
ENDCLASS.


CLASS zcl_bc_ccm_file_excel IMPLEMENTATION.
  METHOD zif_bc_ccm_file~load_file.
    DATA(document) = xco_cp_xlsx=>document->for_file_content( file-excel_file-Attachment )->read_access( ).
    DATA(sheet) = document->get_workbook( )->worksheet->at_position( 1 ).

    DATA(pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ).
    sheet->select( pattern
      )->row_stream(
      )->operation->write_to( REF #( result )
      )->set_value_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value
      )->execute( ).

    DELETE result INDEX 1.
  ENDMETHOD.
ENDCLASS.
