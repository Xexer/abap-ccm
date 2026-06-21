@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Settings Key Value Help'
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZBC_I_CCMSettingsKeyVH
  as select from    DDCDS_CUSTOMER_DOMAIN_VALUE(
                      p_domain_name : 'ZBC_CCM_SETTING_KEY') as Values
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T(
                      p_domain_name : 'ZBC_CCM_SETTING_KEY') as Texts on  Texts.domain_name    = Values.domain_name
                                                                      and Texts.value_position = Values.value_position
                                                                      and Texts.language       = $session.system_language
{
      @ObjectModel.text.element: [ 'Description' ]
      @UI.textArrangement: #TEXT_ONLY
  key Values.value_low as SettingKey,

      @UI.hidden: true
      Texts.text       as Description
}
