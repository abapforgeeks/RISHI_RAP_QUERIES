CLASS zcl_rishi_amdp_query DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
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
    TYPES: tt_inv_date TYPE STANDARD TABLE OF lty_inv_data.

    INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS: fetch_invoice_dues
      IMPORTING VALUE(iv_offset)       TYPE i
                VALUE(iv_max_rows)     TYPE i
                VALUE(iv_where_clause) TYPE string
      EXPORTING
                VALUE(et_inv_data)     TYPE tt_inv_date
                VALUE(ev_count)        TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_rishi_amdp_query IMPLEMENTATION.

  METHOD fetch_invoice_dues BY DATABASE PROCEDURE FOR HDB
  LANGUAGE SQLSCRIPT
  OPTIONS READ-ONLY
  USING zrishi_invoices.
    --filter
    lt_invoice_data = APPLY_FILTER (zrishi_invoices,:iv_where_clause);
    --count
     select count(*) into ev_count from zrishi_invoices ;


    et_inv_data = select kunnr,
                         invoice_date,
                         pay_date,
                         priority,
                         CASE priority
                         WHEN '1' THEN 'Low'
                         WHEN '2' THEN 'Medium'
                         WHEN '3' THEN 'High'
                         END as text,
                         CASE when days_between( invoice_date , pay_date ) BETWEEN 1 and 30 then amount * 5 / 100
                              when days_between( invoice_date , pay_date ) between 31 and 60 then amount * 10 / 100
                              else amount * 10 / 100 end
                              as interest,
                         amount,
                         days_between( invoice_date,pay_date) as due,
                         currency
                         FROM :lt_invoice_data
                         limit :iv_max_rows offset :iv_offset;


  ENDMETHOD.

ENDCLASS.
