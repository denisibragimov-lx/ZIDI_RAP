@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Transactional View for Event Category'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZT_IDI_EVENT_CATEG 
    as select from ZI_IDI_EVENT_CATEG
    association [0..*] to ZT_IDI_EVENT as _Event on $projection.CategoryId = _Event.CategoryId
{
    key CategoryId,
    CategoryName,
    Description,
    SortOrder,
    Active,
    
    created_by,
    created_at,
    last_changed_at,
    /* Associations */
    _Events
}
where
    active = 'X'
