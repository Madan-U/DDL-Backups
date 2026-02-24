-- Object: PROCEDURE dbo.Newacc_trialbalancepartytotal
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------


CREATE Procedure  Newacc_trialbalancepartytotal
/* Report : Trial Balance        
Prints Trial Balance */
@Vdt Varchar(11),               /* As On Date Entered By User */
@Flag Varchar(15),              /* Sort Order For Report - Codewise Or Namewise */
@Viewoption Varchar(10),        /* Options For Accounts Selection - All, Gl, Party */
@Balance Varchar(10),           /* Normal Or Withopbal */
@Stdate Varchar(11),            /* Start Date Entered By User */
@Curryrstdate Varchar(11), /* Start Date Of Financial Year */
@Openentryflag Int, 
@Openingentrydate Varchar(11),  /* O/p Entry Date ( Vtyp = 18 ) Fround From Ledger For Vdt < = Last Date Entered By User */
@Statusid Varchar(20),          /* As Broker/branch/client Etc. */
@Statusname Varchar(20),        /* In Case Of Branch Login Branchcode */
@Sortbydate Varchar(3),         /* Whether Report Is Based On Vdt Or Edt */
@Fromamt    Money,              /* From Amount Entered By User */
@Toamt      Money,              /* To Amount Entered By User */
@Fromac     Varchar(35),        /* From Account/name Entered By User */
@Toac       Varchar(35)         /* To Account/name Entered By User */
As
Declare
@@Selectqury  As Varchar(8000), 
@@Fromtables  As Varchar(2000), 
@@Wherepart   As Varchar(1000), 
@@Wherepart1  As Varchar(500), 
@@Wherepart2  As Varchar(500), 
@@Wherepart3  As Varchar(500), 
@@Addwhere    As Varchar(200), 
@@Groupby     As Varchar(200), 
@@Sortby      As Varchar(200), 
@@Costcode    As Varchar(3), 
@@Whereac     As Varchar(500)
Select @@Groupby = " "
Select @@Sortby  = " "
Select @@Addwhere  = " And A.Accat = 4 " 
If @Statusid = 'Broker'
Begin
   If @Sortbydate = 'Vdt'
   Begin
      Select @@Wherepart1 = " Where Vdt < = '" + @Vdt + " 23:59:59' " 
      Select @@Wherepart2 = " Where Vdt > = '" + @Curryrstdate + " 00:00:00' And Vdt < = '" + @Vdt + " 23:59:59'" 
      Select @@Wherepart3 = " Where Vdt > = '" + @Openingentrydate + " 00:00:00' And Vdt < = '" + @Vdt + " 23:59:59'" 
   End
   Else
   Begin
      Select @@Wherepart1 = " Where Edt < = '" + @Vdt + " 23:59:59' " 
      Select @@Wherepart2 = " Where Edt > = '" + @Curryrstdate + " 00:00:00' And Edt < = '" + @Vdt + " 23:59:59'" 
      Select @@Wherepart3 = " Where Edt > = '" + @Openingentrydate + " 00:00:00' And Edt < = '" + @Vdt + " 23:59:59'" 
   End
End
Else If @Statusid = 'Branch'
Begin
   Select @@Costcode = (Select Costcode From Costmast C, Category C2 Where C2.Category = 'Branch' And C.Catcode = C2.Catcode And Costname = @Statusname )
   If @Sortbydate = 'Vdt'
   Begin
      Select @@Wherepart1 = " Where L2.Vtype = L.Vtyp And L2.Booktype = L.Booktype And L2.Vno = L.Vno And L2.Lno = L.Lno And Costcode = '" + @@Costcode + "' And Vdt < = '" + @Vdt + " 23:59:59' " 
      Select @@Wherepart2 = " Where L2.Vtype = L.Vtyp And L2.Booktype = L.Booktype And L2.Vno = L.Vno And L2.Lno = L.Lno And Costcode = '" + @@Costcode + "' And Vdt > = '" + @Curryrstdate + " 00:00:00' And Vdt < = '" + @Vdt + " 23:59:59'" 
      Select @@Wherepart3 = " Where L2.Vtype = L.Vtyp And L2.Booktype = L.Booktype And L2.Vno = L.Vno And L2.Lno = L.Lno And Costcode = '" + @@Costcode + "' And Vdt > = '" + @Openingentrydate + " 00:00:00' And Vdt < = '" + @Vdt + " 23:59:59'" 
   End
   Else
   Begin
      Select @@Wherepart1 = " Where L2.Vtype = L.Vtyp And L2.Booktype = L.Booktype And L2.Vno = L.Vno And L2.Lno = L.Lno And Costcode = '" + @@Costcode + "' And Edt < = '" + @Vdt + " 23:59:59' " 
      Select @@Wherepart2 = " Where L2.Vtype = L.Vtyp And L2.Booktype = L.Booktype And L2.Vno = L.Vno And L2.Lno = L.Lno And Costcode = '" + @@Costcode + "' And Edt > = '" + @Curryrstdate + " 00:00:00' And Edt < = '" + @Vdt + " 23:59:59'" 
    Select @@Wherepart3 = " Where L2.Vtype = L.Vtyp And L2.Booktype = L.Booktype And L2.Vno = L.Vno And L2.Lno = L.Lno And Costcode = '" + @@Costcode + "' And Edt > = '" + @Openingentrydate + " 00:00:00' And Edt < = '" + @Vdt + " 23:59:59'" 
   End
