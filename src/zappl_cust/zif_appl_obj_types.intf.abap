"! <p class="shorttext synchronized" lang="en">Object Types</p>
INTERFACE zif_appl_obj_types
  PUBLIC .

  INTERFACES zif_appl_object .

  METHODS get_obj_type
    IMPORTING
      !im_obj_types_key TYPE zappl_obj_types_key .
  METHODS set_obj_type .
  METHODS get_obj_type_key
    EXPORTING
      !re_key TYPE zappl_obj_types_key .
ENDINTERFACE.
