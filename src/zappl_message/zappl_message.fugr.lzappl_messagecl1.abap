*----------------------------------------------------------------------*
***INCLUDE LZAPPL_MESSAGECL1.
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
*       CLASS LCL_EVENT_RECEIVER DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_event_receiver DEFINITION.

  PUBLIC SECTION.

    METHODS:
      create_controls
        IMPORTING
          im_container_name TYPE con_name,

      show_alv
        CHANGING
          it_messages_alv TYPE zappl_message_alv_t.


  PRIVATE SECTION.

    DATA: o_splitter       TYPE REF TO cl_gui_splitter_container,
          o_container      TYPE REF TO cl_gui_custom_container,
          o_container_grid TYPE REF TO cl_gui_container,
          o_container_tool TYPE REF TO cl_gui_container,
          o_message_grid   TYPE REF TO zcl_appl_alv,
          o_container_html TYPE REF TO cl_gui_container,
          o_html_help      TYPE REF TO cl_gui_html_viewer.

    DATA: first_flg   TYPE xfeld VALUE 'X',
          layout_name TYPE lvc_tname VALUE 'DCC_MESSAGE'.

    METHODS:
      handle_toolbar
        FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING
          e_object
          e_interactive,

      handle_menu_button
        FOR EVENT menu_button OF cl_gui_alv_grid
        IMPORTING
          e_object
          e_ucomm,

      handle_user_command
        FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm,

      handle_double_click
        FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING
          e_row
          e_column,

      handle_hotspot_click
        FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING
          e_row_id
          e_column_id,

      handle_close
        FOR EVENT close OF cl_gui_dialogbox_container,

      read_and_create_doku_call
        IMPORTING
          im_objid   TYPE doku_obj
          im_doku_id TYPE doku_id DEFAULT 'NA',

      get_layout
        RETURNING VALUE(re_layout) TYPE  lvc_s_layo,

      get_fcat
        RETURNING VALUE(re_t_fcat) TYPE lvc_t_fcat,

      clear.

ENDCLASS.                    "LCL_EVENT_RECEIVER DEFINITION

*----------------------------------------------------------------------*
*       CLASS LCL_EVENT_RECEIVER IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_event_receiver IMPLEMENTATION.

  METHOD handle_toolbar.
    DATA: ls_button    TYPE stb_button.

    CLEAR: ls_button.

**** MAKE A SEPERATOR *****
    ls_button-butn_type = 3.
    INSERT ls_button INTO e_object->mt_toolbar INDEX 1.

***** MAKE USER BUTTON *****
    CLEAR ls_button.
    ls_button-function   = 'LINKS'.
    ls_button-icon       = '@9S@'.
    ls_button-quickinfo  = 'Links'(004).
    ls_button-butn_type  = 0.
    ls_button-disabled   = space.
    INSERT ls_button INTO e_object->mt_toolbar INDEX 1.

***** MAKE USER BUTTON *****
    CLEAR ls_button.
    ls_button-function   = 'CENTER'.
    ls_button-icon       = '@53@'.
    ls_button-quickinfo  = 'Zentrieren'(005).
    ls_button-butn_type  = 0.
    ls_button-disabled   = space.
    INSERT ls_button INTO e_object->mt_toolbar INDEX 1.

***** MAKE USER BUTTON *****
    CLEAR ls_button.
    ls_button-function   = 'RECHTS'.
    ls_button-icon       = '@9T@'.
    ls_button-quickinfo  = 'Rechts'(006).
    ls_button-butn_type  = 0.
    ls_button-disabled   = space.
    INSERT ls_button INTO e_object->mt_toolbar INDEX 1.

***** MAKE USER BUTTON *****
    CLEAR ls_button.
    ls_button-function   = 'CLOSE'.
    ls_button-icon       = '@0W@'.
    ls_button-quickinfo  = 'Schliessen'(003).
    ls_button-butn_type  = 0.
    ls_button-disabled   = space.
    INSERT ls_button INTO e_object->mt_toolbar INDEX 1.


  ENDMETHOD.                    "HANDLE_TOOLBAR
*----------------------------------------------------------------------*

  METHOD handle_menu_button.

    CALL METHOD o_message_grid->add_customer_function
      EXPORTING
        im_object      = e_object
        im_button_name = e_ucomm.

  ENDMETHOD.                    "HANDLE_MENU_BUTTON
*----------------------------------------------------------------------*

  METHOD handle_user_command.
    CASE e_ucomm.
      WHEN 'LINKS'.
        CALL METHOD o_splitter->set_column_width
          EXPORTING
            id    = 1
            width = 80.

      WHEN 'RECHTS'.
        CALL METHOD o_splitter->set_column_width
          EXPORTING
            id    = 1
            width = 0.

      WHEN 'CENTER'.
        CALL METHOD o_splitter->set_column_width
          EXPORTING
            id    = 1
            width = 50.

      WHEN 'CLOSE'.
        CALL METHOD clear.
        sy-ucomm = 'CLOSE'.


      WHEN OTHERS.
