"! <p class="shorttext synchronized" lang="en">Show Message</p>
INTERFACE zif_appl_show_message
  PUBLIC .


  INTERFACES zif_appl_object .

  EVENTS display_finished .

  "! <p class="shorttext synchronized" lang="en">Display of messages in the docking container</p>
  METHODS display_docking
    IMPORTING
      !io_message TYPE REF TO zif_appl_message OPTIONAL .
  METHODS display_modal
    IMPORTING
      !io_message TYPE REF TO zif_appl_message OPTIONAL .
  METHODS display_modeless
    IMPORTING
      !io_message TYPE REF TO zif_appl_message OPTIONAL .
  METHODS display_html
    IMPORTING
      !io_message TYPE REF TO zif_appl_message OPTIONAL .
  METHODS set_visible
    IMPORTING
      !im_visible TYPE xfeld .
ENDINTERFACE.
