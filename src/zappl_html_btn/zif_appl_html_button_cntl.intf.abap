"! <p class="shorttext synchronized" lang="en">HTML Button Controller</p>
INTERFACE zif_appl_html_button_cntl
  PUBLIC .

  INTERFACES zif_appl_object .

    "! <p class="shorttext synchronized" lang="en">create html-button</p>
  METHODS create_btn
    IMPORTING
      !i_btn           TYPE zappl_html_button
    RETURNING
      VALUE(ro_button) TYPE REF TO zif_appl_html_button .

ENDINTERFACE.
