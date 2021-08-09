class ZCL_APPL_OBJ_TYPES definition
  public
  create public .

public section.

  interfaces ZIF_APPL_OBJECT .
  interfaces ZIF_APPL_OBJ_TYPES .

  aliases APPL_TYPE
    for ZIF_APPL_OBJECT~APPL_TYPE .
  aliases O_APPL_MESSAGE
    for ZIF_APPL_OBJECT~O_APPL_MESSAGE .
  aliases GET_APPL_TYPE
    for ZIF_APPL_OBJECT~GET_APPL_TYPE .
  aliases GET_OBJ_TYPE
    for ZIF_APPL_OBJ_TYPES~GET_OBJ_TYPE .
  aliases GET_OBJ_TYPE_KEY
    for ZIF_APPL_OBJ_TYPES~GET_OBJ_TYPE_KEY .
  aliases SET_APPL_TYPE
    for ZIF_APPL_OBJECT~SET_APPL_TYPE .
  aliases SET_OBJ_TYPE
    for ZIF_APPL_OBJ_TYPES~SET_OBJ_TYPE .

  class-methods CLASS_CONSTRUCTOR .
  methods CONSTRUCTOR .
  PROTECTED SECTION.

    CLASS-DATA o_obj_types_db TYPE REF TO zif_appl_object_db .
private section.
ENDCLASS.



CLASS ZCL_APPL_OBJ_TYPES IMPLEMENTATION.


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
