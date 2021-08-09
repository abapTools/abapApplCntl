*----------------------------------------------------------------------*
***INCLUDE LZAPPL_CUSTF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form pbo_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM pbo_0100 .

  IF o_tree IS INITIAL.
    PERFORM create_and_init_tree.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form create_and_init_tree
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_and_init_tree.

  DATA: event            TYPE cntl_simple_event,
        events           TYPE cntl_simple_events,
        hierarchy_header TYPE treemhhdr.

CHECK NOT o_tree is BOUND.
  PERFORM build_tabnames CHANGING t_tabnames.

* setup the hierarchy header
 o_tree = NEW cl_column_tree_model(
    node_selection_mode   = cl_column_tree_model=>node_sel_mode_single
    hierarchy_column_name = 'FOLDER'
    hierarchy_header      = VALUE #( t_image = icon_folder
                                     heading = 'Appl Customizing'
                                     tooltip = 'Appl Customizing'
                                     width   = 30
                                   )
    item_selection        = abap_true ).

  DATA(o_custom_container) = NEW cl_gui_custom_container( container_name = 'TREE_CONT' ).
*----------------------------------------------------------------------*
*  Embed in default_screen
  o_tree->create_tree_control( parent = o_custom_container ).
*----------------------------------------------------------------------*

  o_tree->add_node( EXPORTING isfolder          = abap_true
                              disabled          = abap_true
                              node_key          = 'NODE_CUST'
                              relative_node_key = ''
                              relationship      = cl_tree_model=>relat_last_child
                              expanded_image    = CONV tv_image( icon_folder )
                              image             = CONV tv_image( icon_folder )
                              item_table        = VALUE #( ( class     = cl_column_tree_model=>item_class_link
                                                             item_name = 'FOLDER'
                                                             text      = 'Customizing'
                                                           )
                                                         )
                             ).


  PERFORM add_table_nodes USING t_tabnames
                                o_tree
                                'NODE_CUST'.
*----------------------------------------------------------------------*
* register events
  SET HANDLER lcl_tree_event_receiver=>on_link_click FOR o_tree.
  DATA(it_events) = VALUE lcl_tree_event_receiver=>ty_it_events(
                                                    ( eventid = cl_column_tree_model=>eventid_link_click
                                                      appl_event = abap_true )
                                                  ).

  o_tree->set_registered_events( events = it_events ).

*----------------------------------------------------------------------*
* Erzeugung von cl_gui_container=>default_screen erzwingen
* Force creation of cl_gui_container=>default_screen
  WRITE: space.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form build_tabnames
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_tabnames CHANGING ct_tabnames TYPE ty_t_tabname.

  CHECK lines( ct_tabnames ) EQ 0.

  APPEND INITIAL LINE TO ct_tabnames ASSIGNING FIELD-SYMBOL(<tabname>).
  <tabname>-tabname = 'ZAPPL_OBJ_TYPES'.
  <tabname>-dynpro = 0200.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form add_table_nodes
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM add_table_nodes USING  it_tabnames TYPE        ty_t_tabname
                            io_tree     TYPE REF TO cl_column_tree_model
                            iv_relat_node_key TYPE tm_nodekey.

  CHECK NOT it_tabnames IS INITIAL.
  LOOP AT it_tabnames ASSIGNING FIELD-SYMBOL(<tabname>).
    DATA(lv_node_key) = 'NODE_' && <tabname>-tabname.
    SELECT SINGLE ddtext FROM dd02t WHERE tabname EQ @<tabname>-tabname INTO @DATA(lv_ddtxt).
    io_tree->add_node( EXPORTING isfolder          = abap_true
                                 disabled          = abap_false
                                 node_key          = lv_node_key
                                 relative_node_key = iv_relat_node_key
                                 relationship      = cl_tree_model=>relat_last_child
                                 expanded_image    = CONV tv_image( icon_folder )
                                 image             = CONV tv_image( icon_folder )
                                 item_table        = VALUE #( ( class     = cl_column_tree_model=>item_class_link
                                                                item_name = 'FOLDER'
                                                                text      = lv_ddtxt
                                                              )
                                                            )
                                ).
  ENDLOOP.
ENDFORM.
