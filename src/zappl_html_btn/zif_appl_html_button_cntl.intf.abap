interface ZIF_APPL_HTML_BUTTON_CNTL
  public .


  interfaces ZIF_APPL_OBJECT .

  methods CREATE_BTN
    importing
      !I_BTN type ZAPPL_HTML_BUTTON
    returning
      value(RO_BUTTON) type ref to ZIF_APPL_HTML_BUTTON .
endinterface.
