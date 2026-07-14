@Metadata.allowExtensions: true
@ObjectModel: {
  sapObjectNodeType.name: 'ZBC_Document'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZBC_C_CCMDocument
  provider contract transactional_query
  as projection on ZBC_R_CCMDocument
  association [1..1] to ZBC_R_CCMDocument as _BaseEntity on $projection.DocumentID = _BaseEntity.DocumentID
{
  key DocumentID,
      ShortDescription,
      LongDescription,
      CustomScore,
      DeviatingScoreB,
      DeviatingScoreC,
      DeviatingScoreD,
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
      _BaseEntity,
      _Link : redirected to composition child ZBC_C_CCMDocLink
}
