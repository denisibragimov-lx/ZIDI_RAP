@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Transaction View for Ticket Request'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZT_IDI_REQUEST
  as select from ZI_IDI_REQUEST

  association to parent ZT_IDI_EVENT as _Event on $projection.EventUuid = _Event.EventUuid

{
  key RequestUuid,
  key EventUuid,
      EventId,
      Quantity,
      CustomerName,
      PhoneNumber,
      Status,
      EventDate,

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

      _Event
}
