INTERFACE zif_appl_db_admin
  PUBLIC .


  CLASS-METHODS new_data
    IMPORTING
      !im_data       TYPE any
    EXPORTING
      VALUE(ex_data) TYPE any .
  CLASS-METHODS change_data
    IMPORTING
      !im_data TYPE any
    EXPORTING
      !ex_data TYPE any .
ENDINTERFACE.
