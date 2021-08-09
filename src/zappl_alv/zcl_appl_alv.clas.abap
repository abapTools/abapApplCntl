CLASS zcl_appl_alv DEFINITION
 PUBLIC
  INHERITING FROM cl_gui_alv_grid
  CREATE PUBLIC .

*"* public components of class /BDFPLM/CL_DCC_ALV
*"* do not include other source files here!!!
  PUBLIC SECTION.

    DATA gs_active_classe TYPE bapi_class_key READ-ONLY .
    DATA layout_name TYPE lvc_tname READ-ONLY .
    DATA o_dcc_gui TYPE REF TO zif_appl_object READ-ONLY .
    DATA t_customer_buttons TYPE zappl_lvc_button_tt READ-ONLY .
    DATA t_customer_class_btn TYPE zappl_lvc_button_tt READ-ONLY .
    DATA t_customer_fcat TYPE zappl_lvc_fcat_tt READ-ONLY .

    METHODS add_customer_function
      IMPORTING
        !im_object          TYPE REF TO cl_ctmenu
        !im_button_name     TYPE ui_func
        !im_ready_for_input TYPE xfeld OPTIONAL
        !im_layout_name     TYPE lvc_tname OPTIONAL .
    METHODS constructor
      IMPORTING
        VALUE(i_shellstyle)  TYPE i DEFAULT 0
        VALUE(i_lifetime)    TYPE i OPTIONAL
        VALUE(i_parent)      TYPE REF TO cl_gui_container
        VALUE(i_appl_events) TYPE char01 DEFAULT space
        !i_parentdbg         TYPE REF TO cl_gui_container OPTIONAL
        !i_applogparent      TYPE REF TO cl_gui_container OPTIONAL
        !i_graphicsparent    TYPE REF TO cl_gui_container OPTIONAL
        VALUE(i_name)        TYPE string OPTIONAL
        !i_fcat_complete     TYPE xfeld DEFAULT space
      EXCEPTIONS
        error_cntl_create
        error_cntl_init
        error_cntl_link
        error_dp_create .
    METHODS get_customer_field_catalog
      IMPORTING
        !im_layout_name    TYPE lvc_tname
      RETURNING
        VALUE(re_tab_fcat) TYPE zappl_lvc_fcat_tt .
    METHODS get_variant_handle
      IMPORTING
        !im_layout_name          TYPE lvc_tname OPTIONAL
      RETURNING
        VALUE(re_variant_handle) TYPE slis_handl .
    METHODS on_customer_double_click
      IMPORTING
        !is_column TYPE lvc_s_col
        !is_line   TYPE any .
    METHODS on_customer_hotspot_click
      IMPORTING
        !is_column TYPE lvc_s_col
        !is_line   TYPE any .
    METHODS on_customer_onf4
      IMPORTING
        !im_fieldname  TYPE lvc_fname
        !im_fieldvalue TYPE lvc_value
        !is_row_no     TYPE lvc_s_roid OPTIONAL
        !io_event_data TYPE REF TO cl_alv_event_data OPTIONAL
        !it_bad_cells  TYPE lvc_t_modi OPTIONAL
        !im_display    TYPE char01 OPTIONAL
      EXPORTING
        !ex_changed    TYPE xfeld
      CHANGING
        !ch_line       TYPE any .
    METHODS process_customer_button
      IMPORTING
        !io_sender TYPE REF TO zif_appl_object OPTIONAL
        !im_ucomm  TYPE sy-ucomm
      CHANGING
        !t_outtab  TYPE STANDARD TABLE .
    METHODS set_alv_line
      CHANGING
        !ch_line TYPE any .
    METHODS set_alv_line_attributes
      CHANGING
        !ch_line TYPE any .
    METHODS set_data_from_alv_line
      IMPORTING
        !im_line TYPE any .
    METHODS show_customer_buttons
      IMPORTING
        !im_toolbar_object  TYPE REF TO cl_alv_event_toolbar_set
        !im_layout_name     TYPE lvc_tname
        !im_ready_for_input TYPE xfeld OPTIONAL .

    METHODS set_registered_events
        REDEFINITION .
  PROTECTED SECTION.
*"* protected components of class /BDFPLM/CL_DCC_ALV
*"* do not include other source files here!!!

    METHODS process_class_button
      IMPORTING
        !io_sender TYPE REF TO zif_appl_object OPTIONAL
        !im_ucomm  TYPE sy-ucomm
      CHANGING
        !t_outtab  TYPE STANDARD TABLE .
    METHODS process_customer_button_int
      IMPORTING
        !io_sender TYPE REF TO zif_appl_object OPTIONAL
        !im_ucomm  TYPE sy-ucomm
      CHANGING
        !t_outtab  TYPE STANDARD TABLE .
    METHODS read_customer_customizing
      IMPORTING
        !im_layout_name TYPE lvc_tname .
  PRIVATE SECTION.
