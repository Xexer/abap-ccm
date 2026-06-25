@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Messages'
@Metadata.allowExtensions: true
define view entity ZBC_C_CCMMessages
  as projection on ZBC_I_CCMMessages
{
  key     ProviderId,
  key     ObjectType,
  key     ObjectName,
  key     FindingId,
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMPriorityVH', element : 'Priority' } }]
          @ObjectModel.text.element: [ 'Description' ]
          @UI.textArrangement: #TEXT_ONLY
          Priority,
          _Priority.Description,
          CheckTitle,
          CheckMessage,
          RefObjType,
          RefObjName,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_BC_CCM_MESSAGE_ELEM'
  virtual PriorityIcon : abap.int1,

          _Objects : redirected to parent ZBC_C_CCMObjects,
          _Priority
}
