@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Department (Query with aggregations)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity /LRN/C_Department_Qry

  // 1. Distinct
  //  as select distinct from /LRN/C_Employee_Fnc
  //  {
  //    DepartmentId,
  //    DepartmentDescription
  //  }
  // 2. Aggregation and Group
  //  as select from /LRN/C_Employee_Fnc
  //  {
  //    DepartmentId,
  //    DepartmentDescription,
  //    avg( CompanyAffiliation as abap.dec(11,1) ) as AverageAffiliation,
  //    @Semantics.amount.currencyCode: 'CurrencyCodeUSD'
  //    sum( MonthlySalaryConverted )               as TotalMonthlySalary,
  //    CurrencyCodeUSD
  //  }
  //  group by
  //    DepartmentId,
  //    DepartmentDescription,
  //    CurrencyCodeUSD

  // 3. parameters
  //  with parameters
  //    p_target_curr : /dmo/currency_code,
  //    @EndUserText.label: 'Date of evaluation'
  //    @Environment.systemField: #SYSTEM_DATE
  //    p_date        : abap.dats
  //  as select from /LRN/C_Employee_Par(
  //                   p_target_curr: $parameters.p_target_curr,
  //                   p_date:        $parameters.p_date )
  //  {
  //    DepartmentId,
  //    DepartmentDescription,
  //    avg( CompanyAffiliation as abap.dec(11,1) ) as AverageAffiliation,
  //    @Semantics.amount.currencyCode: 'CurrencyCode'
  //    sum( AnnualSalaryConverted )               as TotalSalary,
  //    CurrencyCode
  //  }
  //  group by
  //    DepartmentId,
  //    DepartmentDescription,
  //    CurrencyCode


  // 4. Join
  with parameters
    p_target_curr : /dmo/currency_code,
    @EndUserText.label: 'Date of evaluation'
    @Environment.systemField: #SYSTEM_DATE
    p_date        : abap.dats
  as select from     /LRN/C_Employee_Par(
                       p_target_curr: $parameters.p_target_curr,
                       p_date:        $parameters.p_date ) as e
    right outer join /LRN/R_Department_Rel                 as d
      on e.DepartmentId = d.Id
  {
    d.Id,
    d.Description,
    avg( e.CompanyAffiliation as abap.dec(11,1) ) as AverageAffiliation,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    sum( e.AnnualSalaryConverted )                as TotalSalary,
    e.CurrencyCode
  }
  group by
    d.Id,
    d.Description,
    e.CurrencyCode
