CLASS zcl_appl_cntl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPE-POOLS abap .

    CLASS-DATA update_flag TYPE xfeld READ-ONLY .
    CLASS-DATA ready_for_input TYPE xfeld READ-ONLY .

    CLASS-EVENTS before_save .
    CLASS-EVENTS buffer_backup .
    CLASS-EVENTS buffer_refresh
      EXPORTING
        VALUE(im_all_objects) TYPE xfeld .
    CLASS-EVENTS buffer_restore .
    CLASS-EVENTS buffer_save .
    CLASS-EVENTS distribute .
    CLASS-EVENTS exit .
    CLASS-EVENTS rollback .
    CLASS-EVENTS save .

    CLASS-METHODS class_constructor .
    CLASS-METHODS create_object
      IMPORTING
        !im_obj_type     TYPE zappl_obj_type
        !it_parameter    TYPE abap_parmbind_tab OPTIONAL
        !im_obj_register TYPE xfeld DEFAULT 'X'
      EXPORTING
        !ex_object       TYPE REF TO zif_appl_object .
    CLASS-METHODS get_appl_message
      RETURNING
        VALUE(re_obj_message) TYPE REF TO zif_appl_message .
    CLASS-METHODS get_field_catalog
      IMPORTING
        !im_layout_name    TYPE lvc_tname
      RETURNING
        VALUE(re_tab_fcat) TYPE zappl_lvc_fcat_tt .
    CLASS-METHODS get_global_parameter
      IMPORTING
        VALUE(im_name) TYPE fieldname
      RETURNING
        VALUE(result)  TYPE string
      RAISING
        zcx_appl_glb_par .
    CLASS-METHODS get_single_obj
      IMPORTING
        !im_appl_type    TYPE zappl_obj_type
      RETURNING
        VALUE(re_object) TYPE REF TO zif_appl_object .
    CLASS-METHODS save_all .
    CLASS-METHODS commit_work
      IMPORTING
        !im_wait TYPE xfeld DEFAULT 'X' .
    CLASS-METHODS refresh_buffer
      IMPORTING
        !im_all_objects TYPE xfeld DEFAULT space .
    CLASS-METHODS restore_buffer .
    CLASS-METHODS save_buffer .
    CLASS-METHODS get_update_flag
      RETURNING
        VALUE(rm_flag) TYPE xfeld .
    CLASS-METHODS set_update_flag
      IMPORTING
        VALUE(im_flag) TYPE xfeld DEFAULT abap_true .
    CLASS-METHODS change_input .
  PROTECTED SECTION.

  PRIVATE SECTION.

    CLASS-DATA o_appl_message TYPE REF TO zif_appl_message .
    CLASS-DATA t_appl_types TYPE zappl_obj_types_tt .
    CLASS-DATA t_single_obj TYPE zappl_object_pointer_tt .
    CLASS-DATA flg_post_on TYPE xfeld .
    CLASS-DATA flg_refresh_on TYPE xfeld .
    CLASS-DATA flg_restore_on TYPE xfeld .

    CLASS-METHODS set_objects_cntl .
    CLASS-METHODS reset_handler .
    CLASS-METHODS set_handler .
ENDCLASS.



CLASS ZCL_APPL_CNTL IMPLEMENTATION.


  METHOD change_input.

    CASE  ready_for_input.
      WHEN abap_true.
        ready_for_input = abap_false.
      WHEN abap_false.
        ready_for_input = abap_true.
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.


  METHOD class_constructor.


* Buffer dynamic class table
    SELECT * FROM zappl_obj_types INTO TABLE t_appl_types ORDER BY type.

* Create global message object
    o_appl_message = get_appl_message( ).

    CALL METHOD set_handler.
  ENDMETHOD.


  METHOD commit_work.

*In a programme executed via batch input or
*if the programme was called with the USING addition to the CALL TRANSACTION statement.
*COMMIT WORK terminates the batch input processing.
*Therefore, do not start COMMIT WORK by batch

    CHECK sy-binpt <> 'X' AND       "Batch-Input
      sy-oncom <> 'P' AND       "PERFORM ... ON COMMIT
      sy-oncom <> 'V' AND       "CALL FUNCTION ... IN UPDATE TASK
      sy-oncom <> 'E'.

    IF im_wait IS INITIAL.
      COMMIT WORK.
    ELSE.
      COMMIT WORK AND WAIT.
    ENDIF.
  ENDMETHOD.


  METHOD create_object.

    DATA: lo_object    TYPE REF TO zif_appl_object,
          ls_appl      TYPE zappl_obj_types,
          ls_object    TYPE zappl_object_pointer,
          lt_parameter TYPE abap_parmbind_tab,
          lv_index     TYPE sytabix.

    CALL METHOD set_handler.

    READ TABLE t_appl_types INTO ls_appl
        WITH KEY  type  = im_obj_type.

    IF ls_appl-class IS INITIAL.
      EXIT.
    ENDIF.

    TRY.
        " Due to return transport on 4.7
        lt_parameter = it_parameter.

        CREATE OBJECT lo_object
          TYPE
            (ls_appl-class)
          PARAMETER-TABLE
            lt_parameter.
      CATCH cx_sy_create_object_error.
    ENDTRY.

    IF lo_object IS BOUND.

      CALL METHOD lo_object->set_appl_type( im_obj_type ).
      lo_object->o_appl_message = o_appl_message.

      " Register Singleton Objects
      IF ls_appl-single = 'X' AND im_obj_register = 'X'.
        READ TABLE t_single_obj INTO ls_object
            WITH KEY  appl_type = im_obj_type BINARY SEARCH.
        IF sy-subrc <> 0.
          lv_index            = sy-tabix.
          ls_object-appl_type = im_obj_type.
          ls_object-object    = lo_object.
          INSERT ls_object INTO t_single_obj INDEX lv_index.
        ENDIF.
      ENDIF.

      ex_object = lo_object.

    ELSE.
      CLEAR ex_object.
    ENDIF.

  ENDMETHOD.


  METHOD get_appl_message.

    DATA: lo_object  TYPE REF TO zif_appl_object.

    IF o_appl_message IS INITIAL.
      CALL METHOD create_object
        EXPORTING
          im_obj_type = 'APPL_MESSAGE'
        IMPORTING
          ex_object   = lo_object.

      o_appl_message ?= lo_object.
    ENDIF.

    re_obj_message = o_appl_message.

  ENDMETHOD.


  METHOD get_field_catalog.

    FIELD-SYMBOLS: <fcat>    TYPE zappl_lvc_fcat.


