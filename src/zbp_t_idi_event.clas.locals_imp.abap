*CLASS lhc_eventimage DEFINITION INHERITING FROM cl_abap_behavior_handler.
*
*  PRIVATE SECTION.
*
*    METHODS setdefaults FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR eventimage~setdefaults.
*    METHODS validateimage FOR VALIDATE ON SAVE
*      IMPORTING keys FOR eventimage~validateimage.
*    METHODS synctype FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR eventimage~synctype.
*
*ENDCLASS.
*
*CLASS lhc_eventimage IMPLEMENTATION.
*
*  " Automatically assigns sort order to newly created images within the same product.
*  " Ensures that each image gets the next available sort position.
*  METHOD setdefaults.
*    READ ENTITIES OF zt_idi_event IN LOCAL MODE
*      ENTITY eventimage
*        ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_images)
*      ENTITY eventimage BY \_event
*        FIELDS ( eventuuid ) WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_parents).
*
*    DATA lt_image_update TYPE TABLE FOR UPDATE zt_idi_event\\eventimage.
*
*    LOOP AT lt_parents ASSIGNING FIELD-SYMBOL(<ls_parent>).
*
*      READ ENTITIES OF zt_idi_event IN LOCAL MODE
*        ENTITY event BY \_images
*          FIELDS ( sortorder )
*          WITH VALUE #( ( %tky = <ls_parent>-%tky ) )
*        RESULT DATA(lt_existing_images).
*
*      DATA(lv_max_sort) = 0.
*
*      " Determine the current maximum sort order among existing images
*      LOOP AT lt_existing_images INTO DATA(ls_img).
*        IF ls_img-sortorder > lv_max_sort.
*          lv_max_sort = ls_img-sortorder.
*        ENDIF.
*      ENDLOOP.
*
*      LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>)
*        WHERE eventuuid = <ls_parent>-eventuuid.
*
*        " Assign next sort order value for new images
*        DATA(lv_next_sort) = lv_max_sort + 1.
*
*        APPEND VALUE #( %tky      = <ls_key>-%tky
*                        sortorder = lv_next_sort ) TO lt_image_update.
*
*        lv_max_sort = lv_next_sort.
*
*      ENDLOOP.
*
*    ENDLOOP.
*
*    IF lt_image_update IS NOT INITIAL.
*      " Update images with calculated sort order
*      MODIFY ENTITIES OF zt_idi_event IN LOCAL MODE
*        ENTITY eventimage
*          UPDATE FIELDS ( sortorder )
*          WITH lt_image_update.
*    ENDIF.
*  ENDMETHOD.
*
*  " Validates image data before save:
*  " - URL must not be empty
*  " - Only one image per product can be marked as main
*  METHOD validateimage.
*    READ ENTITIES OF zt_idi_event IN LOCAL MODE
*      ENTITY eventimage
*        FIELDS ( imageurl isimagemain eventuuid ) WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_images).
*
*    LOOP AT lt_images INTO DATA(ls_image).
*      " Check that image URL is provided
*      IF ls_image-imageurl IS INITIAL.
*        APPEND VALUE #( %tky = ls_image-%tky ) TO failed-eventimage.
*        APPEND VALUE #( %tky              = ls_image-%tky
*                        %msg              = new_message( id       = 'Z_RAP_KNOWLEDGE'
*                                                         number   = '002'
*                                                         v1       = 'URL'
*                                                         severity = if_abap_behv_message=>severity-error )
*                        %element-imageurl = if_abap_behv=>mk-on ) TO reported-eventimage.
*      ENDIF.
*
*      IF ls_image-isimagemain = 'X'.
*        READ ENTITIES OF zt_idi_event IN LOCAL MODE
*          ENTITY event BY \_images
*          FIELDS ( isimagemain ) WITH VALUE #( ( %tky-eventuuid = ls_image-eventuuid ) )
*          RESULT DATA(lt_all_images).
*
*        " Count how many images are marked as main
*        DATA(lv_main_count) = REDUCE i( INIT c = 0 FOR img IN lt_all_images
*                                        WHERE ( isimagemain = 'X' ) NEXT c = c + 1 ).
*
*        " Ensure only one main image exists per product
*        IF lv_main_count > 1.
*          APPEND VALUE #( %tky = ls_image-%tky ) TO failed-eventimage.
*          APPEND VALUE #( %tky                 = ls_image-%tky
*                          %msg                 = new_message( id       = 'Z_RAP_KNOWLEDGE'
*                                                              number   = '006'
*                                                              severity = if_abap_behv_message=>severity-error )
*                          %element-isimagemain = if_abap_behv=>mk-on ) TO reported-eventimage.
*        ENDIF.
*      ENDIF.
*    ENDLOOP.
*  ENDMETHOD.
*
*  " Synchronizes image type based on main image flag:
*  " - MAIN if image is marked as main
*  " - DETAIL otherwise
*  METHOD synctype.
*    READ ENTITIES OF zt_idi_event IN LOCAL MODE
*       ENTITY eventimage
*       FIELDS ( isimagemain )
*       WITH CORRESPONDING #( keys )
*       RESULT DATA(lt_images).
*
*    DATA lt_update TYPE TABLE FOR UPDATE zt_idi_event\\eventimage.
*
*    LOOP AT lt_images ASSIGNING FIELD-SYMBOL(<ls_img>).
*      " Determine target image type based on main image flag
*      DATA(lv_target_type) = COND #( WHEN <ls_img>-isimagemain = 'X' THEN 'MAIN' ELSE 'DETAIL' ).
*
*      " Update image type only if it differs from expected value
*      IF <ls_img>-imagetype <> lv_target_type.
*        APPEND VALUE #( %tky               = <ls_img>-%tky
*                        imagetype          = lv_target_type
*                        %control-imagetype = if_abap_behv=>mk-on ) TO lt_update.
*      ENDIF.
*    ENDLOOP.
*
*    IF lt_update IS NOT INITIAL.
*      " Apply updates to image type
*      MODIFY ENTITIES OF zt_idi_event IN LOCAL MODE
*        ENTITY eventimage
*        UPDATE FROM lt_update.
*    ENDIF.
*  ENDMETHOD.
*
*ENDCLASS.
*
*CLASS lhc_ticketrequest DEFINITION INHERITING FROM cl_abap_behavior_handler.
*
*  PRIVATE SECTION.
*
*    METHODS check_empty_field FOR VALIDATE ON SAVE
*      IMPORTING keys FOR ticketrequest~check_empty_field.
*    METHODS validate_date FOR VALIDATE ON SAVE
*      IMPORTING keys FOR ticketrequest~validate_date.
*
*ENDCLASS.
*
*CLASS lhc_ticketrequest IMPLEMENTATION.
*
*  " Validates mandatory fields of order request:
*  " - Delivery date, quantity, customer name and phone number must not be empty
*  " - Phone number must contain at least 8 digits
*  METHOD check_empty_field.
*    READ ENTITIES OF zt_idi_event IN LOCAL MODE
*     ENTITY ticketrequest
*     FIELDS ( quantity customername phonenumber )
*     WITH CORRESPONDING #( keys )
*     RESULT DATA(lt_requests).
*
*    " Loop through all requests to validate required fields
*    LOOP AT lt_requests INTO DATA(ls_req).
*
**      IF ls_req-eventdate IS INITIAL.
**        APPEND VALUE #( %tky = ls_req-%tky ) TO failed-ticketrequest.
**        APPEND VALUE #( %tky                           = ls_req-%tky
**                        %element-eventdate             = if_abap_behv=>mk-on
**                        %msg                           = new_message( id       = 'Z_RAP_KNOWLEDGE'
**                                                                      number   = '002'
**                                                                      v1       = 'Event Date'
**                                                                      severity = if_abap_behv_message=>severity-error ) ) TO reported-ticketrequest.
**      ENDIF.
*
*      " Check that requested quantity is provided
*      IF ls_req-quantity IS INITIAL.
*        APPEND VALUE #( %tky = ls_req-%tky ) TO failed-ticketrequest.
*        APPEND VALUE #( %tky                 = ls_req-%tky
*                        %element-quantity = if_abap_behv=>mk-on
*                        %msg                 = new_message( id       = 'Z_RAP_KNOWLEDGE'
*                                                            number   = '002'
*                                                            v1       = 'Quantity'
*                                                            severity = if_abap_behv_message=>severity-error ) ) TO reported-ticketrequest.
*      ENDIF.
*
*      " Check that customer name is provided
*      IF ls_req-customername IS INITIAL.
*        APPEND VALUE #( %tky = ls_req-%tky ) TO failed-ticketrequest.
*        APPEND VALUE #( %tky                  = ls_req-%tky
*                        %element-customername = if_abap_behv=>mk-on
*                        %msg                  = new_message( id       = 'Z_RAP_KNOWLEDGE'
*                                                             number   = '002'
*                                                             v1       = 'Customer Name'
*                                                             severity = if_abap_behv_message=>severity-error ) ) TO reported-ticketrequest.
*      ENDIF.
*
*      " Check that phone number is provided
*      IF ls_req-phonenumber IS INITIAL.
*        APPEND VALUE #( %tky = ls_req-%tky ) TO failed-ticketrequest.
*        APPEND VALUE #( %tky                 = ls_req-%tky
*                        %element-phonenumber = if_abap_behv=>mk-on
*                        %msg                 = new_message( id       = 'Z_RAP_KNOWLEDGE'
*                                                            number   = '002'
*                                                            v1       = 'Phone Number'
*                                                            severity = if_abap_behv_message=>severity-error ) ) TO reported-ticketrequest.
*      ELSE.
*        DATA(lv_phone) = ls_req-phonenumber.
*        " Remove all non-numeric characters from phone number
*        REPLACE ALL OCCURRENCES OF REGEX '[^0-9]' IN lv_phone WITH ''.
*
*        " Validate that phone number contains at least 8 digits
*        IF strlen( lv_phone ) < 8.
*          APPEND VALUE #( %tky = ls_req-%tky ) TO failed-ticketrequest.
*          APPEND VALUE #( %tky                 = ls_req-%tky
*                          %element-phonenumber = if_abap_behv=>mk-on
*                          %msg                 = new_message( id       = 'Z_RAP_KNOWLEDGE'
*                                                              number   = '003'
*                                                              severity = if_abap_behv_message=>severity-error ) ) TO reported-ticketrequest.
*        ENDIF.
*      ENDIF.
*    ENDLOOP.
*  ENDMETHOD.
*
*  " Validates requested delivery date against product constraints:
*  " - Delivery date must be greater or equal to today + minimum delivery days
*  METHOD validate_date.
*    " Read request data for validation
*    READ ENTITIES OF zt_idi_event IN LOCAL MODE
*     ENTITY ticketrequest
*     FIELDS ( eventdate quantity eventuuid eventid )
*     WITH CORRESPONDING #( keys )
*     RESULT DATA(lt_req).
*
*    " Read corresponding product data (quantity and minimum delivery days)
*    READ ENTITIES OF zt_idi_event IN LOCAL MODE
*      ENTITY event
*      FIELDS ( eventid bookedquantity )
*      WITH VALUE #( FOR req IN lt_req
*                    ( eventuuid = req-eventuuid ) )
*      RESULT DATA(lt_event).
*
*    " Validate each request against product delivery constraints
*    LOOP AT lt_req INTO DATA(ls_req).
*
*      READ TABLE lt_event INTO DATA(ls_event)
*        WITH KEY eventuuid = ls_req-eventuuid.
*
*
*      IF ls_req-EventDate < sy-datum.
*        APPEND VALUE #( %tky = ls_req-%tky ) TO failed-ticketrequest.
*
*        " Format date for error message
*        DATA(lv_min_date_str) = ls_req-EventDate+6(2) && '.' && ls_req-EventDate+4(2) && '.' && ls_req-EventDate(4).
*
*        APPEND VALUE #(
*          %tky                           = ls_req-%tky
*          %element-eventdate = if_abap_behv=>mk-on
*          %msg                           = new_message(
*          id       = 'Z_RAP_KNOWLEDGE'
*          number   = '000'
*          v1       = 'Event already happened on'
*          v2       = ls_req-EventDate
*          severity = if_abap_behv_message=>severity-error )
*        ) TO reported-ticketrequest.
*      ENDIF.
*    ENDLOOP.
*  ENDMETHOD.
*ENDCLASS.
*
CLASS lhc_event DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR event RESULT result.
*    "    METHODS get_instance_features FOR INSTANCE FEATURES
*    "      IMPORTING keys REQUEST requested_features FOR event RESULT result.
*    "    METHODS createorder FOR MODIFY
*    "      IMPORTING keys FOR ACTION event~createorder RESULT result.
*    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
*      IMPORTING REQUEST requested_authorizations FOR event RESULT result.
*    METHODS checkmainimageexists FOR VALIDATE ON SAVE
*      IMPORTING keys FOR event~checkmainimageexists.
*    METHODS seteventdefaults FOR DETERMINE ON SAVE
*      IMPORTING keys FOR event~seteventdefaults.
*    METHODS setmainimage FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR event~setmainimage.
*    METHODS seteventid FOR DETERMINE ON SAVE
*      IMPORTING keys FOR event~seteventid.
*    METHODS checkmandatoryfields FOR VALIDATE ON SAVE
*      IMPORTING keys FOR event~checkmandatoryfields.
*    METHODS changebookedquan FOR DETERMINE ON SAVE
*      IMPORTING keys FOR event~changebookedquan.
*
ENDCLASS.

