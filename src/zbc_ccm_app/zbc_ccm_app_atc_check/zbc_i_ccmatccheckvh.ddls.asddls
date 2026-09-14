@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VH for ATC Check'
define view entity ZBC_I_CCMATCCheckVH
  as select from zbc_ccm_atcchk
{
      @ObjectModel.text.element: [ 'CheckText' ]
      @UI.textArrangement: #TEXT_ONLY
  key check_name as CheckName,
      check_text as CheckText
}
