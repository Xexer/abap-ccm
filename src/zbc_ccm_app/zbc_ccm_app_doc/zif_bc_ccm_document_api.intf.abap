INTERFACE zif_bc_ccm_document_api
  PUBLIC.

  TYPES: BEGIN OF filter,
           provider_id TYPE ZBC_R_CCMObjects-ProviderId,
           object_type TYPE ZBC_R_CCMObjects-ObjectType,
           object_name TYPE ZBC_R_CCMObjects-ObjectName,
           package     TYPE ZBC_R_CCMObjects-PackageName,
         END OF filter.

  TYPES document TYPE ZBC_R_CCMDocument.

  "! Get Documentation by Filter
  "! @parameter filter | Filter
  "! @parameter result | Document
  METHODS get_documentation
    IMPORTING !filter       TYPE filter
    RETURNING VALUE(result) TYPE document.
ENDINTERFACE.
