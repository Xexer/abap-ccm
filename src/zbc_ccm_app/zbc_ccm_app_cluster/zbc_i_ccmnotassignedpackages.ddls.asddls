@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Not Assigned Packages'
define view entity ZBC_I_CCMNotAssignedPackages
  as select from ZBC_I_CCMPackageVH
  association of one to one ZBC_I_CCMClusterAssignment as _Assignment on  _Assignment.ProviderID = $projection.ProviderId
                                                                      and _Assignment.ObjectType = $projection.ObjectType
                                                                      and _Assignment.ObjectName = $projection.ObjectName
{
  key ProviderId,
  key ObjectType,
  key ObjectName,
      SystemName,
      case when _Assignment.ObjectID <> abap.raw'00000000000000000000000000000000' then 'X'
          else ''
      end as IsAssigned
}
