FUNCTION zappl_show_message_popup .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IO_MESSAGE) TYPE REF TO  ZIF_APPL_MESSAGE
*"----------------------------------------------------------------------
  PERFORM set_message_object.

  IF io_message IS INITIAL.
    o_message   = o_appl_message.
  ELSE.
    o_message   = io_message.
  ENDIF.

  CALL SCREEN '0200' STARTING AT 5 5 .

ENDFUNCTION.
