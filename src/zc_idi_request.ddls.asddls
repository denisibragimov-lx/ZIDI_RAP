@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Request'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZC_IDI_REQUEST 
  as projection on ZT_IDI_REQUEST
{
key RequestUuid,
key EventUuid,
    EventId,
    Quantity,
    CustomerName,
    PhoneNumber,
    Status,
    EventDate,
   
    _Event : redirected to parent ZC_IDI_EVENT
}
