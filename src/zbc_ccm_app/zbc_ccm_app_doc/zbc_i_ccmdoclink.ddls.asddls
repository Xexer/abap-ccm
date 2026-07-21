@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Document Link'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZBC_I_CCMDocLink
  as select from zbc_ccm_dlink
  association to parent ZBC_R_CCMDocument as _Document on _Document.DocumentID = $projection.DocumentId
  association of exact one to one ZBC_I_CCMProviderVH as _Provider on _Provider.ProviderId = $projection.ProviderId  
{
  key link_id     as LinkId,
      provider_id as ProviderId,
      obj_type    as ObjectType,
      obj_name    as ObjectName,
      document_id as DocumentId,
      _Document,
      _Provider
}
