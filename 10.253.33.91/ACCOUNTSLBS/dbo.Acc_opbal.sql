-- Object: PROCEDURE dbo.Acc_opbal
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------


CREATE Procedure Acc_opbal
@Sdate Varchar(11),            /* As Mmm Dd Yyyy */
@Edate Varchar(11),            /* As Mmm Dd Yyyy */
@Fdate Varchar(11),            /* As Mmm Dd Yyyy */
@Tdate Varchar(11),            /* As Mmm Dd Yyyy */
@Fcode Varchar(10), 
@Tcode Varchar(10), 
@Statusid Varchar(30), 
@Statusname Varchar(30), 
@Branch Varchar(10), 
@Selectionby Varchar(3), 
@Groupby Varchar(10), 
@Sortby Varchar(50), 
@Reportname Varchar(30), 
@Reportopt Varchar(10), 
@Fld1 Varchar(10), 
@Fld2 Varchar(10), 
@Fld3 Varchar(10)
As
Declare
@@Opendate   As Varchar(11)
/* -------------------------------------------------------------------------- */
If Len(Rtrim(@Fdate)) = 10 
Begin
   Select @Fdate = Left(@Fdate, 3) + ' ' + Substring(@Fdate, 4, 7)
End
If Len(Rtrim(@Sdate)) = 10 
Begin
   Select @Sdate = Left(@Sdate, 3) + ' ' + Substring(@Sdate, 4, 7)
End
If Len(Rtrim(@Tdate)) = 10 
Begin
   Select @Tdate = Left(@Tdate, 3) + ' ' + Substring(@Tdate, 4, 7)
End
If Len(Rtrim(@Edate)) = 10 
Begin
   Select @Edate = Left(@Edate, 3) + ' ' + Substring(@Edate, 4, 7)
End
If @Fdate = ''
Begin
   Select @Fdate = @Sdate
End
If @Tdate = ''
Begin
   Select @Tdate = @Edate
End
If @Reportname <> 'Marginledger'
Begin
/* Get Opendate From Sdate, Fdate Received As Parameter */
   If Upper(@Selectionby) = 'Vdt'
      Begin
         Select @@Opendate = ( Select Left(Convert(Varchar, Isnull(Max(Vdt), 0), 109), 11) From Ledger Where Vtyp = 18 And Vdt < = @Fdate )
      End
   Else
      Begin
         Select @@Opendate = ( Select Left(Convert(Varchar, Isnull(Max(Edt), 0), 109), 11) From Ledger Where Vtyp = 18 And Edt < = @Fdate )
   End
/* -------------------------------------------------------------------------- */     
   If Upper(@Selectionby) = 'Vdt'
      Begin
         If @Sdate = @Fdate
            Begin
  If @@Opendate = @Fdate 
  Begin
                Select Cltcode, Opbal = Sum( Case When Upper(Drcr) = 'D' Then Vamt Else -vamt End)
                From Ledger 
                Where Cltcode = @Fcode And Vdt Like @@Opendate + '%' And Vtyp = 18
                Group By Cltcode
  End
  Else
  Begin
                Select Cltcode, Opbal = Sum( Case When Upper(Drcr) = 'D' Then Vamt Else -vamt End)
                From Ledger 
                Where Cltcode = @Fcode And Vdt > = @@Opendate + ' 00:00:00' And Vdt < @Fdate 
                Group By Cltcode
  End
            End
         Else
            Begin
               Select Cltcode, Opbal = Sum( Case When Upper(Drcr) = 'D' Then Vamt Else -vamt End)
               From Ledger 
               Where Cltcode = @Fcode And Vdt > = @@Opendate + ' 00:00:00' And Vdt < @Fdate 
               Group By Cltcode
            End
      End
   Else
      Begin
         If @Sdate = @Fdate And @@Opendate = @Fdate
            Begin
               Select Cltcode, Opbal = Sum(Balamt)
               From Ledger 
               Where Cltcode = @Fcode And Edt Like @@Opendate + '%' And Vtyp = 18
               Group By Cltcode
            End
         Else
            Begin
               Select Cltcode, Opbal = Sum(Opbal)
               From
               ( Select Cltcode, Opbal = Sum(Balamt)
                 From Ledger 
                 Where Cltcode = @Fcode And Edt Like @@Opendate + '%' And Vtyp = 18
                 Group By Cltcode
                 Union All
                 Select Cltcode, Opbal = Sum( Case When Upper(Drcr) = 'D' Then Vamt Else -vamt End)
                 From Ledger 
                 Where Cltcode = @Fcode And Edt > = @@Opendate + ' 00:00:00' And Edt < @Fdate And Vtyp <> 18
                 Group By Cltcode ) T
               Group By Cltcode
            End
      End
End
If @Reportname = 'Marginledger'
Begin
/* Get Opendate From Sdate, Fdate Received As Parameter */
   If Upper(@Selectionby) = 'Vdt'
      Begin
         Select @@Opendate = ( Select Left(Convert(Varchar, Isnull(Max(Vdt), 0), 109), 11) From Marginledger Where Vtyp = 18 And Vdt < = @Fdate )
      End
   Else
      Begin
         Select @@Opendate = ( Select Left(Convert(Varchar, Isnull(Max(Vdt), 0), 109), 11) From Marginledger Where Vtyp = 18 And Vdt < = @Fdate )
   End
/* -------------------------------------------------------------------------- */     
   If Upper(@Selectionby) = 'Vdt'
      Begin
         If @Sdate = @Fdate
            Begin
  If @@Opendate = @Fdate 
  Begin
                Select Cltcode = Party_code, Opbal = Sum( Case When Upper(Drcr) = 'D' Then Amount Else -amount End)
                From Marginledger 
                Where Party_code = @Fcode And Vdt Like @@Opendate + '%' And Vtyp = 18
                Group By Party_code
  End
  Else
  Begin
      Select Cltcode = Party_code, Opbal = Sum( Case When Upper(Drcr) = 'D' Then Amount Else -amount End)
                From Marginledger 
                Where Party_code = @Fcode And Vdt > = @@Opendate + ' 00:00:00' And Vdt < @Fdate 
                Group By Party_code
  End
            End
         Else
            Begin
     Select Cltcode = Party_code, Opbal = Sum( Case When Upper(Drcr) = 'D' Then Amount Else -amount End)
               From Marginledger 
               Where Party_code = @Fcode And Vdt > = @@Opendate + ' 00:00:00' And Vdt < @Fdate 
               Group By Party_code
            End
      End
   Else
      Begin
         If @Sdate = @Fdate And @@Opendate = @Fdate
            Begin
               Select Cltcode = Party_code, Opbal = Sum(Sett_no)
               From Marginledger 
               Where Party_code = @Fcode And Vdt Like @@Opendate + '%' And Vtyp = 18
               Group By Party_code
            End
         Else
            Begin
               Select Cltcode, Opbal = Sum(Opbal)
               From
               ( Select Cltcode = Party_code, Opbal = Sum(Sett_no)
                 From Marginledger 
                 Where Party_code = @Fcode And Vdt Like @@Opendate + '%' And Vtyp = 18
                 Group By Party_code
                 Union All
                 Select Cltcode = Party_code, Opbal = Sum( Case When Upper(Drcr) = 'D' Then Amount Else -amount End)
                 From Marginledger 
                 Where Party_code = @Fcode And Vdt > = @@Opendate + ' 00:00:00' And Vdt < @Fdate And Vtyp <> 18
                 Group By Party_code) T
               Group By Cltcode
            End
      End
End

GO
