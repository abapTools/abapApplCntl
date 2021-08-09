class ZCL_APPL_OBJ_TYPES_DB definition
  public
  create public .

public section.

  interfaces ZIF_APPL_OBJECT .
  interfaces ZIF_APPL_OBJECT_DB .

  aliases APPL_TYPE
    for ZIF_APPL_OBJECT~APPL_TYPE .
  aliases O_APPL_MESSAGE
    for ZIF_APPL_OBJECT~O_APPL_MESSAGE .
  aliases GET_APPL_TYPE
    for ZIF_APPL_OBJECT~GET_APPL_TYPE .

  methods CONSTRUCTOR
    importing
      !IM_TABLE_NAME type TABNAME .
  PROTECTED SECTION.
  PRIVATE SECTION.

    ALIASES read_buffer
      FOR zif_appl_object_db~read_buffer .
    ALIASES read_data
      FOR zif_appl_object_db~read_data .
    ALIASES save_data
      FOR zif_appl_object_db~save_data .
    ALIASES set_appl_type
      FOR zif_appl_object~set_appl_type .
    ALIASES data_saved
      FOR zif_appl_object_db~data_saved .

    TYPES:
      ty_data_tab TYPE HASHED TABLE OF zappl_obj_types WITH UNIQUE KEY type.
    TYPES ty_data_key TYPE zappl_obj_types_key .

    DATA gv_table_name TYPE tabname .
    DATA flg_on_save TYPE xfeld .
    DATA t_backup_delete TYPE ty_data_tab .
    DATA t_backup_insert TYPE ty_data_tab .
    DATA t_backup_update TYPE ty_data_tab .
    DATA t_data_delete TYPE ty_data_tab .
    DATA t_data_insert TYPE ty_data_tab .
    DATA t_data_old TYPE ty_data_tab .
    DATA t_data_update TYPE ty_data_tab .

    METHODS set_handler
      IMPORTING
        !im_activation TYPE xfeld .
    METHODS on_buffer_backup
        FOR EVENT buffer_backup OF zcl_appl_cntl .
    METHODS on_buffer_refresh
      FOR EVENT buffer_refresh OF zcl_appl_cntl
      IMPORTING
        !im_all_objects .
    METHODS on_buffer_restore
        FOR EVENT buffer_restore OF zcl_appl_cntl .
    METHODS on_buffer_save
        FOR EVENT buffer_save OF zcl_appl_cntl .
    METHODS save .
    METHODS write_change_documents
      IMPORTING
        !im_change_indicator TYPE cdchngind
        !it_data             TYPE ty_data_tab .
ENDCLASS.



CLASS ZCL_APPL_OBJ_TYPES_DB IMPLEMENTATION.


  METHOD constructor.
    gv_table_name = im_table_name.
  ENDMETHOD.


  METHOD on_buffer_backup.
    _on_buffer_backup.
  ENDMETHOD.


  METHOD on_buffer_refresh.
    _on_buffer_refresh.
  ENDMETHOD.


  METHOD on_buffer_restore.
    _on_buffer_restore.
  ENDMETHOD.


  METHOD on_buffer_save.
    _on_save.

  ENDMETHOD.


  METHOD save.
    _save 'ZDPG_CATEGORY'.
  ENDMETHOD.


  METHOD set_handler.
    CHECK flg_on_save <> im_activation.
    flg_on_save = im_activation.

* Für DCC Ereignissen regestrieren
    SET HANDLER on_buffer_save    ACTIVATION im_activation.
    SET HANDLER on_buffer_refresh ACTIVATION im_activation.
    SET HANDLER on_buffer_backup  ACTIVATION im_activation.
  ENDMETHOD.


  METHOD write_change_documents.
  ENDMETHOD.


  METHOD zif_appl_object_db~clear_data.

    DATA: ls_key      TYPE ty_data_key.

    ls_key = im_key.

    DELETE TABLE t_data_delete
                WITH TABLE KEY type  = ls_key-type.
    DELETE TABLE t_data_insert
                 WITH TABLE KEY type  = ls_key-type.
    DELETE TABLE t_data_old
                 WITH TABLE KEY type  = ls_key-type.
    DELETE TABLE t_data_update
                WITH TABLE KEY type  = ls_key-type.
  ENDMETHOD.


  METHOD zif_appl_object_db~read_buffer.

    DATA: ls_data_key     TYPE ty_data_key.

    ls_data_key = im_key.

    CLEAR ex_data.

    READ TABLE t_data_update INTO ex_data
                WITH TABLE KEY type  = ls_data_key-type.
    CHECK sy-subrc <> 0.

    READ TABLE t_data_insert INTO ex_data
                WITH TABLE KEY type  = ls_data_key-type.
    CHECK sy-subrc <> 0.

    READ TABLE t_data_delete INTO ex_data
                WITH TABLE KEY type  = ls_data_key-type.
    CHECK sy-subrc <> 0.

    READ TABLE t_data_old INTO ex_data
                WITH TABLE KEY type  = ls_data_key-type.
    CHECK sy-subrc <> 0.

    CALL METHOD read_data
      EXPORTING
        im_key  = im_key
      IMPORTING
        ex_data = ex_data.

  ENDMETHOD.


  METHOD zif_appl_object_db~read_data.

    DATA: ls_data_key TYPE ty_data_key,
          ls_data     LIKE LINE OF t_data_old.

    ls_data_key = im_key.

    SELECT SINGLE * FROM zappl_obj_types INTO ex_data
      WHERE type  = ls_data_key-type.

    IF sy-subrc = 0.
      CLEAR ex_new.
      INSERT ex_data INTO TABLE t_data_old.
      IF sy-subrc <> 0.
        MODIFY TABLE t_data_old FROM ex_data.
      ENDIF.

    ELSE.

      ls_data-type  = ls_data_key-type.


      ex_new = 'X'.
      ex_data = ls_data.

*   Neue Zeile zum Speichern vormerken
      IF im_add_new_line = 'X'.
        CALL METHOD save_data
          EXPORTING
            im_data = ex_data.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD zif_appl_object_db~save_data.

    DATA: ls_data    LIKE LINE OF t_data_old,
          ls_im_data LIKE LINE OF t_data_old,
          lv_new     TYPE xfeld.

    CALL METHOD set_handler( 'X' ).

    ls_im_data = im_data.

    READ TABLE t_data_old INTO ls_data
        WITH TABLE KEY type  = ls_im_data-type.

    IF sy-subrc <> 0.
      lv_new = 'X'.
    ENDIF.

    IF im_delete IS INITIAL.
      IF lv_new  = 'X'.
        INSERT im_data INTO TABLE t_data_insert.
        IF sy-subrc <> 0.
          MODIFY TABLE t_data_insert FROM im_data.
        ENDIF.

      ELSE.
        INSERT im_data INTO TABLE t_data_update.
        IF sy-subrc <> 0.
          MODIFY TABLE t_data_update FROM im_data.
        ENDIF.
        DELETE TABLE t_data_delete
               WITH TABLE KEY type  = ls_im_data-type.
      ENDIF.

    ELSE.
      IF lv_new  = 'X'.
        DELETE TABLE t_data_insert
                 WITH TABLE KEY type  = ls_im_data-type.
      ELSE.
        DELETE TABLE t_data_update
                 WITH TABLE KEY type  = ls_im_data-type.
        INSERT im_data INTO TABLE t_data_delete.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD zif_appl_object~get_appl_type.
    re_type = appl_type.
  ENDMETHOD.


  METHOD zif_appl_object~set_appl_type.
    appl_type = im_type.
  ENDMETHOD.
ENDCLASS.
