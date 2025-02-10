CLASS /lrn/cl_s4d430_generator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D430_GENERATOR IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    TRY.

        NEW lcl_generator_depment_rel( )->generate(  ).

        NEW lcl_generator_employ( )->generate(  ).
        NEW lcl_generator_employ_dep( )->generate(  ).
        NEW lcl_generator_employ_rel( )->generate(  ).
        NEW lcl_generator_employ_ext( )->generate(  ).

        lcl_generator=>save( ).

        out->write( name = `Log of S4D430 data generator`
                    data = lcl_generator=>log ).

      CATCH cx_abap_not_a_table INTO DATA(not_a_table).
        out->write(  not_a_table->get_text(  ) ).

    ENDTRY.


  ENDMETHOD.
ENDCLASS.
