FUNCTION zappl_show_message_ucomm.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  CHANGING
*"     REFERENCE(C_S_USER_COMMAND_DATA) TYPE  BAL_S_CBUC
*"----------------------------------------------------------------------

  DATA: lo_event  TYPE REF TO zif_appl_message_event,
        lo_object TYPE REF TO zif_appl_object.


  lo_object = zcl_appl_cntl=>get_single_obj( 'APPL_MESSAGE_EVENT' ).
  lo_event ?= lo_object.

  CALL METHOD lo_event->push_button( c_s_user_command_data ).



ENDFUNCTION.
