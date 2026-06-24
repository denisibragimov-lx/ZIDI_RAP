@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Category'

define view entity ZC_IDI_EVENT_CATEG_VH 
    as select from ZT_IDI_EVENT_CATEG
{
     @EndUserText.label: 'Category ID'
 key CategoryId,
     @EndUserText.label: 'Category Name'    
     CategoryName    
}
