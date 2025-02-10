extend view entity /LRN/C_Employee_Ext with
association [1..1] to I_Country as _/LRN/CountryZem
  on $projection./LRN/CountryZem = _/LRN/CountryZem.Country
  {

    Employee./LRN/TitleZem,
    Employee./LRN/CountryZem,

    concat_with_space( Employee.FirstName,
                       Employee.LastName,
                       1  )                as /LRN/FullNameZem,

    _/LRN/CountryZem.IsEuropeanUnionMember as /LRN/EUBasedZem

  }
