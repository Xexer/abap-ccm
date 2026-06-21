@EndUserText.label: 'Settings'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZBC_I_CCMSettings
  as select from zbc_ccm_sett
  association              to parent ZBC_R_CCMSettingsS  as _SettingsAll on $projection.SingletonID = _SettingsAll.SingletonID
  association of exact one to one ZBC_I_CCMSettingsKeyVH as _SettingsKey on _SettingsKey.SettingKey = $projection.SettingKey
{
  key setting_uuid          as SettingUuid,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMSettingsKeyVH', element : 'SettingKey' } }]
      @ObjectModel.text.element: [ 'Description' ]
      @UI.textArrangement: #TEXT_ONLY
  key setting_key           as SettingKey,
      _SettingsKey.Description,
      setting_value         as SettingValue,
      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      @Consumption.hidden: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      @Consumption.hidden: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Consumption.hidden: true
      1                     as SingletonID,
      _SettingsAll
}
