
REPORT zappl_install.
********************************************************************************
* The MIT License (MIT)
*
* Copyright (c) 2021 abapAppl Contributors
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
********************************************************************************
CLASS lcl_install DEFINITION DEFERRED.


CLASS lcl_install DEFINITION FINAL.

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_appl_sel_install,
             install_obj_types  TYPE boolean,
             install_demo_types TYPE boolean,
             install_colors     TYPE boolean,
           END OF ty_appl_sel_install.
    CLASS-DATA: s_sel TYPE ty_appl_sel_install READ-ONLY.

    METHODS process
      IMPORTING
        im_sel TYPE ty_appl_sel_install.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: t_obj_types  TYPE zappl_obj_types_tt,
          t_demo_types TYPE zappl_obj_types_tt,
          t_colors     TYPE zappl_htm_colors_tt.
    METHODS fill_tables.
    METHODS fill_tbl_obj_types.
    METHODS fill_tbl_demo_types.
    METHODS fill_tbl_colors.
    METHODS clear.
    METHODS install_data.
    METHODS install_html_colors.
    METHODS install_obj_types.
    METHODS install_demo_types.

ENDCLASS.

CLASS lcl_install IMPLEMENTATION.

  METHOD process.
    s_sel = im_sel.
    fill_tables( ).
    install_data( ).
    clear( ).
  ENDMETHOD.

  METHOD fill_tables.
    fill_tbl_obj_types( ).
    fill_tbl_demo_types( ).
    fill_tbl_colors( ).
  ENDMETHOD.

  METHOD fill_tbl_obj_types.

    t_obj_types = VALUE zappl_obj_types_tt(
        ( type = 'APPL_MESSAGE'       class = 'ZCL_APPL_MESSAGE'          single = 'X' )
        ( type = 'APPL_MESSAGE_SHOW'  class = 'ZCL_APPL_SHOW_MESSAGE'     single = ' ' )
        ( type = 'APPL_MESSAGE_EVENT' class = 'ZCL_APPL_MESSAGE_EVENT'    single = ' ' )
        ( type = 'APPL_OBJ_TYPE'      class = 'ZCL_APPL_OBJ_TYPES'        single = 'X' )
        ( type = 'APPL_OBJ_TYPE_DB'   class = 'ZCL_APPL_OBJ_TYPES_DB'     single = 'X' )
        ( type = 'APPL_HTML_BTN'      class = 'ZCL_APPL_HTML_BUTTON'      single = ' ' )
        ( type = 'APPL_HTML_BTN_CNTL' class = 'ZCL_APPL_HTML_BUTTON_CNTL' single = 'X' )
        ( type = 'APPL_LOCK_CNTL'     class = 'ZCL_APPL_LOCK_CNTL'        single = 'X' )
    ).

  ENDMETHOD.

  METHOD fill_tbl_demo_types.
    t_demo_types = VALUE zappl_obj_types_tt(
     ( type = 'DEMO_APPL'       class = 'ZCL_APPL_DEMO'          single = 'X' )
     ).
  ENDMETHOD.

  METHOD fill_tbl_colors.

    t_colors = VALUE zappl_htm_colors_tt(
         ( color_name = 'aliceblue'              color_code = '#f0f8ff' )
         ( color_name = 'antiquewhite'           color_code = '#faebd7' )
         ( color_name = 'aquamarine'             color_code = '#7fffd4' )
         ( color_name = 'azure'                  color_code = '#f0ffff' )
         ( color_name = 'beige'                  color_code = '#f5f5dc' )
         ( color_name = 'bisque'                 color_code = '#ffe4c4' )
         ( color_name = 'black'                  color_code = '#000000' )
         ( color_name = 'blanchedalmond'         color_code = '#ffebcd' )
         ( color_name = 'blue'                   color_code = '#0000ff' )
         ( color_name = 'blueviolet'             color_code = '#8a2be2' )
         ( color_name = 'brown'                  color_code = '#a52a2a' )
         ( color_name = 'burlywood'              color_code = '#deb887' )
         ( color_name = 'cadetblue'              color_code = '#5f9ea0' )
         ( color_name = 'chartreuse'             color_code = '#7fff00' )
         ( color_name = 'chocolate'              color_code = '#d2691e' )
         ( color_name = 'coral'                  color_code = '#ff7f50' )
         ( color_name = 'cornflowerblue'         color_code = '#6495ed' )
         ( color_name = 'cornsilk'               color_code = '#fff8dc' )
         ( color_name = 'crimson'                color_code = '#dc143c' )
         ( color_name = 'cyan'                   color_code = '#00ffff' )
         ( color_name = 'darkblue'               color_code = '#00008b' )
         ( color_name = 'darkcyan'               color_code = '#008b8b' )
         ( color_name = 'darkgoldenrod'          color_code = '#b8860b' )
         ( color_name = 'darkgreen'              color_code = '#006400' )
         ( color_name = 'darkgrey'               color_code = '#a9a9a9' )
         ( color_name = 'darkkhaki'              color_code = '#bdb76b' )
         ( color_name = 'darkmagenta'            color_code = '#8b008b' )
         ( color_name = 'darkolivegreen'         color_code = '#556b2f' )
         ( color_name = 'darkorange'             color_code = '#ff8c00' )
         ( color_name = 'darkorchid'             color_code = '#9932cc' )
         ( color_name = 'darkred'                color_code = '#8b0000' )
         ( color_name = 'darksalmon'             color_code = '#e9967a' )
         ( color_name = 'darkseagreen'           color_code = '#8fbc8f' )
         ( color_name = 'darkslateblue'          color_code = '#483d8b' )
         ( color_name = 'darkslategrey'          color_code = '#2f4f4f' )
         ( color_name = 'darkturquoise'          color_code = '#00ced1' )
         ( color_name = 'darkviolet'             color_code = '#9400d3' )
         ( color_name = 'deeppink'               color_code = '#ff1493' )
         ( color_name = 'deepskyblue'            color_code = '#00bfff' )
         ( color_name = 'dimgray'                color_code = '#696969' )
         ( color_name = 'dodgerblue'             color_code = '#1e90ff' )
         ( color_name = 'firebrick'              color_code = '#b22222' )
         ( color_name = 'floralwhite'            color_code = '#fffaf0' )
         ( color_name = 'forestgreen'            color_code = '#228b22' )
         ( color_name = 'gainsboro'              color_code = '#dcdcdc' )
         ( color_name = 'ghostwhite'             color_code = '#f8f8ff' )
         ( color_name = 'gold'                   color_code = '#ffd700' )
         ( color_name = 'goldenrod'              color_code = '#daa520' )
         ( color_name = 'green'                  color_code = '#008000' )
         ( color_name = 'greenyellow'            color_code = '#adff2f' )
         ( color_name = 'grey'                   color_code = '#808080' )
         ( color_name = 'honeydew'               color_code = '#f0fff0' )
         ( color_name = 'hotpink'                color_code = '#ff69b4' )
         ( color_name = 'indianred'              color_code = '#cd5c5c' )
         ( color_name = 'indigo'                 color_code = '#4b0082' )
         ( color_name = 'ivory'                  color_code = '#fffff0' )
         ( color_name = 'khaki'                  color_code = '#f0e68c' )
         ( color_name = 'lavender'               color_code = '#e6e6fa' )
         ( color_name = 'lavenderblush'          color_code = '#fff0f5' )
         ( color_name = 'lawngreen'              color_code = '#7cfc00' )
         ( color_name = 'lemonchiffon'           color_code = '#fffacd' )
         ( color_name = 'lightblue'              color_code = '#add8e6' )
         ( color_name = 'lightcoral'             color_code = '#f08080' )
         ( color_name = 'lightcyan'              color_code = '#e0ffff' )
         ( color_name = 'lightgoldenrodyellow'   color_code = '#fafad2' )
         ( color_name = 'lightgreen'             color_code = '#90ee90' )
         ( color_name = 'lightgrey'              color_code = '#d3d3d3' )
         ( color_name = 'lightpink'              color_code = '#ffb6c1' )
         ( color_name = 'lightsalmon'            color_code = '#ffa07a' )
         ( color_name = 'lightseagreen'          color_code = '#20b2aa' )
         ( color_name = 'lightskyblue'           color_code = '#87cefa' )
         ( color_name = 'lightslategray'         color_code = '#778899' )
         ( color_name = 'lightsteelblue'         color_code = '#b0c4de' )
         ( color_name = 'lightyellow'            color_code = '#ffffe0' )
         ( color_name = 'lime'                   color_code = '#00ff00' )
         ( color_name = 'limegreen'              color_code = '#32cd32' )
         ( color_name = 'linen'                  color_code = '#faf0e6' )
         ( color_name = 'magenta'                color_code = '#ff00ff' )
         ( color_name = 'maroon'                 color_code = '#800000' )
         ( color_name = 'mediumaquamarine'       color_code = '#66cdaa' )
         ( color_name = 'mediumblue'             color_code = '#0000cd' )
         ( color_name = 'mediumorchid'           color_code = '#ba55d3' )
         ( color_name = 'mediumpurple'           color_code = '#9370db' )
         ( color_name = 'mediumseagreen'         color_code = '#3cb371' )
         ( color_name = 'mediumslateblue'        color_code = '#7b68ee' )
         ( color_name = 'mediumspringgreen'      color_code = '#00fa9a' )
         ( color_name = 'mediumturquoise'        color_code = '#48d1cc' )
         ( color_name = 'mediumvioletred'        color_code = '#c71585' )
         ( color_name = 'midnightblue'           color_code = '#191970' )
         ( color_name = 'mintcream'              color_code = '#f5fffa' )
         ( color_name = 'mistyrose'              color_code = '#ffe4e1' )
         ( color_name = 'moccasin'               color_code = '#ffe4b5' )
         ( color_name = 'navajowhite'            color_code = '#ffdead' )
         ( color_name = 'navy'                   color_code = '#000080' )
         ( color_name = 'oldlace'                color_code = '#fdf5e6' )
         ( color_name = 'olive'                  color_code = '#808000' )
         ( color_name = 'olivedrab'              color_code = '#6b8e23' )
         ( color_name = 'orange'                 color_code = '#ffa500' )
         ( color_name = 'orangered'              color_code = '#ff4500' )
         ( color_name = 'orchid'                 color_code = '#da70d6' )
         ( color_name = 'palegoldenrod'          color_code = '#eee8aa' )
         ( color_name = 'palegreen'              color_code = '#98fb98' )
         ( color_name = 'paleturquoise'          color_code = '#afeeee' )
         ( color_name = 'palevioletred'          color_code = '#db7093' )
         ( color_name = 'papayawhip'             color_code = '#ffefd5' )
         ( color_name = 'peachpuff'              color_code = '#ffdab9' )
         ( color_name = 'peru'                   color_code = '#cd853f' )
         ( color_name = 'pink'                   color_code = '#ffc0cb' )
         ( color_name = 'plum'                   color_code = '#dda0dd' )
         ( color_name = 'powderblue'             color_code = '#b0e0e6' )
         ( color_name = 'purple'                 color_code = '#800080' )
         ( color_name = 'RebeccaPurple'          color_code = '#663399' )
         ( color_name = 'red'                    color_code = '#ff0000' )
         ( color_name = 'rosybrown'              color_code = '#bc8f8f' )
         ( color_name = 'royalblue'              color_code = '#4169e1' )
         ( color_name = 'saddlebrown'            color_code = '#8b4513' )
         ( color_name = 'salmon'                 color_code = '#fa8072' )
         ( color_name = 'sandybrown'             color_code = '#f4a460' )
         ( color_name = 'seagreen'               color_code = '#2e8b57' )
         ( color_name = 'seashell'               color_code = '#fff5ee' )
         ( color_name = 'sienna'                 color_code = '#a0522d' )
         ( color_name = 'silver'                 color_code = '#c0c0c0' )
         ( color_name = 'skyblue'                color_code = '#87ceeb' )
         ( color_name = 'slateblue'              color_code = '#6a5acd' )
         ( color_name = 'slategray'              color_code = '#708090' )
         ( color_name = 'snow'                   color_code = '#fffafa' )
         ( color_name = 'springgreen'            color_code = '#00ff7f' )
         ( color_name = 'steelblue'              color_code = '#4682b4' )
         ( color_name = 'tan'                    color_code = '#d2b48c' )
         ( color_name = 'teal'                   color_code = '#008080' )
         ( color_name = 'thistle'                color_code = '#d8bfd8' )
         ( color_name = 'tomato'                 color_code = '#ff6347' )
         ( color_name = 'turquoise'              color_code = '#40e0d0' )
         ( color_name = 'violet'                 color_code = '#ee82ee' )
         ( color_name = 'wheat'                  color_code = '#f5deb3' )
         ( color_name = 'white'                  color_code = '#ffffff' )
         ( color_name = 'whitesmoke'             color_code = '#f5f5f5' )
         ( color_name = 'yellow'                 color_code = '#ffff00' )
         ( color_name = 'yellowgreen'            color_code = '#9acd32' )
      ).

    LOOP AT t_colors ASSIGNING FIELD-SYMBOL(<color>).
      TRANSLATE <color>-color_name TO UPPER CASE.
      TRANSLATE <color>-color_code TO UPPER CASE.
    ENDLOOP.

  ENDMETHOD.

  METHOD clear.
    CLEAR:      t_obj_types, t_colors.
    REFRESH:    t_obj_types, t_colors.
  ENDMETHOD.

  METHOD install_data.

    IF s_sel-install_obj_types EQ abap_true.
      install_obj_types( ).
    ENDIF.

    IF s_sel-install_demo_types EQ abap_true.
      install_demo_types(  ).
    ENDIF.
    IF s_sel-install_colors EQ abap_true.
      install_html_colors( ).
    ENDIF.


    IF     s_sel-install_obj_types  EQ abap_true
        OR s_sel-install_demo_types EQ abap_true
        OR s_sel-install_colors     EQ abap_true.
      COMMIT WORK.
    ENDIF.

  ENDMETHOD.

