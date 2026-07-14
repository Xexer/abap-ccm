CLASS lhc_Package DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Package RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Package RESULT result.

    METHODS SetClusterForPackage FOR MODIFY
      IMPORTING keys FOR ACTION Package~SetClusterForPackage.

ENDCLASS.


CLASS lhc_Package IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.


  METHOD get_global_authorizations.
  ENDMETHOD.


  METHOD SetClusterForPackage.
    DATA new_assignments    TYPE TABLE FOR CREATE ZBC_R_CCMCluster\_Assignment.
    DATA delete_assignments TYPE TABLE FOR DELETE ZBC_R_CCMCluster\\Assignment.

    TRY.
        DATA(action_key) = keys[ 1 ].
        DATA(new_cluster_id) = action_key-%param-ClusterID.
      CATCH cx_sy_itab_line_not_found.
        " Check in next step
    ENDTRY.

    IF new_cluster_id IS INITIAL.
      INSERT new_message( id       = 'ZBC_CCM'
                          number   = '007'
                          severity = if_abap_behv_message=>severity-error )
             INTO TABLE reported-%other.
      RETURN.
    ENDIF.

    READ ENTITIES OF ZBC_R_CCMNotAssignedPackages IN LOCAL MODE
         ENTITY Package
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(selected_packages).

    INSERT VALUE #( %cid_ref  = action_key-%cid_ref
                    clusterid = new_cluster_id )
           INTO TABLE new_assignments REFERENCE INTO DATA(new_assignment).

    LOOP AT selected_packages INTO DATA(selected_package).
      IF selected_package-IsAssignedBool = abap_true.
        SELECT SINGLE FROM ZBC_I_CCMClusterAssignment
          FIELDS ObjectID
          WHERE     ProviderID = @selected_package-ProviderId
                AND ObjectType = @selected_package-ObjectType
                AND ObjectName = @selected_package-ObjectName
          INTO @DATA(found_assignment).

        INSERT VALUE #( %cid_ref = action_key-%cid_ref
                        objectid = found_assignment )
               INTO TABLE delete_assignments.
      ENDIF.

      INSERT VALUE #( %cid                = xco_cp=>uuid( )->value
                      providerid          = selected_package-ProviderId
                      objecttype          = selected_package-ObjectType
                      objectname          = selected_package-ObjectName
                      %control-providerid = if_abap_behv=>mk-on
                      %control-objecttype = if_abap_behv=>mk-on
                      %control-objectname = if_abap_behv=>mk-on )
             INTO TABLE new_assignment->%target.
    ENDLOOP.

    MODIFY ENTITIES OF ZBC_R_CCMCluster
           ENTITY Assignment
           DELETE FROM delete_assignments
           ENTITY CCMCluster
           CREATE BY \_Assignment FROM new_assignments.

    INSERT new_message( id       = 'ZBC_CCM'
                        number   = '008'
                        severity = if_abap_behv_message=>severity-success
                        v1       = lines( selected_packages ) )
           INTO TABLE reported-%other.
  ENDMETHOD.
ENDCLASS.


CLASS lsc_ZBC_R_CCMNOTASSIGNEDPACKAG DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS
      save_modified REDEFINITION.

    METHODS
      cleanup_finalize REDEFINITION.

ENDCLASS.


CLASS lsc_ZBC_R_CCMNOTASSIGNEDPACKAG IMPLEMENTATION.
  METHOD save_modified.
  ENDMETHOD.


  METHOD cleanup_finalize.
  ENDMETHOD.
ENDCLASS.
