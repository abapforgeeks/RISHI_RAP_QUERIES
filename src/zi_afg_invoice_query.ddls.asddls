@EndUserText.label: 'Query'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_AFG_AMDP_QUERY'
@Search.searchable: true
define custom entity zi_afg_invoice_query 
 {
 @UI.lineItem: [{position: 10,label: 'Customer Number' }]
  key kunnr    : abap.char(10);
 @UI.lineItem: [{position: 20,label: 'Invoice Date' }]
  invoice_date : abap.dats;
 @UI.lineItem: [{position: 30,label: 'Pay Date' }]
  pay_date     : abap.dats;
 @UI.lineItem: [{position: 40,label: 'Priority' }]
 @UI.selectionField: [{ position: 10 }]
 @Search.defaultSearchElement: true
  priority     : abap.char(10);
 @UI.lineItem: [{position: 50,label: 'Amount' }]
 @Semantics.amount.currencyCode: 'currency'
  amount       : abap.curr(13,2);
 @UI.lineItem: [{position: 60,label: 'Due' }]
  due          : abap.int1;
 @UI.lineItem: [{position: 70,label: 'Interest to be Paid' }]
  interest     : abap.int1;
 @UI.lineItem: [{position: 80,label: 'Currency' }]
  currency     : abap.cuky; 
}

     
