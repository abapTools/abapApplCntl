CLASS zcl_appl_message_event DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_appl_message_event .
    INTERFACES zif_appl_object .

    METHODS constructor .
  PROTECTED SECTION.
  PRIVATE SECTION.

    ALIASES appl_type
      FOR zif_appl_object~appl_type .
    ALIASES o_appl_message
      FOR zif_appl_object~o_appl_message .
    ALIASES get_appl_type
      FOR zif_appl_object~get_appl_type .
    ALIASES push_button
      FOR zif_appl_message_event~push_button .
    ALIASES set_appl_type
      FOR zif_appl_object~set_appl_type .
    ALIASES pushbutton
      FOR zif_appl_message_event~pushbutton .
ENDCLASS.



CLASS ZCL_APPL_MESSAGE_EVENT IMPLEMENTATION.


  METHOD constructor.


  ENDMETHOD.


  METHOD zif_appl_message_event~push_button.

    RAISE EVENT pushbutton
      EXPORTING ex_state = im_state.

  ENDMETHOD.


  METHOD zif_appl_object~get_appl_type.
    re_type = appl_type.
  ENDMETHOD.


  METHOD zif_appl_object~set_appl_type.
    appl_type = im_type.
  ENDMETHOD.
ENDCLASS.
