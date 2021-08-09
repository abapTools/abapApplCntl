*----------------------------------------------------------------------*
***INCLUDE LZAPPL_MESSAGEO01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET TITLEBAR  '0100' WITH sy-datum sy-uzeit.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_0100 OUTPUT.
  IF o_event_receiver IS INITIAL.
    CREATE OBJECT o_event_receiver.
  ENDIF.

***** CREATE CONTAINER FOR SPLITTER IF INITIAL *****
  CALL METHOD o_event_receiver->create_controls
    EXPORTING
      im_container_name = 'MESSAGE_CUSTOM'.

  CALL METHOD o_event_receiver->show_alv
    CHANGING
      it_messages_alv = gt_messages_alv.

  SET CURSOR FIELD 'BTN_EXIT'.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS '0200'.
  SET TITLEBAR  '0200' WITH sy-datum sy-uzeit.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_0200 OUTPUT.
  PERFORM show_message.
ENDMODULE.
