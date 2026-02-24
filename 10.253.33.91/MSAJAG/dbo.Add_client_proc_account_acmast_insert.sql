-- Object: PROCEDURE dbo.Add_client_proc_account_acmast_insert
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


Create   Proc Add_client_proc_account_acmast_insert As
/* Acmast Query */
 Insert Into Acmast
  Select
   Tmplongname, Tmplongname, Actyp = 'Asset', Accat = '4', Familycd = '', Tmppartycode, Accdtls = '', 
   Grpcode = 'A0307000000', Booktype = '', Micrno = '0', Tmpbranchcode, 
   Tmpb2bpayment, Tmppaymentmode, 
   Tmppaymentbankname = 
   /*bank Name Fixed For Anagram - Nse*/
    (Select Ltrim(Rtrim(Acname)) From Account.Dbo.Acmast
    Where
     Charindex('&', Acname) = 0 And 
     Cltcode = '995116' And
     Accat = 2), 
   Tmppaymentbranchname, 
   Tmppaymentacno = 
   /*bank Code Fixed For Anagram - Nse*/
    (Select Ltrim(Rtrim(Cltcode)) From Account.Dbo.Acmast
    Where
     Charindex('&', Acname) = 0 And 
     Cltcode = '995116' And
     Accat = 2)
 From
  Msajag.Dbo.Tmp_client_details
 Where
  Tmppartycode Not In (Select Party_code From Msajag.Dbo.Clientmaster)

GO
