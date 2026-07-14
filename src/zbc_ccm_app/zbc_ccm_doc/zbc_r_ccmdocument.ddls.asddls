@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZBC_Document'
define root view entity ZBC_R_CCMDocument
  as select from zbc_ccm_doc as Document
  composition of exact one to many ZBC_I_CCMDocLink as _Link
{
  key document_id           as DocumentID,
      short_description     as ShortDescription,
      long_description      as LongDescription,
      custom_score          as CustomScore,
      deviating_score_b     as DeviatingScoreB,
      deviating_score_c     as DeviatingScoreC,
      deviating_score_d     as DeviatingScoreD,
      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      _Link
}
