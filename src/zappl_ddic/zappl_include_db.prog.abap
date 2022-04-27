*&---------------------------------------------------------------------*
*& Include          ZDPG_INCLUDE_DB
*&---------------------------------------------------------------------*

*------------------------------------------------------------
* SAVE
*------------------------------------------------------------
DEFINE _save.

  FIELD-SYMBOLS <data>       LIKE LINE OF t_data_old.

*------------------------------------------------------------
* * DB Deletes
*------------------------------------------------------------
  IF t_data_delete IS NOT INITIAL.
  DELETE (&1) FROM TABLE t_data_delete.
  IF sy-subrc <> 0.
  RAISE EXCEPTION TYPE cx_os_db_delete
  EXPORTING
  table = &1.
  ENDIF.

  LOOP AT t_data_delete ASSIGNING <data>.
  DELETE TABLE t_data_old FROM <data>.
  ENDLOOP.
  CLEAR t_data_delete.
  ENDIF.

*------------------------------------------------------------
* * DB Inserts
*------------------------------------------------------------
  IF t_data_insert IS NOT INITIAL.
  INSERT (&1) FROM TABLE t_data_insert
  ACCEPTING DUPLICATE KEYS.
  IF sy-subrc <> 0.
  RAISE EXCEPTION TYPE cx_os_db_insert
  EXPORTING
  table = &1.
  ENDIF.

  LOOP AT t_data_insert ASSIGNING <data>.
  INSERT <data> INTO TABLE t_data_old.
  ENDLOOP.
  CLEAR t_data_insert.
  ENDIF.

*------------------------------------------------------------
* * DB Updates
*------------------------------------------------------------
  IF t_data_update IS NOT INITIAL.
  UPDATE (&1) FROM TABLE t_data_update.
  IF sy-subrc <> 0.
  RAISE EXCEPTION TYPE cx_os_db_update
  EXPORTING
  table = &1.
  ENDIF.

  LOOP AT t_data_update ASSIGNING <data>.
  MODIFY TABLE t_data_old FROM <data>.
  ENDLOOP.
  CLEAR t_data_update.
  ENDIF.


*------------------------------------------------------------
  CLEAR: t_backup_delete,
  t_backup_insert,
  t_backup_update.


END-OF-DEFINITION.

*------------------------------------------------------------
* ON_SAVE
*------------------------------------------------------------
DEFINE _on_save.

  TRY .
      CALL METHOD save.

      CALL METHOD set_handler( space ).

      CALL METHOD on_buffer_refresh( space ).

      RAISE EVENT data_saved.

    CATCH:  cx_os_db_delete,
            cx_os_db_insert,
            cx_os_db_update.

  ENDTRY.

END-OF-DEFINITION.

*------------------------------------------------------------
* ON_BUFFER_BACKUP
*------------------------------------------------------------
DEFINE _on_buffer_backup.

  SET HANDLER on_buffer_restore ACTIVATION 'X'.

  CLEAR: t_backup_delete,
         t_backup_insert,
         t_backup_update.

  t_backup_delete = t_data_delete.
  t_backup_insert = t_data_insert.
  t_backup_update = t_data_update.

END-OF-DEFINITION.

*------------------------------------------------------------
* ON_BUFFER_REFRESH
*------------------------------------------------------------
DEFINE _on_buffer_refresh.

  CALL METHOD set_handler( space ).

  SET HANDLER on_buffer_restore ACTIVATION space.

  CLEAR: t_data_insert,
         t_data_delete,
         t_data_update,
         t_backup_delete,
         t_backup_insert,
         t_backup_update.

  IF im_all_objects = 'X'.
    CLEAR: t_data_old.
  ENDIF.

END-OF-DEFINITION.

*------------------------------------------------------------
* ON_BUFFER_RESTORE
*------------------------------------------------------------
DEFINE _on_buffer_restore.

  SET HANDLER on_buffer_restore ACTIVATION space.

  CLEAR: t_data_delete,
         t_data_insert,
         t_data_update.

  t_data_delete = t_backup_delete.
  t_data_insert = t_backup_insert.
  t_data_update = t_backup_update.

  CLEAR: t_backup_delete,
         t_backup_insert,
         t_backup_update.

END-OF-DEFINITION.

*------------------------------------------------------------
* ON_BUFFER_SAVE
*------------------------------------------------------------
DEFINE on_buffer_save.

  TRY .

      CALL METHOD save.
      CALL METHOD set_handler( space ).
      CALL METHOD on_buffer_refresh( space ).
      RAISE EVENT data_saved.

    CATCH:  cx_os_db_delete,
            cx_os_db_insert,
            cx_os_db_update.

  ENDTRY.

END-OF-DEFINITION.
