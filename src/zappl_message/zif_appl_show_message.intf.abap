"! <p class="shorttext synchronized" lang="en">Show Message</p>
interface ZIF_APPL_SHOW_MESSAGE
  public .


  interfaces ZIF_APPL_OBJECT .

  events DISPLAY_FINISHED .

"! <p class="shorttext synchronized" lang="en">Display of messages in the docking container</p>
  methods DISPLAY_DOCKING
    importing
      !IO_MESSAGE type ref to ZIF_APPL_MESSAGE optional .
  methods DISPLAY_MODAL
    importing
      !IO_MESSAGE type ref to ZIF_APPL_MESSAGE optional .
  methods DISPLAY_MODELESS
    importing
      !IO_MESSAGE type ref to ZIF_APPL_MESSAGE optional .
  methods DISPLAY_HTML
    importing
      !IO_MESSAGE type ref to ZIF_APPL_MESSAGE optional .
  methods SET_VISIBLE
    importing
      !IM_VISIBLE type XFELD .
endinterface.
