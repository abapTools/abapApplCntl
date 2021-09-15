INTERFACE zif_appl_object_db
  PUBLIC .
  INTERFACES zif_appl_object.

  EVENTS data_saved .

  METHODS clear_data
    IMPORTING
      !im_key TYPE any .
  METHODS read_buffer
    IMPORTING
      !im_key  TYPE any
    EXPORTING
      !ex_data TYPE any .
  METHODS read_data
    IMPORTING
      !im_key          TYPE any
      !im_add_new_line TYPE xfeld DEFAULT 'X'
    EXPORTING
      !ex_data         TYPE any
      !ex_new          TYPE xfeld .
  METHODS save_data
    IMPORTING
      !im_data   TYPE any
      !im_delete TYPE xfeld OPTIONAL
    EXPORTING
      ex_data    TYPE any.
ENDINTERFACE.
