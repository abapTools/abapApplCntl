FUNCTION-POOL zappl_message.                "MESSAGE-ID ..

INCLUDE <icon>.

CLASS lcl_event_receiver DEFINITION DEFERRED.

DATA: gt_messages_alv TYPE zappl_message_alv_t,
      gt_fcat         TYPE zappl_lvc_fcat_tt.

DATA: o_event_receiver   TYPE REF TO lcl_event_receiver,
      o_appl_message     TYPE REF TO zif_appl_message,
      o_message          TYPE REF TO zif_appl_message,
      o_custom_container TYPE REF TO cl_gui_custom_container,

      g_control_handle   TYPE balcnthndl.
