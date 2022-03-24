"! <p class="shorttext synchronized" lang="en">DB Object</p>
INTERFACE zif_appl_object_db
  PUBLIC .
  INTERFACES zif_appl_object.

  "! Event saved
  EVENTS data_saved .

  "! this methode clear data by key
  "!
  "! @parameter im_key              | Key fields
  METHODS clear_data
    IMPORTING
      !im_key TYPE any .

  "! this methode read buffer by key
  "!
  "! @parameter im_key              | Key fields
  "! @parameter ex_data             | Read data set
  METHODS read_buffer
    IMPORTING
      !im_key  TYPE any
    EXPORTING
      !ex_data TYPE any .

  "! this methode read data set by key
  "!
  "! @parameter im_key              | Key fields
  "! @parameter im_add_new_line     | if data set does not exist, then new entry
  "! @parameter ex_data             | Read data set
  "! @parameter ex_new              | is new dataset = abap_true
  METHODS read_data
    IMPORTING
      !im_key          TYPE any
      !im_add_new_line TYPE xfeld DEFAULT 'X'
    EXPORTING
      !ex_data         TYPE any
      !ex_new          TYPE xfeld .

  "! this methode save or delete data set
  "!
  "! @parameter im_data     | Data set
  "! @parameter im_delete   | mark Data set for delete
  "! @parameter ex_data     | Data set returning
  METHODS save_data
    IMPORTING
      !im_data   TYPE any
      !im_delete TYPE xfeld OPTIONAL
    EXPORTING
      ex_data    TYPE any.
ENDINTERFACE.
