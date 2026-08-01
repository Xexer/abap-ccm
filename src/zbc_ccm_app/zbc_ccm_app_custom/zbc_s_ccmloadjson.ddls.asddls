@EndUserText.label: 'Load Content via JSON'
define root abstract entity ZBC_S_CCMLoadJSON
{
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMUploadModeVH', element : 'UploadMode' } }]
  UploadMode        : zbc_ccm_upload_mode;

  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMProviderVH', element : 'ProviderId' } }]
  @EndUserText.label: 'Overwrite Provider'
  OverwriteProvider : sca_ds_object_provider_id;

  @EndUserText.label: 'JSON path (RAW)'
  JSONFilePath      : abap.sstring( 512 );
}
