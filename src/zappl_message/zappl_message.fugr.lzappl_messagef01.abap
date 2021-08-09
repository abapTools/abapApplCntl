*&---------------------------------------------------------------------*
*& Include          LZAPPL_MESSAGEF01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  show_message
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM show_message .

  DATA: lo_container    TYPE REF TO cl_gui_container.

  CHECK o_custom_container IS INITIAL.

  CREATE OBJECT o_custom_container
    EXPORTING
      container_name = 'MESSAGE_CUSTOM'.

  PERFORM display_message USING o_custom_container.

  SET CURSOR FIELD 'BTN_EXIT'.

ENDFORM.                    " show_message
*&---------------------------------------------------------------------*
*&      Form  display_message
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_message USING lo_container.

  DATA: ls_profile    TYPE bal_s_prof,
        lt_log_handle TYPE bal_t_logh,
        ls_log_handle TYPE balloghndl,
        lt_msg_handle TYPE bal_t_msgh.

  PERFORM get_display_profile CHANGING ls_profile.

  ls_log_handle = o_message->get_log_handle( ).
  INSERT ls_log_handle INTO TABLE lt_log_handle.
  lt_msg_handle = o_message->get_msg_handle( ).


  IF g_control_handle IS INITIAL.

    CALL FUNCTION 'BAL_CNTL_CREATE'
      EXPORTING
        i_container          = lo_container
        i_s_display_profile  = ls_profile
        i_t_log_handle       = lt_log_handle
        i_t_msg_handle       = lt_msg_handle
      IMPORTING
        e_control_handle     = g_control_handle
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
        i_control_handle  = g_control_handle
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

ENDFORM.                    " display_message

*&---------------------------------------------------------------------*
*&      Form  get_display_profile
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LS_PROFILE  text
*----------------------------------------------------------------------*
FORM get_display_profile  CHANGING ch_profile TYPE bal_s_prof.


  DATA:
    ls_fcat TYPE bal_s_fcat,
    ls_sort TYPE bal_s_sort.

  FIELD-SYMBOLS:
    <ls_fcat> TYPE bal_s_fcat.


  CALL FUNCTION 'BAL_DSP_PROFILE_POPUP_GET'
    IMPORTING
      e_s_display_profile = ch_profile.

* increase position of all fields
  LOOP AT ch_profile-mess_fcat ASSIGNING <ls_fcat>.
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
  APPEND ls_fcat TO ch_profile-mess_fcat.
* add field as an invisible field
  CLEAR ls_fcat.
  ls_fcat-ref_table = 'LVC_S_BALS'.
  ls_fcat-ref_field = 'ROW_ID'.
  ls_fcat-no_out    = 'X'.
  APPEND ls_fcat TO ch_profile-mess_fcat.
* add field as an invisible field
  CLEAR ls_fcat.
  ls_fcat-ref_table = 'LVC_S_BALS'.
  ls_fcat-ref_field = 'COL_ID'.
  ls_fcat-no_out    = 'X'.
  APPEND ls_fcat TO ch_profile-mess_fcat.
* add field as an invisible field
  CLEAR ls_fcat.
  ls_fcat-ref_table = 'LVC_S_BALS'.
  ls_fcat-ref_field = 'FIELDNAME'.
  ls_fcat-no_out    = 'X'.
  APPEND ls_fcat TO ch_profile-mess_fcat.
* add field as an invisible field
  CLEAR ls_fcat.
  ls_fcat-ref_table = 'LVC_S_BALS'.
  ls_fcat-ref_field = 'SELTEXT'.
  ls_fcat-no_out    = 'X'.
  APPEND ls_fcat TO ch_profile-mess_fcat.
* add field as an invisible field
*  CLEAR ls_fcat.
*  ls_fcat-ref_table = 'LVC_S_BALS'.
*  ls_fcat-ref_field = 'VALUE'.
*  ls_fcat-no_out    = 'X'.
*  APPEND ls_fcat TO ch_profile-mess_fcat.
* add field as an invisible field
  CLEAR ls_fcat.
  ls_fcat-ref_table = 'LVC_S_BALS'.
  ls_fcat-ref_field = 'COL_POS'.
  ls_fcat-no_out      = 'X'.
  APPEND ls_fcat TO ch_profile-mess_fcat.
* add field as an invisible field
  CLEAR ls_fcat.
  ls_fcat-ref_table = 'LVC_S_BALS'.
  ls_fcat-ref_field = 'BALLOGHNDL'.
  ls_fcat-no_out      = 'X'.
  APPEND ls_fcat TO ch_profile-mess_fcat.

* sort by sortfield and fieldname
  CLEAR ch_profile-mess_sort.
  CLEAR ls_sort.
  ls_sort-spos = 1.
  ls_sort-up = 'X'.
  ls_sort-ref_table = 'LVC_S_BALS'.
  ls_sort-ref_field = 'ROW_ID'.
  APPEND ls_sort TO ch_profile-mess_sort.
  CLEAR ls_sort.
  ls_sort-spos = 2.
  ls_sort-up = 'X'.
  ls_sort-ref_table = 'LVC_S_BALS'.
  ls_sort-ref_field = 'COL_POS'.
  APPEND ls_sort TO ch_profile-mess_sort.


* when a message is doubleclicked, we want to position on the field
* which caused the error
* "Doubleclick" is processed as a standard command to show the longtext
* We therefore set the callback routine 'BEFORE UCOMM' to get control
* and execute our own function
  ch_profile-clbk_ucbf-userexitt = space.
  ch_profile-clbk_ucbf-userexitp = 'BCALV_APPL_LOG'.
  ch_profile-clbk_ucbf-userexitf = 'F2'.
  ch_profile-cwidth_opt = 'X'.

*  IF i_display_toolbar IS INITIAL.
*    ch_profile-no_toolbar          = 'X'.
*  ENDIF.



ENDFORM.                    " get_display_profile

*&---------------------------------------------------------------------*
*&      Form  set_message_object
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_message_object .

  IF o_appl_message IS INITIAL.
    o_appl_message = zcl_appl_cntl=>get_appl_message( ).
  ENDIF.

ENDFORM.                    " set_message_object

*&---------------------------------------------------------------------*
*&      Form  clear_protocol
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM clear_protocol .
*  destroy application log control
  CALL FUNCTION 'BAL_CNTL_FREE'
    CHANGING
      c_control_handle  = g_control_handle
    EXCEPTIONS
      control_not_found = 1
      OTHERS            = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CLEAR g_control_handle.

* destroy container
  IF o_custom_container IS BOUND.
    CALL METHOD o_custom_container->free
      EXCEPTIONS
        OTHERS = 1.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    CLEAR o_custom_container.
  ENDIF.

* destroy log
  CALL METHOD o_message->clear.
ENDFORM.                    " clear_protocol
