*---------------------------------------------------------------------*
*    view related data declarations
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
