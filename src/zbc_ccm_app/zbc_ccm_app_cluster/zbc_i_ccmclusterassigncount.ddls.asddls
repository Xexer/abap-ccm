@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Assignment Cound'
define view entity ZBC_I_CCMClusterAssignCount
  as select from ZBC_I_CCMClusterAssignment
{
  key ClusterID,
      count( * ) as NumberOfPackages
}
group by
  ClusterID
