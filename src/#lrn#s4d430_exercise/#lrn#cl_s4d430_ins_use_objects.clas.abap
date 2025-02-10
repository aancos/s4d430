CLASS /lrn/cl_s4d430_ins_use_objects DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D430_INS_USE_OBJECTS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

* 1) Use dictionary objects as data types
**********************************************************************
* data var1 type /lrn/s4d430_ind_domain.     " domain - not supported
    DATA var2 TYPE /lrn/s4d430_ind_delem.    " data element
    DATA var3 TYPE /lrn/s4d430_ind_struct.   " structure
    DATA var4 TYPE /lrn/s4d430_ind_ttype.    " table type
    DATA var5 TYPE /lrn/s4d430_ind.          " database table

* 2) Use CDS obects as data types
**********************************************************************
    DATA var6 TYPE /lrn/s4d430_ind_cds_view. " only CDS entities supported

* 3) use dictionary objects in ABAP SQL
**********************************************************************
    SELECT
      FROM /lrn/s4d430_ind                   " database table supported
    FIELDS *
      INTO TABLE @DATA(result1).

* 3) use CDS objects in ABAP SQL
**********************************************************************
    SELECT
      FROM /lrn/s4d430_ind_cds_view          " cds view entity supported
    FIELDS *
      INTO TABLE @DATA(result2).

  ENDMETHOD.
ENDCLASS.
