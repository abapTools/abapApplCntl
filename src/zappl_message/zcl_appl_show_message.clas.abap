CLASS zcl_appl_show_message DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_appl_object .
    INTERFACES zif_appl_show_message .

    ALIASES appl_type
      FOR zif_appl_object~appl_type .
    ALIASES o_appl_message
      FOR zif_appl_object~o_appl_message .
    ALIASES display_docking
      FOR zif_appl_show_message~display_docking .
    ALIASES display_html
      FOR zif_appl_show_message~display_html .
    ALIASES display_modal
      FOR zif_appl_show_message~display_modal .
    ALIASES display_modeless
      FOR zif_appl_show_message~display_modeless .
    ALIASES get_appl_type
      FOR zif_appl_object~get_appl_type .
    ALIASES set_appl_type
      FOR zif_appl_object~set_appl_type .
    ALIASES set_visible
      FOR zif_appl_show_message~set_visible .
  PROTECTED SECTION.

    DATA control_handle TYPE balcnthndl .
    DATA mode TYPE zappl_message_show_type.
    DATA o_container_top TYPE REF TO cl_gui_docking_container .
    DATA o_dialogbox TYPE REF TO cl_gui_dialogbox_container .
    DATA o_message TYPE REF TO zif_appl_message.

    METHODS clear_protocol .
    METHODS create_container_top .
    METHODS create_dialogbox .
    METHODS display_protocol
      IMPORTING
        !im_container TYPE REF TO cl_gui_container .
    METHODS get_display_profile
      RETURNING
        VALUE(re_profile) TYPE bal_s_prof .
    METHODS get_extension
      RETURNING
        VALUE(re_extension) TYPE i .
    METHODS on_close
      FOR EVENT close OF cl_gui_dialogbox_container
      IMPORTING
        !sender .
    METHODS on_pushbutton
      FOR EVENT pushbutton OF zif_appl_message_event
      IMPORTING
        !ex_state .

  PRIVATE SECTION.

    ALIASES display_finished
      FOR zif_appl_show_message~display_finished .

ENDCLASS.



CLASS ZCL_APPL_SHOW_MESSAGE IMPLEMENTATION.


  METHOD clear_protocol.

*  destroy application log control
    CALL FUNCTION 'BAL_CNTL_FREE'
      CHANGING
        c_control_handle  = control_handle
      EXCEPTIONS
        control_not_found = 1
        OTHERS            = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CLEAR control_handle.

* destroy container
    IF o_dialogbox IS BOUND.
      CALL METHOD o_dialogbox->free
        EXCEPTIONS
          OTHERS = 1.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
      CLEAR o_dialogbox.
    ENDIF.

* destroy container
    IF o_container_top IS BOUND.
      CALL METHOD o_container_top->free
        EXCEPTIONS
          OTHERS = 1.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
      CLEAR o_container_top.
    ENDIF.

* destroy log
    CALL METHOD o_message->clear.


*  CALL METHOD cl_gui_cfw=>flush.
  ENDMETHOD.


  METHOD create_container_top.
    DATA: l_extension      TYPE i.

    l_extension = get_extension( ).

    CREATE OBJECT o_container_top
      EXPORTING
        side                        = o_container_top->dock_at_top
        extension                   = l_extension
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      EXIT.
    ENDIF.
  ENDMETHOD.


  METHOD create_dialogbox.
    DATA: l_extension      TYPE i.

    l_extension = get_extension( ).

    CREATE OBJECT o_dialogbox
      EXPORTING
        caption                     = TEXT-008
        width                       = '750'
        height                      = l_extension
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        event_already_registered    = 6
        error_regist_event          = 7
        OTHERS                      = 8.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      EXIT.
    ENDIF.

    SET HANDLER on_close FOR o_dialogbox.
  ENDMETHOD.


  METHOD display_protocol.
    DATA: ls_profile    TYPE bal_s_prof,
          lt_log_handle TYPE bal_t_logh,
          ls_log_handle TYPE balloghndl,
          lt_msg_handle TYPE bal_t_msgh.

    ls_profile = get_display_profile( ).
    ls_log_handle = o_message->get_log_handle( ).
    INSERT ls_log_handle INTO TABLE lt_log_handle.
    lt_msg_handle = o_message->get_msg_handle( ).


    IF control_handle IS INITIAL.

      CALL FUNCTION 'BAL_CNTL_CREATE'
        EXPORTING
          i_container          = im_container
          i_s_display_profile  = ls_profile
          i_t_log_handle       = lt_log_handle
          i_t_msg_handle       = lt_msg_handle
        IMPORTING
          e_control_handle     = control_handle
        EXCEPTIONS
          profile_inconsistent = 1
          internal_error       = 2
          OTHERS               = 3.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

    ELSE.

      CALL FUNCTION 'BAL_CNTL_REFRESH'
        EXPORTING
          i_control_handle  = control_handle
          i_t_log_handle    = lt_log_handle
          i_t_msg_handle    = lt_msg_handle
        EXCEPTIONS
          control_not_found = 1
          internal_error    = 2
          OTHERS            = 3.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

    ENDIF.
  ENDMETHOD.


  METHOD get_display_profile.
    DATA:
      ls_fcat TYPE bal_s_fcat,
      ls_sort TYPE bal_s_sort.

    FIELD-SYMBOLS:
      <ls_fcat> TYPE bal_s_fcat.


    CALL FUNCTION 'BAL_DSP_PROFILE_POPUP_GET'
      IMPORTING
        e_s_display_profile = re_profile.

