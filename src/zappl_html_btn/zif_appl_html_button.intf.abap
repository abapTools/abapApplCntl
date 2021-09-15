interface ZIF_APPL_HTML_BUTTON
  public .


  interfaces ZIF_APPL_OBJECT .

  methods SET_INACTIVE .
  methods SET_ACTIVE .
  methods GET_BTN_FIELDS
    returning
      value(RE_BTN_FIELDS) type ZAPPL_HTML_BUTTON .
  methods GET_BTN_TYPE
    returning
      value(RE_BTN_TYPE) type ZAPPL_HTML_BTN_TYPE .
endinterface.
