*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 27.06.2021 at 21:51:35
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZAPPL_OBJ_TYPES.................................*
DATA:  BEGIN OF STATUS_ZAPPL_OBJ_TYPES               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZAPPL_OBJ_TYPES               .
CONTROLS: TCTRL_ZAPPL_OBJ_TYPES
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZAPPL_OBJ_TYPES               .
TABLES: ZAPPL_OBJ_TYPES                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