CLASS lhc_event IMPLEMENTATION.

  " Controls instance-level authorization for update and delete operations.
  " Disables update/delete if user does not have Seller role.
  METHOD get_instance_authorizations.
    RETURN.
*    DATA(lv_update_requested) = COND #( WHEN requested_authorizations-%update = if_abap_behv=>mk-on
*                                        THEN abap_true ELSE abap_false ).
*    DATA(lv_delete_requested) = COND #( WHEN requested_authorizations-%delete = if_abap_behv=>mk-on
*                                        THEN abap_true ELSE abap_false ).
*
*    IF lv_update_requested = abap_true OR lv_delete_requested = abap_true.
*
*      " Check if user has Seller role for update/delete operations
*      AUTHORITY-CHECK OBJECT 'ZUSER_ROLE'
*        ID 'ZUSER_ROLE' FIELD 'S' " 'Z_ROLE_SELLER'
*        ID 'ACTVT'      FIELD '02'.
*
**      IF sy-subrc <> 0.
**        " Disable update and delete for all requested instances
**        LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>).
**          APPEND VALUE #( %tky    = <ls_key>-%tky
**                          %update = if_abap_behv=>fc-o-disabled
**                          %delete = if_abap_behv=>fc-o-disabled ) TO result.
**        ENDLOOP.
**      ENDIF.
**    ENDIF.
  ENDMETHOD.
  ENDCLASS.
