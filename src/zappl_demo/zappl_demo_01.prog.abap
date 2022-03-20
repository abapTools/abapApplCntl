*&---------------------------------------------------------------------*
*& Report ZAPPL_DEMO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zappl_demo_01.

DATA: lo_demo         TYPE REF TO zif_appl_demo,
      lo_appl_message TYPE REF TO zif_appl_message.

INITIALIZATION.

  lo_appl_message = zcl_appl_cntl=>get_appl_message( ).

  TRY.
      lo_demo  ?= zcl_appl_cntl=>get_single_obj( 'DEMO_APPL' ).
    CATCH cx_sy_create_object_error  INTO DATA(e_txt).
      lo_appl_message->add_message(
        EXPORTING
          im_mstyp = lo_appl_message->c_error
          im_msgid = 'ZDEMO'
          im_msgno = 001
          im_msgv1 = e_txt->get_text( )
          im_msgv2 = 'DEMO_APPL' ).
      IF 1 = 2.
        " for use search
        MESSAGE e001(zdemo).
      ENDIF.
  ENDTRY.

START-OF-SELECTION.

  IF lo_appl_message->check_error( 'E' ) IS NOT INITIAL.
    lo_appl_message->show_messages( 'M' ).
    EXIT.
  ENDIF.

  lo_appl_message->add_message(
    EXPORTING
      im_mstyp = 'I'
      im_msgid = 'ZDEMO'
      im_msgno = 002 ).
  IF 1 = 2.
    " for use search
    MESSAGE i002(zdemo).
  ENDIF.

  lo_demo->run( ).
