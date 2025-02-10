*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

**"* use this source file for the definition and implementation of
**"* local helper classes, interface definitions and type
**"* declarations
*

CLASS lcl_generator DEFINITION ABSTRACT.

  PUBLIC SECTION.

    TYPES tt_log TYPE STANDARD TABLE OF string
                 WITH NON-UNIQUE DEFAULT KEY.

    CLASS-DATA log TYPE tt_log READ-ONLY.

    METHODS
      constructor
        IMPORTING
          i_table_name TYPE tabname
          ir_data      TYPE REF TO data
        RAISING
          cx_abap_not_a_table.

    METHODS generate ABSTRACT.

    CLASS-METHODS
      save.


  PROTECTED SECTION.
    CONSTANTS random_min TYPE i VALUE 0.
    CONSTANTS random_max TYPE i VALUE 1000000.

    CLASS-DATA instances TYPE TABLE OF REF TO lcl_generator.
    DATA random TYPE REF TO cl_abap_random_int.

  PRIVATE SECTION.




    DATA table_name  TYPE tabname.
    DATA r_data      TYPE REF TO data.

    METHODS table_exists
      RETURNING VALUE(result) TYPE abap_bool.

    METHODS is_empty_db
      RETURNING VALUE(result) TYPE abap_bool.

    METHODS delete_db.

    METHODS insert_db.


ENDCLASS.

CLASS lcl_generator IMPLEMENTATION.

  METHOD constructor.

    table_name = i_table_name.

    IF table_exists( ) <> abap_true.
      RAISE EXCEPTION TYPE cx_abap_not_a_table
        EXPORTING
          value = CONV #( table_name ).
    ENDIF.

    r_data = ir_data.
    APPEND me TO instances.

    DATA(seed) = CONV i( cl_abap_context_info=>get_system_date(   ) ).
    me->random = cl_abap_random_int=>create( seed = seed
                                              min = me->random_min
                                              max = me->random_max ).

  ENDMETHOD.

  METHOD save.

    LOOP AT instances INTO DATA(instance).

      IF instance->is_empty_db( ) <> abap_false.
        instance->delete_db(  ).
      ENDIF.

      instance->insert_db(  ).

    ENDLOOP.

    COMMIT WORK.

  ENDMETHOD.

  METHOD table_exists.
    cl_abap_typedescr=>describe_by_name(
       EXPORTING
         p_name = table_name
      EXCEPTIONS
        type_not_found = 1
    ).
    IF sy-subrc = 0.
      result = abap_true.
    ELSE.
      result = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD is_empty_db.

    CLEAR result.

    SELECT SINGLE
      FROM (table_name)
    FIELDS @abap_true
     INTO @result.

  ENDMETHOD.

  METHOD delete_db.
    DELETE FROM (table_name).
    APPEND |Deleted content from table { table_name }| TO log.
  ENDMETHOD.

  METHOD insert_db.

    DATA r_itab TYPE REF TO data.

    CREATE DATA r_itab TYPE TABLE OF (table_name).

    r_itab->* = CORRESPONDING #( r_data->* ).

    INSERT (table_name) FROM TABLE @r_itab->*.

    APPEND |Filled table { table_name } with { lines( r_itab->* ) } rows | TO log.

  ENDMETHOD.


ENDCLASS.

CLASS lcl_generator_depment_rel DEFINITION INHERITING FROM lcl_generator.

  PUBLIC SECTION.

    CONSTANTS c_tabname TYPE tabname VALUE '/LRN/DEPMENT_REL'.


    CONSTANTS c_dep1 TYPE /lrn/department_id VALUE 'SALE'.
    CONSTANTS c_dep2 TYPE /lrn/department_id VALUE 'ADMIN'.

    METHODS constructor
      RAISING cx_abap_not_a_table.

    METHODS generate REDEFINITION.

    DATA departments TYPE TABLE OF /lrn/depment_rel READ-ONLY.

  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_generator_depment_rel IMPLEMENTATION.

  METHOD constructor.

    super->constructor(  i_table_name = c_tabname
                         ir_data = REF #( me->departments ) ).

  ENDMETHOD.

  METHOD generate.

    GET TIME STAMP FIELD DATA(timestamp).

    me->departments =
             VALUE #(
                                     created_at            = timestamp
                                     created_by            = 'GENERATOR'
                                     last_changed_at       = timestamp
                                     local_last_changed_at = timestamp
                                     local_last_changed_by = 'GENERATOR'

                                  (  id                   = c_dep1
                                     description          = 'Sales and Distribution'
                                     head_id              = '000001'
                                     assistant_id         = '000006'
                                   )
                                   ( id                   = c_dep2
                                     description          = 'Administration'
                                     head_id              = '000002'
                                     assistant_id         = '000031'
                                   )
                         ).


  ENDMETHOD.

