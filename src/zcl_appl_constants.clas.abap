CLASS zcl_appl_constants DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

PUBLIC SECTION.
CLASS-METHODS: CLASS_CONSTRUCTOR.
CLASS-DATA: MESSAGE_SHOW_TYP type zappl_message_show_type.
PROTECTED SECTION.
PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_APPL_CONSTANTS IMPLEMENTATION.


  METHOD class_constructor.
    TRY.
        message_show_typ = zcl_appl_cntl=>get_global_parameter( 'MESSAGE_SHOW_TYP' ).
      CATCH zcx_appl_glb_par.
        "handle exception
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
