@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel: {
  sapObjectNodeType.name: 'ZBC_Cluster'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZBC_C_CCMCluster
  provider contract transactional_query
  as projection on ZBC_R_CCMCluster
  association [1..1] to ZBC_R_CCMCluster as _BaseEntity on $projection.ClusterID = _BaseEntity.ClusterID
{
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMClusterVH', element : 'ClusterID' } }]
      @ObjectModel.text.element: [ 'ClusterName' ]
      @UI.textArrangement: #TEXT_ONLY
  key ClusterID,
      ClusterName,
      _Count.NumberOfPackages,
      @Semantics: {
        user.createdBy: true
      }
      LocalCreatedBy,
      @Semantics: {
        systemDateTime.createdAt: true
      }
      LocalCreatedAt,
      @Semantics: {
        user.localInstanceLastChangedBy: true
      }
      LocalLastChangedBy,
      @Semantics: {
        systemDateTime.localInstanceLastChangedAt: true
      }
      LocalLastChangedAt,
      @Semantics: {
        systemDateTime.lastChangedAt: true
      }
      LastChangedAt,
      _BaseEntity,
      _Assignment : redirected to composition child ZBC_C_CCMClusterAssignment
}
