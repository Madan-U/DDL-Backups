-- Object: PROCEDURE dbo.Sp_voucherreport
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------


CREATE  Procedure [dbo].[Sp_voucherreport]
(  
 @Reptype Varchar(2),   
 @Fromdate Varchar(11),   
 @Todate Varchar(11),   
 @Frombankcode Varchar(10),   
 @Tobankcode Varchar(10),   
 @Fromclientid Varchar(10),   
 @Toclientid Varchar(10),   
 @Statusid Varchar(12),   
 @Statusname Varchar(12),   
 @Datetype varchar(6),  
 @VamtFr varchar(20),  
 @VamtTo varchar(20),  
 @Chqno  varchar(15),  
 @PageSize varchar(3),  
 @VnoFr varchar(12),  
 @VnoTo varchar(12)  
)  
As
Declare @Strsql As Varchar(1000)  



If  @Statusid = 'broker'  
Begin  
 
 If @Reptype = '16'  
    Begin  
           --Cheque Is Cancelled.  
    Set @Strsql = "select  C.Ddno, A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, " +   
    " A.Drcr, A.Vamt, Convert(Varchar(11), C.Dddt, 109) Cdt, A.Narration From Ledger A" +   
    " Inner Join (Select Vno, Cltcode, Acname, Vtyp, Booktype From Ledger Where Vtyp = 16 And Drcr = 'D' "   
    If  @Frombankcode <> ''   
    Begin  
      Set @Strsql = @Strsql + " And (Cltcode > = ' " + @Frombankcode + "' And Cltcode < = '" + @Tobankcode + "')"  
    End  
      
    Set @Strsql = @Strsql + " ) D On A.Vno = D.Vno And A.Vtyp = D.Vtyp And A.Booktype = D.Booktype " +  
    " Inner Join Ledger1 C On A.Vno = C.Vno And A.Vtyp = C.Vtyp And A.Booktype = C.Booktype " +  
    " Where A.Vno <> '' And A.Vtyp = 16 And A.Drcr = 'C' And A.Vdt > = '" + @Fromdate + "' And A.Vdt < = '" + @Todate + " 23:59:59'" --test   
    If @Chqno <> ''    
    Begin  
      Set @Strsql = @Strsql + "and C.Ddno = '" + @Chqno + "' "   
    End  
     If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End  
     If @VnoFr <> '' or @VnoTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
     End   
     If @Fromclientid <> ''  
      Begin  
       Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "')"   
      End  
    /* Set @Strsql = @Strsql + " Group By C.Ddno, A.Vtyp, A.Cltcode, A.Vno, A.Vdt, A.Acname, A.Drcr, A.Vamt, C.Dddt, A.Narration Order By A.Vno, A.Vdt, A.Drcr Desc " */  
    Set @Strsql = @Strsql + " Order By A.Vno, A.Vdt, A.Drcr Desc "   
    End   
  
  Else If @Reptype = '17'   
    Begin  
  --  ****  Cheque Is Returned.  
    Set @Strsql = "select  C.Ddno, A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, " +  
     " A.Vamt, Convert(Varchar(11), C.Dddt, 109) Cdt, A.Narration From Ledger A " +  
     " Inner Join (Select Vno, Cltcode, Acname, Vtyp, Booktype From Ledger Where Vtyp = 17 And Drcr = 'C' "   
     If @Frombankcode <> ''  
     Begin  
      Set @Strsql = @Strsql + " And (Cltcode > = '" + @Frombankcode + "' And Cltcode < = '" + @Tobankcode + "')"   
     End   
    Set @Strsql = @Strsql + " ) D On A.Vno = D.Vno And A.Vtyp = D.Vtyp And A.Booktype = D.Booktype " +  
     " Inner Join Ledger1 C On A.Vno = C.Vno And A.Vtyp = C.Vtyp And A.Booktype = C.Booktype " +  
     " Where A.Vno <> '' And A.Vtyp = 17 And A.Drcr = 'D' And A.Vdt > = '" + @Fromdate + " 00:00:00'" +  
     " And A.Vdt < = '" + @Todate + " 23:59:59' "  
    If @Chqno <> ''    
     Begin  
      Set @Strsql = @Strsql + "and C.Ddno = '" + @Chqno + "' "   
     End  
    If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End   
    If @VnoFr <> '' or @VnoTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
     End    
    If @Fromclientid <> ''  
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "')"   
     End  
   /* Set @Strsql = @Strsql + " Group By C.Ddno, A.Vtyp, A.Cltcode, A.Vno, A.Vdt, A.Acname, A.Drcr, A.Vamt, C.Dddt, A.Narration " +  
      "order By A.Vno, A.Vdt, A.Drcr Desc " */  
  
    Set @Strsql = @Strsql + " order By A.Vno, A.Vdt, A.Drcr Desc "   
  
    End  
  Else If @Reptype = '19'   
    Begin  
  --  **** Margin Bank Received.  
    Set @Strsql = "select  Ledger.Narration, A.Booktype, A.Vtyp, A.Vno, A.Party_code Cltcode,  " +  
     "convert(Varchar(11), A.Vdt, 109) Vdt, B.Acname, A.Amount Vamt, A.Drcr, C.Ddno, Convert(Varchar(11), C.Dddt, 109) Cdt " +  
     "from Ledger Inner Join Marginledger A On Ledger.Vno = A.Vno And Ledger.lno = A.lno And Ledger.Vtyp = A.Vtyp And Ledger.Booktype = A.Booktype " +  
     "inner Join Ledger1 C On A.Vno = C.Vno And A.Vtyp = C.Vtyp And A.Booktype = C.Booktype " +  
     "inner Join Acmast B On A.Party_code = B.Cltcode Where A.Vtyp = 19 And A.Vdt > = '" + @Fromdate + " 00:00:00'" +  
     " And A.Vdt < = '" + @Todate + " 23:59:59' "  
    If @Chqno <> ''    
     Begin  
      Set @Strsql = @Strsql + "and C.Ddno = '" + @Chqno + "' "   
     End   
    If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End   
    If @VnoFr <> '' or @VnoTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
     End 
    If @FromDate <> '' or @ToDate <> ''   
    Begin  
      Set @Strsql = @Strsql + "and A.vdt between '" + @FromDate + "'  And  '" + @ToDate + "' "  
    End 	   
    If @Frombankcode <> ''  
     Begin  
      Set @Strsql = @Strsql + " And (A.Party_code > = '" + @Frombankcode + "' And A.Party_code < = '" + @Tobankcode + "')"       
     End  
     If @Fromclientid <> ''  
     Begin  
      Set @Strsql = @Strsql + " And (A.Party_code > = '" + @Fromclientid + "' And A.Party_code < = '" + @Toclientid + "')"  
     End  
  /*  Set @Strsql = @Strsql + " Group By A.Booktype, A.Vtyp, A.Vno,  A.Party_code, A.Vdt, B.Acname, A.Amount, A.Drcr, C.Ddno, C.Dddt, Ledger.Narration" */     End  
  
  Else If @Reptype = '8'   
    Begin  
  --  **** Journal Voucher.  

    Set @Strsql = "select   A.Vtyp,  A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, " +   
     "a.Vamt, A.Narration From Ledger A Where A.Vno <> '' And A.Vtyp = 8  " +  
     "and A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "  
       
    If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End   
    If @VnoFr <> '' or @VnoTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
     End    
     /*if(@Frombankcode <> "")   
      --@Strsql = @Strsql + " And (Cltcode > = '" & Trim(Strbankcode) & "' And Cltcode < = '" & Trim(Strtobankcode) & "')"       
     End If*/  
      
     If @Fromclientid <>  ''  
      Begin  
       Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "')"   
     End  
    /* Set @Strsql = @Strsql + " Group By  A.Vtyp,  A.Cltcode, A.Vno, A.Vdt, A.Acname, A.Drcr, A.Vamt,  A.Narration " +  
    "order By A.Vno, A.Vdt, A.Drcr Desc " */  
   Set @Strsql = @Strsql + " order By A.Vno, A.Vdt, A.Drcr Desc "