METHOD install_html_colors.

  IF s_sel-install_colors EQ abap_false.
    EXIT.
  ENDIF.

  DELETE FROM zappl_htm_colors.
  MODIFY zappl_htm_colors FROM TABLE t_colors.

ENDMETHOD.

METHOD install_demo_types.

  IF s_sel-install_demo_types EQ abap_false.
    EXIT.
  ENDIF.

    DELETE FROM zappl_obj_types
      WHERE type LIKE 'DEMO_%'.
  MODIFY zappl_obj_types FROM TABLE t_demo_types.
ENDMETHOD.

METHOD install_obj_types.

  IF s_sel-install_obj_types EQ abap_false.
    EXIT.
  ENDIF.

  DELETE FROM zappl_obj_types
      WHERE type LIKE 'APPL_%'.
  MODIFY zappl_obj_types FROM TABLE t_obj_types.

ENDMETHOD.

ENDCLASS.

DATA: lo_install TYPE REF TO lcl_install,
      s_sel      TYPE lcl_install=>ty_appl_sel_install.

PARAMETERS:
  pa_type AS CHECKBOX DEFAULT 'X',
  pa_demo AS CHECKBOX,
  pa_col  AS CHECKBOX.

INITIALIZATION.

  CREATE OBJECT lo_install.

AT SELECTION-SCREEN OUTPUT.
  %_pa_type_%_app_%-text = 'install object types'.
  %_pa_demo_%_app_%-text = 'install demo types'.
  %_pa_col_%_app_%-text  = 'install html colors'.

START-OF-SELECTION.
  s_sel-install_obj_types = pa_type.
  s_sel-install_demo_types = pa_demo.
  s_sel-install_colors    = pa_col.

  lo_install->process( s_sel ).
