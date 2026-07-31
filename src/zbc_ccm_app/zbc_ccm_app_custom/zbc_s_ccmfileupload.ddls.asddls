@EndUserText.label: 'Upload File structure'
define root abstract entity ZBC_S_CCMFileUpload
{
  @Semantics.largeObject: {
    mimeType : 'MimeType',
    fileName : 'Filename'
  }
  Attachment : abap.rawstring;
  @Semantics.mimeType: true
  @UI.hidden : true
  MimeType   : abap.char(128);
  @UI.hidden : true
  Filename   : abap.char(128);
}
