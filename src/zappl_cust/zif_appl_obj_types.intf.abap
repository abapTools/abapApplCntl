interface ZIF_APPL_OBJ_TYPES
  public .


  interfaces ZIF_APPL_OBJECT .

  methods GET_OBJ_TYPE
    importing
      !IM_OBJ_TYPES_KEY type ZAPPL_OBJ_TYPES_KEY .
  methods SET_OBJ_TYPE .
  methods GET_OBJ_TYPE_KEY
    exporting
      !RE_KEY type ZAPPL_OBJ_TYPES_KEY .
endinterface.
