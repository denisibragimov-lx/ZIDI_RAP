@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Transaction view to Event'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true

define root view entity ZT_IDI_EVENT 
    as select from ZI_IDI_EVENT
    
    composition [0..*] of ZT_IDI_EVENT_IMG      as _Images
    association [0..1] to ZI_IDI_MAIN_IMAGE     as _MainImage on $projection.EventUuid = _MainImage.EventUuid
    composition [0..*] of ZT_IDI_REQUEST        as _Request
    association [1..1] to ZT_IDI_EVENT_CATEG    as _Category on $projection.CategoryId = _Category.CategoryId
    association [1..1] to ZT_IDI_LOCATION       as _Location on $projection.LocationId = _Location.LocationId

{
    key EventUuid,
    EventId,
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
    @Search.ranking: #HIGH
    EventName,
    Description,
    CategoryId,
    _Category.CategoryName as CategoryName,
    
    LocationId,
    LocationName,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    Price,    
    CurrencyCode,
    EventDate,
    BookedQuantity,
    MaxCapacity,
    @EndUserText.label: 'Availability'
    case
      when BookedQuantity = MaxCapacity
        then 'Sold out'        
     // when division( MaxCapacity, BookedQuantity, 2 ) between 0.8 and 1
     when division( BookedQuantity, _Location.MaxCapacity, 2 ) between 0.8 and 1
        then 'Has few'
      else 'Tickets are available'
    end                    as AvailabilityText,
    
    @Semantics.imageUrl: true
    _MainImage.ImageUrl    as MainImageUrl,
    
    @Semantics.user.createdBy: true
    CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    CreatedAt,
    @Semantics.user.localInstanceLastChangedBy: true
    LocalLastChangedBy,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    LocalLastChangedAt,
    @Semantics.systemDateTime.lastChangedAt: true
    LastChangedAt,
    
    /* Associations */
    _Category,
    _Images,
    _Location,
    _MainImage,
    _Request
    
}
