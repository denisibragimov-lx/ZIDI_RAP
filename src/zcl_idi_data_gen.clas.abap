CLASS zcl_idi_data_gen DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_idi_data_gen IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA: lt_categories TYPE TABLE OF zidi_event_categ,
          lt_events     TYPE TABLE OF zidi_event,
          lt_images     TYPE TABLE OF zidi_event_img,
          lt_location   TYPE TABLE OF zidi_location,
          lv_uuid       TYPE sysuuid_x16.

    DELETE FROM zidi_event_categ.
    DELETE FROM zidi_event.
    DELETE FROM zidi_event_img.
    DELETE FROM zidi_location.

    lt_categories = VALUE #(
     ( mandt = sy-mandt category_id = '000001' category_name = 'Live concert'     description = 'Concert, Live show'                sort_order = 1 active = 'X' )
     ( mandt = sy-mandt category_id = '000002' category_name = 'Theatre'          description = 'Classic Thetre, Modern Theatre'    sort_order = 2 active = 'X' )
     ( mandt = sy-mandt category_id = '000003' category_name = 'Sports'           description = 'Fightings, Hoockey, Football'      sort_order = 3 active = 'X' )
     ( mandt = sy-mandt category_id = '000004' category_name = 'Festivals'        description = 'Music, Arts, Science'              sort_order = 4 active = 'X' ) ).
    INSERT zidi_event_categ FROM TABLE @lt_categories.

    lt_location = VALUE #(
     ( mandt = sy-mandt location_id = '000010' location_name = 'Madrid Stadium'      city = 'Madrid' adress = 'Olympic str. 10'  max_capacity = '9000'   sort_order = 1 active = 'X' )
     ( mandt = sy-mandt location_id = '000020' location_name = 'Pink Pantera Bar'    city = 'Madrid' adress = 'Lenina str. 27'        max_capacity = '250'    sort_order = 2 active = 'X' )
     ( mandt = sy-mandt location_id = '000030' location_name = 'Drama Theatre'       city = 'Madrid' adress = 'Prima str. 17'    max_capacity = '800'    sort_order = 2 active = 'X' )
     ( mandt = sy-mandt location_id = '000110' location_name = 'Forum'               city = 'Barcelona' adress = 'Catalonia str. 7'    max_capacity = '12000'    sort_order = 1 active = 'X' )
     ( mandt = sy-mandt location_id = '000120' location_name = 'Old Elephant'        city = 'Barcelona' adress = 'Sagrada str. 4'    max_capacity = '200'    sort_order = 2 active = 'X' )
     ).
    INSERT zidi_location FROM TABLE @lt_location.


    DATA(lv_uuid_event_1) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(lv_uuid_event_2) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(lv_uuid_event_3) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(lv_uuid_event_4) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(lv_uuid_event_5) = cl_system_uuid=>create_uuid_x16_static( ).

    lt_events = VALUE #( (   mandt        = sy-mandt                    event_uuid = lv_uuid_event_1    event_id = '000001'         event_name   = 'Kanye West'
                             description  = 'Kanye West Live in Madrid' category_id  = '000001'         location_id = '000010'       price          = '899.99'
                             currencycode = 'EUR'                       event_date = '20260808'         booked_quantity = '8500' )
                         (   mandt        = sy-mandt                    event_uuid = lv_uuid_event_2    event_id = '000002'         event_name   = 'Kanye West'
                             description  = 'Kanye West Live in Barcelona' category_id  = '000001'         location_id = '000110'       price          = '790'
                             currencycode = 'EUR'                       event_date = '20260815'         booked_quantity = '7845' )
                         (   mandt        = sy-mandt                    event_uuid = lv_uuid_event_3    event_id = '000003'         event_name   = 'Footbal'
                             description  = 'FC Madrid VS FC Real' category_id  = '000003'         location_id = '000010'       price          = '150'
                             currencycode = 'EUR'                       event_date = '20260715'         booked_quantity = '5440' )
                         (   mandt        = sy-mandt                    event_uuid = lv_uuid_event_4    event_id = '000004'         event_name   = 'Primavera Barcelona'
                             description  = 'Primavera Music Festival'  category_id  = '000004'         location_id = '000110'       price          = '390'
                             currencycode = 'EUR'                       event_date = '20260625'         booked_quantity = '12000' )
                         (   mandt        = sy-mandt                    event_uuid = lv_uuid_event_5    event_id = '000005'         event_name   = 'GikKon Barcelona'
                             description  = 'GikKon Fest 2026'          category_id  = '000004'         location_id = '000110'       price          = '110'
                             currencycode = 'EUR'                       event_date = '20260710'         booked_quantity = '3741' )

                          ).
    INSERT zidi_event FROM TABLE @lt_events.

    " Kanye West Live in Madrid
    lt_images = VALUE #( ( mandt     = sy-mandt image_uuid = cl_system_uuid=>create_uuid_x16_static( ) event_uuid = lv_uuid_event_1  image_type = 'MAIN'   sort_order = 1
                           image_url = 'https://images.unsplash.com/photo-1432250767374-ee19cba37b52?q=80&w=1017&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D' )
                         ( mandt     = sy-mandt image_uuid = cl_system_uuid=>create_uuid_x16_static( ) event_uuid = lv_uuid_event_1  image_type = 'DETAIL' sort_order = 2
                           image_url = 'https://images.unsplash.com/photo-1607873637553-132acdc40181?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D' )

    " Kanye West Live in Barcelona
                        ( mandt     = sy-mandt image_uuid = cl_system_uuid=>create_uuid_x16_static( ) event_uuid = lv_uuid_event_2  image_type = 'MAIN'   sort_order = 1
                           image_url = 'https://images.unsplash.com/photo-1432250767374-ee19cba37b52?q=80&w=1017&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D' )
                         ( mandt     = sy-mandt image_uuid = cl_system_uuid=>create_uuid_x16_static( ) event_uuid = lv_uuid_event_2  image_type = 'DETAIL' sort_order = 2
                           image_url = 'https://images.unsplash.com/photo-1607874089816-bf5af74fe2c5?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D' )
    " FC Madrid VS FC Real'
                         ( mandt     = sy-mandt image_uuid = cl_system_uuid=>create_uuid_x16_static( ) event_uuid = lv_uuid_event_3  image_type = 'MAIN'   sort_order = 1
                           image_url = 'https://images.unsplash.com/photo-1641159009736-8a5fd4e52fef?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8Zm9vdGJhbGwlMjB0ZWFtfGVufDB8fDB8fHww' )
                         ( mandt     = sy-mandt image_uuid = cl_system_uuid=>create_uuid_x16_static( ) event_uuid = lv_uuid_event_3  image_type = 'DETAIL' sort_order = 2
                           image_url = 'https://images.unsplash.com/photo-1583558952124-8a5c7f29ab35?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Zm9vdGJhbGwlMjB0ZWFtfGVufDB8fDB8fHww' )
                            ( mandt     = sy-mandt image_uuid = cl_system_uuid=>create_uuid_x16_static( ) event_uuid = lv_uuid_event_3  image_type = 'DETAIL' sort_order = 3
                           image_url = 'https://images.unsplash.com/photo-1629217855633-79a6925d6c47?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8c29ja2VyJTIwc3RhZGl1bXxlbnwwfHwwfHx8MA%3D%3D' )
     " 'Primavera Music Festival'
                           ( mandt     = sy-mandt image_uuid = cl_system_uuid=>create_uuid_x16_static( ) event_uuid = lv_uuid_event_4  image_type = 'MAIN'   sort_order = 1
                           image_url = 'https://images.unsplash.com/photo-1526478806334-5fd488fcaabc?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8bGl2ZSUyMGJhbmR8ZW58MHx8MHx8fDA%3D' )
                         ( mandt     = sy-mandt image_uuid = cl_system_uuid=>create_uuid_x16_static( ) event_uuid = lv_uuid_event_4  image_type = 'DETAIL' sort_order = 2
                           image_url = 'https://images.unsplash.com/photo-1582711012124-a56cf82307a0?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fG11c2ljJTIwZmVzdGl2YWx8ZW58MHx8MHx8fDA%3D' )
     " 'GikKon Fest 2026'
                           ( mandt     = sy-mandt image_uuid = cl_system_uuid=>create_uuid_x16_static( ) event_uuid = lv_uuid_event_5  image_type = 'MAIN'   sort_order = 1
                           image_url = 'https://images.unsplash.com/photo-1772587002840-30b82d74fbf5?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8Z2VlayUyMGN1bHR1cmV8ZW58MHx8MHx8fDA%3D' )
                         ( mandt     = sy-mandt image_uuid = cl_system_uuid=>create_uuid_x16_static( ) event_uuid = lv_uuid_event_5  image_type = 'DETAIL' sort_order = 2
                           image_url = 'https://plus.unsplash.com/premium_photo-1739910298679-061bb05a8c89?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8Z2VlayUyMGN1bHR1cmV8ZW58MHx8MHx8fDA%3D' )

                            ( mandt     = sy-mandt image_uuid = cl_system_uuid=>create_uuid_x16_static( ) event_uuid = lv_uuid_event_5  image_type = 'DETAIL' sort_order = 3
                           image_url = 'https://images.unsplash.com/photo-1764156105944-6f8f40d0cba1?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Z2VlayUyMGN1bHR1cmV8ZW58MHx8MHx8fDA%3D' )
                           ).


    INSERT zidi_event_img FROM TABLE @lt_images.


    COMMIT WORK.
  ENDMETHOD.
ENDCLASS.
