@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZBC_CCMCustomAPI'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZBC_C_CCMCustomAPIs
  provider contract transactional_query
  as projection on ZBC_R_CCMCustomAPIs
  association [1..1] to ZBC_R_CCMCustomAPIs as _BaseEntity on  $projection.ProviderID = _BaseEntity.ProviderID
                                                           and $projection.ObjectType = _BaseEntity.ObjectType
                                                           and $projection.ObjectName = _BaseEntity.ObjectName
{
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMProviderVH', element : 'ProviderId' } }]
      @ObjectModel.text.element: [ 'SystemName' ]
      @UI.textArrangement: #TEXT_ONLY
  key ProviderID,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMObjectTypeAPIVH', element : 'ObjectType' } }]
      @ObjectModel.text.element: [ 'Description' ]
      @UI.textArrangement: #TEXT_FIRST
  key ObjectType,
  key ObjectName,
      ShortDescription,
      _Provider.SystemName,
      _ObjectType.Description,
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
      _BaseEntity
}