End
If Len(Rtrim(@Fromac)) <> 0 
Begin
   If Len(Rtrim(@Toac)) <> 0  
       Begin
          If @Flag = 'Codewise' 
             Select @@Addwhere = @@Addwhere + " And L.Cltcode > = '" + @Fromac + "' And L.Cltcode < = '" + @Toac + "' "
          Else
             Select @@Addwhere = @@Addwhere + " And L.Acname > = '" + @Fromac + "' And L.Acname < = '" + @Toac + "' "
       End
    Else
       Begin
          If @Flag = 'Codewise' 
             Select @@Addwhere = @@Addwhere + " And L.Cltcode > = '" + @Fromac + "' "
          Else
             Select @@Addwhere = @@Addwhere + " And L.Acname > = '" + @Fromac + "' "
       End
End
Else
Begin
   If Len(Rtrim(@Toac)) <> 0  
       Begin
          If @Flag = 'Codewise' 
             Select @@Addwhere = @@Addwhere + " And L.Cltcode < = '" + @Toac + "' "
          Else
             Select @@Addwhere = @@Addwhere + " And L.Acname < = '" + @Toac + "' "
       End
End
/*  -- For Broker --  */
/* ------------------ */
If @Statusid = 'Broker'
Begin
/*---- If User Wants To See Normal Trial Balance ---*/
If @Balance = 'Normal'
Begin
   If @Openentryflag = 0   /* Opening Entry ( Vtyp = 18 ) Not Found In Ledger */
   Begin
      Select @@Selectqury = "select Amount = Sum(Case When Drcr = 'D' Then Vamt Else -vamt End)"
      Select @@Fromtables = " From Ledger L Left Outer Join Acmast A On L.Cltcode =  A.Cltcode " 
      Select @@Wherepart  = @@Wherepart1 + @@Addwhere
   End
   Else If @Openentryflag = 1  /* Opening Entry ( Vtyp = 18 ) Found In Ledger For Selected Year */
   Begin
      Select @@Selectqury = "select Amount = Sum(Case When Drcr = 'D' Then Vamt Else -vamt End)"
      Select @@Fromtables = " From Ledger L Left Outer Join Acmast A On L.Cltcode =  A.Cltcode " 
      Select @@Wherepart  = @@Wherepart2 + @@Addwhere
   End
   Else If @Openentryflag = 2  /* Opening Entry ( Vtyp = 18 ) Found In Ledger For Earlier Year */
   Begin
      Select @@Selectqury = "select Amount = Sum(Case When Drcr = 'D' Then Vamt Else -vamt End)"
      Select @@Fromtables = " From Ledger L Left Outer Join Acmast A On L.Cltcode =  A.Cltcode " 
      Select @@Wherepart  = @@Wherepart3 + @@Addwhere
   End
