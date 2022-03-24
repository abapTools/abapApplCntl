"! <p class="shorttext synchronized" lang="en">Application Message</p>
INTERFACE zif_appl_message
  PUBLIC .


  INTERFACES zif_appl_object .

  ALIASES appl_type
    FOR zif_appl_object~appl_type .
  ALIASES get_appl_type
    FOR zif_appl_object~get_appl_type.
  ALIASES o_appl_message
    FOR zif_appl_object~o_appl_message .
  ALIASES set_appl_type
    FOR zif_appl_object~set_appl_type.

  "! <p class="shorttext synchronized" lang="en">Messagetype Abort</p>
  CONSTANTS c_abort TYPE bapi_mtype VALUE 'A' ##NO_TEXT.
  "! <p class="shorttext synchronized" lang="en">Messagetype Error</p>
  CONSTANTS c_error TYPE bapi_mtype VALUE 'E' ##NO_TEXT.
  "! <p class="shorttext synchronized" lang="en">Messagetype Information</p>
  CONSTANTS c_infor TYPE bapi_mtype VALUE 'I' ##NO_TEXT.
  "! <p class="shorttext synchronized" lang="en">Messagetype Success</p>
  CONSTANTS c_succe TYPE bapi_mtype VALUE 'S' ##NO_TEXT.
  "! <p class="shorttext synchronized" lang="en">Messagetype Warning</p>
  CONSTANTS c_warng TYPE bapi_mtype VALUE 'W' ##NO_TEXT.
  "! <p class="shorttext synchronized" lang="en">Error available ( Y/N )</p>
  DATA error_flag TYPE bapi_mtype READ-ONLY .
  DATA not_error_mtype TYPE bapi_mtype READ-ONLY .

  "! <p class="shorttext synchronized" lang="en">add message with syst or message class</p>
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

  "! <p class="shorttext synchronized" lang="en">add message with bapireturn</p>
  METHODS add_message2
    IMPORTING
      !is_return TYPE bapiret2 .

  "! <p class="shorttext synchronized" lang="en">add message with table of bapireturn</p>
  METHODS add_messtab
    IMPORTING
      !it_messages TYPE bapiret2_t OPTIONAL
      !im_err_obj  TYPE REF TO zif_appl_message OPTIONAL .

  "! <p class="shorttext synchronized" lang="en">check for errors in the message object</p>
  METHODS check_error
    IMPORTING
      !im_errorflag    TYPE bapi_mtype DEFAULT c_infor
    RETURNING
      VALUE(re_return) TYPE xfeld .

  "! <p class="shorttext synchronized" lang="en">clear all messages</p>
  METHODS clear .

  METHODS get_log_handle
    RETURNING
      VALUE(re_log_handle) TYPE balloghndl .
  "! <p class="shorttext synchronized" lang="en">retrieve all current messages</p>
  METHODS get_messages
    RETURNING
      VALUE(re_t_messages) TYPE bapiret2_t .
  "! <p class="shorttext synchronized" lang="en">get message handle</p>
  METHODS get_msg_handle
    RETURNING
      VALUE(re_t_msg_handle) TYPE bal_t_msgh .
  "! <p class="shorttext synchronized" lang="en">get object of message show</p>
  METHODS get_show_message_obj
    RETURNING
      VALUE(ro_show_message) TYPE REF TO zif_appl_show_message .
  "! <p class="shorttext synchronized" lang="en">Application Log: Database: Save logs</p>
  METHODS save_log
    IMPORTING
      !iv_save_all TYPE boolean DEFAULT space .
  "! <p class="shorttext synchronized" lang="en">set error type</p>
  METHODS set_not_error_mtype
    IMPORTING
      !im_mtype TYPE bapi_mtype .
  "! <p class="shorttext synchronized" lang="en">show messages</p>
  METHODS show_messages
    IMPORTING
      !im_mode        TYPE zappl_message_show_type OPTIONAL
      !im_force_table TYPE xfeld OPTIONAL
        PREFERRED PARAMETER im_mode .
ENDINTERFACE.