*"* private components of class /BDFPLM/CL_DCC_ALV
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_APPL_ALV IMPLEMENTATION.


  METHOD add_customer_function.

    DATA: ls_customer_button TYPE zappl_lvc_button,
          ls_button          TYPE stb_button,
          lv_icon            TYPE icon_d,
          lv_disabled        TYPE xfeld,
          lv_count           TYPE i,
          lv_ready_for_input TYPE int4.


    DEFINE _buttons.

      CHECK ls_customer_button-button_type = 6    "6  Menüeintrag
         OR ls_customer_button-button_type = 3.   "3  Separator

      CLEAR: lv_icon, lv_disabled.

      CASE ls_customer_button-display_mode.
        WHEN 'R'.
          IF lv_ready_for_input = 1.
            lv_disabled = 'X'.
          ENDIF.

        WHEN 'U'.
          IF lv_ready_for_input = 0.
            lv_disabled = 'X'.
          ENDIF.

*      WHEN '*'.

      ENDCASE.

      IF ls_customer_button-button_type = 3.            "Separator.
        CALL METHOD im_object->add_separator.
      ENDIF.
      lv_icon = ls_customer_button-icon(4).
      CALL METHOD im_object->add_function
        EXPORTING
          fcode    = ls_customer_button-button_name       "Function Code
          text     = ls_customer_button-button_text       "Function text
          icon     = lv_icon                              "Icons
          disabled = lv_disabled.                         "Inaktiv

    END-OF-DEFINITION.


    IF im_ready_for_input IS SUPPLIED.
      IF im_ready_for_input = 'X'.
        lv_ready_for_input = 1.
      ELSE.
        lv_ready_for_input = 0.
      ENDIF.
    ELSE.
      lv_ready_for_input   = is_ready_for_input( ).
    ENDIF.

* Customizing nachlesen
    IF im_layout_name IS SUPPLIED AND layout_name <> im_layout_name.
      CALL METHOD read_customer_customizing( im_layout_name ).
    ENDIF.

* Kundenbutton
    LOOP AT t_customer_buttons INTO ls_customer_button
      WHERE parent_button = im_button_name.

      _buttons.

    ENDLOOP.

* Klassifizierungsbutton
    LOOP AT t_customer_class_btn INTO ls_customer_button
      WHERE parent_button = im_button_name.

      _buttons.

    ENDLOOP.






  ENDMETHOD.


  METHOD constructor.
    CALL METHOD super->constructor
      EXPORTING
        i_shellstyle      = i_shellstyle
        i_lifetime        = i_lifetime
        i_parent          = i_parent
        i_appl_events     = i_appl_events
        i_parentdbg       = i_parentdbg
        i_applogparent    = i_applogparent
        i_graphicsparent  = i_graphicsparent
        i_name            = i_name
        i_fcat_complete   = i_fcat_complete
      EXCEPTIONS
        error_cntl_create = 1
        error_cntl_init   = 2
        error_cntl_link   = 3
        error_dp_create   = 4
        OTHERS            = 5.
    CASE sy-subrc.
      WHEN 0.
      WHEN 1.
        RAISE error_cntl_create.
      WHEN 2.
        RAISE error_cntl_init.
      WHEN 3.
        RAISE error_cntl_link.
      WHEN 4.
        RAISE error_dp_create.
      WHEN OTHERS.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDCASE.

  ENDMETHOD.


  METHOD get_customer_field_catalog.

    CALL METHOD read_customer_customizing( im_layout_name ).

    re_tab_fcat = t_customer_fcat.

  ENDMETHOD.


  METHOD get_variant_handle.

    DATA: lv_handle TYPE slis_handl,
          lv_string TYPE string,
          lv_hash   TYPE hash160.

