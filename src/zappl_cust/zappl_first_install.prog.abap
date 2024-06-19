
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
           END OF ty_appl_sel_install.
    CLASS-DATA: s_sel TYPE ty_appl_sel_install READ-ONLY.

    METHODS process
      IMPORTING
        im_sel TYPE ty_appl_sel_install.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: t_obj_types  TYPE zappl_obj_types_tt,
          t_demo_types TYPE zappl_obj_types_tt.
    METHODS fill_tables.
    METHODS fill_tbl_obj_types.
    METHODS fill_tbl_demo_types.
    METHODS clear.
    METHODS install_data.
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
  ENDMETHOD.

  METHOD fill_tbl_obj_types.

    t_obj_types = VALUE zappl_obj_types_tt(
        ( type = 'APPL_MESSAGE'       class = 'ZCL_APPL_MESSAGE'          single = 'X' )
        ( type = 'APPL_MESSAGE_SHOW'  class = 'ZCL_APPL_SHOW_MESSAGE'     single = ' ' )
        ( type = 'APPL_MESSAGE_EVENT' class = 'ZCL_APPL_MESSAGE_EVENT'    single = ' ' )
        ( type = 'APPL_OBJ_TYPE'      class = 'ZCL_APPL_OBJ_TYPES'        single = 'X' )
        ( type = 'APPL_OBJ_TYPE_DB'   class = 'ZCL_APPL_OBJ_TYPES_DB'     single = 'X' )
        ( type = 'APPL_LOCK_CNTL'     class = 'ZCL_APPL_LOCK_CNTL'        single = 'X' )
    ).

  ENDMETHOD.

  METHOD fill_tbl_demo_types.
    t_demo_types = VALUE zappl_obj_types_tt(
     ( type = 'DEMO_APPL'       class = 'ZCL_APPL_DEMO'          single = 'X' )
     ).
  ENDMETHOD.



  METHOD clear.
    CLEAR:      t_obj_types, t_demo_types.
    REFRESH:    t_obj_types, t_demo_types.
  ENDMETHOD.

  METHOD install_data.

    IF s_sel-install_obj_types EQ abap_true.
      install_obj_types( ).
    ENDIF.

    IF s_sel-install_demo_types EQ abap_true.
      install_demo_types(  ).
    ENDIF.


    IF     s_sel-install_obj_types  EQ abap_true
        OR s_sel-install_demo_types EQ abap_true.
      COMMIT WORK.
    ENDIF.

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
  pa_demo AS CHECKBOX.

INITIALIZATION.

  CREATE OBJECT lo_install.

AT SELECTION-SCREEN OUTPUT.
  %_pa_type_%_app_%-text = 'install object types'.
  %_pa_demo_%_app_%-text = 'install demo types'.


START-OF-SELECTION.
  s_sel-install_obj_types = pa_type.
  s_sel-install_demo_types = pa_demo.

  lo_install->process( s_sel ).
