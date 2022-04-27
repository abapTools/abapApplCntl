FUNCTION zappl_show_message_modal.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_MESSAGES_ALV) TYPE  ZAPPL_MESSAGE_ALV_T
*"----------------------------------------------------------------------


  gt_messages_alv = it_messages_alv.

  PERFORM set_message_object.

  CALL SCREEN '0100' STARTING AT 5 5 .


ENDFUNCTION.
