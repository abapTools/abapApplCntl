    "! <p class="shorttext synchronized" lang="en">application object</p>
INTERFACE zif_appl_object
  PUBLIC .

  "! <p class="shorttext synchronized" lang="en">application type</p>
  DATA appl_type TYPE zappl_obj_type .
    "! <p class="shorttext synchronized" lang="en">message object</p>
  DATA o_appl_message TYPE REF TO zif_appl_message.

  "! <p class="shorttext synchronized" lang="en">get application type</p>
  METHODS get_appl_type
    RETURNING
      VALUE(re_type) TYPE zappl_obj_type.

  "! <p class="shorttext synchronized" lang="en">set application type</p>
  METHODS set_appl_type
    IMPORTING
      !im_type TYPE zappl_obj_type .

ENDINTERFACE.