ENDCLASS.

CLASS lcl_generator_employ_root DEFINITION ABSTRACT INHERITING FROM lcl_generator.

  PUBLIC SECTION.

    CLASS-METHODS
      class_constructor.
  PROTECTED SECTION.

    CLASS-DATA raw_data TYPE TABLE OF /lrn/employ_ext.

  PRIVATE SECTION.


ENDCLASS.

CLASS lcl_generator_employ_root IMPLEMENTATION.

  METHOD class_constructor.

    GET TIME STAMP FIELD DATA(timestamp).

    raw_data = VALUE #(
                            created_at            = timestamp
                            created_by            = 'GENERATOR'
                            last_changed_at       = timestamp
                            local_last_changed_at = timestamp
                            local_last_changed_by = 'GENERATOR'

                            ( employee_id      = '000020'
                              first_name       = 'Janos'
                              last_name        = 'Kovacs'
                              birth_date       = '19980128'
                              entry_date       = '20190401'
                              department_id    = lcl_generator_depment_rel=>c_dep1
                              annual_salary    = '87000.00'
                              currency_code    = 'USD'
                              /lrn/country_zem = 'US'
                            )
                            ( employee_id       = '000023'
                              first_name        = 'Mario'
                              last_name         = 'Rossi'
                              birth_date        = '19791012'
                              entry_date        = '20190901'
                              department_id     = lcl_generator_depment_rel=>c_dep1
                              annual_salary     = '90000.00'
                              currency_code     = 'EUR'
                              /lrn/country_zem  = 'IT'
                              /lrn/title_zem    = 'dott.'
                            )
                            ( employee_id       = '000025'
                              first_name        = 'Jan'
                              last_name         = 'Jansen'
                              birth_date        = '19950413'
                              entry_date        = '20200401'
                              department_id     = lcl_generator_depment_rel=>c_dep1
                              annual_salary     = '80000.00'
                              currency_code     = 'EUR'
                             /lrn/country_zem   = 'NL'
                             )
                            ( employee_id       = '000030'
                              first_name        = 'Eva'
                              last_name         = 'Novakova'
                              birth_date        = '19981204'
                              entry_date        = '20200501'
                              annual_salary     = '65000.00'
                              department_id     = lcl_generator_depment_rel=>c_dep2
                              currency_code     = 'EUR'
                             /lrn/country_zem   = 'AT'
                            )
                            ( employee_id       = '000033'
                              first_name        = 'Jane'
                              last_name         = 'Doe'
                              birth_date        = '20020617'
                              entry_date        = '20220101'
                              annual_salary     = '110000.00'
                              department_id     = lcl_generator_depment_rel=>c_dep2
                              currency_code     = 'USD'
                             /lrn/country_zem   = 'US'
                            )
                          " department heads
                          ( employee_id       = '000001'
                            first_name        = 'John'
                            last_name         =  'Doe'
                            birth_date        =  '19730521'
                            entry_date        =  '20180601'
                            department_id     = lcl_generator_depment_rel=>c_dep1
                            annual_salary     = '170000.00'
                            currency_code     = 'USD'
                            /lrn/country_zem  = 'US'
                          )
                          ( employee_id       = '000002'
                            first_name        = 'Anna'
                            last_name         = 'Malli'
                            birth_date        = '19810807'
                            entry_date        = '20180601'
                            department_id     = lcl_generator_depment_rel=>c_dep2
                            annual_salary     = '150000.00'
                            currency_code     = 'EUR'
                            /lrn/country_zem  = 'ES'
                          )
                          "department assistants
                          ( employee_id       = '000006'
                            first_name        = 'Erika'
                            last_name         = 'Mustermann'
                            birth_date        = '19840204'
                            entry_date        = '20190101'
                            department_id     = lcl_generator_depment_rel=>c_dep1
                            annual_salary     = '110000.00'
                            currency_code     = 'EUR'
                            /lrn/country_zem  = 'DE'
                          )
                          ( employee_id       = '000031'
                            first_name        = 'Jan'
                            last_name         = 'Kowalski'
                            birth_date        = '19880930'
                            entry_date        = '20210101'
                            department_id     = lcl_generator_depment_rel=>c_dep2
                            annual_salary     = '80000.00'
                            currency_code     = 'USD'
                            /lrn/country_zem  = 'US'
                          )

                       ).

  ENDMETHOD.

