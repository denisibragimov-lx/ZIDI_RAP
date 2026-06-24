@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Image'
@Metadata.allowExtensions: true

define view entity ZC_IDI_EVENT_IMG 
  as projection on ZT_IDI_EVENT_IMG
{
        key ImageUuid,
        key EventUuid,
        EventId,
        EventName,
        
        @Semantics.imageUrl: true
        ImageUrl,
        ImageType,
        SortOrder,

        @Semantics.largeObject: { mimeType: 'MimeType',
                                fileName: 'FileName' }
        @EndUserText.label: 'Image File'
        ImageFile,
        @EndUserText.label: 'Mime Type'
        MimeType,
        @EndUserText.label: 'File name'
        FileName,
        @EndUserText.label: 'The main Image'
        @Consumption.filter.defaultValue: ' '
        IsImageMain,     
        
        _Event : redirected to parent ZC_IDI_EVENT
}
