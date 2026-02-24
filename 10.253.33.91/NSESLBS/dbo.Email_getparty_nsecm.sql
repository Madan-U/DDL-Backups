-- Object: PROCEDURE dbo.Email_getparty_nsecm
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Procedure Email_getparty_nsecm          
          
@reportflag Varchar (50),          
@partyfrom Varchar(50),          
@partyto Varchar (50),          
@reportdate Varchar(20),          
@setttype Varchar (20),          
@datefrom Varchar (20),          
@dateto Varchar (20),          
@settno Varchar (20)          
          
          
As          
  
if @partyto = ''  
   Begin  
     set @partyto = 'ZZZZZZZZ'   
   end   
  
if @partyfrom = ''  
   Begin  
     set @partyfrom = '0'   
   end   
/*confirmation Report*/          
If @reportflag='confirmation'          
Begin          
 Select Distinct S.party_code,email From Settlement S,client1 C1, Client2 C2, Email_partyreport E          
  Where C1.cl_code = C2.cl_code And S.party_code = C2.party_code And E.email_party_code = S.party_code          
  And Convert(varchar,s.sauda_date,109) Like @reportdate And S.party_code >= @partyfrom And S.party_code <= @partyto          
  And S.sett_type = @setttype          
  Union          
  Select Distinct S.party_code,email From Isettlement S,client1 C1, Client2 C2, Email_partyreport E          
  Where C1.cl_code = C2.cl_code And S.party_code = C2.party_code And E.email_party_code = S.party_code          
  And Convert(varchar,s.sauda_date,109) Like @reportdate And S.party_code >= @partyfrom And S.party_code <= @partyto          
  And S.sett_type = @setttype          
  Union          
  Select Distinct S.party_code,email From History S,client1 C1, Client2 C2, Email_partyreport E Where C1.cl_code = C2.cl_code          
  And S.party_code = C2.party_code And E.email_party_code = S.party_code And Convert(varchar,s.sauda_date,109) Like @reportdate          
  And S.party_code >= @partyfrom And S.party_code <= @partyto And S.sett_type = @setttype Order By S.party_code          
End          
Else          
Begin          
 If @reportflag='ledger'          
 Begin/*ledger*/          
  Select Distinct C2.party_code,email From Client1 C1, Client2 C2,email_partyreport E          
  Where C1.cl_code = C2.cl_code And E.email_party_code = C2.party_code And C2.party_code >= @partyfrom          
  And C2.party_code <= @partyto Order By C2.party_code          
 End/*ledger*/          
 Else          
 Begin          
  If @reportflag='contractannexure'          
  Begin/*contract Annexure*/          
   Select Distinct S.party_code,email From Settlement S,client1 C1, Client2 C2, Email_partyreport E          
   Where C1.cl_code = C2.cl_code And S.party_code = C2.party_code And E.email_party_code = S.party_code          
   /*and Sauda_date >= @datefrom And Sauda_date >= @dateto And S.party_code >= @partyfrom And S.party_code <= @partyto*/          
   And Sauda_date >= @datefrom And Sauda_date <= @dateto + ' 23:59:59' And S.party_code >= @partyfrom And S.party_code <= @partyto          
   Union          
   Select Distinct S.party_code,email From Bsedb.dbo.settlement S,client1 C1, Client2 C2, Email_partyreport E          
   Where C1.cl_code = C2.cl_code And S.party_code = C2.party_code And E.email_party_code = S.party_code          
   /*and Sauda_date >= @datefrom And Sauda_date >= @dateto And S.party_code >= @partyfrom And S.party_code <= @partyto*/          
   And Sauda_date >= @datefrom And Sauda_date <= @dateto + ' 23:59:59' And S.party_code >= @partyfrom And S.party_code <= @partyto          
   Union          
   Select Distinct S.party_code,email From History S,client1 C1, Client2 C2, Email_partyreport E          
   Where C1.cl_code = C2.cl_code And S.party_code = C2.party_code And E.email_party_code = S.party_code          
   /*and Sauda_date >= @datefrom And Sauda_date >= @dateto And S.party_code >= @partyfrom And S.party_code <= @partyto*/          
   And Sauda_date >= @datefrom And Sauda_date <= @dateto + ' 23:59:59' And S.party_code >= @partyfrom And S.party_code <= @partyto          
   Union          
   Select Distinct S.party_code,email From Bsedb.dbo.history S,client1 C1, Client2 C2, Email_partyreport E          
   Where C1.cl_code = C2.cl_code And S.party_code = C2.party_code And E.email_party_code = S.party_code          
   /*and Sauda_date >= @datefrom And Sauda_date >= @dateto And S.party_code >= @partyfrom And S.party_code <= @partyto*/          
   And Sauda_date >= @datefrom And Sauda_date <= @dateto + ' 23:59:59' And S.party_code >= @partyfrom And S.party_code <= @partyto          
   Order By S.party_code          
  End/*contract Annexure*/          
 Else          
  Begin          
   If @reportflag='bill'          
   Begin/*bill Report*/          
    Select Distinct S.party_code,email From History S,client1 C1, Client2 C2, Email_partyreport E          
     Where C1.cl_code = C2.cl_code And S.party_code = C2.party_code And E.email_party_code = S.party_code          
     And S.sett_no = @settno And S.sett_type = @setttype And S.party_code >= @partyfrom And S.party_code <= @partyto          
     Union          
     Select Distinct S.party_code,email From Settlement S,client1 C1, Client2 C2, Email_partyreport E          
     Where C1.cl_code = C2.cl_code And S.party_code = C2.party_code And E.email_party_code = S.party_code          
     And S.sett_no = @settno And S.sett_type = @setttype And S.party_code >= @partyfrom And S.party_code <= @partyto          
     Union          
     Select Distinct S.party_code,email From Isettlement S,client1 C1, Client2 C2, Email_partyreport E          
     Where C1.cl_code = C2.cl_code And S.party_code = C2.party_code And E.email_party_code = S.party_code          
     And S.sett_no = @settno And S.sett_type = @setttype And S.party_code >= @partyfrom And S.party_code <= @partyto          
     Order By S.party_code          
   End/*bill Report*/          
   Else           
   Begin          
    If @reportflag = 'auction'          
    Begin          
     Select Distinct C2.party_code,email From Settlement D,client1 C1, Client2 C2,email_partyreport E          
     Where C1.cl_code = C2.cl_code And E.email_party_code = C2.party_code And C2.party_code >= @partyfrom And C2.party_code <= @partyto           
     And C2.party_code = D.party_code /*And Auctionpart Like 'f%'*/ And Sett_no = @settno And Sett_type = @setttype          
     Order By C2.party_code               
    End          
    Else          
     Begin          
      If @reportflag = 'contcumbill'          
      Begin          
       Select Distinct S.party_code,email From Settlement S,client1 C1, Client2 C2, Email_partyreport E          
       Where C1.cl_code = C2.cl_code And S.party_code = C2.party_code And E.email_party_code = S.party_code           
       And Convert(varchar,s.sauda_date,109) LIKE @reportdate + '%' And S.party_code >= @partyfrom And S.party_code <= @partyto          
       And S.sett_type = @setttype          
       Order By S.party_code                
      End          
     Else          
     Begin/*default*/          
      Select Distinct C2.party_code,email From Client1 C1, Client2 C2,email_partyreport E          
      Where C1.cl_code = C2.cl_code And E.email_party_code = C2.party_code And C2.party_code >= @partyfrom And C2.party_code <= @partyto Order By C2.party_code               
     End/*default*/                   
    End          
   End          
  End          
 End          
End

GO
