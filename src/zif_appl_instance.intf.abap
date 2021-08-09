INTERFACE zif_appl_instance
  PUBLIC .

  INTERFACES: zif_appl_object.


  EVENTS cleared .

  METHODS clear .
  METHODS delete.
  METHODS get_object_key
    EXPORTING
      !ex_object_key TYPE any .
  METHODS lock .
  METHODS reset_read_time .
  METHODS restore .
  METHODS unlock .


ENDINTERFACE.
