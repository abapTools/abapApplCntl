*----------------------------------------------------------------------*
***INCLUDE LZAPPL_CUSTO01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module PBO_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo_0100 OUTPUT.
  PERFORM pbo_0100.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module PBO_0110 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo_0110 OUTPUT.
  BREAK-POINT.

ENDMODULE.
