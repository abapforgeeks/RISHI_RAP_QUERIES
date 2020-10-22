CLASS zcl_rishi_purchasequery DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_rishi_purchasequery IMPLEMENTATION.
  METHOD if_rap_query_provider~select.
    "our code
    DATA: lt_purchase_data TYPE STANDARD TABLE OF zrishi_podoc.

    DATA(lv_test) = abap_true.
    "We need to form the query, based on the OData request.
    CASE io_request->get_entity_id(  ).
      WHEN 'ZC_RISHI_PURCHASEQUERY'.


        "1)We always receives request to send back total number of records,based on count framework handles paging info.
        IF io_request->is_total_numb_of_rec_requested( ).
          SELECT COUNT( * ) FROM zrishi_podoc INTO @DATA(lv_count).
          io_response->set_total_number_of_records( lv_count ).
        ENDIF.

        IF io_request->is_data_requested(  ).

          "2)Forming selection fields (for querying data in 'SELECT' Statement)
          DATA(lt_req_elements)  = io_request->get_requested_elements( ).
          DATA(lv_req_elements)  = concat_lines_of( table = lt_req_elements sep = ',').

          "3)Form the Where cluase.
          DATA(lv_sql_filter) = io_request->get_filter(  )->get_as_sql_string(  ).

          "4)Paging Information.
          DATA(lv_offset) = io_request->get_paging(  )->get_offset(  ).
          DATA(lv_page_size) = io_request->get_paging(  )->get_page_size(  ).

          "5)Implementing Search.
          DATA(lv_search_value) = io_request->get_search_expression(  ).

*          DATA(LV_TEST) = 'Purchase document' && lv_po && 'is Created'.
*          data(lv_test2) = | Purchase Document { lv_po } is CreAted  |."CONCATENATION USING NEW SYX.

          DATA(lv_search_sql) = |PO_DESC LIKE '%{ cl_abap_dyn_prg=>escape_quotes(  lv_search_value ) }%'|.

          "if no filter given, keep search term as filter
          IF lv_sql_filter IS INITIAL.
            lv_sql_filter =   lv_search_sql.
          ELSE."If filter given search & actual filter given by the user.
            lv_sql_filter = |  ( { lv_sql_filter } AND { lv_search_sql } ) |.
          ENDIF.


          "6)final Query.(which is dynamic)
          SELECT (lv_req_elements) FROM zrishi_podoc
          WHERE (lv_sql_filter)
          ORDER BY po_document
          INTO CORRESPONDING FIELDS OF TABLE @lt_purchase_data
          OFFSET @lv_offset UP TO @lv_page_size ROWS.
          IF sy-subrc EQ 0.
            io_response->set_data(  lt_purchase_data )."send the response back.
          ENDIF.

        ENDIF.


    ENDCASE.

  ENDMETHOD.

ENDCLASS.
