@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee (Consumption)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #D,
    sizeCategory:   #M,
    dataClass:      #MASTER
}
define view entity /LRN/C_Employee_Exp
  as select from /LRN/R_Employee_Rel
  {
    key EmployeeId,
        FirstName,
        LastName,
        DepartmentId,

        _Department.Description                  as DepartmentDescription,
        _Department._Assistant.LastName          as AssistantName,

        @EndUserText.label: 'Employee Role'
        case EmployeeId
          when _Department.HeadId      then 'H'
          when _Department.AssistantId then 'A'
          else ' '
        end                                      as EmployeeRole,

        @EndUserText.label: 'Monthly Salary'
        @Semantics.amount.currencyCode: 'CurrencyCode'
        cast( AnnualSalary as abap.fltp ) / 12.0 as MonthlySalary,
        CurrencyCode,

        /* Associations */
        _Department

  }
