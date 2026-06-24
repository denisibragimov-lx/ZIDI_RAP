@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Event'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true

define root view entity ZI_IDI_EVENT 
as select from zidi_event

composition [0..*] of ZI_IDI_EVENT_IMG      as _Images
association [0..1] to ZI_IDI_MAIN_IMAGE     as _MainImage on $projection.EventUuid = _MainImage.EventUuid
composition [0..*] of ZI_IDI_REQUEST        as _Request
association [1..1] to ZI_IDI_EVENT_CATEG    as _Category on $projection.CategoryId = _Category.CategoryId
association [1..1] to ZI_IDI_LOCATION       as _Location on $projection.LocationId = _Location.LocationId
{
    key event_uuid              as EventUuid,
        event_id                as EventId,
        @Search.defaultSearchElement: true
        @Search.fuzzinessThreshold: 0.8
        @Search.ranking: #HIGH
        event_name              as EventName,
        description             as Description,
        category_id             as CategoryId,
        location_id             as LocationId,
        _Location.LocationName  as LocationName,
        
        @Semantics.amount.currencyCode: 'CurrencyCode'
        price                   as Price,
        currencycode            as CurrencyCode,
        event_date              as EventDate,
        booked_quantity         as BookedQuantity,
        _Location.MaxCapacity   as MaxCapacity,
//        @EndUserText.label: 'Availability'
//        case
//          when booked_quantity = _Location.MaxCapacity
//            then 'Sold out'       
//          when division( booked_quantity, _Location.MaxCapacity, 2 ) between 0.8 and 1
//            then 'Has few'
//          else 'Tickets are available'
//        end                    as AvailabilityText,
        
        @Semantics.imageUrl: true
        _MainImage.ImageUrl    as MainImageUrl,
        
        created_by              as CreatedBy,
        created_at              as CreatedAt,
        local_last_changed_by   as LocalLastChangedBy,
        local_last_changed_at   as LocalLastChangedAt,
        last_changed_at         as LastChangedAt,
        
        _Images,
        _Request,
        _MainImage,
        _Category,
        _Location
}