End
/*--- If User Wants To See Trial Balance With Opening Balances ---*/
Else If @Balance = 'Withopbal'
Begin
   If @Openentryflag = 0   /* Opening Entry ( Vtyp = 18 ) Not Found In Ledger */
   Begin
      If @Curryrstdate = @Stdate 
         Begin
            Select @@Selectqury = "select Drtot = Sum(Case When Drcr = 'D' Then Vamt Else 0 End), Crtot = Sum(Case When Drcr = 'C' Then Vamt Else 0 End), Opbal = 0 "
            Select @@Fromtables = " From Ledger L Left Outer Join Acmast A On L.Cltcode =  A.Cltcode " 
            Select @@Wherepart  = @@Wherepart1 + @@Addwhere
         End
      Else
         Begin
           Select @@Selectqury = "select Drtot = Sum(Case When Vtyp <> 18 And Vdt > = '" + @Stdate + "' Then ( Case When Drcr = 'D' Then Vamt Else 0 End) Else 0 End), Crtot = Sum(Case When Vtyp <> 18 And
 
 Vdt > = '" + @Stdate + "' Then ( Case When Drcr = 'C' Then Vamt Else 0 End) Else 0 End), Opbal = Sum(Case When Vdt < '" + @Stdate + "' Then ( Case When Drcr = 'D' Then Vamt Else -vamt End) Else 0 End) "
           Select @@Fromtables = " From Ledger L Left Outer Join Acmast A On L.Cltcode =  A.Cltcode " 
           Select @@Wherepart  = @@Wherepart1 + @@Addwhere
         End
   End
   Else If @Openentryflag = 1  /* Opening Entry ( Vtyp = 18 ) Found In Ledger For Selected Year */
   Begin
      If @Curryrstdate = @Stdate 
         Begin
            Select @@Selectqury = "select Drtot = Sum(Case When Vtyp <> 18 And Vdt > = '" + @Stdate + "' Then ( Case When Drcr = 'D' Then Vamt Else 0 End) Else 0 End), Crtot = Sum(Case When Vtyp <> 18 And
 Vdt > = '" + @Stdate + "' Then ( Case When Drcr = 'C' Then Vamt Else 0 End) Else 0 End), Opbal = Sum(Case When Vtyp = 18 Then ( Case When Drcr = 'D' Then Vamt Else -vamt End) Else 0 End)"
            Select @@Fromtables = " From Ledger L Left Outer Join Acmast A On L.Cltcode =  A.Cltcode " 
            Select @@Wherepart  = @@Wherepart2 + @@Addwhere
         End
      Else
         Begin
           Select @@Selectqury = "select Drtot = Sum(Case When Vtyp <> 18 And Vdt > = '" + @Stdate + "' Then ( Case When Drcr = 'D' Then Vamt Else 0 End) Else 0 End), Crtot = Sum(Case When Vtyp <> 18 And 
Vdt > = '" + @Stdate + "' Then ( Case When Drcr = 'C' Then Vamt Else 0 End) Else 0 End), Opbal = Sum(Case When Vdt < '" + @Stdate + "' Then ( Case When Drcr = 'D' Then Vamt Else -vamt End) Else 0 End) "
           Select @@Fromtables = " From Ledger L Left Outer Join Acmast A On L.Cltcode =  A.Cltcode " 
           Select @@Wherepart  = @@Wherepart2 + @@Addwhere
         End
   End
   Else If @Openentryflag = 2  /* Opening Entry ( Vtyp = 18 ) Found In Ledger For Earlier Year */
   Begin
      Select @@Selectqury = "select Drtot = Sum(Case When Vtyp <> 18 And Vdt > = '" + @Stdate + "' Then ( Case When Drcr = 'D' Then Vamt Else 0 End) Else 0 End), Crtot = Sum(Case When Vtyp <> 18 And Vdt >
 = '" + @Stdate + "' Then ( Case When Drcr = 'C' Then Vamt Else 0 End) Else 0 End), Opbal = Sum(Case When Vdt < '" + @Stdate + "' Then ( Case When Drcr = 'D' Then Vamt Else -vamt End) Else 0 End) "
      Select @@Fromtables = " From Ledger L Left Outer Join Acmast A On L.Cltcode =  A.Cltcode " 
      Select @@Wherepart  = @@Wherepart3 + @@Addwhere
   End
End
End    /* End Og Statusid = 'Broker'  */
/*  -- For Branch Selection --  */
/* ---------------------------- */
If @Statusid = 'Branch'
Begin
/*---- If User Wants To See Normal Trial Balance ---*/
If @Balance = 'Normal'
Begin
   If @Openentryflag = 0   /* Opening Entry ( Vtyp = 18 ) Not Found In Ledger */
   Begin
      Select @@Selectqury = " Select Amount = Sum(Case When L2.Drcr = 'D' Then Camt Else -camt End)"
      Select @@Fromtables = " From Ledger2 L2, Ledger L Left Outer Join Acmast A On L.Cltcode =  A.Cltcode  " 
      Select @@Wherepart  = @@Wherepart1 + @@Addwhere
   End
   Else If @Openentryflag = 1  /* Opening Entry ( Vtyp = 18 ) Found In Ledger For Selected Year */
   Begin
      Select @@Selectqury = " Select Amount = Sum(Case When L2.Drcr = 'D' Then Camt Else -camt End)"
      Select @@Fromtables = " From Ledger2 L2, Ledger L Left Outer Join Acmast A On L.Cltcode =  A.Cltcode  " 
      Select @@Wherepart  = @@Wherepart2 + @@Addwhere
   End
   Else If @Openentryflag = 2  /* Opening Entry ( Vtyp = 18 ) Found In Ledger For Earlier Year */
   Begin
      Select @@Selectqury = " Select Amount = Sum(Case When L2.Drcr = 'D' Then Camt Else -camt End)"
      Select @@Fromtables = " From Ledger2 L2, Ledger L Left Outer Join Acmast A On L.Cltcode =  A.Cltcode  " 
      Select @@Wherepart  = @@Wherepart3 + @@Addwhere
   End
