*"* use this source file for your ABAP unit test classes
CLASS ltcl_appl_cntl DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA:
    "! CDS Test Environment Interface
       environment_obj_types TYPE REF TO if_osql_test_environment.


    CLASS-METHODS:
      		class_Setup,
      	class_Teardown.
    METHODS:
		setup,
  		teardown,
		get_single_obj FOR TESTING
	  		RAISING cx_static_check,
		get_appl_message FOR TESTING
	  		RAISING cx_static_check,
	   create_object FOR TESTING
            RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_appl_cntl IMPLEMENTATION.

  METHOD class_Setup.

    environment_obj_types = cl_osql_test_environment=>create( VALUE #( ( 'ZAPPL_OBJ_TYPES' ) ) ).

    TRY.
        DATA(obj_types) = VALUE zappl_obj_types_tt(
            ( type = 'APPL_MESSAGE'         class = 'ZCL_APPL_MESSAGE'          single = 'X' )
            ( type = 'APPL_MESSAGE_SHOW'    class = 'ZCL_APPL_SHOW_MESSAGE'     single = '' )
            ( type = 'APPL_OBJ_TYPE'        class = 'ZCL_APPL_OBJ_TYPES'        single = 'X' )
            ( type = 'APPL_OBJ_TYPE_DB'     class = 'ZCL_APPL_OBJ_TYPES_DB'     single = 'X' )
            ( type = 'APPL_MESSAGE_EVENT'   class = 'ZCL_APPL_MESSAGE_EVENT'    single = '' )
            ( type = 'APPL_HTML_BTN'        class = 'ZCL_APPL_HTML_BUTTON'      single = '' )
            ).
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

    environment_obj_types->insert_test_data( obj_types ).

  ENDMETHOD.

  METHOD setup.

    environment_obj_types->clear_doubles( ).
  ENDMETHOD.

  METHOD teardown.

  ENDMETHOD.

  METHOD class_Teardown.
    environment_obj_types->destroy( ).
  ENDMETHOD.

  METHOD get_single_obj.
    DATA lo_show_message TYPE REF TO zif_appl_show_message.


    lo_show_message ?= zcl_appl_cntl=>get_single_obj( im_appl_type = 'APPL_MESSAGE_SHOW' ).

  ENDMETHOD.

  METHOD get_appl_message.


    	"Test



  ENDMETHOD.
  METHOD create_object.

  ENDMETHOD.

ENDCLASS.
