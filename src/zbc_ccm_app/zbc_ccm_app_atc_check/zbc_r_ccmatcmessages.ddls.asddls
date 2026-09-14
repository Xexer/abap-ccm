@EndUserText.label: 'ATC Message Customizing Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Semantics.valueRange.maximum: '1'
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'ATCMessageAll'
  }
}
define root view entity ZBC_R_CCMATCMessageS
  as select from    I_Language
    left outer join zbc_ccm_atcmsg on 0 = 0
  composition [0..*] of ZBC_I_CCMATCMessage as _ATCMessage
{
      @UI.facet: [ {
        id: 'ATCMessage',
        purpose: #STANDARD,
        type: #LINEITEM_REFERENCE,
        label: 'ATC Message Customizing',
        position: 1 ,
        targetElement: '_ATCMessage'
      } ]
      @UI.lineItem: [ {
        position: 1
      } ]
  key 1                                     as SingletonID,
      _ATCMessage,
      @UI.hidden: true
      max( zbc_ccm_atcmsg.last_changed_at ) as LastChangedAtMax
}
where
  I_Language.Language = $session.system_language
