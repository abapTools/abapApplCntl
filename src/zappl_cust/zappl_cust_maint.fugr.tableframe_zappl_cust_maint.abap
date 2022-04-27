*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZAPPL_CUST_MAINT
*   generation date: 09.09.2021 at 23:54:50
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZAPPL_CUST_MAINT   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
