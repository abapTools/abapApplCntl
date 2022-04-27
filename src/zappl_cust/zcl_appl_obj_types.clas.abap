"! <p class="shorttext synchronized" lang="en">Obj Types</p>
CLASS zcl_appl_obj_types DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_appl_object .
    INTERFACES zif_appl_obj_types .

    ALIASES appl_type
      FOR zif_appl_object~appl_type .
    ALIASES o_appl_message
      FOR zif_appl_object~o_appl_message .
    ALIASES get_appl_type
      FOR zif_appl_object~get_appl_type .
    ALIASES get_obj_type
      FOR zif_appl_obj_types~get_obj_type .
    ALIASES get_obj_type_key
      FOR zif_appl_obj_types~get_obj_type_key .
    ALIASES set_appl_type
      FOR zif_appl_object~set_appl_type .
    ALIASES set_obj_type
      FOR zif_appl_obj_types~set_obj_type .

    "! <p class="shorttext synchronized" lang="en">CLASS_CONSTRUCTOR</p>
    CLASS-METHODS class_constructor .
    "! <p class="shorttext synchronized" lang="en">CONSTRUCTOR</p>
    METHODS constructor .
  PROTECTED SECTION.

    "! <p class="shorttext synchronized" lang="en">DB Object</p>
    CLASS-DATA o_obj_types_db TYPE REF TO zif_appl_object_db .
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_appl_obj_types IMPLEMENTATION.


  METHOD class_constructor.

    o_obj_types_db ?= zcl_appl_cntl=>get_single_obj( im_appl_type = 'OBJ_TYPES_DB' ).

  ENDMETHOD.


  METHOD constructor.

    o_appl_message ?= zcl_appl_cntl=>get_appl_message( ).

  ENDMETHOD.


  METHOD zif_appl_object~get_appl_type.
  ENDMETHOD.


  METHOD zif_appl_object~set_appl_type.
  ENDMETHOD.


  METHOD zif_appl_obj_types~get_obj_type.
  ENDMETHOD.


  METHOD zif_appl_obj_types~get_obj_type_key.
  ENDMETHOD.


  METHOD zif_appl_obj_types~set_obj_type.
  ENDMETHOD.
ENDCLASS.
