*----------------------------------------------------------------------*
***INCLUDE LZAPPL_CUSTCL2.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class LCL_TREE_EVENT_RECEIVER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_tree_event_receiver DEFINITION.
  PUBLIC SECTION.

    TYPES: ty_it_events TYPE STANDARD TABLE OF cntl_simple_event WITH DEFAULT KEY.

    CLASS-METHODS:
      handle_node_double_click
        FOR EVENT node_double_click
        OF cl_column_tree_model
        IMPORTING node_key,

      on_link_click
        FOR EVENT link_click
        OF cl_column_tree_model
        IMPORTING
          node_key
          item_name
          sender,

      handle_item_double_click
        FOR EVENT item_double_click
        OF cl_column_tree_model
        IMPORTING node_key item_name.
ENDCLASS.
*&---------------------------------------------------------------------*
*& Class (Implementation) _CL_TREE_EVENT_RECEIVER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_tree_event_receiver IMPLEMENTATION.

  METHOD handle_node_double_click.

    " this method handles the node double click event of the tree
    " model instance

    " show the key of the double clicked node in a dynpro field
    g_event = 'NODE_DOUBLE_CLICK'.
    g_node_key = node_key.
    CLEAR: g_item_name, g_header_name.
  ENDMETHOD.

  METHOD  handle_item_double_click.
    " this method handles the item double click event of the tree
    " model instance

    " show the key of the node and the name of the item
    " of the double clicked item in a dynpro field
    g_event = 'ITEM_DOUBLE_CLICK'.
    g_node_key = node_key.
    g_item_name = item_name.
    CLEAR g_header_name.
  ENDMETHOD.

  METHOD on_link_click.
    BREAK-POINT.
  ENDMETHOD.

ENDCLASS.
