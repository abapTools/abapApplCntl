CLASS zcl_appl_message DEFINITION
  PUBLIC
  CREATE PUBLIC .



  PUBLIC SECTION.

    INTERFACES zif_appl_message.
    INTERFACES zif_appl_object.


    ALIASES appl_type
      FOR zif_appl_object~appl_type .
    ALIASES error_flag
      FOR zif_appl_message~error_flag .
    ALIASES o_appl_message
      FOR zif_appl_object~o_appl_message .
    ALIASES add_message
      FOR zif_appl_message~add_message .
    ALIASES add_message2
      FOR zif_appl_message~add_message2 .
    ALIASES add_messtab
      FOR zif_appl_message~add_messtab .
    ALIASES check_error
      FOR zif_appl_message~check_error .
    ALIASES clear
      FOR zif_appl_message~clear .
    ALIASES get_appl_type
      FOR zif_appl_object~get_appl_type .
    ALIASES get_show_message_obj
      FOR zif_appl_message~get_show_message_obj .
    ALIASES set_appl_type
      FOR zif_appl_object~set_appl_type .
    ALIASES show_messages
      FOR zif_appl_message~show_messages .

    DATA t_messages TYPE bapiret2_t .

    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    METHODS constructor .

  PROTECTED SECTION.


    ALIASES not_error_mtype
      FOR zif_appl_MESSAGE~not_error_mtype .
    ALIASES save_log
      FOR zif_appl_MESSAGE~save_log .
    ALIASES set_not_error_mtype
      FOR zif_appl_MESSAGE~set_not_error_mtype .

    DATA log_handle TYPE balloghndl .
    DATA o_show_message TYPE REF TO zif_appl_SHOW_MESSAGE.
    DATA t_msg_handle TYPE bal_t_msgh .

    METHODS add_to_protocol
      IMPORTING
        !im_msg TYPE bal_s_msg .
    METHODS catch_errorflag .
    METHODS on_display_finished
        FOR EVENT display_finished OF zif_appl_SHOW_MESSAGE .
    METHODS set_errorflag
      IMPORTING
        !im_errorflag TYPE bapi_mtype .
    METHODS set_log_handle .
    METHODS set_obj_show .

  PRIVATE SECTION.

    ALIASES co_abort
      FOR zif_appl_MESSAGE~co_abort .
    ALIASES co_error
      FOR zif_appl_MESSAGE~co_error .
    ALIASES co_infor
      FOR zif_appl_MESSAGE~co_infor .
    ALIASES co_succe
      FOR zif_appl_MESSAGE~co_succe .
    ALIASES co_warng
      FOR zif_appl_MESSAGE~co_warng .
    ALIASES get_log_handle
      FOR zif_appl_MESSAGE~get_log_handle .
    ALIASES get_messages
      FOR zif_appl_MESSAGE~get_messages .
    ALIASES get_msg_handle
      FOR zif_appl_MESSAGE~get_msg_handle .

ENDCLASS.



CLASS ZCL_APPL_MESSAGE IMPLEMENTATION.


  METHOD add_to_protocol.
    DATA: ls_msg_handle   TYPE balmsghndl.

    CALL METHOD set_log_handle.

