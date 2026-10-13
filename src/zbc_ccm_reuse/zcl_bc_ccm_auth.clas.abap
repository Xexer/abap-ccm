CLASS zcl_bc_ccm_auth DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE
  GLOBAL FRIENDS zcl_bc_ccm_auth_factory.

  PUBLIC SECTION.
    INTERFACES zif_bc_ccm_auth.
ENDCLASS.


CLASS zcl_bc_ccm_auth IMPLEMENTATION.
  METHOD zif_bc_ccm_auth~has_authority.
    IF provider_id IS INITIAL.
      AUTHORITY-CHECK OBJECT 'ZBC_CCM'
                      ID 'ACTVT' FIELD activity
                      ID 'ZBCCCMPROV' DUMMY.

    ELSE.
      AUTHORITY-CHECK OBJECT 'ZBC_CCM'
                      ID 'ACTVT' FIELD activity
                      ID 'ZBCCCMPROV' FIELD provider_id.

    ENDIF.

    RETURN xsdbool( sy-subrc = 0 ).
  ENDMETHOD.
ENDCLASS.