* Determine field catalogue
    SELECT *  FROM zappl_lvcfc
            INTO CORRESPONDING FIELDS OF TABLE re_tab_fcat
      WHERE layout_name = im_layout_name
        AND active      = 'X'.

    LOOP AT re_tab_fcat ASSIGNING <fcat>.
      SELECT SINGLE *  FROM zappl_lvcft       "#EC CI_ALL_FIELDS_NEEDED
              INTO CORRESPONDING FIELDS OF <fcat>
        WHERE layout_name = <fcat>-layout_name
          AND fieldname   = <fcat>-fieldname
          AND langu       = sy-langu.
    ENDLOOP.

    SORT re_tab_fcat BY col_pos.

  ENDMETHOD.


  METHOD get_global_parameter.
*
*  DATA: ls_parameter_val    TYPE zappl_glprv,
*        ls_parameter_def    TYPE zappl_lprd.
*
** Für Transaktionsave regestrieren
*  CALL METHOD set_handler.
*
*  READ TABLE t_parameter_val INTO ls_parameter_val WITH KEY param_name = im_name.
*  IF sy-subrc = 0.
*    result = ls_parameter_val-param_value.
*  ELSE.
*    CLEAR result.
*    IF t_parameter_def IS INITIAL.
*      SELECT * FROM zappl_glprd INTO TABLE t_parameter_def.
*    ENDIF.
*    READ TABLE t_parameter_def INTO ls_parameter_def WITH KEY param_name = im_name.
*    IF sy-subrc <> 0.
*      CALL METHOD o_appl_message->add_message
*        EXPORTING
*          im_mstyp = 'E'
*          im_msgid = 'ZAPPL'
*          im_msgno = 27
*          im_msgv1 = im_name.
*
*      RAISE EXCEPTION TYPE zcx_appl_glb_par
*        EXPORTING
*          textid = zcx_appl_glb_par=>parameter_name_not_exist
*          table_name = 'ZAPPL_GLPRD'.
*
*    ENDIF.
*  ENDIF.

  ENDMETHOD.


  METHOD get_single_obj.

    DATA: lo_object TYPE REF TO zif_appl_object,
          ls_obj    TYPE zappl_object_pointer.


    READ TABLE t_single_obj INTO ls_obj
        WITH KEY appl_type  = im_appl_type BINARY SEARCH.

    IF sy-subrc <> 0.
      CALL METHOD create_object
        EXPORTING
          im_obj_type = im_appl_type
        IMPORTING
          ex_object   = lo_object.

      READ TABLE t_single_obj INTO ls_obj
          WITH KEY appl_type = im_appl_type BINARY SEARCH.
    ENDIF.

    re_object = ls_obj-object.

  ENDMETHOD.


  METHOD get_update_flag.
    rm_flag = update_flag.
  ENDMETHOD.


  METHOD refresh_buffer.

    CHECK flg_refresh_on IS INITIAL.

    CALL METHOD set_objects_cntl.

    flg_refresh_on = 'X'.

    RAISE EVENT buffer_refresh
      EXPORTING im_all_objects = im_all_objects.


*  CALL METHOD o_lock_cntl->unlock_all.

    CLEAR flg_refresh_on.
  ENDMETHOD.


  METHOD reset_handler.



  ENDMETHOD.


  METHOD restore_buffer.

    CHECK flg_restore_on IS INITIAL.

    flg_restore_on = 'X'.

    RAISE EVENT buffer_restore.

    CLEAR flg_restore_on.

  ENDMETHOD.


  METHOD save_all.

    CHECK flg_post_on IS INITIAL.

    CHECK o_appl_message->check_error( ) IS INITIAL.
    CALL METHOD reset_handler.
    RAISE EVENT buffer_save.

    CALL METHOD zcl_appl_cntl=>commit_work.

    " Output success message
    CHECK o_appl_message->check_error( ) IS INITIAL.
    CALL METHOD o_appl_message->add_message
      EXPORTING
        im_mstyp = o_appl_message->co_succe
        im_msgid = 'ZAPPL'
        im_msgno = 001.
    IF 1 = 2.
      MESSAGE s001(zappl).
    ENDIF.
    set_update_flag( abap_false ).
  ENDMETHOD.


  METHOD save_buffer.

    RAISE EVENT buffer_save.

  ENDMETHOD.


  METHOD set_handler.
  ENDMETHOD.


  METHOD set_objects_cntl.

*    IF o_lock_cntl IS INITIAL.
*      o_lock_cntl ?= get_single_obj( 'APPL_LOCK_CNTL' ).
*    ENDIF.

  ENDMETHOD.


  METHOD set_update_flag.
    update_flag = im_flag.
  ENDMETHOD.
ENDCLASS.