*        CALL METHOD o_message_grid->process_customer_button
*          EXPORTING
*            im_ucomm  = e_ucomm
**            io_sender = me
*          CHANGING
*            t_outtab  = gt_messages_alv.

    ENDCASE.

  ENDMETHOD.                    "HANDLE_USER_COMMAND
*----------------------------------------------------------------------*

  METHOD handle_double_click.

    DATA: l_objid     TYPE dokhl-object,
          l_index     TYPE sy-dbcnt,
          ls_alv_line TYPE zappl_message_alv.

    l_index = e_row.

    IF e_column = 'LTEXT' AND l_index > 0.

      READ TABLE gt_messages_alv INTO ls_alv_line INDEX l_index.
      CONCATENATE ls_alv_line-id ls_alv_line-number INTO l_objid.

      IF NOT ls_alv_line-ltext IS INITIAL.

        CALL METHOD read_and_create_doku_call
          EXPORTING
            im_objid   = l_objid
            im_doku_id = 'NA'.

        CALL METHOD o_splitter->set_column_width
          EXPORTING
            id    = 1
            width = 60.
        EXIT.
      ENDIF.

    ENDIF.

    MESSAGE s006(zappl_message).


  ENDMETHOD.                    "HANDLE_DOUBLE_CLICK
*----------------------------------------------------------------------*

  METHOD handle_hotspot_click.

    DATA: l_index     TYPE sy-dbcnt,
          ls_alv_line TYPE zappl_message_alv.

    l_index = e_row_id.

    IF e_column_id = 'TYPE' AND l_index > 0.
      READ TABLE gt_messages_alv INTO ls_alv_line INDEX l_index.
      CASE ls_alv_line-type.
        WHEN 'S'.
          MESSAGE s001(zappl_message).
        WHEN 'W'.
          MESSAGE s002(zappl_message).
        WHEN 'E'.
          MESSAGE s003(zappl_message).
        WHEN 'I'.
          MESSAGE s004(zappl_message).
        WHEN 'A'.
          MESSAGE s005(zappl_message).
      ENDCASE.
    ENDIF.


  ENDMETHOD.                    "HANDLE_HOTSPOT_CLICK
*----------------------------------------------------------------------*

  METHOD handle_close.

    CALL METHOD clear.

  ENDMETHOD.                    "HANDLE_CLOSE
*----------------------------------------------------------------------*

  METHOD read_and_create_doku_call.

    DATA: l_dokversion TYPE dokvers,
          l_typ        TYPE doku_typ,
          l_doktitle   TYPE doku_title,
          ls_heat      TYPE thead,
          lt_line      TYPE TABLE OF tline,
          lt_html_line TYPE TABLE OF htmlline.


    SELECT SINGLE MAX( dokversion ) FROM dokhl INTO l_dokversion
      WHERE id = im_doku_id
      AND   object = im_objid
      AND   langu  = sy-langu
      AND   typ    = 'E'.          "I HOPE THAT MEAN ACTIVE :-)

    IF sy-subrc <> 0.
      EXIT.
    ENDIF.

    CALL FUNCTION 'DOCU_READ'
      EXPORTING
        id       = im_doku_id
        langu    = sy-langu
        object   = im_objid
        typ      = 'E'
        version  = l_dokversion
      IMPORTING
        doktitle = l_doktitle
        head     = ls_heat
      TABLES
        line     = lt_line.

    CALL FUNCTION 'CONVERT_ITF_TO_HTML'
      EXPORTING
        i_header       = ls_heat
*       I_PAGE         = ' '
*       I_WINDOW       = ' '
*       I_SYNTAX_CHECK = ' '
*       I_REPLACE      = 'X'
*       I_PRINT_COMMANDS   = ' '
*       I_HTML_HEADER  = 'X'
*       I_FUNCNAME     = ' '
        i_title        = 'Help long text'(001)
*       I_BACKGROUND   = ' '
        i_bgcolor      = '#CECCBD'
      TABLES
        t_itf_text     = lt_line
        t_html_text    = lt_html_line
      EXCEPTIONS
        syntax_check   = 1
        replace        = 2
        illegal_header = 3
        OTHERS         = 4.
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.

    CALL METHOD o_html_help->load_data
      EXPORTING
        url                  = 'VAT'
*       TYPE                 = 'text'
*       SUBTYPE              = 'html'
*       SIZE                 = 0
*          IMPORTING
*       ASSIGNED_URL         =
      CHANGING
        data_table           = lt_html_line
      EXCEPTIONS
        dp_invalid_parameter = 1
        dp_error_general     = 2
        cntl_error           = 3
        OTHERS               = 4.

    IF sy-subrc <> 0.
      EXIT.
    ENDIF.

    CALL METHOD o_html_help->show_data
      EXPORTING
        url        = 'VAT'
*       FRAME      =
      EXCEPTIONS
        cntl_error = 1
        OTHERS     = 2.

    IF sy-subrc <> 0.
      EXIT.
    ENDIF.

  ENDMETHOD.                    "read_and_create_doku_call
