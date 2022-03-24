"! <p class="shorttext synchronized" lang="en">HTML Button</p>
INTERFACE zif_appl_html_button
  PUBLIC .


  INTERFACES zif_appl_object .

  "! <p class="shorttext synchronized" lang="en">set button function inactive</p>
  METHODS set_inactive .

  "! <p class="shorttext synchronized" lang="en">set button function active</p>
  METHODS set_active .

  "! <p class="shorttext synchronized" lang="en">get fields of button</p>
  METHODS get_btn_fields
    RETURNING
      VALUE(re_btn_fields) TYPE zappl_html_button .

  "! <p class="shorttext synchronized" lang="en">get type of button</p>
  METHODS get_btn_type
    RETURNING
      VALUE(re_btn_type) TYPE zappl_html_btn_type .

ENDINTERFACE.
