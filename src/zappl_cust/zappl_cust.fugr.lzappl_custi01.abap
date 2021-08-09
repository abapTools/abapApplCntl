*----------------------------------------------------------------------*
***INCLUDE LZAPPL_CUSTI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  DATA: return_code TYPE i.


  CALL METHOD cl_gui_cfw=>dispatch
    IMPORTING
      return_code = return_code.
  IF return_code <> cl_gui_cfw=>rc_noevent.
    " a control event occured => exit PAI
    CLEAR g_ok_code.
    EXIT.
  ENDIF.

  CASE g_ok_code.
    WHEN 'BACK'. " Finish program
      IF NOT o_tree_cust_cont IS INITIAL.
        " destroy tree container (detroys contained tree control, too)
        CALL METHOD o_tree_cust_cont->free
          EXCEPTIONS
            cntl_system_error = 1
            cntl_error        = 2.
        IF sy-subrc <> 0.
          o_appl_message->add_message(
            EXPORTING
              im_mstyp = 'A'
              im_msgid = 'TREE_CONTROL_MSG'
              im_msgno = 000 ).
        ENDIF.
        CLEAR o_tree_cust_cont.
        CLEAR o_tree.
      ENDIF.
      LEAVE PROGRAM.
  ENDCASE.

* CAUTION: clear ok code!
  CLEAR g_ok_code.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0110 INPUT.

ENDMODULE.
