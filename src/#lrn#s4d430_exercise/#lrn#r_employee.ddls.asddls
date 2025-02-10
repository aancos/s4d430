@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee (Entity)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity /LRN/R_Employee
  as select from /lrn/employ_dep
  {
    key employee_id           as EmployeeId,
        first_name            as FirstName,
        last_name             as LastName,
        birth_date            as BirthDate,
        entry_date            as EntryDate,
        department_id         as DepartmentId,
        //    annual_salary as AnnualSalary,
        //    currency_code as CurrencyCode,
        created_by            as CreatedBy,
        created_at            as CreatedAt,
        local_last_changed_by as LocalLastChangedBy,
        local_last_changed_at as LocalLastChangedAt,
        last_changed_at       as LastChangedAt
  }
