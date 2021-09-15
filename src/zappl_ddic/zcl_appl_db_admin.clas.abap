CLASS zcl_appl_db_admin DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_appl_db_admin .

    ALIASES change_data
      FOR zif_appl_db_admin~change_data .
    ALIASES new_data
      FOR zif_appl_db_admin~new_data .

    METHODS constructor .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_appl_db_admin IMPLEMENTATION.


  METHOD constructor.

  ENDMETHOD.


  METHOD zif_appl_db_admin~change_data.

    ex_data = im_data.

    ASSIGN COMPONENT 'CHANGED_BY' OF STRUCTURE ex_data TO FIELD-SYMBOL(<field_ch_user>).
    IF <field_ch_user> IS ASSIGNED.
      <field_ch_user> = sy-uname.
    ENDIF.

    ASSIGN COMPONENT 'CHTSTP' OF STRUCTURE ex_data TO FIELD-SYMBOL(<field_ch_date>).
    IF <field_ch_date> IS ASSIGNED.
      <field_ch_date> = sy-datum.
    ENDIF.

  ENDMETHOD.


  METHOD zif_appl_db_admin~new_data.

    ex_data = im_data.

    ASSIGN COMPONENT 'CREATED_BY' OF STRUCTURE ex_data TO FIELD-SYMBOL(<field_cr_user>).
    IF <field_cr_user> IS ASSIGNED.
      <field_cr_user> = sy-uname.
    ENDIF.

    ASSIGN COMPONENT 'CRTSTP' OF STRUCTURE ex_data TO FIELD-SYMBOL(<field_cr_date>).
    IF <field_cr_date> IS ASSIGNED.
      <field_cr_date> = sy-datum.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
