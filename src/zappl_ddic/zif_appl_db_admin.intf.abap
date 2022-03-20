"! <p class="shorttext synchronized" lang="en">Appl DB Admin Data</p>
INTERFACE zif_appl_db_admin
  PUBLIC .

"! <p class="shorttext synchronized" lang="en">set admin data by new dataset</p>
  CLASS-METHODS new_data
    IMPORTING
      !im_data       TYPE any
    EXPORTING
      VALUE(ex_data) TYPE any .

     "! <p class="shorttext synchronized" lang="en">set admin data by change dataset</p>
  CLASS-METHODS change_data
    IMPORTING
      !im_data TYPE any
    EXPORTING
      !ex_data TYPE any .

ENDINTERFACE.
