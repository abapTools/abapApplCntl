*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 08.09.2023 at 19:00:07
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZAPPL_HTM_COLORS................................*
DATA:  BEGIN OF STATUS_ZAPPL_HTM_COLORS              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZAPPL_HTM_COLORS              .
CONTROLS: TCTRL_ZAPPL_HTM_COLORS
            TYPE TABLEVIEW USING SCREEN '0003'.
*...processing: ZAPPL_OBJ_TYPES.................................*
DATA:  BEGIN OF STATUS_ZAPPL_OBJ_TYPES               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZAPPL_OBJ_TYPES               .
CONTROLS: TCTRL_ZAPPL_OBJ_TYPES
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZAPPL_HTM_COLORS              .
TABLES: *ZAPPL_OBJ_TYPES               .
TABLES: ZAPPL_HTM_COLORS               .
TABLES: ZAPPL_OBJ_TYPES                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
