-- Object: PROCEDURE dbo.Rpt_detailperiodledger
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Procedure Rpt_detailperiodledger   
@Fromdt  Datetime,   
@Todt   Datetime,   
@Partycode Varchar(10),   
@Sortby Varchar(4)  
As  
If @Sortby = 'Vdt'   
Begin  
 Select  Left(Convert(Varchar, Vdt, 103), 11), L.Vtyp, Vno, Lno, Drcr,   
  Dramt = Isnull((Case Drcr When 'D' Then Vamt End), 0),   
  Cramt = Isnull((Case Drcr When 'C' Then Vamt End), 0), Balamt, Vdesc,   
  Nar = Isnull(L.Narration, ''),   
   Edt, Edtdiff = Datediff(D, L.Edt , Getdate() ) , Displayvdt = Left(Convert(Varchar, Vdt, 109), 11) , Bt.Description , Bt.Booktype  
  From Account.Dbo.ledger L, Account.Dbo.Vmast V , Account.Dbo.Booktype Bt   
  Where  L.Vdt > = @Fromdt And L.Vdt< = @Todt + ' 23:59:59'  
  And Cltcode = @Partycode And L.Vtyp = V.Vtype   
  And L.Vtyp <> '18'  
 And L.Vtyp = Bt.Vtyp  
 And L.Booktype = Bt.Booktype  
  Order By L.Vdt, Drcr, L.Vtyp  
End  
Else  
Begin  
 Select Left( Convert(Varchar, Edt, 103), 11), L.Vtyp, Vno, Lno, Drcr,   
  Dramt = Isnull((Case Drcr When 'D' Then Vamt End), 0),   
  Cramt = Isnull((Case Drcr When 'C' Then Vamt End), 0), Balamt, Vdesc,   
 Nar = Isnull(L.Narration, ''),   
 Edt, Edtdiff = Datediff(D, L.Edt , Getdate() )  , Bt.Description , Bt.Booktype  
  From Account.Dbo.ledger L, Account.Dbo.Vmast V , Account.Dbo.Booktype Bt  
 Where Edt > = @Fromdt And Edt< = @Todt + ' 23:59:59'  
  And Cltcode = @Partycode And L.Vtyp = V.Vtype   
  And L.Vtyp <> '18'  
 And L.Vtyp = Bt.Vtyp  
 And L.Booktype = Bt.Booktype  
  Order By Edt, Drcr, L.Vtyp  
End

GO
