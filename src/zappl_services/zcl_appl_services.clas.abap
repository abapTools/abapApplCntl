class ZCL_APPL_SERVICES definition
  public
  create public .

public section.

  class-methods CLASS_CONSTRUCTOR .
  class-methods CREATE_DYNAMIC_TABLE
    importing
      !IT_FIELDCATALOG type LVC_T_FCAT
    exporting
      !EP_TABLE type ref to DATA
    exceptions
      CREATE_ERROR .
  class-methods CREATE_DYNAMIC_STRUCTURE
    importing
      !IT_FIELDCATALOG type LVC_T_FCAT
    exporting
      !EP_LINE type ref to DATA
    exceptions
      CREATE_ERROR .
  class-methods GET_NEW_GUID
    returning
      value(RE_GUID) type SYSUUID_X16 .

protected section.

  class-methods GET_LENGTH
    importing
      !IS_FCAT type LVC_S_FCAT
    returning
      value(RE_LENGTH) type I .
  PRIVATE SECTION.

    CLASS-DATA o_appl_message TYPE REF TO zif_appl_message .
ENDCLASS.



CLASS ZCL_APPL_SERVICES IMPLEMENTATION.


  METHOD class_constructor.

    " Get global message object
    o_appl_message = zcl_appl_cntl=>get_appl_message( ).

  ENDMETHOD.


  METHOD create_dynamic_structure.

    DATA: ls_fcat        TYPE lvc_s_fcat,
          lo_struc_descr TYPE REF TO cl_abap_structdescr,
          ls_field       TYPE abap_componentdescr,
          lt_fields      TYPE abap_component_tab,
          lv_name        TYPE string,
          lv_length      TYPE i,
          lv_decimals    TYPE i,
          lv_int1        TYPE int1,
          lv_int2        TYPE int2.
    DATA l_err_message TYPE string.
    DATA lx_err_struct TYPE REF TO cx_sy_struct_creation.

    LOOP AT it_fieldcatalog INTO ls_fcat.
      CLEAR: ls_field.
      ls_field-name = ls_fcat-fieldname.

*   Referenztabellenname für internes Tabellenfeld
      IF ls_fcat-ref_table IS NOT INITIAL.
        CLEAR lv_name.
        IF ls_fcat-ref_field IS INITIAL .
          CONCATENATE ls_fcat-ref_table '-' ls_fcat-fieldname INTO lv_name.
        ELSE.
          CONCATENATE ls_fcat-ref_table '-' ls_fcat-ref_field INTO lv_name.
        ENDIF.

        ls_field-type ?= cl_abap_typedescr=>describe_by_name( lv_name ).

*   Datentyp im ABAP Dictionary
      ELSEIF ls_fcat-datatype IS NOT INITIAL.
        CASE ls_fcat-datatype. "#EC CI_DATN_TIMN_OK
          WHEN 'CHAR'.
            lv_length = get_length( ls_fcat ).
            ls_field-type ?= cl_abap_elemdescr=>get_c( p_length = lv_length ).

          WHEN 'NUMC'.
            lv_length = get_length( ls_fcat ).
            ls_field-type ?= cl_abap_elemdescr=>get_n( p_length = lv_length ).

          WHEN 'CURR'.
            lv_length = ls_fcat-intlen.
            ls_field-type ?= cl_abap_elemdescr=>get_p( p_length   = lv_length
                                                       p_decimals = 2 ).
          WHEN 'DATS'.
            ls_field-type ?= cl_abap_elemdescr=>get_d( ).

          WHEN 'FLTP'.
            ls_field-type ?= cl_abap_elemdescr=>get_f( ).

          WHEN 'INT1'.
            ls_field-type ?= cl_abap_datadescr=>describe_by_data( lv_int1 ).

          WHEN 'INT2'.
            ls_field-type ?= cl_abap_datadescr=>describe_by_data( lv_int2 ).

        ENDCASE.

*   ABAP-Datentyp (C,D,N,...)
      ELSEIF ls_fcat-inttype IS NOT INITIAL.
        CASE ls_fcat-inttype. "#EC CI_INT8_OK  "#EC CI_UTCL_OK
          WHEN 'C'.       "Zeichenfolge  (Character)
            lv_length = get_length( ls_fcat ).
            ls_field-type ?= cl_abap_elemdescr=>get_c( p_length = lv_length ).

          WHEN 'N'.       "Zeichenfolge nur mit Ziffern
            lv_length = get_length( ls_fcat ).
            ls_field-type ?= cl_abap_elemdescr=>get_n( p_length = lv_length ).

          WHEN 'D'.       "Datum (Date: JJJJMMTT)
            ls_field-type ?= cl_abap_elemdescr=>get_d( ).

          WHEN 'T'.       "Zeitpunkt (Time: HHMMSS)
            ls_field-type ?= cl_abap_elemdescr=>get_t( ).

          WHEN 'X'.       "Bytefolge (heXadecimal)
            lv_length = get_length( ls_fcat ).
            ls_field-type ?= cl_abap_elemdescr=>get_x( p_length = lv_length ).

          WHEN 'I'.       "Ganze Zahl (4-Byte Integer mit Vorzeichen)
            ls_field-type ?= cl_abap_elemdescr=>get_i( ).

          WHEN 'P'.       "Gepackte Zahl (Packed)
            lv_length = get_length( ls_fcat ).
            lv_decimals = ls_fcat-decimals.
            ls_field-type ?= cl_abap_elemdescr=>get_p( p_length   = lv_length
                                                       p_decimals = lv_decimals ).

          WHEN 'F'.       "Gleitpunktzahl (Float) mit 8 Byte Genauigkeit
            ls_field-type ?= cl_abap_elemdescr=>get_f( ).

          WHEN 'g'.       "Zeichenfolge mit variabler Länge (ABAP-Typ STRING)
            ls_field-type ?= cl_abap_elemdescr=>get_string( ).

          WHEN 'y'.       "Bytefolge mit variabler Länge (ABAP-Typ XSTRING)
            ls_field-type ?= cl_abap_elemdescr=>get_xstring( ).

          WHEN 'b'.       "1-Byte Integer, ganze Zahl <= 254
            ls_field-type ?= cl_abap_datadescr=>describe_by_data( lv_int1 ).

          WHEN 's'.       "2-Byte Integer, nur für Längenfeld vor LCHR oder LRAW
            ls_field-type ?= cl_abap_datadescr=>describe_by_data( lv_int2 ).

        ENDCASE.