*
*  " Controls UI features (actions availability) for each product instance.
*  " Enables 'createorder' action only for Customer role and if product is in stock.
**  METHOD get_instance_features.
**    IF keys IS INITIAL.
**      APPEND INITIAL LINE TO reported-%other ASSIGNING FIELD-SYMBOL(<lo_reported>).
**      <lo_reported> = new_message( id       = 'Z_RAP_KNOWLEDGE'
**                                   number   = '001'
**                                   severity = if_abap_behv_message=>severity-error ).
**      RETURN.
**    ENDIF.
**
**    " Read product data to evaluate feature availability
**    READ ENTITIES OF zt_idi_event IN LOCAL MODE
**        ENTITY event
**        ALL FIELDS WITH CORRESPONDING #( keys )
**        RESULT DATA(lt_event).
**
**    IF lt_event IS INITIAL.
**      APPEND INITIAL LINE TO reported-%other ASSIGNING <lo_reported>.
**      <lo_reported> = new_message( id       = 'Z_RAP_KNOWLEDGE'
**                                   number   = '001'
**                                   severity = if_abap_behv_message=>severity-error ).
**      RETURN.
**    ENDIF.
**
**    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>).
**
**      ASSIGN lt_product[ KEY id COMPONENTS %tky = <ls_key>-%tky ] TO FIELD-SYMBOL(<ls_instance>).
**      IF sy-subrc <> 0.
**        APPEND INITIAL LINE TO failed-product ASSIGNING FIELD-SYMBOL(<ls_failed>).
**        <ls_failed>-%tky        = <ls_instance>-%tky.
**        <ls_failed>-%fail-cause = if_abap_behv=>cause-not_found.
**        CONTINUE.
**      ENDIF.
**    ENDLOOP.
**
**    " Check if user has Customer role
**    AUTHORITY-CHECK OBJECT 'ZUSER_ROLE'
**      ID 'ZUSER_ROLE' FIELD 'С' " 'Z_ROLE_CUSTOMER'
**      ID 'ACTVT'      FIELD '33'.
**
**    DATA(lv_is_customer) = COND #( WHEN sy-subrc = 0 THEN abap_true ELSE abap_false ).
**
**    LOOP AT lt_product INTO DATA(ls_product).
**      " Enable action only if user is Customer and product quantity > 0
**      DATA(lv_order_state) = COND #( WHEN lv_is_customer = abap_true AND ls_product-quantity > 0
**                                     THEN if_abap_behv=>fc-o-enabled
**                                     ELSE if_abap_behv=>fc-o-disabled ).
**
**      APPEND VALUE #( %tky                = ls_product-%tky
**                      %action-createorder = lv_order_state ) TO result.
**    ENDLOOP.
**  ENDMETHOD.
*
*  " Creates an order request for a product:
*  " - Validates requested quantity against available stock
*  " - Creates request entity
*  " - Decreases product quantity accordingly
**  METHOD createorder.
**    DATA: lt_create_request TYPE TABLE FOR CREATE zt_vta_product\_request.
**
**    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>).
**      " Cheacking Quantity
**      " Quantity in the request <= Quantity in the product
**      READ ENTITIES OF zt_vta_product IN LOCAL MODE
**            ENTITY product
**            FIELDS ( quantity productuuid prodid )
**            WITH VALUE #( ( %tky = <ls_key>-%tky ) )
**            RESULT DATA(lt_product_check).
**
**      READ TABLE lt_product_check INTO DATA(ls_product_check) INDEX 1.
**
**      " Ensure requested quantity does not exceed available stock
**      IF <ls_key>-%param-reqquantity > ls_product_check-quantity.
**
**        APPEND VALUE #( %tky = <ls_key>-%tky ) TO failed-product.
**
**        APPEND VALUE #( %tky = <ls_key>-%tky
**                        %msg = new_message( id       = 'Z_RAP_KNOWLEDGE'
**                                            number   = '005'
**                                            v1       = ls_product_check-quantity
**                                            severity = if_abap_behv_message=>severity-error ) ) TO reported-product.
**        CONTINUE.
**      ENDIF.
**
**      " Prepare request creation payload
**      APPEND INITIAL LINE TO lt_create_request ASSIGNING FIELD-SYMBOL(<ls_req_line>).
**
**      <ls_req_line>-%tky      = <ls_key>-%tky.
**      <ls_req_line>-%is_draft = <ls_key>-%is_draft.
**
**      APPEND INITIAL LINE TO <ls_req_line>-%target ASSIGNING FIELD-SYMBOL(<ls_target>).
**
**      " Normalize phone number (keep digits only)
**      DATA(lv_phone) = <ls_key>-%param-phonenumber.
**      REPLACE ALL OCCURRENCES OF REGEX '[^0-9]' IN lv_phone WITH ''.
**
**      <ls_target>-%cid                  = |REQ{ sy-tabix }|.
**      <ls_target>-requesteddeliverydate = <ls_key>-%param-requesteddeliverydate.
**      <ls_target>-reqquantity           = <ls_key>-%param-reqquantity.
**      <ls_target>-customername          = <ls_key>-%param-customername.
**      <ls_target>-phonenumber           = lv_phone.
**      <ls_target>-status                = 'C'.
**
**      <ls_target>-%control-requesteddeliverydate = if_abap_behv=>mk-on.
**      <ls_target>-%control-reqquantity           = if_abap_behv=>mk-on.
**      <ls_target>-%control-customername          = if_abap_behv=>mk-on.
**      <ls_target>-%control-phonenumber           = if_abap_behv=>mk-on.
**      <ls_target>-%control-status                = if_abap_behv=>mk-on.
**    ENDLOOP.
**
**    " Create request via composition
**    MODIFY ENTITIES OF zt_vta_product IN LOCAL MODE
**        ENTITY product
**          CREATE BY \_request
**          FROM lt_create_request
**          MAPPED   DATA(lt_mapped)
**          FAILED   DATA(lt_failed)
**          REPORTED DATA(lt_reported).
**
**    IF lt_failed IS NOT INITIAL.
**      APPEND LINES OF lt_failed-product        TO failed-product.
**      APPEND LINES OF lt_reported-product      TO reported-product.
**      APPEND LINES OF lt_reported-orderrequest TO reported-orderrequest.
**      RETURN.
**    ENDIF.
**
**    " Update product quantity after successful request creation
**    " Changing Quantity
**    READ ENTITIES OF zt_vta_product IN LOCAL MODE
**      ENTITY product
**      FIELDS ( quantity )
**      WITH CORRESPONDING #( keys )
**      RESULT DATA(lt_product).
**
**    LOOP AT lt_product INTO DATA(ls_product).
**
**      READ TABLE keys ASSIGNING FIELD-SYMBOL(<ls_key_prod>)
**        WITH KEY %tky = ls_product-%tky.
**
**      DATA(lv_new_qty) = ls_product-quantity - <ls_key_prod>-%param-reqquantity.
**
**      MODIFY ENTITIES OF zt_vta_product IN LOCAL MODE
**          ENTITY product
**          UPDATE FROM VALUE #( ( productuuid       = ls_product-productuuid
**                                 prodid            = ls_product-prodid
**                                 quantity          = lv_new_qty
**                                 %control-quantity = if_abap_behv=>mk-on ) ).
**
**    ENDLOOP.
**
**    " Return updated product data
**    READ ENTITIES OF zt_vta_product IN LOCAL MODE
**      ENTITY product
**        ALL FIELDS WITH CORRESPONDING #( keys )
**      RESULT DATA(lt_product_res).
**
**    result = VALUE #( FOR ls_prod_res IN lt_product_res ( %tky   = ls_prod_res-%tky
**                                                          %param = ls_prod_res ) ).
**  ENDMETHOD.
*
*  " Controls global authorization for create operation.
*  " Only users with Seller role are allowed to create products.
*  METHOD get_global_authorizations.
*
*    " Check if user has Seller role for create operation
*    AUTHORITY-CHECK OBJECT 'ZUSER_ROLE'
*        ID 'ZUSER_ROLE' FIELD 'S'
*        ID 'ACTVT'      FIELD '01'.
*
*    IF sy-subrc <> 0.
*      result-%create = if_abap_behv=>auth-unauthorized.
*    ELSE.
*      result-%create = if_abap_behv=>auth-allowed.
*    ENDIF.
*
*    result-%update = if_abap_behv=>auth-allowed.
*    result-%delete = if_abap_behv=>auth-allowed.
*  ENDMETHOD.
*
*  " Validates that each product has at least one main image assigned.
*  METHOD checkmainimageexists.
*    READ ENTITIES OF zt_idi_event IN LOCAL MODE
*      ENTITY event BY \_images
*      FIELDS ( isimagemain ) WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_images).
*
*    LOOP AT keys INTO DATA(ls_key).
*      " Check if at least one image is marked as main for the product
*      IF NOT line_exists( lt_images[ eventuuid = ls_key-eventuuid isimagemain = 'X' ] ).
*        APPEND VALUE #( %tky = ls_key-%tky ) TO failed-event.
*        APPEND VALUE #( %tky = ls_key-%tky
*                        %msg = new_message( id       = 'Z_RAP_KNOWLEDGE'
*                                            number   = '007'
*                                            severity = if_abap_behv_message=>severity-error )
*                      ) TO reported-event.
*      ENDIF.
*    ENDLOOP.
*  ENDMETHOD.
*
*  " Sets default values for product:
*  " - Assigns default currency if not provided
*  METHOD seteventdefaults.
*    READ ENTITIES OF zt_idi_event IN LOCAL MODE
*       ENTITY event
*         ALL FIELDS WITH CORRESPONDING #( keys )
*       RESULT DATA(lt_events).
*
*    DATA lt_update TYPE TABLE FOR UPDATE zt_idi_event.
*
*    " Identify products without currency and set default value
*    lt_update = VALUE #( FOR event IN lt_events WHERE ( currencycode IS INITIAL )
*                       ( %tky         = event-%tky
*                         currencycode = 'EUR' ) ).
*
*    IF lt_update IS NOT INITIAL.
*      MODIFY ENTITIES OF zt_idi_event IN LOCAL MODE
*        ENTITY event
*          UPDATE FIELDS ( currencycode )
*          WITH lt_update
*        REPORTED DATA(lt_reported).
*    ENDIF.
*  ENDMETHOD.
*
*  " Updates product with URL of its main image
*  METHOD setmainimage.
*    READ ENTITIES OF zt_idi_event IN LOCAL MODE
*       ENTITY event
*         FIELDS ( mainimageurl ) WITH CORRESPONDING #( keys )
*       RESULT DATA(lt_events).
*
*    " Read all images to find main image
*    READ ENTITIES OF zt_idi_event IN LOCAL MODE
*      ENTITY event BY \_images
*        FIELDS ( imageurl isimagemain ) WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_images).
*
*    LOOP AT lt_events ASSIGNING FIELD-SYMBOL(<ls_event>).
*      READ TABLE lt_images ASSIGNING FIELD-SYMBOL(<ls_main_img>)
*        WITH KEY eventuuid = <ls_event>-eventuuid
*                 isimagemain = 'X'.
*
*      " Update product only if main image URL has changed
*      IF sy-subrc = 0 AND <ls_event>-mainimageurl <> <ls_main_img>-imageurl.
*        MODIFY ENTITIES OF zt_idi_event IN LOCAL MODE
*          ENTITY event
*          UPDATE FIELDS ( mainimageurl )
*          WITH VALUE #( ( %tky                  = <ls_event>-%tky
*                          mainimageurl          = <ls_main_img>-imageurl
*                          %control-mainimageurl = if_abap_behv=>mk-on ) ).
*      ENDIF.
*    ENDLOOP.
*  ENDMETHOD.
*
*  " Generates sequential product ID for new products
*  METHOD seteventid.
*    DATA: lt_update TYPE TABLE FOR UPDATE zt_idi_event.
*
*    READ ENTITIES OF zt_idi_event IN LOCAL MODE
*      ENTITY event
*      FIELDS ( eventuuid eventid )
*      WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_events).
*
*    DELETE lt_events WHERE eventid IS NOT INITIAL.
*
*    IF lt_events IS INITIAL.
*      RETURN.
*    ENDIF.
*
*    " Get current maximum product ID from database
*    SELECT MAX( event_id )
*      FROM zidi_event
*      INTO @DATA(lv_max_id).
*
*    IF lv_max_id IS INITIAL.
*      lv_max_id = 0.
*    ENDIF.
*
*    " Assign next available product ID
*    LOOP AT lt_events ASSIGNING FIELD-SYMBOL(<ls_event>).
*
*      lv_max_id += 1.
*
*      APPEND VALUE #( %tky            = <ls_event>-%tky
*                      eventid         = lv_max_id
*                      %control-eventid = if_abap_behv=>mk-on ) TO lt_update.
*
*    ENDLOOP.
*
*    IF lt_update IS NOT INITIAL.
*      MODIFY ENTITIES OF zt_idi_event IN LOCAL MODE
*        ENTITY event
*        UPDATE FIELDS ( eventid )
*        WITH lt_update.
*    ENDIF.
*  ENDMETHOD.
*
*  " Validates mandatory fields and business rules for product:
*  " - Required fields must be filled
*  " - Rating must be between 1 and 5
*  " - Quantity and delivery days must be valid
*  METHOD checkmandatoryfields.
*    READ ENTITIES OF zt_idi_event IN LOCAL MODE
*      ENTITY event
*      FIELDS ( eventname bookedquantity eventdate categoryid price )
*      WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_events).
*
*    LOOP AT lt_events INTO DATA(ls_event).
*
*      " Validate product name
*      IF ls_event-eventname IS INITIAL.
*        APPEND VALUE #( %tky = ls_event-%tky ) TO failed-event.
*
*        APPEND VALUE #( %tky                 = ls_event-%tky
*                        %msg                 = new_message(
*                        id       = 'Z_RAP_KNOWLEDGE'
*                        number   = '002'
*                        v1       = 'Event name'
*                        severity = if_abap_behv_message=>severity-error )
*                        %element-eventname = if_abap_behv=>mk-on ) TO reported-event.
*      ENDIF.
*
*      " Validate minimum delivery days is greater than 0
*      IF ls_event-eventdate IS INITIAL." OR ls_event-eventdate  <= 0.
*        APPEND VALUE #( %tky = ls_event-%tky ) TO failed-event.
*
*        APPEND VALUE #( %tky                  = ls_event-%tky
*                        %msg                  = new_message(
*                        id       = 'Z_RAP_KNOWLEDGE'
*                        number   = '002'
*                        v1       = 'Event Date'
*                        severity = if_abap_behv_message=>severity-error )
*                        %element-eventdate = if_abap_behv=>mk-on ) TO reported-event.
*      ENDIF.
*
*      " Validate category is assigned
*      IF ls_event-categoryid IS INITIAL.
*        APPEND VALUE #( %tky = ls_event-%tky ) TO failed-event.
*
*        APPEND VALUE #( %tky                = ls_event-%tky
*                        %msg                = new_message(
*                        id       = 'Z_RAP_KNOWLEDGE'
*                        number   = '002'
*                        v1       = 'Category'
*                        severity = if_abap_behv_message=>severity-error )
*                        %element-eventid = if_abap_behv=>mk-on ) TO reported-event.
*      ENDIF.
*
*      " Validate price is provided
*      IF ls_event-price IS INITIAL.
*        APPEND VALUE #( %tky = ls_event-%tky ) TO failed-event.
*
*        APPEND VALUE #( %tky           = ls_event-%tky
*                        %msg           = new_message(
*                        id       = 'Z_RAP_KNOWLEDGE'
*                        number   = '002'
*                        v1       = 'Price'
*                        severity = if_abap_behv_message=>severity-error )
*                        %element-price = if_abap_behv=>mk-on ) TO reported-event.
*      ENDIF.
*    ENDLOOP.
*  ENDMETHOD.
*
*  " Updates 'instock' flag based on product quantity.
*  METHOD changebookedquan.
*
*    RETURN.
**    DATA: lt_update TYPE TABLE FOR UPDATE zt_vta_product.
**
**    READ ENTITIES OF zt_vta_product IN LOCAL MODE
**        ENTITY product
**        FIELDS ( instock quantity )
**        WITH CORRESPONDING #( keys )
**        RESULT DATA(lt_products).
**
**    LOOP AT lt_products ASSIGNING FIELD-SYMBOL(<ls_product>).
**      " Determine stock availability based on quantity
**      DATA(lv_new_in_stock) = COND #( WHEN <ls_product>-quantity = 0 THEN abap_false ELSE abap_true ).
**
**      " Update only if stock status has changed
**      IF lv_new_in_stock <> <ls_product>-instock.
**        APPEND VALUE #( %tky             = <ls_product>-%tky
**                        instock          = lv_new_in_stock
**                        %control-instock = if_abap_behv=>mk-on ) TO lt_update.
**      ENDIF.
**    ENDLOOP.
**
**    IF lt_update IS NOT INITIAL.
**      " Persist updated stock status
**      MODIFY ENTITIES OF zt_vta_product IN LOCAL MODE
**        ENTITY product
**        UPDATE FIELDS ( instock )
**        WITH lt_update.
**    ENDIF.
*  ENDMETHOD.
*ENDCLASS.
