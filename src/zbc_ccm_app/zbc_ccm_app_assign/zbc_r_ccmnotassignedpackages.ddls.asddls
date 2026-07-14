@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Not Assigned Packages'
define root view entity ZBC_R_CCMNotAssignedPackages
  as select from ZBC_I_CCMNotAssignedPackages
  association of one to one ZBC_I_CCMProviderCust      as _Provider   on  _Provider.ProviderId = $projection.ProviderId
  association of one to one ZBC_I_CCMClusterAssignment as _Assignment on  _Assignment.ProviderID = $projection.ProviderId
                                                                      and _Assignment.ObjectType = $projection.ObjectType
                                                                      and _Assignment.ObjectName = $projection.ObjectName
{
  key ProviderId,
  key ObjectType,
  key ObjectName,
      SystemName,
      cast( IsAssigned as abap_boolean ) as IsAssignedBool,
      _Assignment.ClusterID,
      _Provider,
      _Assignment
}
