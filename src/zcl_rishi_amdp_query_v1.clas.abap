CLASS zcl_rishi_amdp_query_v1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF lty_inv_data,
             kunnr(10)    TYPE c,
             invoice_date TYPE zdate,
             pay_date     TYPE zdate,
             priority(1),
             text(10),
             interest     TYPE i,
             amount       TYPE zcurrency,
             due          TYPE i,
             currency     TYPE zcurrency_code,
           END OF lty_inv_data.
    TYPES: tt_inv_data TYPE STANDARD TABLE OF lty_inv_data.

    INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS: fetch_invoice_dues
      IMPORTING
        VALUE(iv_offset)       TYPE i
        VALUE(iv_max_rows)     TYPE i
        VALUE(iv_where_clause) TYPE string
      EXPORTING
        VALUE(ev_count)        TYPE i
        VALUE(et_invoice_data) TYPE tt_inv_data.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_rishi_amdp_query_v1 IMPLEMENTATION.
  METHOD fetch_invoice_dues BY DATABASE PROCEDURE FOR HDB
  LANGUAGE SQLSCRIPT
  OPTIONS READ-ONLY
  USING zrishi_invoices.

    lt_invoice_data = APPLY_FILTER ( zrishi_invoices,:iv_where_clause);

    --count
    select count(*) into ev_count from zrishi_invoices;

    --fetching invoice data.

    et_invoice_data = select kunnr,
                              invoice_date,
                              pay_date,
                              priority,
                              case priority
                              when '1' then 'High'
                              when '2' then 'Medium'
                              when '3' then 'Low'
                              end as text,
                            case when days_between(  invoice_date,pay_date ) between 1 and 30 then amount * 5 / 100
                                 when days_between(  invoice_date,pay_date ) between 30 and 60 then amount * 10 /100
                              else amount * 15 / 100
                              END as interest,
                              amount,
                              days_between( invoice_date,pay_date ) as due,
                              currency
                              FROM :lt_invoice_data
                              ORDER BY kunnr
                              limit :iv_max_rows OFFSET :iv_offset;


  ENDMETHOD.

ENDCLASS.
