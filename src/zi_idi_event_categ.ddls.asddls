@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View Event Category'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZI_IDI_EVENT_CATEG
  as select from ZIDI_EVENT_CATEG

  association [0..*] to ZI_IDI_EVENT as _Events on $projection.CategoryId = _Events.CategoryId 

{
  key category_id   as CategoryId,
      category_name as CategoryName,
      description   as Description,
      sort_order    as SortOrder, 
      active        as Active,
      created_by,
      created_at,
      last_changed_at,

      _Events
}
where
  active = 'X'
