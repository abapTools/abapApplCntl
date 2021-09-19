CLASS zcl_appl_html_button_cntl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_appl_html_button_cntl .

    ALIASES appl_type
      FOR zif_appl_object~appl_type .
    ALIASES o_appl_message
      FOR zif_appl_object~o_appl_message .
    ALIASES create_btn
      FOR zif_appl_html_button_cntl~create_btn .
    ALIASES get_appl_type
      FOR zif_appl_object~get_appl_type .
    ALIASES set_appl_type
      FOR zif_appl_object~set_appl_type .

    METHODS constructor .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA t_pointer TYPE zappl_html_btn_pointer_tt .

    METHODS get_obj_btn
      IMPORTING
        !i_btn           TYPE zappl_html_button
      RETURNING
        VALUE(ro_button) TYPE REF TO zif_appl_html_button .
ENDCLASS.



CLASS ZCL_APPL_HTML_BUTTON_CNTL IMPLEMENTATION.


  METHOD constructor.

    o_appl_message = zcl_appl_cntl=>get_appl_message( ).

  ENDMETHOD.


  METHOD get_obj_btn.

    DATA: lo_button  TYPE REF TO zif_appl_html_button,
          lo_object  TYPE REF TO zif_appl_object,
          ls_btn     TYPE zappl_html_button,
          lt_param   TYPE abap_parmbind_tab,
          ls_param   TYPE abap_parmbind,
          ls_pointer TYPE zappl_html_btn_pointer,
          lv_index   TYPE sytabix.

    ls_btn = i_btn.

    IF ls_btn-guid IS INITIAL.
      TRY.
          ls_btn-guid = zcl_appl_services=>get_new_guid( ).
        CATCH cx_uuid_error INTO DATA(e_txt).
      ENDTRY.
    ELSE.
      READ TABLE t_pointer INTO ls_pointer WITH KEY guid = ls_btn-guid.
      IF sy-subrc EQ 0.
        ro_button = ls_pointer-object.
        EXIT.
      ENDIF.
    ENDIF.

    " Prepare parameter table
    ls_param-name = 'I_BTN'.
    ls_param-kind = cl_abap_objectdescr=>exporting.
    GET REFERENCE OF ls_btn INTO ls_param-value.
    INSERT ls_param INTO TABLE lt_param.

    TRY.
        CALL METHOD zcl_appl_cntl=>create_object
          EXPORTING
            im_obj_type  = 'APPL_HTML_BTN'
            it_parameter = lt_param
          IMPORTING
            ex_object    = lo_object.
      CATCH cx_sy_create_object_error.
        EXIT.
    ENDTRY.

    READ TABLE t_pointer ASSIGNING FIELD-SYMBOL(<pointer>)
      WITH KEY guid = ls_btn-guid.
    IF sy-subrc <> 0.
      lv_index = sy-tabix.
      IF lv_index EQ 0.
        lv_index = 1.
      ENDIF.
      ls_pointer-guid   = ls_btn-guid.
      ls_pointer-object ?= lo_object.
      INSERT ls_pointer INTO t_pointer INDEX lv_index.
    ENDIF.

    ro_button = ls_pointer-object.
  ENDMETHOD.


  METHOD zif_appl_html_button_cntl~create_btn.
    ro_button = get_obj_btn( i_btn ).
  ENDMETHOD.


  METHOD zif_appl_object~get_appl_type.
    re_type = appl_type.
  ENDMETHOD.


  METHOD zif_appl_object~set_appl_type.
    appl_type = im_type.
  ENDMETHOD.
ENDCLASS.