* add message to log
    CALL FUNCTION 'BAL_LOG_MSG_ADD'
      EXPORTING
        i_log_handle   = log_handle
        i_s_msg        = im_msg
      IMPORTING
        e_s_msg_handle = ls_msg_handle
      EXCEPTIONS
        OTHERS         = 1.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ELSE.
      INSERT ls_msg_handle INTO TABLE t_msg_handle.
    ENDIF.
  ENDMETHOD.


  METHOD catch_errorflag.
    FIELD-SYMBOLS: <message>   TYPE bapiret2.

    error_flag = co_succe.

    LOOP AT t_messages  ASSIGNING <message>.

      CALL METHOD set_errorflag( <message>-type ).

    ENDLOOP.
  ENDMETHOD.


  METHOD constructor.
    CALL METHOD clear.

    not_error_mtype = co_infor.
  ENDMETHOD.


  METHOD on_display_finished.
    CALL METHOD clear.
  ENDMETHOD.


  METHOD set_errorflag.

    CASE im_errorflag.
      WHEN co_abort.
        error_flag = co_abort.

      WHEN co_error.
        IF error_flag <> co_abort.
          error_flag = co_error.
        ENDIF.

      WHEN co_warng.
        IF error_flag = co_infor OR error_flag = co_succe.
          error_flag = co_warng.
        ENDIF.

      WHEN co_infor.
        IF error_flag = co_succe.
          error_flag = co_infor.
        ENDIF.

      WHEN co_succe.


    ENDCASE.
  ENDMETHOD.


  METHOD set_log_handle.
    DATA: ls_log          TYPE bal_s_log.

    IF log_handle IS INITIAL.
      CALL FUNCTION 'BAL_LOG_CREATE'
        EXPORTING
          i_s_log                 = ls_log
        IMPORTING
          e_log_handle            = log_handle
        EXCEPTIONS
          log_header_inconsistent = 1
          OTHERS                  = 2.

      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

    ENDIF.
  ENDMETHOD.


  METHOD set_obj_show.
    DATA: lo_object   TYPE REF TO zif_appl_object.

    IF o_show_message IS INITIAL.
      TRY.
          CALL METHOD zcl_appl_cntl=>create_object
            EXPORTING
              im_obj_type = 'APPL_MESSAGE_SHOW'
            IMPORTING
              ex_object   = lo_object.

        CATCH cx_sy_create_object_error.
          CALL METHOD o_appl_message->add_message
            EXPORTING
              im_mstyp = o_appl_message->co_abort
              im_msgid = 'ZAPPL'
              im_msgno = 41
              im_msgv1 = 'APPL_MESSAGE_SHOW'.
          IF 1 = 2.
            MESSAGE a041(zappl) WITH 'APPL_MESSAGE_SHOW' .
            " Event &1 already exists.
          ENDIF.
      ENDTRY.
      o_show_message ?= lo_object.
      SET HANDLER on_display_finished FOR o_show_message.
    ENDIF.
  ENDMETHOD.


  METHOD zif_appl_message~add_message.
    DATA: l_msg   TYPE bapiret2,
          l_msgv1 TYPE symsgv,
          l_msgv2 TYPE symsgv,
          l_msgv3 TYPE symsgv,
          l_msgv4 TYPE symsgv.

    CHECK im_mstyp IS NOT INITIAL AND
          im_msgid IS NOT INITIAL.


    CALL METHOD set_errorflag( im_mstyp ).

    l_msgv1 = im_msgv1.
    l_msgv2 = im_msgv2.
    l_msgv3 = im_msgv3.
    l_msgv4 = im_msgv4.


    CALL FUNCTION 'BALW_BAPIRETURN_GET2'
      EXPORTING
        type       = im_mstyp
        cl         = im_msgid
        number     = im_msgno
        par1       = l_msgv1
        par2       = l_msgv2
        par3       = l_msgv3
        par4       = l_msgv4
        log_no     = im_log_no
        log_msg_no = im_log_msg_no
        parameter  = im_parameter
        row        = im_row
        field      = im_field
      IMPORTING
        return     = l_msg.


    APPEND l_msg TO t_messages.

    DELETE ADJACENT DUPLICATES FROM t_messages.     " COMPARING message.
    CHECK sy-subrc <> 0.

********************************************************************

    DATA: ls_msg          TYPE bal_s_msg.

* fill basic message data
    ls_msg-msgty = im_mstyp.
    ls_msg-msgid = im_msgid.
    ls_msg-msgno = im_msgno.
    ls_msg-msgv1 = im_msgv1.
    ls_msg-msgv2 = im_msgv2.
    ls_msg-msgv3 = im_msgv3.
    ls_msg-msgv4 = im_msgv4.

    CALL METHOD add_to_protocol( ls_msg ).

  ENDMETHOD.


  METHOD zif_appl_message~add_message2.
    CHECK NOT is_return IS INITIAL.

    CALL METHOD add_message
      EXPORTING
        im_mstyp      = is_return-type
        im_msgid      = is_return-id
        im_msgno      = is_return-number
        im_msgv1      = is_return-message_v1
        im_msgv2      = is_return-message_v2
        im_msgv3      = is_return-message_v3
        im_msgv4      = is_return-message_v4
        im_field      = is_return-field
        im_log_no     = is_return-log_no
        im_log_msg_no = is_return-log_msg_no
        im_parameter  = is_return-parameter
        im_row        = is_return-row.
  ENDMETHOD.


  METHOD zif_appl_message~add_messtab.
    DATA: lt_messages TYPE bapiret2_t,
          ls_message  TYPE bapiret2.

    IF NOT im_err_obj IS INITIAL.
      lt_messages = im_err_obj->get_messages( ).
      CALL METHOD im_err_obj->clear.
    ENDIF.

    APPEND LINES OF it_messages TO lt_messages.


    LOOP AT lt_messages INTO ls_message.

      CALL METHOD add_message2( ls_message ).

    ENDLOOP.
  ENDMETHOD.


  METHOD zif_appl_message~check_error.
    DATA: lv_mtype    TYPE bapi_mtype.

    re_return = 'X'.


    IF im_errorflag IS SUPPLIED.
      lv_mtype = im_errorflag.
    ELSE.
      lv_mtype = not_error_mtype.
    ENDIF.


    CASE lv_mtype.
      WHEN co_abort.
        CLEAR re_return.

      WHEN co_error.
        IF error_flag <> co_abort.
          CLEAR re_return.
        ENDIF.

      WHEN co_warng.
        IF error_flag = co_infor OR error_flag = co_succe OR error_flag = co_warng.
          CLEAR re_return.
        ENDIF.

      WHEN co_infor.
        IF error_flag = co_succe OR error_flag = co_infor.
          CLEAR re_return.
        ENDIF.

      WHEN co_succe.
        IF error_flag = co_succe.
          CLEAR re_return.
        ENDIF.

    ENDCASE.
  ENDMETHOD.


  METHOD zif_appl_message~clear.
    REFRESH: t_messages, t_msg_handle.

    error_flag      = co_succe.