* increase position of all fields
    LOOP AT re_profile-mess_fcat ASSIGNING <ls_fcat>.
      ADD 1 TO <ls_fcat>-col_pos.
      IF <ls_fcat>-ref_field = 'T_MSG'.
        <ls_fcat>-outputlen = 60.
      ENDIF.
    ENDLOOP.

* add field to field catalog on position 1.
    CLEAR ls_fcat.
    ls_fcat-col_pos = 1.
    ls_fcat-outputlen = 20.
    ls_fcat-ref_table = 'LVC_S_BALS'.
    ls_fcat-ref_field = 'COLTEXT'.
*  ls_fcat-hotspot   = 'X'.
    APPEND ls_fcat TO re_profile-mess_fcat.
* add field as an invisible field
    CLEAR ls_fcat.
    ls_fcat-ref_table = 'LVC_S_BALS'.
    ls_fcat-ref_field = 'ROW_ID'.
    ls_fcat-no_out    = 'X'.
    APPEND ls_fcat TO re_profile-mess_fcat.
* add field as an invisible field
    CLEAR ls_fcat.
    ls_fcat-ref_table = 'LVC_S_BALS'.
    ls_fcat-ref_field = 'COL_ID'.
    ls_fcat-no_out    = 'X'.
    APPEND ls_fcat TO re_profile-mess_fcat.
* add field as an invisible field
    CLEAR ls_fcat.
    ls_fcat-ref_table = 'LVC_S_BALS'.
    ls_fcat-ref_field = 'FIELDNAME'.
    ls_fcat-no_out    = 'X'.
    APPEND ls_fcat TO re_profile-mess_fcat.
* add field as an invisible field
    CLEAR ls_fcat.
    ls_fcat-ref_table = 'LVC_S_BALS'.
    ls_fcat-ref_field = 'SELTEXT'.
    ls_fcat-no_out    = 'X'.
    APPEND ls_fcat TO re_profile-mess_fcat.
* add field as an invisible field
*  CLEAR ls_fcat.
*  ls_fcat-ref_table = 'LVC_S_BALS'.
*  ls_fcat-ref_field = 'VALUE'.
*  ls_fcat-no_out    = 'X'.
*  APPEND ls_fcat TO re_profile-mess_fcat.
* add field as an invisible field
    CLEAR ls_fcat.
    ls_fcat-ref_table = 'LVC_S_BALS'.
    ls_fcat-ref_field = 'COL_POS'.
    ls_fcat-no_out      = 'X'.
    APPEND ls_fcat TO re_profile-mess_fcat.
* add field as an invisible field
    CLEAR ls_fcat.
    ls_fcat-ref_table = 'LVC_S_BALS'.
    ls_fcat-ref_field = 'BALLOGHNDL'.
    ls_fcat-no_out      = 'X'.
    APPEND ls_fcat TO re_profile-mess_fcat.

* sort by sortfield and fieldname
    CLEAR re_profile-mess_sort.
    CLEAR ls_sort.
    ls_sort-spos = 1.
    ls_sort-up = 'X'.
    ls_sort-ref_table = 'LVC_S_BALS'.
    ls_sort-ref_field = 'ROW_ID'.
    APPEND ls_sort TO re_profile-mess_sort.
    CLEAR ls_sort.
    ls_sort-spos = 2.
    ls_sort-up = 'X'.
    ls_sort-ref_table = 'LVC_S_BALS'.
    ls_sort-ref_field = 'COL_POS'.
    APPEND ls_sort TO re_profile-mess_sort.




    IF mode = 'T'.

* add a pushbotton on the right side of toolbar above messages
      re_profile-ext_push1-active    = 'X'.
      re_profile-ext_push1-position  = '3'.
      re_profile-ext_push1-def-icon_id   = '@0W@'.
      re_profile-ext_push1-def-quickinfo = 'Schliessen'(009).

* set callback routine to handle user commands
      re_profile-clbk_ucom-userexitt = 'F'.
      re_profile-clbk_ucom-userexitf = 'ZAPPL_SHOW_MESSAGE_UCOMM'.

