CLASS zcl_afg_amdp_query DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_afg_amdp_query IMPLEMENTATION.
  METHOD if_rap_query_provider~select.
   TYPES: BEGIN OF lty_inv_data,
             kunnr(10)    TYPE c,
             invoice_date TYPE zdate,
             pay_date     TYPE  zdate,
             priority(1),
             text(10),
             interest     TYPE i,
             amount       TYPE zcurrency,
             due          TYPE i,
             currency     TYPE zcurrency_code,
           END OF lty_inv_data.
    DATA: lt_final_inv_data TYPE STANDARD TABLE OF lty_inv_data.

    CASE io_request->get_entity_id(  ).
      WHEN 'ZI_AFG_INVOICE_QUERY'.
        IF io_request->is_data_requested(  ).

          "where clause
          DATA(lv_where_clause) = io_request->get_filter(  )->get_as_sql_string(  ).

          "Paging Information.
          DATA(lv_offset) = io_request->get_paging(  )->get_offset(  ).
          DATA(lv_page_size) = io_request->get_paging(  )->get_page_size(  ).

          zcl_rishi_amdp_query=>fetch_invoice_dues(
            EXPORTING
              iv_offset       = CONV #( lv_offset )
              iv_max_rows     = CONV #( lv_page_size )
              iv_where_clause = lv_where_clause
            IMPORTING
              et_inv_data     =  DATA(lt_inv_data)
              ev_count        = DATA(lv_count)
          ).
          IF lt_inv_data IS NOT INITIAL.
          MOVE-CORRESPONDING lt_inv_data to lt_final_inv_data.

            io_response->set_data( lt_final_inv_data ).
          ENDIF.

          IF io_request->is_total_numb_of_rec_requested(  ).
            io_response->set_total_number_of_records( CONV #( lv_count ) ).
          ENDIF.

        ENDIF.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.