*----------------------------------------------------------------------*

  METHOD clear.
    FREE : o_message_grid,
           o_splitter,
           o_container_html,
           o_container_grid,
           o_html_help,
           o_container.

  ENDMETHOD.                    "clear
*----------------------------------------------------------------------*

  METHOD create_controls.

    CHECK o_container IS INITIAL.

    CREATE OBJECT o_container
      EXPORTING
        container_name = im_container_name.

***** CREATE SPLITTER FOR TREE/GRID/HTML IF INITIAL *****
    CREATE OBJECT o_splitter
      EXPORTING
        parent  = o_container
        rows    = 1
        columns = 2.

    CALL METHOD o_splitter->set_border
      EXPORTING
        border = space.

    CALL METHOD o_splitter->get_container
      EXPORTING
        row       = 1
        column    = 1
      RECEIVING
        container = o_container_html.

    CALL METHOD o_splitter->set_column_width
      EXPORTING
        id    = 1
        width = 0.

    CALL METHOD o_splitter->get_container
      EXPORTING
        row       = 1
        column    = 2
      RECEIVING
        container = o_container_grid.


***** CREATE GRID IF INITIAL *****
    CREATE OBJECT o_message_grid
      EXPORTING
        i_parent      = o_container_grid
        i_appl_events = 'X'.

    SET HANDLER:
      handle_toolbar        FOR o_message_grid,
      handle_user_command   FOR o_message_grid,
      handle_menu_button    FOR o_message_grid,
      handle_double_click   FOR o_message_grid,
      handle_hotspot_click  FOR o_message_grid.


***** CREATE HTML IF INITIAL *****
    CREATE OBJECT o_html_help
      EXPORTING
        parent   = o_container_html
        saphtmlp = 'X'
        uiflag   = 1.

*    CALL METHOD read_and_create_doku_call
*      EXPORTING
*        im_objid   = '...'
*        im_doku_id = 'HY'.



  ENDMETHOD.                    "create_controls
*----------------------------------------------------------------------*

  METHOD show_alv.
    DATA: lt_fcodes  TYPE ui_functions,
          ls_layout  TYPE lvc_s_layo,
          ls_variant TYPE disvariant,
          lt_fcat    TYPE lvc_t_fcat.

    IF first_flg = 'X'.
      first_flg = space.

      ls_variant-report   = sy-repid.
      ls_variant-username = sy-uname.

***** EXCLUDE SOME MENUS *****
      INSERT '&SUMC'   INTO lt_fcodes INDEX 1.
      INSERT '&SUBTOT' INTO lt_fcodes INDEX 1.

***** SET LAYOUT *****
      ls_layout = get_layout( ).
      lt_fcat   = get_fcat( ).

      CALL METHOD o_message_grid->set_table_for_first_display
        EXPORTING
*         i_structure_name              = ''
          is_layout                     = ls_layout
          it_toolbar_excluding          = lt_fcodes
          is_variant                    = ls_variant
          i_save                        = 'A'
        CHANGING
          it_outtab                     = it_messages_alv
          it_fieldcatalog               = lt_fcat
        EXCEPTIONS
          invalid_parameter_combination = 1
          program_error                 = 2
          OTHERS                        = 3.

      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
      " raise event TOOLBAR:
      CALL METHOD o_message_grid->set_toolbar_interactive.
    ELSE.
      CALL METHOD o_message_grid->refresh_table_display.
    ENDIF.

  ENDMETHOD.                    "show_alv
*----------------------------------------------------------------------*
  METHOD get_layout.

    re_layout-cwidth_opt = 'X'.
    re_layout-no_hgridln = 'X'.
    re_layout-no_vgridln = 'X'.
    re_layout-smalltitle = 'X'.
    re_layout-numc_total = space.
    re_layout-no_rowmark = 'X'.
    re_layout-detailinit = 'X'.
    re_layout-detailtitl = 'FURTHER DETAILS'.
    re_layout-keyhot     = 'X'.
    re_layout-no_keyfix  = 'X'.
    re_layout-keyhot     = 'X'.
    re_layout-grid_title = TEXT-002.
    re_layout-detailinit = space.

  ENDMETHOD.                    "get_layout
*----------------------------------------------------------------------*

  METHOD get_fcat.

    DATA: lt_fcat TYPE lvc_t_fcat,
          ls_fcat TYPE lvc_s_fcat.

    FIELD-SYMBOLS: <fcat>    LIKE LINE OF gt_fcat,
                   <ls_fcat> TYPE lvc_s_fcat.

    LOOP AT gt_fcat ASSIGNING <fcat>.
      CLEAR ls_fcat.
      MOVE-CORRESPONDING <fcat> TO ls_fcat.
      ls_fcat-key = <fcat>-key_flg.
      APPEND ls_fcat TO lt_fcat.
    ENDLOOP.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = 'ZAPPL_MESSAGE_ALV'
        i_client_never_display = 'X'
      CHANGING
        ct_fieldcat            = lt_fcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

    re_t_fcat = lt_fcat.

  ENDMETHOD.                    "get_fcat
*----------------------------------------------------------------------*


ENDCLASS.                    "LCL_EVENT_RECEIVER IMPLEMENTATION
