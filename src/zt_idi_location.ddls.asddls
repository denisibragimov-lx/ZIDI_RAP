@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Transaction View for Location'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZT_IDI_LOCATION 
    as select from ZI_IDI_LOCATION
    association [0..*] to ZT_IDI_EVENT as _Events on $projection.LocationId = _Events.LocationId 
{
    key LocationId,
    LocationName,
    City,
    Adress,
    MaxCapacity,
    SortOrder,
    Active,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_at as LastChangedBy,
    /* Associations */
    _Events
}
