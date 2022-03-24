"! <p class="shorttext synchronized" lang="en">Application Cntl</p>
CLASS zcl_appl_cntl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPE-POOLS abap .

    "! <p class="shorttext synchronized" lang="en">data changed</p>
    CLASS-DATA update_flag TYPE xfeld READ-ONLY .
    "! <p class="shorttext synchronized" lang="en">ready for input y/n</p>
    CLASS-DATA ready_for_input TYPE xfeld READ-ONLY .

    "! <p class="shorttext synchronized" lang="en">Event before save</p>
    CLASS-EVENTS before_save .
    "! <p class="shorttext synchronized" lang="en">Event buffer backup</p>
    CLASS-EVENTS buffer_backup .
    "! <p class="shorttext synchronized" lang="en">Event buffer refresh</p>
    "!
    "! @parameter im_all_objects | <p class="shorttext synchronized" lang="en">X - All objects; Space - only changed objects.</p>
    CLASS-EVENTS buffer_refresh
      EXPORTING
        VALUE(im_all_objects) TYPE xfeld .
    "! <p class="shorttext synchronized" lang="en">Event buffer restore</p>
    CLASS-EVENTS buffer_restore .
    "! <p class="shorttext synchronized" lang="en">Event buffer save</p>
    CLASS-EVENTS buffer_save .
    "! <p class="shorttext synchronized" lang="en">distribute</p>
    CLASS-EVENTS distribute .
    "! <p class="shorttext synchronized" lang="en">Exit</p>
    CLASS-EVENTS exit .
    "! <p class="shorttext synchronized" lang="en">rollback</p>
    CLASS-EVENTS rollback .
    "! <p class="shorttext synchronized" lang="en">save</p>
    CLASS-EVENTS save .

    "! <p class="shorttext synchronized" lang="en">Constructor</p>
    CLASS-METHODS class_constructor .
    "! <p class="shorttext synchronized" lang="en">create object</p>
    CLASS-METHODS create_object
      IMPORTING
        !im_obj_type     TYPE zappl_obj_type
        !it_parameter    TYPE abap_parmbind_tab OPTIONAL
        !im_obj_register TYPE xfeld DEFAULT 'X'
      EXPORTING
        !ex_object       TYPE REF TO zif_appl_object .
    "! <p class="shorttext synchronized" lang="en">get message object</p>
    CLASS-METHODS get_appl_message
      RETURNING
        VALUE(re_obj_message) TYPE REF TO zif_appl_message .
    "! <p class="shorttext synchronized" lang="en">get field catalog</p>
    CLASS-METHODS get_field_catalog
      IMPORTING
        !im_layout_name    TYPE lvc_tname
      RETURNING
        VALUE(re_tab_fcat) TYPE zappl_lvc_fcat_tt .
    "! <p class="shorttext synchronized" lang="en">get global parameters</p>
    CLASS-METHODS get_global_parameter
      IMPORTING
        VALUE(im_name) TYPE fieldname
      RETURNING
        VALUE(result)  TYPE string
      RAISING
        zcx_appl_glb_par .
    "! <p class="shorttext synchronized" lang="en">get single object</p>
    CLASS-METHODS get_single_obj
      IMPORTING
        !im_appl_type    TYPE zappl_obj_type
      RETURNING
        VALUE(re_object) TYPE REF TO zif_appl_object .
    "! <p class="shorttext synchronized" lang="en">save all data</p>
    CLASS-METHODS save_all .
    "! <p class="shorttext synchronized" lang="en">commit work</p>
    "!
    "! @parameter im_wait | <p class="shorttext synchronized" lang="en">Commit work and wait</p>
    CLASS-METHODS commit_work
      IMPORTING
        !im_wait TYPE xfeld DEFAULT 'X' .
    "! <p class="shorttext synchronized" lang="en">refresh buffer</p>
    "!
    "! @parameter im_all_objects | <p class="shorttext synchronized" lang="en">refresh all objects (default = space)</p>
    CLASS-METHODS refresh_buffer
      IMPORTING
        !im_all_objects TYPE xfeld DEFAULT space .
    "! <p class="shorttext synchronized" lang="en">restore buffer</p>
    CLASS-METHODS restore_buffer .
    "! <p class="shorttext synchronized" lang="en">Internal calls only</p>
    CLASS-METHODS save_buffer .
    "! <p class="shorttext synchronized" lang="en">get update flag</p>
    CLASS-METHODS get_update_flag
      RETURNING
        VALUE(rm_flag) TYPE xfeld .
    "! <p class="shorttext synchronized" lang="en">set update flag</p>
    CLASS-METHODS set_update_flag
      IMPORTING
        VALUE(im_flag) TYPE xfeld DEFAULT abap_true .
    "! <p class="shorttext synchronized" lang="en">change ready for input flag</p>
    CLASS-METHODS change_input .
  PROTECTED SECTION.

  PRIVATE SECTION.

    "! <p class="shorttext synchronized" lang="en">message object</p>
    CLASS-DATA o_appl_message TYPE REF TO zif_appl_message .
    "! <p class="shorttext synchronized" lang="en">Application object types</p>
    CLASS-DATA t_appl_types TYPE zappl_obj_types_tt .
    "! <p class="shorttext synchronized" lang="en">Single objects</p>
    CLASS-DATA t_single_obj TYPE zappl_object_pointer_tt .
    "! <p class="shorttext synchronized" lang="en">Checkbox</p>
    CLASS-DATA flg_post_on TYPE xfeld .
    "! <p class="shorttext synchronized" lang="en">Checkbox</p>
    CLASS-DATA flg_refresh_on TYPE xfeld .
    "! <p class="shorttext synchronized" lang="en">Checkbox</p>
    CLASS-DATA flg_restore_on TYPE xfeld .

    "! <p class="shorttext synchronized" lang="en">set object controller</p>
    CLASS-METHODS set_objects_cntl .
    "! <p class="shorttext synchronized" lang="en">reset handler</p>
    CLASS-METHODS reset_handler .
    "! <p class="shorttext synchronized" lang="en">set handler</p>
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

* In a program executed via batch input or
* if the program was called with the USING addition to the CALL TRANSACTION statement.
* COMMIT WORK terminates the batch input processing.
* Therefore, do not start COMMIT WORK by batch

    CHECK sy-binpt <> 'X'        "Batch-Input
      AND sy-oncom <> 'P'       "PERFORM ... ON COMMIT
      AND sy-oncom <> 'V'       "CALL FUNCTION ... IN UPDATE TASK
      AND sy-oncom <> 'E'.

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

*  DATA: ls_parameter_val    TYPE zappl_glprv,
*        ls_parameter_def    TYPE zappl_lprd.

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
        im_mstyp = o_appl_message->c_succe
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
