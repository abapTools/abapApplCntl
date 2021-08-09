INTERFACE zif_appl_object
  PUBLIC .
  DATA appl_type TYPE zappl_obj_type .
  DATA o_appl_message TYPE REF TO zif_appl_message.

  METHODS get_appl_type
    RETURNING
      VALUE(re_type) TYPE zappl_obj_type.
  METHODS set_appl_type
    IMPORTING
      !im_type TYPE zappl_obj_type .
ENDINTERFACE.
