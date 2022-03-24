CLASS zcl_appl_demo DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_appl_object .
    INTERFACES zif_appl_demo .

    ALIASES appl_type
      FOR zif_appl_object~appl_type .
    ALIASES o_appl_message
      FOR zif_appl_object~o_appl_message .
    ALIASES get_appl_type
      FOR zif_appl_object~get_appl_type .
    ALIASES set_appl_type
      FOR zif_appl_object~set_appl_type .

    ALIASES run
      FOR zif_appl_demo~run.

    METHODS constructor.

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS add_msg_with_msgclass.
    METHODS check_error.
ENDCLASS.



CLASS ZCL_APPL_DEMO IMPLEMENTATION.


  METHOD add_msg_with_msgclass.
    DATA: lo_object    TYPE REF TO object,
          lt_parameter TYPE abap_parmbind_tab,
          lv_obj_name  TYPE sobj_name.
    TRY.
        CREATE OBJECT lo_object
          TYPE
            (lv_obj_name)
          PARAMETER-TABLE
            lt_parameter.
      CATCH cx_sy_create_object_error  INTO DATA(e_txt).
        o_appl_message->add_message(
          EXPORTING
            im_mstyp = o_appl_message->c_error
            im_msgid = 'ZDEMO'
            im_msgno = 001
            im_msgv1 = e_txt->get_text( )
            im_msgv2 = lv_obj_name ).
        IF 1 = 2.
          " for use search
          MESSAGE e001(zdemo).
        ENDIF.
    ENDTRY.
  ENDMETHOD.


  METHOD check_error.
    CHECK o_appl_message->check_error( ) IS INITIAL.
  ENDMETHOD.


  METHOD constructor.
    o_appl_message = zcl_appl_cntl=>get_appl_message( ).
  ENDMETHOD.


  METHOD zif_appl_demo~run.

    add_msg_with_msgclass( ).

    check_error( ).

    o_appl_message->show_messages('M' ).

  ENDMETHOD.


  METHOD zif_appl_object~get_appl_type.
    re_type = appl_type.
  ENDMETHOD.


  METHOD zif_appl_object~set_appl_type.
    appl_type = im_type.
  ENDMETHOD.
ENDCLASS.
