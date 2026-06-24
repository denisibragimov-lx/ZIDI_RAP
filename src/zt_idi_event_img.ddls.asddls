@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Transaction view for Event Image'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZT_IDI_EVENT_IMG 
    as select from ZI_IDI_EVENT_IMG
    
    association to parent ZT_IDI_EVENT as _Event
    on $projection.EventUuid = _Event.EventUuid
    
{
    key ImageUuid,
    key EventUuid,
    EventId,
    EventName,
    ImageUrl,
    ImageType,
    ImageFile,
    MimeType,
    FileName,
    SortOrder,
    IsImageMain,
    
    CreatedBy,
    CreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    /* Associations */
    _Event
}
