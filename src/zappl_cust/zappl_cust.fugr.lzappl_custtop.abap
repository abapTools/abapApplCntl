* regenerated at 27.06.2021 14:37:13
FUNCTION-POOL ZAPPL_CUST                 MESSAGE-ID SV.

* INCLUDE LZAPPL_CUSTD...                    " Local class definition
CLASS lcl_event_receiver DEFINITION DEFERRED.
CLASS lcl_tree_event_receiver DEFINITION DEFERRED.
CLASS cl_gui_cfw DEFINITION LOAD.

TYPES: BEGIN OF ty_s_tabname,
         tabname TYPE  tabname,
         dynpro  TYPE sy-dynnr,
       END OF ty_s_tabname,
       ty_t_tabname TYPE STANDARD TABLE OF ty_s_tabname.

TYPES: BEGIN OF ty_s_object,
         object TYPE REF TO object,
       END OF ty_s_object,
       ty_t_object TYPE STANDARD TABLE OF ty_s_object.
DATA: t_objects TYPE ty_t_object.

DATA:
  o_appl_message   TYPE REF TO zif_appl_message,
  o_alv            TYPE REF TO cl_gui_alv_grid,
  o_tree_cust_cont TYPE REF TO cl_gui_custom_container,
  o_tree           TYPE REF TO cl_column_tree_model.


DATA: t_tabnames       TYPE ty_t_tabname.

DATA: g_event       TYPE string,
      g_dynnr       TYPE sy-dynnr,
      g_ok_code     TYPE sy-ucomm,
      g_node_key    TYPE tm_nodekey,
      node_key      TYPE tm_nodekey,
      g_item_name   TYPE tv_itmname,
      g_header_name TYPE tv_hdrname.

INCLUDE lzappl_custcl1.

INCLUDE lzappl_custcl2.

LOAD-OF-PROGRAM.
  g_dynnr = '0110'.
