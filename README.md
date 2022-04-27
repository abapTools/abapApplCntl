# abapApplCntl - ABAP Application Controller

![Software License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square)
![ABAP Version](https://img.shields.io/badge/ABAP%20-7.20-brightgreen)


## Features

- Object management and control on singleton via customizing
- Message Handler

## Requirements
- [abapGit](https://abapgit.org/)

## First steps

- Import via abapGit
- start Transaction code ZAPPL_FIRST_INSTALL


## Class framework

Classes are created dynamically using interfaces

- Call solely via references to interfaces (no reference to the class necessary)
- see [`customizing`](## Customizing).

```abap
DATA: lo_demo  TYPE REF TO zif_appl_demo.

**Creation object*
lo_demo  ?= zcl_appl_cntl=>get_single_obj( 'DEMO_APPL' ).

**Call any method*
call method lo_demo->run( ).
```

## Message controller
```abap
DATA: lo_appl_message TYPE REF TO zif_appl_message.

**Creation object*
 lo_appl_message = zcl_appl_cntl=>get_appl_message( ).
 
**Check error
lo_appl_message->check_error( ).

**Output messages in modal dialogue window
lo_appl_message->->show_messages('M' ).
```

### Message handling

#### Message handling after the function module

```abap
tables
	object_identifikation = lt_obj_key
exeptions
	error   = 1 
	warning = 2
	others  = 3.
	
if sy-subrc ne 0.
    o_appl_message->add_message(
       EXPORTING
         im_mstyp = sy-msgty
         im_msgid = sy-msgid
         im_msgno = sy-msgno
         im_msgv1 = sy-msgv1
         im_msgv2 = sy-msgv2
         im_msgv3 = sy-msgv3
         im_msgv4 = sy-msgv4.
         ).
endif.
```

#### Message handling after the BAPI module
```abap
CALL METHOD o_appl_message->add_message2( ls_return ).
* or
o_appl_message->add_message2( ls_return ).
```
#### Message handling using message class
```abap
  o_appl_message->add_message(
    EXPORTING
      im_mstyp = 'S'
      im_msgid = 'ZAPPL_MESSAGE'
      im_msgno = 001 ).
  IF 1 = 2.
* for where-used list
    MESSAGE s001(zappl_message).
* This is a success message.
  ENDIF.
```
## Database access

Database access can be realised via own classes. 

The interfaces ZIF_APPL_OBJECT (application object) and ZIF_APPL_OBJECT_DB (DB Object) are to be used.

Class ZCL_APPL_EXAMPLE_DB, for example, can be used as a copy template.

## Customizing
 ZAPPL_OBJ_TYPES

