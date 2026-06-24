@AccessControl.authorizationCheck: #NOT_REQUIRED
@AbapCatalog.sqlViewName: 'ZI_IDI_REQUESTS'
@EndUserText.label: 'Interface View for Ticket Requests'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_IDI_REQUEST
    as select from zidi_request
    association to parent ZI_IDI_EVENT as _Event on $projection.EventUuid = _Event.EventUuid

{
    key request_uuid            as RequestUuid,
    key event_uuid              as EventUuid,
        event_id                as EventId,
        quantity                as Quantity,
        customer_name           as CustomerName,
        phone_number            as PhoneNumber,
        status                  as Status,
        _Event.EventDate        as EventDate,
        
        created_by              as CreatedBy,
        created_at              as CreatedAt,
        local_last_changed_by   as LocalLastChangedBy,
        local_last_changed_at   as LocalLastChangedAt,
        last_changed_at         as LastChangedAt,
        
        _Event
}
