INTERFACE zif_bc_ccm_auth
  PUBLIC.

  TYPES activity TYPE c LENGTH 2.

  CONSTANTS:
    BEGIN OF activities,
      create     TYPE activity VALUE '01',
      change     TYPE activity VALUE '02',
      display    TYPE activity VALUE '03',
      delete     TYPE activity VALUE '06',
      execute    TYPE activity VALUE '16',
      administer TYPE activity VALUE '70',
    END OF activities.

  "! Check if the user has the authorization
  "! @parameter activity    | ACTVT (Activity)
  "! @parameter provider_id | Provider ID
  "! @parameter result      | X = Authorization, '' = No authorization
  METHODS has_authority
    IMPORTING activity      TYPE activity
              provider_id   TYPE sca_ds_object_provider_id OPTIONAL
    RETURNING VALUE(result) TYPE abap_boolean.
ENDINTERFACE.
