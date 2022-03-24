*&---------------------------------------------------------------------*
*& Report ZAPPL_DEMO_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zappl_demo_02.

DATA o_appl_message TYPE REF TO zif_appl_message.
DATA error TYPE xfeld.

o_appl_message ?= zcl_appl_cntl=>get_appl_message( ).

IF 1 = 2.

ENDIF.
*----------------------------------------------------------------------*
PERFORM add_messages.
*----------------------------------------------------------------------*
error = o_appl_message->check_error( ).
o_appl_message->show_messages(
  EXPORTING
    im_mode = 'M' ).

error = o_appl_message->check_error( ).


IF 1 = 2.

ENDIF.

*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
FORM add_messages.

  o_appl_message->add_message(
    EXPORTING
      im_mstyp = 'S'
      im_msgid = 'ZAPPL_MESSAGE'
      im_msgno = 001 ).
  IF 1 = 2.
    MESSAGE s001(zappl_message).
* This is a success message.
  ENDIF.
*----------------------------------------------------------------------*
  o_appl_message->add_message(
    EXPORTING
      im_mstyp = 'W'
      im_msgid = 'ZAPPL_MESSAGE'
      im_msgno = 002 ).
  IF 1 = 2.
    MESSAGE s002(zappl_message).
* This is a warning message.
  ENDIF.
*----------------------------------------------------------------------*
  o_appl_message->add_message(
    EXPORTING
      im_mstyp = 'E'
      im_msgid = 'ZAPPL_MESSAGE'
      im_msgno = 003 ).
  IF 1 = 2.
    MESSAGE s003(zappl_message).
* This is a error message.
  ENDIF.
*----------------------------------------------------------------------*
  o_appl_message->add_message(
    EXPORTING
      im_mstyp = 'I'
      im_msgid = 'ZAPPL_MESSAGE'
      im_msgno = 004 ).
  IF 1 = 2.
    MESSAGE s004(zappl_message).
* This is a info message.
  ENDIF.
*----------------------------------------------------------------------*
  o_appl_message->add_message(
    EXPORTING
      im_mstyp = 'A'
      im_msgid = 'ZAPPL_MESSAGE'
      im_msgno = 005 ).
  IF 1 = 2.
    MESSAGE s005(zappl_message).
* This is a abort message.
  ENDIF.

ENDFORM.
