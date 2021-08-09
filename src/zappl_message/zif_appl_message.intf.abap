INTERFACE zif_appl_message
  PUBLIC .

  INTERFACES zif_appl_object.

  ALIASES appl_type
    FOR zif_appl_object~appl_type .
  ALIASES o_appl_message
    FOR zif_appl_object~o_appl_message .
  ALIASES get_appl_type
    FOR zif_appl_object~get_appl_type.
  ALIASES set_appl_type
    FOR zif_appl_object~set_appl_type .

  CONSTANTS co_abort TYPE bapi_mtype VALUE 'A'.             "#EC NOTEXT
  CONSTANTS co_error TYPE bapi_mtype VALUE 'E'.             "#EC NOTEXT
  CONSTANTS co_infor TYPE bapi_mtype VALUE 'I'.             "#EC NOTEXT
  CONSTANTS co_succe TYPE bapi_mtype VALUE 'S'.             "#EC NOTEXT
  CONSTANTS co_warng TYPE bapi_mtype VALUE 'W'.             "#EC NOTEXT
  DATA error_flag TYPE bapi_mtype READ-ONLY .
  DATA not_error_mtype TYPE bapi_mtype READ-ONLY .

  METHODS add_message
    IMPORTING
      VALUE(im_mstyp) TYPE bapi_mtype
      VALUE(im_msgid) TYPE symsgid
      VALUE(im_msgno) TYPE symsgno
      !im_msgv1       TYPE any OPTIONAL
      !im_msgv2       TYPE any OPTIONAL
      !im_msgv3       TYPE any OPTIONAL
      !im_msgv4       TYPE any OPTIONAL
      !im_field       TYPE bapi_fld OPTIONAL
      !im_log_no      TYPE balognr OPTIONAL
      !im_log_msg_no  TYPE balmnr OPTIONAL
      !im_parameter   TYPE bapi_param OPTIONAL
      !im_row         TYPE bapi_line OPTIONAL .
  METHODS add_message2
    IMPORTING
      !is_return TYPE bapiret2 .
  METHODS add_messtab
    IMPORTING
      !it_messages TYPE bapiret2_t OPTIONAL
      !im_err_obj  TYPE REF TO zif_appl_message OPTIONAL .
  TYPE-POOLS co .
  METHODS check_error
    IMPORTING
      !im_errorflag    TYPE bapi_mtype DEFAULT co_infor
    RETURNING
      VALUE(re_return) TYPE xfeld .
  METHODS clear .
  METHODS get_log_handle
    RETURNING
      VALUE(re_log_handle) TYPE balloghndl .
  METHODS get_messages
    RETURNING
      VALUE(re_t_messages) TYPE bapiret2_t .
  METHODS get_msg_handle
    RETURNING
      VALUE(re_t_msg_handle) TYPE bal_t_msgh .
  METHODS get_show_message_obj
    RETURNING
      VALUE(ro_show_message) TYPE REF TO zif_appl_show_message.
  METHODS save_log
    IMPORTING
      !iv_save_all TYPE boolean DEFAULT space .
  METHODS set_not_error_mtype
    IMPORTING
      !im_mtype TYPE bapi_mtype .
  METHODS show_messages
    IMPORTING
      !im_mode        TYPE zappl_message_show_type OPTIONAL
      !im_force_table TYPE xfeld OPTIONAL
        PREFERRED PARAMETER im_mode .
ENDINTERFACE.
