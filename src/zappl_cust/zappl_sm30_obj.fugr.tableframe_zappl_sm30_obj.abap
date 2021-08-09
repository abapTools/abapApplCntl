*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZAPPL_SM30_OBJ
*   generation date: 27.06.2021 at 21:51:35
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZAPPL_SM30_OBJ     .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
