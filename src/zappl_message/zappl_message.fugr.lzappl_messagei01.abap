*----------------------------------------------------------------------*
***INCLUDE LZAPPL_MESSAGEI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CALL METHOD cl_gui_cfw=>dispatch.

  CASE sy-ucomm.
    WHEN 'CLOSE'.
      FREE o_event_receiver.
      LEAVE TO SCREEN 0.

    WHEN OTHERS.

  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  CALL METHOD cl_gui_cfw=>dispatch.

  CASE sy-ucomm.
    WHEN 'CANC'.
      PERFORM clear_protocol.
      LEAVE TO SCREEN 0.

    WHEN OTHERS.

  ENDCASE.
ENDMODULE.
