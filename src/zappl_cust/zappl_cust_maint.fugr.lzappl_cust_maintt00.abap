*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZAPPL_BTN_TYPES.................................*
DATA:  BEGIN OF STATUS_ZAPPL_BTN_TYPES               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZAPPL_BTN_TYPES               .
CONTROLS: TCTRL_ZAPPL_BTN_TYPES
            TYPE TABLEVIEW USING SCREEN '0002'.
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
TABLES: *ZAPPL_BTN_TYPES               .
TABLES: *ZAPPL_HTM_COLORS              .
TABLES: *ZAPPL_OBJ_TYPES               .
TABLES: ZAPPL_BTN_TYPES                .
TABLES: ZAPPL_HTM_COLORS               .
TABLES: ZAPPL_OBJ_TYPES                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