*  re_profile-clbk_toolb-userexitt = space.
*  re_profile-clbk_toolb-userexitp = sy-repid.
*  re_profile-clbk_toolb-userexitf = 'TEST'.

    ENDIF.









* when a message is doubleclicked, we want to position on the field
* which caused the error
* "Doubleclick" is processed as a standard command to show the longtext
* We therefore set the callback routine 'BEFORE UCOMM' to get control
* and execute our own function
    re_profile-clbk_ucbf-userexitt = space.
    re_profile-clbk_ucbf-userexitp = 'BCALV_APPL_LOG'.
    re_profile-clbk_ucbf-userexitf = 'F2'.
    re_profile-cwidth_opt = 'X'.

*  IF i_display_toolbar IS INITIAL.
*    re_profile-no_toolbar          = 'X'.
*  ENDIF.

  ENDMETHOD.


  METHOD get_extension.
    DATA: l_lines     TYPE i,
          lt_messages TYPE bapiret2_t,
          l_max       TYPE i.

    lt_messages = o_message->get_messages( ).
    DESCRIBE TABLE lt_messages LINES l_lines.

    re_extension = l_lines * 10 + 40.

    CASE mode.
      WHEN 'T'.
        l_max = 200.

      WHEN 'D'.
        re_extension = re_extension + 20.
        l_max = 400.

      WHEN 'M'.

    ENDCASE.


    IF re_extension > l_max.
      re_extension = l_max.
    ENDIF.
  ENDMETHOD.


  METHOD on_close.
    CALL METHOD clear_protocol.
  ENDMETHOD.


  METHOD on_pushbutton.
    CHECK ex_state-list_msgh-log_handle = o_message->get_log_handle( ).

    CASE ex_state-ucomm.
      WHEN '%EXT_PUSH1'.
        CALL METHOD clear_protocol.

      WHEN '%EXT_PUSH2'.
*      CALL METHOD save_protocol.

      WHEN '%EXT_PUSH3'.
      WHEN '%EXT_PUSH4'.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.


  METHOD zif_appl_object~get_appl_type.
    re_type = appl_type.
  ENDMETHOD.


  METHOD zif_appl_object~set_appl_type.
    appl_type = im_type.
  ENDMETHOD.


  METHOD zif_appl_show_message~display_docking.
    DATA: lo_container TYPE REF TO cl_gui_container,
          l_height     TYPE i.

    mode = 'T'.

    IF io_message IS BOUND.
      o_message = io_message.
    ELSE.
      o_message = o_appl_message.
    ENDIF.

    IF o_container_top IS INITIAL.
      CALL METHOD create_container_top.
    ENDIF.

*      l_height = get_extension( ).
*      CALL METHOD o_container_top->set_height( l_height ).

    lo_container ?= o_container_top.

    CALL METHOD display_protocol( lo_container ).
  ENDMETHOD.


  METHOD zif_appl_show_message~display_html.
  ENDMETHOD.


  METHOD zif_appl_show_message~display_modal.

    mode = 'M'.

    IF io_message IS BOUND.
      o_message = io_message.
    ELSE.
      o_message = o_appl_message.
    ENDIF.

    CALL FUNCTION 'ZAPPL_SHOW_MESSAGE_POPUP'
      EXPORTING
        io_message = o_message.

  ENDMETHOD.


  METHOD zif_appl_show_message~display_modeless.
    DATA: lo_container TYPE REF TO cl_gui_container,
          l_height     TYPE i.

    mode = 'D'.

    IF io_message IS BOUND.
      o_message = io_message.
    ELSE.
      o_message = o_appl_message.
    ENDIF.


    IF o_dialogbox IS INITIAL.
      CALL METHOD create_dialogbox.
    ENDIF.

*  l_height = 20 + get_extension( ).
*  CALL METHOD o_dialogbox->set_height( l_height ).

    lo_container ?= o_dialogbox.

    CALL METHOD display_protocol( lo_container ).
  ENDMETHOD.


  METHOD zif_appl_show_message~set_visible.
    DATA: l_height    TYPE i.

    IF im_visible = 'X'.
      l_height = get_extension( ).

    ELSE.
      l_height = 0.

    ENDIF.


    IF o_dialogbox IS BOUND.

      l_height = 20 + l_height.

      CALL METHOD o_dialogbox->set_height
        EXPORTING
          height = l_height.

      CALL METHOD o_dialogbox->set_visible
        EXPORTING
          visible           = im_visible
        EXCEPTIONS
          cntl_error        = 1
          cntl_system_error = 2
          OTHERS            = 3.

      IF sy-subrc <> 0.
        EXIT.
      ENDIF.

    ENDIF.


    IF o_container_top IS BOUND.

      CALL METHOD o_container_top->set_height
        EXPORTING
          height = l_height.

      CALL METHOD o_container_top->set_visible( im_visible ).

    ENDIF.
  ENDMETHOD.
ENDCLASS.
