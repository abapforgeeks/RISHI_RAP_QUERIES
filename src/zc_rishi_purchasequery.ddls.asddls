@EndUserText.label: 'Query Example'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_RISHI_PURCHASEQUERY'
@Search.searchable: true
define root custom entity ZC_RISHI_PURCHASEQUERY
 
{

      @UI.lineItem      : [{ position:  10 ,label: 'Purchase Document'}]
  key po_document       : zebeln;
        
      @UI.lineItem      : [{ position:  20 ,label: 'Purchase Desc'}]
      @Search.defaultSearchElement: true
      po_desc           : zpo_desc;
      @UI.lineItem      : [{ position:  30 ,label: 'Po Status'}]
      @UI.selectionField: [{ position: 10 }]
      po_status         : zpo_status;
      @UI.lineItem      : [{ position:  40,label: 'PO Priority' }]
      @UI.selectionField: [{ position: 20 }]
      po_priority       : zpo_priority;
      @UI.lineItem      : [{ position:  50,label: 'Comapny Code' }]
      @EndUserText.label: 'Company Code'
      ccode             : abap.char(4);
      @UI.lineItem      : [{ position:  60,label: 'Created By' }]
      create_by         : zcreated_by;
      @UI.lineItem      : [{ position:  70,label: 'Created On' }]
      created_date_time : timestampl;
      @UI.lineItem      : [{ position:  80 ,label: 'Changed On'}]
      changed_date_time : timestampl;


}
