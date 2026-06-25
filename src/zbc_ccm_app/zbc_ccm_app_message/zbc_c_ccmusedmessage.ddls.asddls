@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Used Messages'
@Metadata.allowExtensions: true
define root view entity ZBC_C_CCMUsedMessage
  provider contract transactional_query
  as projection on ZBC_R_CCMUsedMessage
{
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMProviderVH', element : 'ProviderId' } }]
          @ObjectModel.text.element: [ 'SystemName' ]
          @UI.textArrangement: #TEXT_ONLY
  key     ProviderId,
  key     ObjType,
  key     ObjName,
  key     FindingId,
          _Provider.SystemName,
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMPriorityVH', element : 'Priority' } }]
          @ObjectModel.text.element: [ 'Description' ]
          @UI.textArrangement: #TEXT_ONLY
          Priority,
          _Priority.Description,
          CheckTitle,
          CheckMessage,
          RefObjType,
          RefObjName,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_BC_CCM_USED_MSG_ELEM'
  virtual PriorityIcon : abap.int1
}
