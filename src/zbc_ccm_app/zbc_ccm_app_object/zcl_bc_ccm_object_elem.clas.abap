CLASS zcl_bc_ccm_object_elem DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
ENDCLASS.


CLASS zcl_bc_ccm_object_elem IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA original_data TYPE STANDARD TABLE OF ZBC_C_CCMObjects WITH EMPTY KEY.

    DATA(document) = zcl_bc_ccm_document_api_fact=>create_document( ).
    original_data = CORRESPONDING #( it_original_data ).

    LOOP AT original_data REFERENCE INTO DATA(original).
      CASE original->Classification.
        WHEN 'B'.
          original->ClassPriority = 5.
        WHEN 'C'.
          original->ClassPriority = 2.
        WHEN 'D'.
          original->ClassPriority = 1.
      ENDCASE.

      DATA(linked_document) = document->get_documentation( VALUE #( provider_id = original->ProviderId
                                                                    object_type = original->ObjectType
                                                                    object_name = original->ObjectName
                                                                    package     = original->PackageName ) ).

      original->DocumentID       = linked_document-DocumentId.
      original->ShortDescription = linked_document-ShortDescription.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( original_data ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    et_requested_orig_elements = VALUE #( ( `CLASSIFICATION` )
                                          ( `PROVIDERID` )
                                          ( `OBJECTTYPE` )
                                          ( `OBJECTNAME` )
                                          ( `PACKAGENAME` ) ).
  ENDMETHOD.
ENDCLASS.