ENDCLASS.

CLASS lcl_generator_employ DEFINITION INHERITING FROM lcl_generator_employ_root.

  PUBLIC SECTION.

    CONSTANTS c_tabname TYPE tabname VALUE '/LRN/EMPLOY'.

    METHODS constructor
      RAISING cx_abap_not_a_table.

    METHODS generate REDEFINITION.

    DATA employees TYPE TABLE OF /lrn/employ READ-ONLY.

  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_generator_employ IMPLEMENTATION.

  METHOD constructor.

    super->constructor(  i_table_name = c_tabname
                         ir_data = REF #( me->employees ) ).

  ENDMETHOD.

  METHOD generate.

    me->employees = CORRESPONDING #( raw_data ).

  ENDMETHOD.

ENDCLASS.

CLASS lcl_generator_employ_dep DEFINITION INHERITING FROM lcl_generator_employ_root.

  PUBLIC SECTION.

    CONSTANTS c_tabname TYPE tabname VALUE '/LRN/EMPLOY_DEP'.

    METHODS constructor
      RAISING cx_abap_not_a_table.

    METHODS generate REDEFINITION.

    DATA employees TYPE TABLE OF /lrn/employ_dep READ-ONLY.

  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_generator_employ_dep IMPLEMENTATION.

  METHOD constructor.

    super->constructor(  i_table_name = c_tabname
                         ir_data = REF #( me->employees ) ).

  ENDMETHOD.

  METHOD generate.

    me->employees = CORRESPONDING #( raw_data ).

  ENDMETHOD.

ENDCLASS.

CLASS lcl_generator_employ_rel DEFINITION INHERITING FROM lcl_generator_employ_root.

  PUBLIC SECTION.

    CONSTANTS c_tabname TYPE tabname VALUE '/LRN/EMPLOY_REL'.

    METHODS constructor
      RAISING cx_abap_not_a_table.

    METHODS generate REDEFINITION.

    DATA employees TYPE TABLE OF /lrn/employ_rel READ-ONLY.

  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_generator_employ_rel IMPLEMENTATION.

  METHOD constructor.

    super->constructor(  i_table_name = c_tabname
                         ir_data = REF #( me->employees ) ).

  ENDMETHOD.

  METHOD generate.

    me->employees = CORRESPONDING #( raw_data ).

  ENDMETHOD.

ENDCLASS.

CLASS lcl_generator_employ_ext DEFINITION INHERITING FROM lcl_generator_employ_root.

  PUBLIC SECTION.

    CONSTANTS c_tabname TYPE tabname VALUE '/LRN/EMPLOY_EXT'.

    METHODS constructor
      RAISING cx_abap_not_a_table.

    METHODS generate REDEFINITION.

    DATA employees TYPE TABLE OF /lrn/employ_ext READ-ONLY.

  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_generator_employ_ext IMPLEMENTATION.

  METHOD constructor.

    super->constructor(  i_table_name = c_tabname
                         ir_data = REF #( me->employees ) ).

  ENDMETHOD.

  METHOD generate.

    me->employees = CORRESPONDING #( raw_data ).

  ENDMETHOD.

ENDCLASS.
