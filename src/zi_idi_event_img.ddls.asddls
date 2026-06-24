@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Event Image'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_IDI_EVENT_IMG as select from ZIDI_EVENT_IMG
association to parent ZI_IDI_EVENT as _Event
    on $projection.EventUuid = _Event.EventUuid
{
    key image_uuid          as ImageUuid,
    key event_uuid          as EventUuid,
    _Event.EventId          as EventId,
    _Event.EventName        as EventName,
    @Semantics.imageUrl: true
    image_url               as ImageUrl,
    image_type              as ImageType,
    image_file              as ImageFile,
    mime_type               as MimeType,
    file_name               as FileName,
    sort_order              as SortOrder,
    is_image_main           as IsImageMain,
    created_by              as CreatedBy,
    created_at              as CreatedAt,
    local_last_changed_by   as LocalLastChangedBy,
    local_last_changed_at   as LocalLastChangedAt,
    last_changed_at         as LastChangedAt,
    _Event // Make association public
}
