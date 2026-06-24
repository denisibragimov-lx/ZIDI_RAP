@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Event Location'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_IDI_LOCATION 
as select from ZIDI_LOCATION
association [0..*] to ZI_IDI_EVENT as _Events on $projection.LocationId = _Events.LocationId 
{
    key location_id         as LocationId,
        location_name       as LocationName,
        city                as City,
        adress              as Adress,
        max_capacity        as MaxCapacity,
        sort_order          as SortOrder,
        active              as Active,
        created_by,
        created_at,
        last_changed_at,
        
        _Events
}

where 
active = 'X'