print 'hi123'

    End  
  
  Else If @Reptype = '6'   
    Begin  
  --  **** Debit Note.  
    Set @Strsql = "select   A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, A.Vamt, " +  
     "convert(Varchar(11), A.Cdt, 109) Cdt, B.Pobankname, B.Pobankcode, A.Narration " +  
     "from Ledger A Inner Join Acmast B On A.Cltcode = B.Cltcode Where A.Vtyp = 6  " +  
     "and A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "  
    If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End   
    If @VnoFr <> '' or @VnoTo <> ''    
     Begin  
      Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
     End   
     If @Frombankcode <> ''  
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Frombankcode + "' And A.Cltcode < = '" + @Tobankcode + "')"   
     End  
      
     If @Fromclientid <> ''  
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "') "   
     End  
    Set @Strsql = @Strsql + " Order By A.Vno, A.Vdt, A.Drcr Desc"  
    End  
  
  Else If @Reptype = '7'   
    Begin  
  --  **** Credit Note.  
    Set @Strsql = "select  A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, A.Vamt, " +  
     "convert(Varchar(11), A.Cdt, 109) Cdt, B.Pobankname, B.Pobankcode, A.Narration " +  
     "from Ledger A Inner Join Acmast B On A.Cltcode = B.Cltcode Where A.Vtyp = 7  " +  
     "and A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "  
    If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End    
    If @VnoFr <> '' or @VnoTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
     End   
    If @Frombankcode <> ''  
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Frombankcode + "' And A.Cltcode < = '" + @Tobankcode + "')"  
     End  
      
     If @Fromclientid <> ''  
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "') "   
     End  
    Set @Strsql = @Strsql + " Order By A.Vno, A.Vdt, A.Drcr Desc"  
    End  
  
  Else If @Reptype = '5'   
    Begin  
  --  **** Contra Entry.  
    Set @Strsql = "select  A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, A.Vamt, " +  
     "convert(Varchar(11), A.Cdt, 109) Cdt, B.Pobankname, B.Pobankcode, A.Narration " +  
     "from Ledger A Inner Join Acmast B On A.Cltcode = B.Cltcode Where A.Vtyp = 5 " +  
     "and A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "  
    If @Chqno <> ''    
     Begin  
      Set @Strsql = @Strsql + "and C.Ddno = '" + @Chqno + "' "   
     End  
   If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End  
   If @VnoFr <> '' or @VnoTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
     End   
   If @Frombankcode <> ''  
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Frombankcode + "' And A.Cltcode < = '" + @Tobankcode + "')"   
     End  
      
     If @Fromclientid <> ''  
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "') "   
     End  
    Set @Strsql = @Strsql + " Order By A.Vno, A.Vdt, A.Drcr Desc"  
    End  
  
  Else If @Reptype = '20'   
    Begin  
  --  **** Margin Bank Repayment.  
    Set @Strsql = "select  Ledger.Narration, A.Booktype, A.Vtyp, A.Vno, A.Party_code Cltcode, " +  
     "convert(Varchar(11), A.Vdt, 109) Vdt, B.Acname, A.Amount Vamt, A.Drcr, C.Ddno, Convert(Varchar(11), C.Dddt, 109) Cdt " +  
     "from Ledger Inner Join Marginledger A On Ledger.Vno = A.Vno And Ledger.lno = A.lno And Ledger.Vtyp = A.Vtyp And " +  
     "ledger.Booktype = A.Booktype Inner Join Ledger1 C On A.Vno = C.Vno And A.Vtyp = C.Vtyp And " +  
     "a.Booktype = C.Booktype Inner Join Acmast B On A.Party_code = B.Cltcode Where A.Vtyp = 20 "  
    If @Chqno <> ''    
     Begin  
      Set @Strsql = @Strsql + "and C.Ddno = '" + @Chqno + "' "   
     End  
    If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End  
    If @VnoFr <> '' or @VnoTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
     End   
    If @FromDate <> '' or @ToDate <> ''   
    Begin  
      Set @Strsql = @Strsql + "and A.vdt between '" + @FromDate + "'  And  '" + @ToDate + "' "  
    End  
    If @Frombankcode <> ''   
    Begin  
      Set @Strsql = @Strsql + " And (A.Party_code > = '" + @Frombankcode + "' And A.Party_code < = '" + @Tobankcode + "')"       
     End  
     If @Fromclientid <> ''  
     Begin   
      Set @Strsql = @Strsql + " And (A.Party_code > = '" + @Fromclientid + "' And A.Party_code < = '" + @Toclientid + "')"  
     End  
     
    Set @Strsql = @Strsql + " Group By A.Booktype, A.Vtyp, A.Vno,  A.Party_code, A.Vdt, B.Acname, A.Amount, A.Drcr,   
     C.Ddno,  C.Dddt, Ledger.Narration"  
    End  
  
  Else If @Reptype = '22'    
    Begin  
  --  **** Margin Cash Received.    
    Set @Strsql = "select  Ledger.Narration, A.Booktype, A.Vtyp, A.Vno, A.Party_code Cltcode, " +  
     "convert(Varchar(11), A.Vdt, 109) Vdt, B.Acname, A.Amount Vamt, A.Drcr  From Ledger " +  
     "inner Join Marginledger A On Ledger.Vno = A.Vno And Ledger.Vtyp = A.Vtyp And Ledger.Booktype = A.Booktype " +  
     "inner Join Acmast B On A.Party_code = B.Cltcode Where A.Vtyp = 22 "  
       
    If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
    End  
    If @VnoFr <> '' or @VnoTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
    End    
     If @Frombankcode <> ''  
     Begin  
      Set @Strsql = @Strsql + " And (A.Party_code > = '" + @Frombankcode + "' And A.Party_code < = '" + @Tobankcode + "')"   
    End  
    If @Fromclientid <> ''  
     Begin  
      Set @Strsql = @Strsql + " And (A.Party_code > = '" + @Fromclientid + "' And A.Party_code < = '" + @Toclientid + "')"  
    End  
     
   /* Set @Strsql = @Strsql + " Group By A.Booktype, A.Vtyp, A.Vno,  A.Party_code, A.Vdt, B.Acname, A.Amount, A.Drcr, Ledger.Narration"*/  
    End  
  
  Else If @Reptype = '23'   
    Begin  
  --  **** Margin Cash Repayment.  
    Set @Strsql = "select  Ledger.Narration, A.Booktype, A.Vtyp, A.Vno, A.Party_code Cltcode, " +  
     "convert(Varchar(11), A.Vdt, 109) Vdt, B.Acname, A.Amount Vamt, A.Drcr  From Ledger " +  
     "inner Join Marginledger A On Ledger.Vno = A.Vno And Ledger.Vtyp = A.Vtyp And Ledger.Booktype = A.Booktype " +  
     "inner Join Acmast B On A.Party_code = B.Cltcode Where A.Vtyp = 23 "  
    If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End    
    If @VnoFr <> '' or @VnoTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
     End    
    If @Frombankcode <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (A.Party_code > = '" + @Frombankcode + "' And A.Party_code < = '" + @Tobankcode + "')"   
     End  
     If @Fromclientid <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (A.Party_code > = '" + @Fromclientid + "' And A.Party_code < = '" + @Toclientid + "')"  
     End  
     
   /* Set @Strsql = @Strsql + " Group By A.Booktype, A.Vtyp, A.Vno,  A.Party_code, A.Vdt, B.Acname, A.Amount, A.Drcr, Ledger.Narration"*/  
    End  
  
  Else If @Reptype = '24'      
    Begin  
  --  **** Margin Journal Entries.(Vtyp = 24)  
      
    Set @Strsql = "select  A.Vtyp, A.Party_code  Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, B.Acname, A.Drcr, " +  
     " A.Amount Vamt, C.Narration From Marginledger A Inner Join Ledger C On A.Vno = C.Vno And A.Vtyp = C.Vtyp " +  
     "and A.Booktype = C.Booktype Inner Join Acmast B On  A.Party_code = B.Cltcode " +  
     "where A.Vno <> ''  And A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "   
     If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End   
     If @VnoFr <> '' or @VnoTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
     End   
    /*if(Trim(Strbankcode) <> "")   
      'Strsql = Strsql + " And (Cltcode > = '" & Trim(Strbankcode) & "' And Cltcode < = '" & Trim(Strtobankcode) & "')"       
     End If */  
      
     If @Fromclientid <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (A.Party_code > = '" + @Fromclientid + "' And A.Party_code < = '" + @Toclientid + "') "   
     End  
   /* Set @Strsql = @Strsql + " Group By  A.Vtyp, A.Party_code, A.Vno, A.Vdt, B.Acname, A.Drcr, A.Amount, C.Narration " +  
       "order By A.Vno, A.Vdt, A.Drcr Desc " */  
  Set @Strsql = @Strsql + "order By A.Vno, A.Vdt, A.Drcr Desc "  
    End  
  
  Else If @Reptype = '3'   
  --  **** Payment Bank.  
    Begin  
       IF @datetype ='Voudt'  
   Begin  
     Set @Strsql = "select  C.Ddno, A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname,   
        A.Drcr, A.Vamt, " +  "convert(Varchar(11), C.Dddt, 109) Cdt, A.Narration , D.CLTCODE as ctl     
       From Ledger A Inner Join (Select Vno, Cltcode, Acname, Vtyp, " +  
      "booktype From Ledger Where Vtyp = 3 And Drcr = 'C' "   
       
      If @Frombankcode <> ''   
      Begin  
       Set @Strsql = @Strsql + " And (Cltcode > = '" + @Frombankcode + "' And Cltcode < = '" + @Tobankcode + "')"       
      End  
     
      Set @Strsql = @Strsql + " ) D On A.Vno = D.Vno And A.Vtyp = D.Vtyp And A.Booktype = D.Booktype Inner Join " +  
      "ledger1 C On A.Vno = C.Vno And A.Vtyp = C.Vtyp And A.Booktype = C.Booktype Where A.Vno <> '' " +  
      "and A.Vtyp = 3 And A.Drcr = 'D' And A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "  
    
      If @Fromclientid <> ''  
      Begin  
       Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "')"   
      End  
     if @Chqno <> ''    
      Begin  
       Set @Strsql = @Strsql + "and C.Ddno = '" + @Chqno + "' "   
      End     
     If @VamtFr <> '' or @VamtTo <> ''   
      Begin  
          Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
        End   
     If @VnoFr <> '' or @VnoTo <> ''   
         Begin  
              Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
            End    
     Set @Strsql = @Strsql + " /* Group By C.Ddno, A.Vtyp, A.Cltcode, A.Vno, A.Vdt, A.Acname, A.Drcr, A.Vamt,   
        C.Dddt, A.Narration, D.Cltcode */ Order By A.Vno, A.Vdt, A.Drcr Desc "  
        End  
      else if  @datetype ='EntDt'  
       Begin   
       Set @Strsql = "select C.Ddno, A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Pdt, 109) Pdt, A.Acname,   
       A.Drcr, A.Vamt, " +  "convert(Varchar(11), C.Dddt, 109) cdt, A.Narration , D.CLTCODE as ct     
       From Ledger A Inner Join (Select Vno, Cltcode, Acname, Vtyp, " +  
"booktype From Ledger Where Vtyp = 3 And Drcr = 'C' "   
       If @VamtFr <> '' or @VamtTo <> ''   
       Begin  
        Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
       End    
       If @VnoFr <> '' or @VnoTo <> ''   
        Begin  
         Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
       End     
       If @Frombankcode <> ''   
       Begin  
       Set @Strsql = @Strsql + " And (Cltcode > = '" + @Frombankcode + "' And Cltcode < = '" + @Tobankcode + "')"       
       End  
     
      Set @Strsql = @Strsql + " ) D On A.Vno = D.Vno And A.Vtyp = D.Vtyp And A.Booktype = D.Booktype Inner Join " +  
      "ledger1 C On A.Vno = C.Vno And A.Vtyp = C.Vtyp And A.Booktype = C.Booktype Where A.Vno <> '' " +  
      "and A.Vtyp = 3 And A.Drcr = 'D' And A.Pdt > = '" + @Fromdate + " 00:00:00' And A.Pdt < = '" + @Todate + " 23:59:59' "  
    
      If @Fromclientid <> ''  
      Begin  
       Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "')"   
      End  
      Set @Strsql = @Strsql + "/* Group By C.Ddno, A.Vtyp, A.Cltcode, A.Vno, A.Pdt, A.Acname, A.Drcr, A.Vamt,   
      C.Dddt, A.Narration, D.Cltcode */ Order By A.Vno, A.Pdt, A.Drcr Desc "  
    End  
  End  
  
  Else If @Reptype = '4'   
    Begin  
  --  **** Payment Cash.  
    Set @Strsql = "select  A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, A.Vamt,  A.Narration From Ledger A Inner Join (Select Vno, Cltcode, Acname, Vtyp, Booktype From Ledger Where Vtyp = 4 And Drcr = 'C' "  
     If @Frombankcode <> ''   
     Begin   
      Set @Strsql = @Strsql + " And (Cltcode > = '" + @Frombankcode + "' And Cltcode < = '" + @Tobankcode + "')"   
     End  
     Set @Strsql = @Strsql + " ) D On A.Vno = D.Vno And A.Vtyp = D.Vtyp And A.Booktype = D.Booktype Where A.Vno <> '' And A.Vtyp = 4 And A.Drcr = 'D' And A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "   
       
     If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End   
     If @VnoFr <> '' or @VnoTo <> ''   
        Begin  
         Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
     End   
     If @Fromclientid <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "')"   
     End  
   /* Set @Strsql = @Strsql + " Group By  A.Vtyp, A.Cltcode, A.Vno, A.Vdt, A.Acname, A.Drcr, A.Vamt,  A.Narration " +  
       "order By A.Vno, A.Vdt, A.Drcr Desc " */  
  Set @Strsql = @Strsql + "order By A.Vno, A.Vdt, A.Drcr Desc "  
    End  
  Else If @Reptype =  '2'   
    Begin  
  --  **** Receipt Bank.  
     IF @datetype ='Voudt'  
     Begin  
     Set @Strsql = "select  C.Ddno, A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, " +  
     "a.Vamt, Convert(Varchar(11), C.Dddt, 109) Cdt, A.Narration , D.CLTCODE as ctl   From Ledger A Inner Join " +  
     "(Select Vno, Cltcode, Acname, Vtyp, Booktype From Ledger Where Vtyp = 2 And Drcr = 'D' "  
     If @Frombankcode <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (Cltcode > = '" + @Frombankcode + "' And Cltcode < = '" + @Tobankcode + "')"       
     End  
     Set @Strsql = @Strsql + " ) D On A.Vno = D.Vno And A.Vtyp = D.Vtyp And A.Booktype = D.Booktype " +  
     "inner Join Ledger1 C On A.Vno = C.Vno And A.Vtyp = C.Vtyp And A.Booktype = C.Booktype " +  
     "where A.Vno <> '' And A.Vtyp = 2 And A.Drcr = 'C' And A.Vdt > = '" + @Fromdate + " 00:00:00' " +  
     "and A.Vdt < = '" + @Todate + " 23:59:59' "   
     if @Chqno <> ''    
     Begin  
      Set @Strsql = @Strsql + "and C.Ddno = '" + @Chqno + "' "   
     End  
     If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End  
     If @VnoFr <> '' or @VnoTo <> ''   
       Begin  
        Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "' And '" + @VnoTo + "' "  
     End  
     If @Fromclientid <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "' )"   
     End  
    Set @Strsql = @Strsql + "/* Group By C.Ddno, A.Vtyp, A.Cltcode ,A.Vno, A.Vdt, A.Acname, A.Drcr, A.Vamt, C.Dddt, A.Narration , D.CLTCODE */ Order By A.Vno, A.Vdt, A.Drcr Desc "  
    End  
  Else If @datetype='Entdt'  
   Begin    
    Set @Strsql = "select C.Ddno, A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Pdt, 109) Pdt, A.Acname, A.Drcr, " +  
     "a.Vamt, Convert(Varchar(11), C.Dddt, 109) Cdt, A.Narration ,D.Cltcode as ct From Ledger A Inner Join " +  
     "(Select Vno, Cltcode, Acname, Vtyp, Booktype From Ledger Where Vtyp = 2 And Drcr = 'D' "  
     If @Frombankcode <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (Cltcode > = '" + @Frombankcode + "' And Cltcode < = '" + @Tobankcode + "')"       
     End  
     Set @Strsql = @Strsql + " ) D On A.Vno = D.Vno And A.Vtyp = D.Vtyp And A.Booktype = D.Booktype " +  
     "inner Join Ledger1 C On A.Vno = C.Vno And A.Vtyp = C.Vtyp And A.Booktype = C.Booktype " +  
     "where A.Vno <> '' And A.Vtyp = 2 And A.Drcr = 'C' And A.Pdt > = '" + @Fromdate + " 00:00:00' " +  
     "and A.Pdt < = '" + @Todate + " 23:59:59' "  
     If @Chqno <> ''    
     Begin  
      Set @Strsql = @Strsql + "and C.Ddno = '" + @Chqno + "' "   
     End   
     If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End   
     If @VnoFr <> '' or @VnoTo <> ''   
        Begin  
         Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
       End  
     If @Fromclientid <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "' )"   
     End  
    Set @Strsql = @Strsql + "/* Group By C.Ddno, A.Vtyp, A.Cltcode, A.Vno, A.Pdt, A.Acname, A.Drcr, A.Vamt, C.Dddt, A.Narration , D.CLTCODE */ Order By A.Vno, A.Pdt, A.Drcr Desc "  
   End  
  End  
  
  Else If @Reptype = '1'   
    Begin  
  --  **** Receipt Cash.  
    Set @Strsql = "select  A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, A.Vamt,  A.Narration From Ledger A Inner Join (Select Vno, Cltcode, Acname, Vtyp, Booktype From Ledger Where Vtyp = 1 And Drcr = 'D' "  
     If @Frombankcode <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (Cltcode > = '" + @Frombankcode + "' And Cltcode < = '" + @Tobankcode + "')"   
     End  
     Set @Strsql = @Strsql + " ) D On A.Vno = D.Vno And A.Vtyp = D.Vtyp And A.Booktype = D.Booktype Where A.Vno <> '' " +  
     "and A.Vtyp = 1 And A.Drcr = 'C' And A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "  
      
    If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End    
    If @VnoFr <> '' or @VnoTo <> ''   
        Begin  
         Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
       End  
    If @Fromclientid <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "')"   
     End  
   /* Set @Strsql = @Strsql + " Group By  A.Vtyp, A.Cltcode, A.Vno, A.Vdt, A.Acname, A.Drcr, A.Vamt,  A.Narration " +  
     "order By A.Vno, A.Vdt, A.Drcr Desc " */  
  Set @Strsql = @Strsql + " order By A.Vno, A.Vdt, A.Drcr Desc "   
     
   --else Raiserror ('50001 : No Voucher Type Found', 0, 13)  
   End  
  End

--New  
--Else 
Else if @Statusid ='Subbroker'  
	If @Reptype = '8'   
	Begin  
  --  **** Journal Voucher.  
		Set @Strsql = "select   A.Vtyp,  A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, " +  
		 "a.Vamt, A.Narration From Ledger A , msajag.dbo.Subbrokers S, msajag.dbo.Client1 C Where A.Vno <> '' And A.Vtyp = 8  " + 
		 "and A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "  +
		 "and A.cltcode= C.Cl_Code and C.sub_broker = '" + @StatusName + "'  "  
       
		If @VamtFr <> '' or @VamtTo <> ''   
		 Begin  
		  Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
		 End   
		If @VnoFr <> '' or @VnoTo <> ''   
		 Begin  
		  Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
		 End    

		Set @Strsql = @Strsql + " order By A.Vno, A.Vdt, A.Drcr Desc "  
	 End  
   Else If @Reptype =  '2'   
    Begin  
  --  **** Receipt Bank.  
     IF @datetype ='Voudt'  
     Begin  
     Set @Strsql = "select  C.Ddno, A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, " +  
     "a.Vamt, Convert(Varchar(11), C.Dddt, 109) Cdt, A.Narration , D.CLTCODE as ctl From msajag.dbo.Subbrokers S, msajag.dbo.Client1 C1 ,Ledger A Inner Join " +  
     "(Select Vno, Cltcode, Acname, Vtyp, Booktype From Ledger Where Vtyp = 2 And Drcr = 'D' "  
	 
	 If @Frombankcode <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (Cltcode > = '" + @Frombankcode + "' And Cltcode < = '" + @Tobankcode + "')"       
     End  
     Set @Strsql = @Strsql + " ) D On A.Vno = D.Vno And A.Vtyp = D.Vtyp And A.Booktype = D.Booktype " +  
     "inner Join Ledger1 C On A.Vno = C.Vno And A.Vtyp = C.Vtyp And A.Booktype = C.Booktype " +  
     "where A.Vno <> '' and A.cltcode= C1.Cl_Code And C1.sub_broker= '" + @Statusname + "' And A.Vtyp = 2 And A.Drcr = 'C' And A.Vdt > = '" + @Fromdate + " 00:00:00' " +  
     "and A.Vdt < = '" + @Todate + " 23:59:59' "   
     if @Chqno <> ''    
     Begin  
      Set @Strsql = @Strsql + "and C.Ddno = '" + @Chqno + "' "   
     End  
     If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End  
     If @VnoFr <> '' or @VnoTo <> ''   
       Begin  
        Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "' And '" + @VnoTo + "' "  
     End  
     If @Fromclientid <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "' )"   
     End  
    Set @Strsql = @Strsql + " Group By C.Ddno, A.Vtyp, A.Cltcode ,A.Vno, A.Vdt, A.Acname, A.Drcr, A.Vamt, C.Dddt, A.Narration , D.CLTCODE  Order By A.Vno, A.Vdt, A.Drcr Desc "  
    End  
  Else If @datetype='Entdt'  
   Begin    
    Set @Strsql = "select C.Ddno, A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Pdt, 109) Pdt, A.Acname, A.Drcr, " +  
     "a.Vamt, Convert(Varchar(11), C.Dddt, 109) Cdt, A.Narration ,D.Cltcode as ct From msajag.dbo.Subbrokers S, msajag.dbo.Client1 C1 ,Ledger A Inner Join " +  
     "(Select Vno, Cltcode, Acname, Vtyp, Booktype From Ledger Where Vtyp = 2 And Drcr = 'D' "  
     If @Frombankcode <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (Cltcode > = '" + @Frombankcode + "' And Cltcode < = '" + @Tobankcode + "')"       
     End  
     Set @Strsql = @Strsql + " ) D On A.Vno = D.Vno And A.Vtyp = D.Vtyp And A.Booktype = D.Booktype " +  
     "inner Join Ledger1 C On A.Vno = C.Vno And A.Vtyp = C.Vtyp And A.Booktype = C.Booktype " +  
     "where A.Vno <> '' and A.cltcode= C1.Cl_Code And C1.sub_broker= '" + @Statusname + "' And A.Vtyp = 2 And A.Drcr = 'C' And A.Pdt > = '" + @Fromdate + " 00:00:00' " +  
     "and A.Pdt < = '" + @Todate + " 23:59:59' "  
     If @Chqno <> ''    
     Begin  
      Set @Strsql = @Strsql + "and C.Ddno = '" + @Chqno + "' "   
     End   
     If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End   
     If @VnoFr <> '' or @VnoTo <> ''   
        Begin  
         Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
       End  
     If @Fromclientid <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "' )"   
     End  
    Set @Strsql = @Strsql + " Group By C.Ddno, A.Vtyp, A.Cltcode, A.Vno, A.Pdt, A.Acname, A.Drcr, A.Vamt, C.Dddt, A.Narration , D.CLTCODE  Order By A.Vno, A.Pdt, A.Drcr Desc "  
   End  
  End  

 Else If @Reptype = '16'   
    Begin  
  --  **** When Cheque Is Cancelled.  
    Set @Strsql = "select  C.Ddno, A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, " +  
     "a.Drcr, A.Vamt, Convert(Varchar(11), C.Dddt, 109) Cdt, A.Narration From msajag.dbo.Subbrokers S, msajag.dbo.Client1 C1 , Ledger A " +  
     "inner Join (Select Vno, Cltcode, Acname, Vtyp, Booktype From Ledger Where Vtyp = 16 And Drcr = 'D' "  
     If @Frombankcode <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (Cltcode > = '" + @Frombankcode + "' And Cltcode < = '" + @Tobankcode + "')"  
     End  
      
    Set @Strsql = @Strsql + " ) D On A.Vno = D.Vno And A.Vtyp = D.Vtyp And A.Booktype = D.Booktype " +  
     "inner Join Acmast B On A.Cltcode = B.Cltcode " +  
     "inner Join Ledger1 C On A.Vno = C.Vno And A.Vtyp = C.Vtyp And A.Booktype = C.Booktype " +  
     "where A.Vno <> '' and A.cltcode= C1.Cl_Code And C1.sub_broker = '" + @Statusname + "' And A.Vtyp = 16 And A.Drcr = 'C' " +  
     "and A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "  
   If @Chqno <> ''    
     Begin  
      Set @Strsql = @Strsql + "and C.Ddno = '" + @Chqno + "' "   
     End    
   If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End   
   If @VnoFr <> '' or @VnoTo <> ''   
        Begin  
         Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
       End  
   If @Fromclientid <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "')"   
     End  
    Set @Strsql = @Strsql + " Group By C.Ddno, A.Vtyp, A.Cltcode, A.Vno, A.Vdt, A.Acname, A.Drcr, A.Vamt, C.Dddt, A.Narration  " +  
       "order By A.Vno, A.Vdt, A.Drcr Desc "   
   Set @Strsql = @Strsql + " order By A.Vno, A.Vdt, A.Drcr Desc "  
    End  
  
  Else If @Reptype = '17'   
    Begin  
  --  **** When Cheque Is Returned.(Vtyp = 17)  
    Set @Strsql = "select  C.Ddno, A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, " +  
     "A.Vamt, Convert(Varchar(11), C.Dddt, 109) Cdt, A.Narration From msajag.dbo.Subbrokers S, msajag.dbo.Client1 C1 , Ledger A " +  
     "Inner Join (Select Vno, Cltcode, Acname, Vtyp, Booktype From Ledger Where Vtyp = 17 And Drcr = 'C' "  
   If @Chqno <> ''    
     Begin  
      Set @Strsql = @Strsql + "and C.Ddno = '" + @Chqno + "' "   
     End    
   If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End    
   If @VnoFr <> '' or @VnoTo <> ''   
        Begin  
         Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
       End   
  If @Frombankcode <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (Cltcode > = '" + @Frombankcode + "' And Cltcode < = '" + @Tobankcode + "')"   
     End  
    Set @Strsql = @Strsql + " ) D On A.Vno = D.Vno And A.Vtyp = D.Vtyp And A.Booktype = D.Booktype  " +  
     "inner Join Acmast B On A.Cltcode = B.Cltcode " +  
     "inner Join Ledger1 C On A.Vno = C.Vno And A.Vtyp = C.Vtyp And A.Booktype = C.Booktype  " +  
     "where A.Vno <> '' and A.cltcode= C1.Cl_Code And C1.sub_broker= '" + @Statusname + "' And A.Vtyp = 17 And A.Drcr = 'D' And A.Vdt > = '" + @Fromdate + " 00:00:00' " +  
     "and A.Vdt < = '" + @Todate + " 23:59:59' "  
     If @Fromclientid <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "')"   
     End  
    Set @Strsql = @Strsql + " Group By C.Ddno, A.Vtyp, A.Cltcode, A.Vno, A.Vdt, A.Acname, A.Drcr, A.Vamt, C.Dddt, A.Narration " +  
       "order By A.Vno, A.Vdt, A.Drcr Desc "   
  Set @Strsql = @Strsql + " order By A.Vno, A.Vdt, A.Drcr Desc "   
    End  
  
  Else If @Reptype = '19'   
    Begin  
  --  **** Margin Bank Received.(Vtyp = 19)  
    Set @Strsql = "select  Ledger.Narration, A.Booktype, A.Vtyp, A.Vno, A.Party_code Cltcode,  " +  
     "convert(Varchar(11), A.Vdt, 109) Vdt, B.Acname, A.Amount Vamt, A.Drcr, C.Ddno, Convert(Varchar(11), C.Dddt, 109) Cdt " +  
     "from msajag.dbo.Subbrokers S, msajag.dbo.Client1 C1 , Ledger Inner Join Marginledger A On Ledger.Vno = A.Vno And Ledger.Vtyp = A.Vtyp And Ledger.Booktype = A.Booktype  " +  
     "inner Join Ledger1 C On A.Vno = C.Vno And A.Vtyp = C.Vtyp And A.Booktype = C.Booktype " +  
     "inner Join Acmast B On A.Party_code = B.Cltcode and A.cltcode= C1.Cl_Code Where C1.sub_broker= '" + @Statusname + "' and A.Vtyp = 19 And A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "  
   If @Chqno <> ''    
     Begin  
      Set @Strsql = @Strsql + "and C.Ddno = '" + @Chqno + "' "   
     End      
   If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End    
    If @VnoFr <> '' or @VnoTo <> ''   
     Begin  
     Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
    End  
    If @Frombankcode <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (A.Party_code > = '" + @Frombankcode + "' And A.Party_code < = '" + @Tobankcode + "')"   
     End  
     If @Fromclientid <> ''  
     Begin  
      Set @Strsql = @Strsql + " And (A.Party_code > = '" + @Fromclientid + "' And A.Party_code < = '" + @Toclientid + "')"  
     End  
     
    Set @Strsql = @Strsql + " Group By A.Booktype, A.Vtyp, A.Vno,  A.Party_code, A.Vdt, B.Acname, A.Amount, A.Drcr, C.Ddno, C.Dddt, Ledger.Narration"  
      
    End  

 Else If @Reptype = '6'   
    Begin  
  --  **** Debit Note.(Vtyp = 6)  
    Set @Strsql = "select  A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, A.Vamt, " +  
     "convert(Varchar(11), A.Cdt, 109) Cdt, B.Pobankname, B.Pobankcode, A.Narration " +  
     "from msajag.dbo.Subbrokers S, msajag.dbo.Client1 C1 , Ledger A Inner Join Acmast B On A.Cltcode = B.Cltcode and A.cltcode= C1.Cl_Code Where C1.sub_broker= '" + @Statusname + "'  and A.Vtyp = 6  " +  
     "and A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "  
     If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End     
     If @VnoFr <> '' or @VnoTo <> ''   
        Begin  
         Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
       End  
     If @Frombankcode <> ''      Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Frombankcode + "' And A.Cltcode < = '" + @Tobankcode + "')"       
     End  
      
     If @Fromclientid <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid +"' ) "   
     End  
    Set @Strsql = @Strsql + " Order By A.Vno, A.Vdt, A.Drcr Desc"  
    End  
  
  Else If @Reptype = '7'  
    Begin   
  --  **** Credit Note.(Vtyp = 7)  
    Set @Strsql = "select  A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, A.Vamt, " +  
     "convert(Varchar(11), A.Cdt, 109) Cdt, B.Pobankname, B.Pobankcode, A.Narration " +  
     "from msajag.dbo.Subbrokers S, msajag.dbo.Client1 C1 , Ledger A Inner Join Acmast B On A.Cltcode = B.Cltcode and A.cltcode= C1.Cl_Code Where C1.sub_broker= '" + @Statusname + "'  and A.Vtyp = 7   " +  
     "and A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "  
     If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End   
     If @VnoFr <> '' or @VnoTo <> ''   
        Begin  
         Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
       End  
     If @Frombankcode <> ''  
     Begin   
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Frombankcode + "' And A.Cltcode < = '" + @Tobankcode + "')"   
     End   
      
     If @Fromclientid <> ''   
    Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "') "   
     End  
    Set @Strsql = @Strsql + " Order By A.Vno, A.Vdt, A.Drcr Desc"  
    End  
  
  Else If @Reptype = '5'   
    Begin  
  --  **** Contra Entry. (Vtyp = 5)  
    Set @Strsql = "select  A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, A.Vamt, " +  
     "convert(Varchar(11), A.Cdt, 109) Cdt, B.Pobankname, B.Pobankcode, A.Narration " +  
     "from msajag.dbo.Subbrokers S, msajag.dbo.Client1 C1 , Ledger A Inner Join Acmast B On A.Cltcode = B.Cltcode and A.cltcode= C1.Cl_Code Where C1.sub_broker= '" + @Statusname + "' and A.Vtyp = 5 " +  
     "and A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "  
     If @Chqno <> ''    
     Begin  
      Set @Strsql = @Strsql + "and C.Ddno = '" + @Chqno + "' "   
     End   
     If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End   
     If @VnoFr <> '' or @VnoTo <> ''   
       Begin  
       Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
     End  
     If @Frombankcode <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Frombankcode + "' And A.Cltcode < = '" + @Tobankcode + "')"   
     End  
      
     If @Fromclientid <> ''   
     Begin   
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "') "   
     End  
    Set @Strsql = @Strsql + " Order By A.Vno, A.Vdt, A.Drcr Desc"  
     
    End  
  
  Else If @Reptype = '20'   
   Begin  
 --  **** Margin Bank Repayment. (Vtyp = 20)  
   Set @Strsql = "select  Ledger.Narration, A.Booktype, A.Vtyp, A.Vno, A.Party_code Cltcode, " +  
    "convert(Varchar(11), A.Vdt, 109) Vdt, B.Acname, A.Amount Vamt, A.Drcr, C.Ddno, Convert(Varchar(11), C.Dddt, 109) Cdt  " +  
    "from msajag.dbo.Subbrokers S, msajag.dbo.Client1 C1 , Ledger Inner Join Marginledger A On Ledger.Vno = A.Vno And Ledger.Vtyp = A.Vtyp And " +  
    "ledger.Booktype = A.Booktype Inner Join Ledger1 C On A.Vno = C.Vno And A.Vtyp = C.Vtyp And " +  
    "a.Booktype = C.Booktype Inner Join Acmast B On A.Party_code = B.Cltcode and A.cltcode= C1.Cl_Code Where C1.sub_broker= '" + @Statusname + "' and A.Vtyp = 20 "  
    If @Chqno <> ''    
    Begin  
     Set @Strsql = @Strsql + "and C.Ddno = '" + @Chqno + "' "   
    End    
   If @VamtFr <> '' or @VamtTo <> ''   
    Begin  
     Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
    End   
   If @VnoFr <> '' or @VnoTo <> ''   
     Begin  
       Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
    End   
    If (@Frombankcode <> "")   
    Begin  
     Set @Strsql = @Strsql + " And (A.Party_code > = '" + @Frombankcode + "' And A.Party_code < = '" + @Tobankcode + "' )"  
    End  
    If @Fromclientid <> ''  
    Begin  
     Set @Strsql = @Strsql + " And (A.Party_code > = '" + @Fromclientid + "' And A.Party_code < = '" + @Toclientid + "')"  
    End  
    
  /* Set @Strsql = @Strsql + " Group By A.Booktype, A.Vtyp, A.Vno,  A.Party_code, A.Vdt, B.Acname, A.Amount, A.Drcr, " +  
    "c.Ddno,  C.Dddt, Ledger.Narration" */  
   End  
  
  Else If @Reptype = '22'   
    Begin  
  --  **** Margin Cash Received.(Vtyp = 22)    
    Set @Strsql = "select  Ledger.Narration, A.Booktype, A.Vtyp, A.Vno, A.Party_code Cltcode,  " +  
     "convert(Varchar(11), A.Vdt, 109) Vdt, B.Acname, A.Amount Vamt, A.Drcr  From msajag.dbo.Subbrokers S, msajag.dbo.Client1 C1 , Ledger " +  
     "inner Join Marginledger A On Ledger.Vno = A.Vno And Ledger.Vtyp = A.Vtyp And Ledger.Booktype = A.Booktype " +  
     "inner Join Acmast B On A.Party_code = B.Cltcode and A.cltcode= C1.Cl_Code Where C1.sub_broker= '" + @Statusname + "' and A.Vtyp = 22 "  
     If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End    
    If @VnoFr <> '' or @VnoTo <> ''   
        Begin  
         Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
       End  
    If @Frombankcode <> ''  
     Begin  
      Set @Strsql = @Strsql + " And (A.Party_code > = '" + @Frombankcode + "' And A.Party_code < = '" + @Tobankcode + "')"   
     End  
     If @Fromclientid <> ''  
     Begin  
      Set @Strsql = @Strsql + " And (A.Party_code > = '" + @Fromclientid + "' And A.Party_code < = '" + @Toclientid + "')"  
     End  
     
   /* Set @Strsql = @Strsql + " Group By A.Booktype, A.Vtyp, A.Vno,  A.Party_code, A.Vdt, B.Acname, A.Amount, A.Drcr, Ledger.Narration" */  
      
    End    
  
  Else If @Reptype = '23'   
    Begin  
  --  **** Margin Cash Repayment.  
    Set @Strsql = "select  Ledger.Narration, A.Booktype, A.Vtyp, A.Vno, A.Party_code Cltcode, " +  
     "convert(Varchar(11), A.Vdt, 109) Vdt, B.Acname, A.Amount Vamt, A.Drcr  From msajag.dbo.Subbrokers S, msajag.dbo.Client1 C1 , Ledger " +  
     "inner Join Marginledger A On Ledger.Vno = A.Vno And Ledger.Vtyp = A.Vtyp And Ledger.Booktype = A.Booktype " +  
     "inner Join Acmast B On A.Party_code = B.Cltcode and A.cltcode= C1.Cl_Code Where C1.sub_broker= '" + @Statusname + "'  and A.Vtyp = 23 "  
     If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End   
    If @VnoFr <> '' or @VnoTo <> ''   
       Begin  
       Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
    End  
     If @Frombankcode <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (A.Party_code > = '" + @Frombankcode + "' And A.Party_code < = '" + @Tobankcode + "')"   
     End  
     If @Fromclientid <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (A.Party_code > = '" + @Fromclientid + "' And A.Party_code < = '" + @Toclientid + "')"  
     End  
     
   /* Set @Strsql = @Strsql + " Group By A.Booktype, A.Vtyp, A.Vno,  A.Party_code, A.Vdt, B.Acname, A.Amount, A.Drcr, Ledger.Narration" */  
    End  
  
  Else If @Reptype = '24'      
    Begin  
  --  **** Margin Journal Entries.(Vtyp = 24)  
      
    Set @Strsql = "select  A.Vtyp, A.Party_code  Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, B.Acname, A.Drcr, "+  
     " A.Amount Vamt, C.Narration From msajag.dbo.Subbrokers S, msajag.dbo.Client1 C1 , Marginledger A Inner Join Ledger C On A.Vno = C.Vno And A.Vtyp = C.Vtyp " +  
     "and A.Booktype = C.Booktype Inner Join Acmast B On  A.Party_code = B.Cltcode And A.Booktype = B.Booktype " +  
     "where A.Vno <> '' and A.cltcode= C1.Cl_Code And C1.sub_broker= '" + @Statusname + "' And A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "   
     /*if(Trim(Strbankcode) <> "")   
      'Strsql = Strsql + " And (Cltcode > = '" & Trim(Strbankcode) & "' And Cltcode < = '" & Trim(Strtobankcode) & "')"       
     End If */  
     If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End   
     If @VnoFr <> '' or @VnoTo <> ''   
       Begin  
       Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
     End  
     If @Fromclientid <> ''  
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "') "   
     End   
   /* Set @Strsql = @Strsql + " Group By  A.Vtyp, A.Party_code, A.Vno, A.Vdt, B.Acname, A.Drcr, A.Amount, C.Narration  " +  
       "order By A.Vno, A.Vdt, A.Drcr Desc " */  
   Set @Strsql = @Strsql + " order By A.Vno, A.Vdt, A.Drcr Desc "  
    End  
  
  Else If @Reptype = '3'   
    Begin  
  --  **** Payment Bank.  
    Set @Strsql = "select  C.Ddno, A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, A.Vamt, " +  
     "convert(Varchar(11), C.Dddt, 109) Cdt, A.Narration, D.CLTCODE as ctl From msajag.dbo.Subbrokers S, msajag.dbo.Client1 C1 ,Ledger A Inner Join (Select Vno, Cltcode, Acname, Vtyp, " +  
     "booktype From Ledger Where Vtyp = 3 And Drcr = 'C' "  
     If @Frombankcode <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (Cltcode > = '" + @Frombankcode + "' And Cltcode < = '" + @Tobankcode + "')"   
     End  
       
     Set @Strsql = @Strsql + " ) D On A.Vno = D.Vno And A.Vtyp = D.Vtyp And A.Booktype = D.Booktype " +  
     "inner Join Acmast B On A.Cltcode = B.Cltcode Inner Join Ledger1 C On A.Vno = C.Vno " +  
     "and A.Vtyp = C.Vtyp And A.Booktype = C.Booktype Where A.Vno <> '' and A.cltcode= C1.Cl_Code And C1.sub_broker= '" + @Statusname + "'" +  
     "and A.Vtyp = 3 And A.Drcr = 'D' And A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "  
     If @Fromclientid <> ''  
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "' )"   
     End  
    
     If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End   
     If @VnoFr <> '' or @VnoTo <> ''   
       Begin  
        Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
      End   
   /* Set @Strsql = @Strsql + " Group By C.Ddno, A.Vtyp, A.Cltcode, A.Vno, A.Vdt, A.Acname, A.Drcr, A.Vamt, " +  
       "c.Dddt, A.Narration,D.Cltcode Order By A.Vno, A.Vdt, A.Drcr Desc " */  
  Set @Strsql = @Strsql + " Order By A.Vno, A.Vdt, A.Drcr Desc "  
    End  
  
  Else If @Reptype = '4'   
    Begin  
  --  **** Payment Cash.  
    Set @Strsql = "select  A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, A.Vamt,  A.Narration " +  
     "from Ledger A Inner Join (Select Vno, Cltcode, Acname, Vtyp, Booktype From msajag.dbo.Subbrokers S, msajag.dbo.Client1 C1 ,Ledger Where Vtyp = 4 And Drcr = 'C' "  
     If @Frombankcode <> ''   
  Begin  
      Set @Strsql = @Strsql + " And (Cltcode > = '" + @Frombankcode + "' And Cltcode < = '" + @Tobankcode + "')"   
     End   
     Set @Strsql = @Strsql + " ) D On A.Vno = D.Vno And A.Vtyp = D.Vtyp And A.Booktype = D.Booktype " +  
     "inner Join Acmast B On A.Cltcode = B.Cltcode Where A.Vno <> '' and A.cltcode= C1.Cl_Code And C1.sub_broker= '" + @Statusname + "'" +  
     "and A.Vtyp = 4 And A.Drcr = 'D' And A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "   
     If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End  
     If @VnoFr <> '' or @VnoTo <> ''   
        Begin  
         Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
       End  
     If @Fromclientid <> ''    
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "')"   
     End   
   /* Set @Strsql = @Strsql + " Group By  A.Vtyp, A.Cltcode, A.Vno, A.Vdt, A.Acname, A.Drcr, A.Vamt,  A.Narration " +  
       "order By A.Vno, A.Vdt, A.Drcr Desc " */  
   Set @Strsql = @Strsql + " order By A.Vno, A.Vdt, A.Drcr Desc "   
   End  
 
   Else If @Reptype = '1'   
    Begin  
  --  **** Receipt Cash.  
    Set @Strsql = "select  A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, A.Vamt,  A.Narration From msajag.dbo.Subbrokers S, msajag.dbo.Client1 C1 , Ledger A Inner Join (Select Vno, Cltcode, Acname, Vtyp, Booktype from Ledger Where Vtyp = 1 And Drcr = 'D' "  
     If @Frombankcode <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (Cltcode > = '" + @Frombankcode + "' And Cltcode < = '" + @Tobankcode + "')"       
     End  
     Set @Strsql = @Strsql + " ) D On A.Vno = D.Vno And A.Vtyp = D.Vtyp And A.Booktype = D.Booktype " +  
     " Inner Join Acmast B On A.Cltcode = B.Cltcode Where A.Vno <> '' and A.cltcode= C1.Cl_Code And C1.sub_broker= '" + @Statusname + "'" +  
     " And A.Vtyp = 1 And A.Drcr = 'C' And A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "  
     If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End  
     If @VnoFr <> '' or @VnoTo <> ''   
        Begin  
         Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
       End  
     If @Fromclientid <> ''  
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "')"   
     End  
   /* Set @Strsql = @Strsql + " Group By  A.Vtyp, A.Cltcode, A.Vno, A.Vdt, A.Acname, A.Drcr, A.Vamt,  A.Narration " +  
     "order By A.Vno, A.Vdt, A.Drcr Desc " */  
   Set @Strsql = @Strsql + " order By A.Vno, A.Vdt, A.Drcr Desc "  
  -----else Raiserror ('50001 : No Voucher Type Found For Branch.', 0, 13)  
   End  


        

--New */


else if  @Statusid ='Branch' 
 Begin  
 -- **** Branch Login.  
  If @Reptype = '16'   
    Begin  
  --  **** When Cheque Is Cancelled.  
    Set @Strsql = "select  C.Ddno, A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, " +  
     "a.Drcr, A.Vamt, Convert(Varchar(11), C.Dddt, 109) Cdt, A.Narration From Ledger A " +  
     "inner Join (Select Vno, Cltcode, Acname, Vtyp, Booktype From Ledger Where Vtyp = 16 And Drcr = 'D' "  
     If @Frombankcode <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (Cltcode > = '" + @Frombankcode + "' And Cltcode < = '" + @Tobankcode + "')"  
     End  
      
    Set @Strsql = @Strsql + " ) D On A.Vno = D.Vno And A.Vtyp = D.Vtyp And A.Booktype = D.Booktype " +  
     "inner Join Acmast B On A.Cltcode = B.Cltcode " +  
     "inner Join Ledger1 C On A.Vno = C.Vno And A.Vtyp = C.Vtyp And A.Booktype = C.Booktype " +  
     "where A.Vno <> '' And B.Branchcode = '" + @Statusname + "' And A.Vtyp = 16 And A.Drcr = 'C' " +  
     "and A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "  
   If @Chqno <> ''    
     Begin  
      Set @Strsql = @Strsql + "and C.Ddno = '" + @Chqno + "' "   
     End    
   If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End   
   If @VnoFr <> '' or @VnoTo <> ''   
        Begin  
         Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
       End  
   If @Fromclientid <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "')"   
     End  
   /* Set @Strsql = @Strsql + " Group By C.Ddno, A.Vtyp, A.Cltcode, A.Vno, A.Vdt, A.Acname, A.Drcr, A.Vamt, C.Dddt, A.Narration  " +  
       "order By A.Vno, A.Vdt, A.Drcr Desc " */  
   Set @Strsql = @Strsql + " order By A.Vno, A.Vdt, A.Drcr Desc "  
    End  
  
  Else If @Reptype = '17'   
    Begin  
  --  **** When Cheque Is Returned.(Vtyp = 17)  
    Set @Strsql = "select  C.Ddno, A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, " +  
     "A.Vamt, Convert(Varchar(11), C.Dddt, 109) Cdt, A.Narration From Ledger A " +  
     "Inner Join (Select Vno, Cltcode, Acname, Vtyp, Booktype From Ledger Where Vtyp = 17 And Drcr = 'C' "  
   If @Chqno <> ''    
     Begin  
      Set @Strsql = @Strsql + "and C.Ddno = '" + @Chqno + "' "   
     End    
   If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End    
   If @VnoFr <> '' or @VnoTo <> ''   
        Begin  
         Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
       End   
  If @Frombankcode <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (Cltcode > = '" + @Frombankcode + "' And Cltcode < = '" + @Tobankcode + "')"   
     End  
    Set @Strsql = @Strsql + " ) D On A.Vno = D.Vno And A.Vtyp = D.Vtyp And A.Booktype = D.Booktype  " +  
     "inner Join Acmast B On A.Cltcode = B.Cltcode " +  
     "inner Join Ledger1 C On A.Vno = C.Vno And A.Vtyp = C.Vtyp And A.Booktype = C.Booktype  " +  
     "where A.Vno <> '' And B.Branchcode = '" + @Statusname + "' And A.Vtyp = 17 And A.Drcr = 'D' And A.Vdt > = '" + @Fromdate + " 00:00:00' " +  
     "and A.Vdt < = '" + @Todate + " 23:59:59' "  
     If @Fromclientid <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "')"   
     End  
   /* Set @Strsql = @Strsql + " Group By C.Ddno, A.Vtyp, A.Cltcode, A.Vno, A.Vdt, A.Acname, A.Drcr, A.Vamt, C.Dddt, A.Narration " +  
       "order By A.Vno, A.Vdt, A.Drcr Desc " */  
  Set @Strsql = @Strsql + " order By A.Vno, A.Vdt, A.Drcr Desc "   
    End  
  
  Else If @Reptype = '19'   
    Begin  
  --  **** Margin Bank Received.(Vtyp = 19)  
    Set @Strsql = "select  Ledger.Narration, A.Booktype, A.Vtyp, A.Vno, A.Party_code Cltcode,  " +  
     "convert(Varchar(11), A.Vdt, 109) Vdt, B.Acname, A.Amount Vamt, A.Drcr, C.Ddno, Convert(Varchar(11), C.Dddt, 109) Cdt " +  
     "from Ledger Inner Join Marginledger A On Ledger.Vno = A.Vno And Ledger.Vtyp = A.Vtyp And Ledger.Booktype = A.Booktype  " +  
     "inner Join Ledger1 C On A.Vno = C.Vno And A.Vtyp = C.Vtyp And A.Booktype = C.Booktype " +  
     "inner Join Acmast B On A.Party_code = B.Cltcode Where B.Branchcode = '" + @Statusname + "' and A.Vtyp = 19 And A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "  
   If @Chqno <> ''    
     Begin  
      Set @Strsql = @Strsql + "and C.Ddno = '" + @Chqno + "' "   
     End      
   If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End    
    If @VnoFr <> '' or @VnoTo <> ''   
     Begin  
     Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
    End  
    If @Frombankcode <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (A.Party_code > = '" + @Frombankcode + "' And A.Party_code < = '" + @Tobankcode + "')"   
     End  
     If @Fromclientid <> ''  
     Begin  
      Set @Strsql = @Strsql + " And (A.Party_code > = '" + @Fromclientid + "' And A.Party_code < = '" + @Toclientid + "')"  
     End  
     
   /* Set @Strsql = @Strsql + " Group By A.Booktype, A.Vtyp, A.Vno,  A.Party_code, A.Vdt, B.Acname, A.Amount, A.Drcr, C.Ddno, C.Dddt, Ledger.Narration"*/  
      
    End  
  
  Else If @Reptype = '8'   
    Begin  
  --  **** Journal Voucher.(Vtyp = 8)  
    Set @Strsql = "select   A.Vtyp,  A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, " +   
     "a.Vamt, A.Narration From Ledger A Inner Join Acmast B On A.Cltcode = B.Cltcode Where A.Vno <> '' " +  
     "and B.Branchcode = '" + @Statusname + "' And A.Vtyp = 8  " +  
     "and A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "  
      If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End   
     If @VnoFr <> '' or @VnoTo <> ''   
        Begin  
         Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
       End    
     /*if(@Frombankcode <> "")   
      --@Strsql = @Strsql + " And (Cltcode > = '" & Trim(Strbankcode) & "' And Cltcode < = '" & Trim(Strtobankcode) & "')"       
     End If*/  
      
     If @Fromclientid <> ''  
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "')"   
     End  
   /* Set @Strsql = @Strsql + " Group By  A.Vtyp,  A.Cltcode, A.Vno, A.Vdt, A.Acname, A.Drcr, A.Vamt,  A.Narration " +  
     "order By A.Vno, A.Vdt, A.Drcr Desc " */  
  Set @Strsql = @Strsql + "order By A.Vno, A.Vdt, A.Drcr Desc "  
  
    End  
  
  Else If @Reptype = '6'   
    Begin  
  --  **** Debit Note.(Vtyp = 6)  
    Set @Strsql = "select  A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, A.Vamt, " +  
     "convert(Varchar(11), A.Cdt, 109) Cdt, B.Pobankname, B.Pobankcode, A.Narration " +  
     "from Ledger A Inner Join Acmast B On A.Cltcode = B.Cltcode Where B.Branchcode = '" + @Statusname + "' and A.Vtyp = 6  " +  
     "and A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "  
     If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End     
     If @VnoFr <> '' or @VnoTo <> ''   
        Begin  
         Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
       End  
     If @Frombankcode <> ''      Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Frombankcode + "' And A.Cltcode < = '" + @Tobankcode + "')"       
     End  
      
     If @Fromclientid <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid +"' ) "   
     End  
    Set @Strsql = @Strsql + " Order By A.Vno, A.Vdt, A.Drcr Desc"  
    End  
  
  Else If @Reptype = '7'  
    Begin   
  --  **** Credit Note.(Vtyp = 7)  
    Set @Strsql = "select  A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, A.Vamt, " +  
     "convert(Varchar(11), A.Cdt, 109) Cdt, B.Pobankname, B.Pobankcode, A.Narration " +  
     "from Ledger A Inner Join Acmast B On A.Cltcode = B.Cltcode Where B.Branchcode = '" + @Statusname + "' and A.Vtyp = 7   " +  
     "and A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "  
     If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End   
     If @VnoFr <> '' or @VnoTo <> ''   
        Begin  
         Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
       End  
     If @Frombankcode <> ''  
     Begin   
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Frombankcode + "' And A.Cltcode < = '" + @Tobankcode + "')"   
     End   
      
     If @Fromclientid <> ''   
    Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "') "   
     End  
    Set @Strsql = @Strsql + " Order By A.Vno, A.Vdt, A.Drcr Desc"  
    End  
  
  Else If @Reptype = '5'   
    Begin  
  --  **** Contra Entry. (Vtyp = 5)  
    Set @Strsql = "select  A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, A.Vamt, " +  
     "convert(Varchar(11), A.Cdt, 109) Cdt, B.Pobankname, B.Pobankcode, A.Narration " +  
     "from Ledger A Inner Join Acmast B On A.Cltcode = B.Cltcode Where B.Branchcode = '" + @Statusname + "' and A.Vtyp = 5 " +  
     "and A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "  
     If @Chqno <> ''    
     Begin  
      Set @Strsql = @Strsql + "and C.Ddno = '" + @Chqno + "' "   
     End   
     If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End   
     If @VnoFr <> '' or @VnoTo <> ''   
       Begin  
       Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
     End  
     If @Frombankcode <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Frombankcode + "' And A.Cltcode < = '" + @Tobankcode + "')"   
     End  
      
     If @Fromclientid <> ''   
     Begin   
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "') "   
     End  
    Set @Strsql = @Strsql + " Order By A.Vno, A.Vdt, A.Drcr Desc"  
     
    End  
  
  Else If @Reptype = '20'   
   Begin  
 --  **** Margin Bank Repayment. (Vtyp = 20)  
   Set @Strsql = "select  Ledger.Narration, A.Booktype, A.Vtyp, A.Vno, A.Party_code Cltcode, " +  
    "convert(Varchar(11), A.Vdt, 109) Vdt, B.Acname, A.Amount Vamt, A.Drcr, C.Ddno, Convert(Varchar(11), C.Dddt, 109) Cdt  " +  
    "from Ledger Inner Join Marginledger A On Ledger.Vno = A.Vno And Ledger.lno = A.lno And Ledger.Vtyp = A.Vtyp And " +  
    "ledger.Booktype = A.Booktype Inner Join Ledger1 C On A.Vno = C.Vno And A.Vtyp = C.Vtyp And " +  
    "a.Booktype = C.Booktype Inner Join Acmast B On A.Party_code = B.Cltcode Where B.Branchcode = '" + @Statusname + "' and A.Vtyp = 20 "  
    If @Chqno <> ''    
    Begin  
     Set @Strsql = @Strsql + "and C.Ddno = '" + @Chqno + "' "   
    End    
   If @VamtFr <> '' or @VamtTo <> ''   
    Begin  
     Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
    End   
   If @VnoFr <> '' or @VnoTo <> ''   
     Begin  
       Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
    End   
    If (@Frombankcode <> "")   
    Begin  
     Set @Strsql = @Strsql + " And (A.Party_code > = '" + @Frombankcode + "' And A.Party_code < = '" + @Tobankcode + "' )"  
    End  
    If @Fromclientid <> ''  
    Begin  
     Set @Strsql = @Strsql + " And (A.Party_code > = '" + @Fromclientid + "' And A.Party_code < = '" + @Toclientid + "')"  
    End  
    
  /* Set @Strsql = @Strsql + " Group By A.Booktype, A.Vtyp, A.Vno,  A.Party_code, A.Vdt, B.Acname, A.Amount, A.Drcr, " +  
    "c.Ddno,  C.Dddt, Ledger.Narration" */  
   End  
  
  Else If @Reptype = '22'   
    Begin  
  --  **** Margin Cash Received.(Vtyp = 22)    
    Set @Strsql = "select  Ledger.Narration, A.Booktype, A.Vtyp, A.Vno, A.Party_code Cltcode,  " +  
     "convert(Varchar(11), A.Vdt, 109) Vdt, B.Acname, A.Amount Vamt, A.Drcr  From Ledger " +  
     "inner Join Marginledger A On Ledger.Vno = A.Vno And Ledger.Vtyp = A.Vtyp And Ledger.Booktype = A.Booktype " +  
     "inner Join Acmast B On A.Party_code = B.Cltcode Where B.Branchcode = '" + @Statusname + "' and A.Vtyp = 22 "  
     If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End    
    If @VnoFr <> '' or @VnoTo <> ''   
        Begin  
         Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
       End  
    If @Frombankcode <> ''  
     Begin  
      Set @Strsql = @Strsql + " And (A.Party_code > = '" + @Frombankcode + "' And A.Party_code < = '" + @Tobankcode + "')"   
     End  
     If @Fromclientid <> ''  
     Begin  
      Set @Strsql = @Strsql + " And (A.Party_code > = '" + @Fromclientid + "' And A.Party_code < = '" + @Toclientid + "')"  
     End  
     
   /* Set @Strsql = @Strsql + " Group By A.Booktype, A.Vtyp, A.Vno,  A.Party_code, A.Vdt, B.Acname, A.Amount, A.Drcr, Ledger.Narration" */  
      
    End    
  
  Else If @Reptype = '23'   
    Begin  
  --  **** Margin Cash Repayment.  
    Set @Strsql = "select  Ledger.Narration, A.Booktype, A.Vtyp, A.Vno, A.Party_code Cltcode, " +  
     "convert(Varchar(11), A.Vdt, 109) Vdt, B.Acname, A.Amount Vamt, A.Drcr  From Ledger " +  
     "inner Join Marginledger A On Ledger.Vno = A.Vno And Ledger.Vtyp = A.Vtyp And Ledger.Booktype = A.Booktype " +  
     "inner Join Acmast B On A.Party_code = B.Cltcode Where B.Branchcode = '" + @Statusname + "' and A.Vtyp = 23 "  
     If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End   
    If @VnoFr <> '' or @VnoTo <> ''   
       Begin  
       Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
    End  
     If @Frombankcode <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (A.Party_code > = '" + @Frombankcode + "' And A.Party_code < = '" + @Tobankcode + "')"   
     End  
     If @Fromclientid <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (A.Party_code > = '" + @Fromclientid + "' And A.Party_code < = '" + @Toclientid + "')"  
     End  
     
   /* Set @Strsql = @Strsql + " Group By A.Booktype, A.Vtyp, A.Vno,  A.Party_code, A.Vdt, B.Acname, A.Amount, A.Drcr, Ledger.Narration" */  
    End  
  
  Else If @Reptype = '24'      
    Begin  
  --  **** Margin Journal Entries.(Vtyp = 24)  
      
    Set @Strsql = "select  A.Vtyp, A.Party_code  Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, B.Acname, A.Drcr, "+  
     " A.Amount Vamt, C.Narration From Marginledger A Inner Join Ledger C On A.Vno = C.Vno And A.Vtyp = C.Vtyp " +  
     "and A.Booktype = C.Booktype Inner Join Acmast B On  A.Party_code = B.Cltcode And A.Booktype = B.Booktype " +  
     "where A.Vno <> '' And B.Branchcode = '" + @Statusname + "' And A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "   
     /*if(Trim(Strbankcode) <> "")   
      'Strsql = Strsql + " And (Cltcode > = '" & Trim(Strbankcode) & "' And Cltcode < = '" & Trim(Strtobankcode) & "')"       
     End If */  
     If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End   
     If @VnoFr <> '' or @VnoTo <> ''   
       Begin  
       Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
     End  
     If @Fromclientid <> ''  
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "') "   
     End   
   /* Set @Strsql = @Strsql + " Group By  A.Vtyp, A.Party_code, A.Vno, A.Vdt, B.Acname, A.Drcr, A.Amount, C.Narration  " +  
       "order By A.Vno, A.Vdt, A.Drcr Desc " */  
   Set @Strsql = @Strsql + " order By A.Vno, A.Vdt, A.Drcr Desc "  
    End  
  
  Else If @Reptype = '3'   
    Begin  
  --  **** Payment Bank.  
    Set @Strsql = "select  C.Ddno, A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, A.Vamt, " +  
     "convert(Varchar(11), C.Dddt, 109) Cdt, A.Narration, D.CLTCODE as ctl From Ledger A Inner Join (Select Vno, Cltcode, Acname, Vtyp, " +  
     "booktype From Ledger Where Vtyp = 3 And Drcr = 'C' "  
     If @Frombankcode <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (Cltcode > = '" + @Frombankcode + "' And Cltcode < = '" + @Tobankcode + "')"   
     End  
       
     Set @Strsql = @Strsql + " ) D On A.Vno = D.Vno And A.Vtyp = D.Vtyp And A.Booktype = D.Booktype " +  
     "inner Join Acmast B On A.Cltcode = B.Cltcode Inner Join Ledger1 C On A.Vno = C.Vno " +  
     "and A.Vtyp = C.Vtyp And A.Booktype = C.Booktype Where A.Vno <> '' And B.Branchcode = '" + @Statusname + "'" +  
     "and A.Vtyp = 3 And A.Drcr = 'D' And A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "  
     If @Fromclientid <> ''  
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "' )"   
     End  
    
     If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End   
     If @VnoFr <> '' or @VnoTo <> ''   
       Begin  
        Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
      End   
   /* Set @Strsql = @Strsql + " Group By C.Ddno, A.Vtyp, A.Cltcode, A.Vno, A.Vdt, A.Acname, A.Drcr, A.Vamt, " +  
       "c.Dddt, A.Narration,D.Cltcode Order By A.Vno, A.Vdt, A.Drcr Desc " */  
  Set @Strsql = @Strsql + " Order By A.Vno, A.Vdt, A.Drcr Desc "  
    End  
  
  Else If @Reptype = '4'   
    Begin  
  --  **** Payment Cash.  
    Set @Strsql = "select  A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, A.Vamt,  A.Narration " +  
     "from Ledger A Inner Join (Select Vno, Cltcode, Acname, Vtyp, Booktype From Ledger Where Vtyp = 4 And Drcr = 'C' "  
     If @Frombankcode <> ''   
  Begin  
      Set @Strsql = @Strsql + " And (Cltcode > = '" + @Frombankcode + "' And Cltcode < = '" + @Tobankcode + "')"   
     End   
     Set @Strsql = @Strsql + " ) D On A.Vno = D.Vno And A.Vtyp = D.Vtyp And A.Booktype = D.Booktype " +  
     "inner Join Acmast B On A.Cltcode = B.Cltcode Where A.Vno <> '' And B.Branchcode = '" + @Statusname + "'" +  
     "and A.Vtyp = 4 And A.Drcr = 'D' And A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "   
     If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End  
     If @VnoFr <> '' or @VnoTo <> ''   
        Begin  
         Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
       End  
     If @Fromclientid <> ''    
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "')"   
     End   
   /* Set @Strsql = @Strsql + " Group By  A.Vtyp, A.Cltcode, A.Vno, A.Vdt, A.Acname, A.Drcr, A.Vamt,  A.Narration " +  
       "order By A.Vno, A.Vdt, A.Drcr Desc " */  
  Set @Strsql = @Strsql + " order By A.Vno, A.Vdt, A.Drcr Desc "   
    End  
  
  Else If @Reptype = '2'   
    Begin  
  --  **** Receipt Bank.  
    Set @Strsql = "select  C.Ddno, A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, " +  
     "a.Vamt, Convert(Varchar(11), C.Dddt, 109) Cdt, A.Narration, D.CLTCODE as ctl From Ledger A Inner Join " +  
     "(Select Vno, Cltcode, Acname, Vtyp, Booktype From Ledger Where Vtyp = 2 And Drcr = 'D' "  
     If @Frombankcode <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (Cltcode > = '" + @Frombankcode + "' And Cltcode < = '" + @Tobankcode + "' )"  
     End  
     Set @Strsql = @Strsql + " ) D On A.Vno = D.Vno And A.Vtyp = D.Vtyp And A.Booktype = D.Booktype " +  
     "inner Join Acmast B On A.Cltcode = B.Cltcode " +  
     "inner Join Ledger1 C On A.Vno = C.Vno And A.Vtyp = C.Vtyp And A.Booktype = C.Booktype " +  
     "where A.Vno <> '' And B.Branchcode = '" + @Statusname + "' And A.Vtyp = 2 And A.Drcr = 'C' And A.Vdt > = '" + @Fromdate + " 00:00:00' " +  
     "and A.Vdt < = '" + @Todate + " 23:59:59' "  
    If @Chqno <> ''    
     Begin  
      Set @Strsql = @Strsql + "and C.Ddno = '" + @Chqno + "' "   
     End    
    If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End  
    If @VnoFr <> '' or @VnoTo <> ''   
        Begin  
        Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
       End  
     If @Fromclientid <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "')"   
     End  
   /* Set @Strsql = @Strsql + " Group By C.Ddno, A.Vtyp, A.Cltcode, A.Vno, A.Vdt, A.Acname, A.Drcr, A.Vamt, C.Dddt, A.Narration,D.Cltcode Order By A.Vno, A.Vdt, A.Drcr Desc " */  
  Set @Strsql = @Strsql + " Order By A.Vno, A.Vdt, A.Drcr Desc "  
    End  
  
  Else If @Reptype = '1'   
    Begin  
  --  **** Receipt Cash.  
    Set @Strsql = "select  A.Vtyp, A.Cltcode, A.Vno, Convert(Varchar(11), A.Vdt, 109) Vdt, A.Acname, A.Drcr, A.Vamt,  A.Narration From Ledger A Inner Join (Select Vno, Cltcode, Acname, Vtyp, Booktype From Ledger Where Vtyp = 1 And Drcr = 'D' "  
     If @Frombankcode <> ''   
     Begin  
      Set @Strsql = @Strsql + " And (Cltcode > = '" + @Frombankcode + "' And Cltcode < = '" + @Tobankcode + "')"       
     End  
     Set @Strsql = @Strsql + " ) D On A.Vno = D.Vno And A.Vtyp = D.Vtyp And A.Booktype = D.Booktype " +  
     " Inner Join Acmast B On A.Cltcode = B.Cltcode Where A.Vno <> '' And B.Branchcode = '" + @Statusname + "'" +  
     " And A.Vtyp = 1 And A.Drcr = 'C' And A.Vdt > = '" + @Fromdate + " 00:00:00' And A.Vdt < = '" + @Todate + " 23:59:59' "  
     If @VamtFr <> '' or @VamtTo <> ''   
     Begin  
      Set @Strsql = @Strsql + "and A.vamt between " + @VamtFr + " And " + @VamtTo + " "  
     End  
     If @VnoFr <> '' or @VnoTo <> ''   
        Begin  
         Set @Strsql = @Strsql + "and A.vno between '" + @VnoFr + "'  And  '" + @VnoTo + "' "  
       End  
     If @Fromclientid <> ''  
     Begin  
      Set @Strsql = @Strsql + " And (A.Cltcode > = '" + @Fromclientid + "' And A.Cltcode < = '" + @Toclientid + "')"   
     End  
   /* Set @Strsql = @Strsql + " Group By  A.Vtyp, A.Cltcode, A.Vno, A.Vdt, A.Acname, A.Drcr, A.Vamt,  A.Narration " +  
     "order By A.Vno, A.Vdt, A.Drcr Desc " */  
   Set @Strsql = @Strsql + " order By A.Vno, A.Vdt, A.Drcr Desc "  
  -----else Raiserror ('50001 : No Voucher Type Found For Branch.', 0, 13)  
   End  
End  
  
Print @Strsql  
Execute ( @Strsql )

GO
