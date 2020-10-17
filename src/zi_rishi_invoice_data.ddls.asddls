@AbapCatalog.sqlViewName: 'ZRISHI_INV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Invoice Data'
define view ZI_Rishi_Invoice_Data as select from zrishi_invoices {
    //zrishi_invoices
    key kunnr,
    invoice_date,
    pay_date,
    priority,
    amount,
//    case when dats_days_between( invoice_date, pay_date ) between 1 and 30 then amount * 5 / 100
//    when dats_days_between( invoice_date, pay_date ) between 30 and 60 then amount * 10 / 100
//    else ''
//    end as interest,
    
    currency
}
