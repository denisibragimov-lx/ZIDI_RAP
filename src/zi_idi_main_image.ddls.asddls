@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Main Image'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_IDI_MAIN_IMAGE 
    as select from ZIDI_EVENT_IMG

{
   
    key event_uuid  as EventUuid,
    image_url       as ImageUrl    
}
where 
     sort_order = 1
 and is_image_main = 'X'
