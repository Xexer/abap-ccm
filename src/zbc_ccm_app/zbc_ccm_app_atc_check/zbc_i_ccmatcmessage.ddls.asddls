@EndUserText.label: 'ATC Message Customizing'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZBC_I_CCMATCMessage
  as select from zbc_ccm_atcmsg
  association              to parent ZBC_R_CCMATCMessageS     as _ATCMessageAll    on $projection.SingletonID = _ATCMessageAll.SingletonID
  association of exact one to one ZBC_I_CCMATCCheckVH         as _Check            on _Check.CheckName = $projection.CheckName
  association of exact one to one ZBC_I_CCMApproveSettingVH   as _ApproveSetting   on _ApproveSetting.AutoApproveSetting = $projection.AutoApprovalSetting
  association of exact one to one ZBC_I_CCMOverwriteMessageVH as _OverwriteMessage on _OverwriteMessage.OverwriteMessage = $projection.OverwriteMessageType
{
      @ObjectModel.text.element: [ 'CheckText' ]
      @UI.textArrangement: #TEXT_ONLY
  key check_name                    as CheckName,
      @ObjectModel.text.element: [ 'MessageText' ]
      @UI.textArrangement: #TEXT_FIRST
  key message_name                  as MessageName,
      @UI.hidden: true  
      message_text                  as MessageText,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMApproveSettingVH', element : 'AutoApproveSetting' } }]
      @ObjectModel.text.element: [ 'ApprovalDescription' ]
      @UI.textArrangement: #TEXT_ONLY
      auto_approval_setting         as AutoApprovalSetting,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMOverwriteMessageVH', element : 'OverwriteMessage' } }]
      @ObjectModel.text.element: [ 'OverwriteDescription' ]
      @UI.textArrangement: #TEXT_ONLY
      overwrite_message_type        as OverwriteMessageType,

      _Check.CheckText,
      _ApproveSetting.Description   as ApprovalDescription,
      _OverwriteMessage.Description as OverwriteDescription,

      @Semantics.user.createdBy: true
      local_created_by              as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at              as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      @Consumption.hidden: true
      local_last_changed_by         as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      @Consumption.hidden: true
      local_last_changed_at         as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at               as LastChangedAt,
      @Consumption.hidden: true
      1                             as SingletonID,
      _ATCMessageAll
}
