@AbapCatalog.sqlViewName: 'ZPO_UMTEST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Test Query'
define view zi_test_query_Association as select from zrishi_podoc
association[0..*] to zc_rishi_purchasequery as _test on $projection.po_document = _test.po_document  {
    //ZC_RISHI_PURCHASEQUERY
    @UI.facet: [
    { 
    id:'Items',
    type:#LINEITEM_REFERENCE,
    label:'Items',
    targetQualifier:'_test'  
    }
    ]
    key po_document,
    po_desc,
    po_status,
    po_priority,
    ccode,
    create_by,
    created_date_time,
    changed_date_time,
    _test
}