*  CALL 'C_ENQ_WILDCARD' ID 'TEXT'     FIELD layout_name
*                        ID 'TEXTHASH' FIELD lv_handle.
*  re_variant_handle = lv_handle.

    IF im_layout_name IS SUPPLIED.
      lv_string = im_layout_name.
    ELSE.
      lv_string = layout_name.
    ENDIF.

    CALL FUNCTION 'CALCULATE_HASH_FOR_CHAR'
      EXPORTING
        data           = lv_string
      IMPORTING
        hash           = lv_hash
      EXCEPTIONS
        unknown_alg    = 1
        param_error    = 2
        internal_error = 3
        OTHERS         = 4.

    re_variant_handle = lv_hash.

  ENDMETHOD.


  METHOD on_customer_double_click.



  ENDMETHOD.


  METHOD on_customer_hotspot_click.


  ENDMETHOD.


  METHOD on_customer_onf4.


  ENDMETHOD.


  METHOD process_class_button.

    gs_active_classe-classtype = im_ucomm+19(3).
    gs_active_classe-classnum = im_ucomm+23.

  ENDMETHOD.


  METHOD process_customer_button.


  ENDMETHOD.


  METHOD process_customer_button_int.


  ENDMETHOD.


  METHOD read_customer_customizing.


  ENDMETHOD.


  METHOD set_alv_line.

  ENDMETHOD.


  METHOD set_alv_line_attributes.


  ENDMETHOD.


  METHOD set_data_from_alv_line.


  ENDMETHOD.


  METHOD set_registered_events.
* Es ist eine Kopie von die private Methode
* CL_GUI_ALV_GRID - SET_REGISTERED_EVENTS_INTERNAL

    DATA: simple_event TYPE cntl_simple_event, "// event
          ex_event     TYPE cntl_event,  "// eventid, is_shellevent
          lt_events    TYPE cntl_simple_events,
          events_ex    TYPE cntl_events. "// table

    CALL METHOD get_registered_events IMPORTING events = lt_events.
    LOOP AT lt_events INTO simple_event.
      IF simple_event-eventid = evt_click_col_header OR
         simple_event-eventid = evt_delayed_move_current_cell OR
         simple_event-eventid = evt_delayed_change_selection.
        DELETE lt_events.
      ENDIF.
    ENDLOOP.

*  if m_cl_variant is initial.
*    create object m_cl_variant
*        exporting
*           it_outtab             = mt_outtab
*           it_fieldcatalog       = m_cl_variant->mt_fieldcatalog
*           it_sort               = m_cl_variant->mt_sort
*           it_filter             = m_cl_variant->mt_filter
*           it_grouplevels_filter = m_cl_variant->mt_grouplevels_filter
*           is_variant            = m_cl_variant->ms_variant
*           is_layout             = m_cl_variant->ms_layout
*           i_variant_save        = m_cl_variant->m_variant_save
*           i_variant_default     = m_cl_variant->m_variant_default
*           i_www_active          = m_www
*           is_print              = m_cl_variant->ms_print
*           i_cl_alv_grid         = me
*           ir_salv_adapter       = me->r_salv_adapter.
*  else.
*    call method m_cl_variant->set_values
*         exporting
*           it_outtab             = mt_outtab
*           i_www_active          = m_www.
*  endif.
*
*  if m_cl_variant->ms_layout-sgl_clk_hd eq 'X'.
*    simple_event-eventid = evt_click_col_header.
*    append simple_event to lt_events.
*  endif.

    APPEND LINES OF events TO lt_events.
    SORT lt_events BY eventid.
    DELETE ADJACENT DUPLICATES FROM lt_events COMPARING eventid.

    LOOP AT events INTO simple_event.
*... map simple_event into ex_event, append to events_ex
      CLEAR ex_event.
      ex_event-eventid = simple_event-eventid.
      ex_event-is_shellevent = space.
      IF simple_event-appl_event IS INITIAL.
        ex_event-is_systemevent = 'X'.
      ENDIF.
      APPEND ex_event TO events_ex.
    ENDLOOP.

    ex_event-eventid        = cl_gui_control=>shellevt_dragdrop.
    ex_event-is_shellevent  = 'X'.
    ex_event-is_systemevent = 'X'.       "Drag&Drop always systemevents!!
    APPEND ex_event TO events_ex.

    CALL METHOD me->set_registered_events_ex
      EXPORTING
        eventtab                  = events_ex
      EXCEPTIONS
        cntl_error                = 1
        cntl_system_error         = 2
        illegal_event_combination = 3
        OTHERS                    = 4.
    CASE sy-subrc.
      WHEN 0.
      WHEN 1.      RAISE cntl_error.
      WHEN 2.      RAISE cntl_system_error.
      WHEN 3.      RAISE illegal_event_combination.
      WHEN OTHERS. RAISE cntl_error.
    ENDCASE.

    registered_simple_events[] = lt_events.


  ENDMETHOD.


  METHOD show_customer_buttons.



  ENDMETHOD.
ENDCLASS.
