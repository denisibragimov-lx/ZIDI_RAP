@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consumption View for Event'
@Metadata.allowExtensions: true
@Search.searchable: true

define root view entity ZC_IDI_EVENT 
    provider contract transactional_query
    as projection on ZT_IDI_EVENT as Event

{
    @EndUserText.label: 'Event UUID'
key EventUuid,
    @EndUserText.label: 'Event ID'
    EventId,
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
    @Search.ranking: #HIGH
    EventName,
    @EndUserText.label: 'Description'
    Description,
    @EndUserText.label: 'Category'
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZC_IDI_EVENT_CATEG_VH', element: 'CategoryId' } }]
    @ObjectModel.text.element: [ 'CategoryName' ]
    CategoryId,
    @EndUserText.label: 'Category name'
    CategoryName,
    @EndUserText.label: 'Location'
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZC_IDI_LOCATION', element: 'LocationId' } }]
    @ObjectModel.text.element: [ 'LocationName' ]    
    LocationId,
    @EndUserText.label: 'Location name'
    LocationName,
    @EndUserText.label: 'Price'
    @Semantics.amount.currencyCode: 'CurrencyCode'
    Price,
    @EndUserText.label: 'Currency code'
    @Semantics.currencyCode: true
    @Consumption.filter.defaultValue: 'EUR'
    CurrencyCode,
    @EndUserText.label: 'Date'
    EventDate,
    @EndUserText.label: 'Booked quantity'
    BookedQuantity,
    @EndUserText.label: 'Max Location Capacity'
    MaxCapacity,
    AvailabilityText,
    @Semantics.imageUrl: true
    MainImageUrl,
    
    _Images     : redirected to composition child ZC_IDI_EVENT_IMG,
    _Request    : redirected to composition child ZC_IDI_REQUEST,
    _Category,
    _Location,
    _MainImage
  
  
}
