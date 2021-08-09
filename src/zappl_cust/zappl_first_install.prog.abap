*&---------------------------------------------------------------------*
*& Report ZAPPL_CUST_INIT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zappl_cust_init.

" insert object types

DATA: ls_obj_types TYPE zappl_obj_types,
      lt_obj_types TYPE zappl_obj_types_tt.



INITIALIZATION.

  APPEND VALUE #( type = 'APPL_MESSAGE'
                  class = 'ZCL_APPL_MESSAGE'
                  single = 'X' )
                  TO lt_obj_types.
  APPEND VALUE #( type = 'APPL_MESSAGE_SHOW'
                  class = 'ZCL_APPL_SHOW_MESSAGE'
                  single = ' ' )
                  TO lt_obj_types.
  APPEND VALUE #( type = 'APPL_MESSAGE_EVENT'
                  class = 'ZCL_APPL_MESSAGE_EVENT'
                  single = ' ' )
                  TO lt_obj_types.
  APPEND VALUE #( type = 'APPL_OBJ_TYPE'
                  class = 'ZCL_APPL_OBJ_TYPES'
                  single = 'X' )
                  TO lt_obj_types.
  APPEND VALUE #( type = 'APPL_OBJ_TYPE_DB'
                  class = 'ZCL_APPL_OBJ_TYPES_DB'
                  single = 'X' )
                  TO lt_obj_types.

START-OF-SELECTION.