End
Else If @Balance = 'Withopbal'
Begin
   If @Openentryflag = 0   /* Opening Entry ( Vtyp = 18 ) Not Found In Ledger */
   Begin
      If @Curryrstdate = @Stdate 
         Begin
            Select @@Selectqury = "select Drtot = Sum(Case When L2.Drcr = 'D' Then Camt Else 0 End), Crtot = Sum(Case When L2.Drcr = 'C' Then Camt Else 0 End), Opbal = 0 "
            Select @@Fromtables = " From Ledger2 L2, Ledger L Left Outer Join Acmast A On L.Cltcode =  A.Cltcode  " 
            Select @@Wherepart  = @@Wherepart1 + @@Addwhere
         End
      Else
         Begin
           Select @@Selectqury = "select Drtot = Sum(Case When L.Vtyp <> 18 And L.Vdt > = '" + @Stdate + "' Then ( Case When L2.Drcr = 'D' Then Camt Else 0 End) Else 0 End), Crtot = Sum(Case When L.Vtyp <
> 18 And L.Vdt > = '" + @Stdate + "' Then ( Case When L2.Drcr = 'C' Then Camt Else 0 End) Else 0 End), Opbal = Sum(Case When L.Vdt < '" + @Stdate + "' Then ( Case When L2.Drcr = 'D' Then Camt Else -camt End) Else 0 End) "
           Select @@Fromtables = " From Ledger2 L2, Ledger L Left Outer Join Acmast A On L.Cltcode =  A.Cltcode  " 
           Select @@Wherepart  = @@Wherepart1 + @@Addwhere
         End
   End
   Else If @Openentryflag = 1  /* Opening Entry ( Vtyp = 18 ) Found In Ledger For Selected Year */
   Begin
      If @Curryrstdate = @Stdate 
         Begin
            Select @@Selectqury = "select Drtot = Sum(Case When L.Vtyp <> 18 And L.Vdt > = '" + @Stdate + "' Then ( Case When L2.Drcr = 'D' Then Camt Else 0 End) Else 0 End), Crtot = Sum(Case When L.Vtyp 
 <> 18 And L.Vdt > = '" + @Stdate + "' Then ( Case When L2.Drcr = 'C' Then Camt Else 0 End) Else 0 End), Opbal = Sum(Case When L.Vtyp = 18 Then ( Case When L2.Drcr = 'D' Then Camt Else -camt End) Else 0 End)"
            Select @@Fromtables = " From Ledger2 L2, Ledger L Left Outer Join Acmast A On L.Cltcode =  A.Cltcode  " 
            Select @@Wherepart  = @@Wherepart2 + @@Addwhere
         End
      Else
         Begin
           Select @@Selectqury = "select Drtot = Sum(Case When L.Vtyp <> 18 And L.Vdt > = '" + @Stdate + "' Then ( Case When L2.Drcr = 'D' Then Camt Else 0 End) Else 0 End), Crtot = Sum(Case When L.Vtyp <
> 18 And L.Vdt > = '" + @Stdate + "' Then ( Case When L2.Drcr = 'C' Then Camt Else 0 End) Else 0 End), Opbal = Sum(Case When L.Vdt < '" + @Stdate + "' Then ( Case When L2.Drcr = 'D' Then Camt Else -camt End) Else 0 End) "
           Select @@Fromtables = " From Ledger2 L2, Ledger L Left Outer Join Acmast A On L.Cltcode =  A.Cltcode  " 
           Select @@Wherepart  = @@Wherepart2 + @@Addwhere
         End
   End
   Else If @Openentryflag = 2  /* Opening Entry ( Vtyp = 18 ) Found In Ledger For Earlier Year */
   Begin
      Select @@Selectqury = "select Drtot = Sum(Case When L.Vtyp <> 18 And L.Vdt > = '" + @Stdate + "' Then ( Case When L2.Drcr = 'D' Then Camt Else 0 End) Else 0 End), Crtot = Sum(Case When L.Vtyp <> 18 
And L.Vdt > = '" + @Stdate + "' Then ( Case When Drcr = 'C' Then Camt Else 0 End) Else 0 End), Opbal = Sum(Case When L.Vdt < '" + @Stdate + "' Then ( Case When L2.Drcr = 'D' Then Camt Else -camt End) Else 0 End) "
      Select @@Fromtables = " From Ledger2 L2, Ledger L Left Outer Join Acmast A On L.Cltcode =  A.Cltcode  " 
      Select @@Wherepart  = @@Wherepart3 + @@Addwhere
   End
End
End /* End Of Branch Login Or Branch Selection From Broker Login */
Print @@Selectqury + @@Fromtables + @@Wherepart + @@Groupby + @@Sortby  
Exec (@@Selectqury + @@Fromtables + @@Wherepart + @@Groupby + @@Sortby )

GO