*   Bezeichnung einer Domäne
      ELSEIF ls_fcat-domname IS NOT INITIAL.

*   Datenelement (semantische Domäne)
      ELSEIF ls_fcat-dd_roll IS NOT INITIAL.
        ls_field-type ?= cl_abap_typedescr=>describe_by_name( ls_fcat-dd_roll ).

*   Datenelement für F1-Hilfe
      ELSEIF ls_fcat-rollname IS NOT INITIAL.
        ls_field-type ?= cl_abap_typedescr=>describe_by_name( ls_fcat-rollname ).

      ENDIF.

      IF ls_field-type IS INITIAL.
*   Fehlermeldung!!!!
        CONTINUE.
      ENDIF.

      APPEND ls_field TO lt_fields.

    ENDLOOP.

    CHECK lt_fields IS NOT INITIAL.


* Strukture generieren
    TRY .
        lo_struc_descr ?= cl_abap_structdescr=>create( lt_fields ).

      CATCH cx_sy_struct_creation INTO lx_err_struct.
        l_err_message = lx_err_struct->get_text( ).

        CALL METHOD o_appl_message->add_message
          EXPORTING
            im_mstyp = 'E'
            im_msgid = 'ZAPPL_SERVICES'
            im_msgno = '003'.
        IF 1 = 2.
          MESSAGE e003(zappl_services). "Bei der Erzeugung eines Strukturtyps ist eine Ausnahme aufgetreten.
        ENDIF.

        RAISE create_error.

    ENDTRY.

    CHECK lo_struc_descr IS BOUND.

    CREATE DATA ep_line TYPE HANDLE lo_struc_descr.

  ENDMETHOD.


  METHOD create_dynamic_table.

 DATA: lr_line             TYPE REF TO data,
        lo_struc_descr      TYPE REF TO cl_abap_structdescr,
        lo_table_descr      TYPE REF TO cl_abap_tabledescr.

  CALL METHOD create_dynamic_structure
    EXPORTING
      it_fieldcatalog = it_fieldcatalog
    IMPORTING
      ep_line         = lr_line
    EXCEPTIONS
      create_error    = 4
      OTHERS          = 8.
  IF sy-subrc <> 0.
    RAISE create_error.
  ENDIF.

  lo_struc_descr ?= cl_abap_structdescr=>describe_by_data_ref( lr_line ).

  TRY .
      lo_table_descr ?= cl_abap_tabledescr=>create( p_line_type = lo_struc_descr  ).

    CATCH cx_sy_table_creation.
      CALL METHOD o_appl_message->add_message
        EXPORTING
          im_mstyp = 'E'
          im_msgid = 'ZAPPL_SERVICES'
          im_msgno = '004'.
      IF 1 = 2.
        MESSAGE e004(ZAPPL_SERVICES). "Bei der Erzeugung eines Tabellentyps ist eine Ausnahme aufgetreten.
      ENDIF.

      RAISE create_error.

  ENDTRY.


  CHECK lo_table_descr IS BOUND.

  CREATE DATA ep_table TYPE HANDLE lo_table_descr.


  ENDMETHOD.


  METHOD get_length.


    DATA: lv_length       TYPE lvc_outlen.

    CLEAR re_length.

    IF is_fcat-dd_outlen > 0.
      lv_length = is_fcat-dd_outlen.
    ENDIF.

    IF is_fcat-intlen > 0.
      IF is_fcat-dd_outlen > is_fcat-intlen.
        lv_length = is_fcat-dd_outlen.
      ELSE.
        lv_length = is_fcat-intlen.
      ENDIF.
    ENDIF.

    IF lv_length = 0.
      lv_length = is_fcat-outputlen.
    ENDIF.

    IF lv_length = 0.
      IF is_fcat-outputlen > is_fcat-intlen.
        lv_length = is_fcat-outputlen.
      ELSE.
        lv_length = is_fcat-intlen.
      ENDIF.
    ENDIF.

    re_length = lv_length.

  ENDMETHOD.


  METHOD get_new_guid.
    TRY.
        re_guid = cl_system_uuid=>create_uuid_x16_static( ).
      CATCH cx_uuid_error INTO DATA(e_txt).
        o_appl_message->add_message(
          EXPORTING
            im_mstyp = o_appl_message->co_error
            im_msgid = 'ZAPPL_SERVICES'
            im_msgno = 005
            im_msgv1 = e_txt->get_text( )
            ).
        IF 1 = 2.
          MESSAGE e005(zappl_services) WITH '&1' '&2' .
          " Error during GUID creation &1 &2
        ENDIF.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
