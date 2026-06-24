@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Location'

define view entity ZC_IDI_LOCATION 
    as select from ZT_IDI_LOCATION
{
    @EndUserText.label: 'Location ID'
    key LocationId,
    @EndUserText.label: 'Location Name'
    LocationName,
    @EndUserText.label: 'City'
    City,
    @EndUserText.label: 'Adress'
    Adress,
    MaxCapacity
    
}