*  not_error_mtype = co_infor.

    CHECK NOT log_handle IS INITIAL.

    CALL FUNCTION 'BAL_LOG_MSG_DELETE_ALL'
      EXPORTING
        i_log_handle  = log_handle
      EXCEPTIONS
        log_not_found = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.


  METHOD zif_appl_message~get_log_handle.
    CALL METHOD set_log_handle.

    re_log_handle = log_handle.
  ENDMETHOD.


  METHOD zif_appl_message~get_messages.
    re_t_messages = t_messages.
  ENDMETHOD.


  METHOD zif_appl_message~get_msg_handle.
    re_t_msg_handle = t_msg_handle.
  ENDMETHOD.


  METHOD zif_appl_message~get_show_message_obj.
    ro_show_message = o_show_message.
  ENDMETHOD.


  METHOD zif_appl_message~save_log.
    DATA: lt_log_handle TYPE bal_t_logh.

    IF iv_save_all IS INITIAL.
      IF log_handle IS NOT INITIAL.
        APPEND log_handle TO lt_log_handle.
      ENDIF.
    ENDIF.

    CALL FUNCTION 'BAL_DB_SAVE'
      EXPORTING
        i_save_all       = iv_save_all
        i_t_log_handle   = lt_log_handle
      EXCEPTIONS
        log_not_found    = 1
        save_not_allowed = 2
        numbering_error  = 3
        OTHERS           = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.


  METHOD zif_appl_message~set_not_error_mtype.
    CHECK im_mtype IS NOT INITIAL.

    not_error_mtype = im_mtype.
  ENDMETHOD.


  METHOD zif_appl_message~show_messages.
    DATA: l_lines          TYPE i,
          ls_message       TYPE bapiret2,
          l_mode           TYPE zappl_message_show_type,
          lv_gui_available TYPE xfeld.

    CHECK NOT t_messages IS INITIAL.

* check if there is a GUI
    CALL FUNCTION 'GUI_IS_AVAILABLE'
      IMPORTING
        return = lv_gui_available.
    IF lv_gui_available IS INITIAL.
*   GUI is not available, write the messages to the application log
      CALL METHOD save_log.
      EXIT.
    ENDIF.

* If GUI is available, then display the messages
    CHECK lv_gui_available IS NOT INITIAL.

    DESCRIBE TABLE t_messages LINES l_lines.

    IF l_lines = 1 AND im_force_table <> 'X' AND check_error( co_warng ) IS INITIAL.
      READ TABLE t_messages INTO ls_message INDEX 1.
*   Clear must happen BEFORE the MESSAGE instruction, as no subsequent instruction is achieved.
      CALL METHOD clear.
      MESSAGE ID ls_message-id TYPE 'S' NUMBER ls_message-number
              WITH ls_message-message_v1 ls_message-message_v2
                   ls_message-message_v3 ls_message-message_v4
              DISPLAY LIKE ls_message-type.
*   This position is no longer reached after MESSAGE.
      EXIT.
    ENDIF.


    CALL METHOD set_obj_show.

    IF im_mode IS INITIAL.

      l_mode = zcl_appl_constants=>message_show_typ.

      IF l_mode IS INITIAL.
        l_mode = 'M'.
      ENDIF.

    ELSE.
      l_mode = im_mode.
    ENDIF.

    CASE l_mode.
      WHEN 'T'.
        CALL METHOD o_show_message->display_docking( me ).

      WHEN 'M'.
        CALL METHOD o_show_message->display_modal( me ).

      WHEN 'D'.
        CALL METHOD o_show_message->display_modeless( me ).

      WHEN OTHERS.

    ENDCASE.

  ENDMETHOD.


  METHOD zif_appl_object~get_appl_type.

  ENDMETHOD.


  METHOD zif_appl_object~set_appl_type.

    appl_type = im_type.

  ENDMETHOD.
ENDCLASS.
