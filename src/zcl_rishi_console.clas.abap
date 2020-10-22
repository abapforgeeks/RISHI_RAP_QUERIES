CLASS zcl_rishi_console DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_rishi_console IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    zcl_rishi_amdp_query_v1=>fetch_invoice_dues(
      EXPORTING
        iv_offset       = 0
        iv_max_rows     = 20
        iv_where_clause = 'KUNNR = 10001 OR KUNNR = 10002'
      IMPORTING
        et_invoice_data     = DATA(lt_data)
        ev_count            = DATA(lv_count)
    ).
    out->write( lt_data ).
    OUT->WRITE( LV_COUNT ).
  ENDMETHOD.

ENDCLASS.
