"! <p class="shorttext synchronized" lang="en">Application Message Event</p>
INTERFACE zif_appl_message_event
  PUBLIC .


  INTERFACES zif_appl_object .

  ALIASES appl_type
    FOR zif_appl_object~appl_type .
  ALIASES o_appl_message
    FOR zif_appl_object~o_appl_message .
  ALIASES get_appl_type
    FOR zif_appl_object~get_appl_type .
  ALIASES set_appl_type
    FOR zif_appl_object~set_appl_type .

  "! <p class="shorttext synchronized" lang="en">Push button event</p>
  EVENTS pushbutton
    EXPORTING
      VALUE(ex_state) TYPE bal_s_cbuc .

  "! <p class="shorttext synchronized" lang="en">Push button</p>
  METHODS push_button
    IMPORTING
      !im_state TYPE bal_s_cbuc .

ENDINTERFACE.
