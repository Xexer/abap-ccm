@EndUserText.label: 'Load Content Popup'
define root abstract entity ZBC_S_CCMLoadContent
{
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMUploadModeVH', element : 'UploadMode' } }]
  UploadMode        : zbc_ccm_upload_mode;

  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMProviderVH', element : 'ProviderId' } }]
  @EndUserText.label: 'Overwrite Provider'
  OverwriteProvider : sca_ds_object_provider_id;

  @EndUserText.label: 'JSON file (RAW)'
  JSONFilePath      : abap.sstring( 512 );

  @EndUserText.label: 'Excel file'
  _Files            : association [1] to ZBC_S_CCMFileUpload on 1 = 1;
}
