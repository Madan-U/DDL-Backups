-- Object: PROCEDURE dbo.Newacmultiinsert_05092013
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE Procedure [dbo].[Newacmultiinsert_05092013]            
@Vtyp Smallint,                 
@Booktype Char(2),                 
@Vno Varchar(12),                 
@Lno Int,                 
@Vdt Varchar(11),                 
@Edt Varchar(11),                 
@Cltcode Varchar(10),                 
@Drcr Char(1),                  
@Vamt Money,                 
@Enteredby Varchar(25),                 
@Cdt Datetime, /*varchar(30), */                
@Checkedby Varchar(25),                 
@Pdt Datetime, /*varchar(30), */                
@Acname Varchar(50),                 
@Narration Varchar(234),                 
@Chequeinname Varchar(50),                 
@Chqprinted Tinyint,                 
@Accat Int,                 
@Bnkname Varchar(50),                 
@Brnname Varchar(30),                 
@Dd Char(1),                 
@Ddno Varchar(15),                 
@Dddt Datetime,                 
@Reldt Datetime,                 
@Relamt Money,                 
@Micrno Int,                 
@Sessionid Int,                 
@Branchname Char(10),                 
@Costflag Varchar(1),                 
@Costrowid Int,                 
@Clearingmode Char(1),                 
@Emode Char(1)                
/*slipno, , Chequeinname, Chqprinted*/                
As                
Declare                
@@Vno1 As Varchar(12),                 
@@Refno Char(12),                 
@@Nodays Int,                 
@@Actnodays Int,                 
@@Balamt Money,                 
@@Slipno Smallint,                 
@@Slipdate Datetime,                 
@@Clearingmode Char(2),                 
@@Receiptno Int,                 
@@Branch As Char(15),                 
@@Exchange As Varchar(3),                 
@@Segment As Varchar(10),                 
@@Sett_no As Varchar(7),                 
@@Sett_type As Varchar(3),                 
@@Party_code As Varchar(10),                 
@@Vdt1 As Datetime,                 
@@Edt1 As Datetime,                 
@@Dddt1 As Datetime,                 
@@Reldt1 As Datetime,                 
@@Recordcount As Int                
Select @@Vdt1 = Convert(Datetime, @Vdt+' '+convert(Varchar, Getdate(), 114))                
Select @@Edt1 = Convert(Datetime, @Edt+' '+convert(Varchar, Getdate(), 114))                
Select @@Dddt1 = Convert(Datetime, Substring(Convert(Varchar, @Dddt, 109), 1, 11)+' '+convert(Varchar, Getdate(), 114))                
/* Select @@Reldt1 = Convert(Datetime, Substring(Convert(Varchar, @Reldt, 109), 1, 11)+' 00:00:00' */                
Select @@Reldt1 = @Reldt                
Select @@Vno1 = @Vno                
Select @@Refno = ''                
Select @@Nodays = 0                
Select @@Actnodays  = 0                
Select @@Balamt = 0                
Select @@Slipno = 0                
Select @@Slipdate = ''                
/*select @@Clearingmode = ' ' */                
Select @@Receiptno = 0                
Select @@Branch =  'Branch'                
/* Inserting Record In Ledger */                
Insert Into Ledger(Vtyp, Vno, Drcr, Vamt, Vdt, Refno, Cltcode, Enteredby, Lno, Balamt,                 
Vno1, Booktype, Edt, Cdt, Pdt, Nodays, Actnodays, Checkedby, Acname, Narration)                 
Values (@Vtyp, @Vno, @Drcr, @Vamt, @@Vdt1, @@Refno, Upper(@Cltcode), @Enteredby, @Lno, @@Balamt,                 
@@Vno1, @Booktype, @@Edt1, @Cdt, @Pdt, @@Nodays, @@Actnodays, @Checkedby, @Acname, @Narration)                
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */                
/* Inserting Record In Ledger3 */                
Insert Into Ledger3(Naratno, Narr, Refno, Vtyp, Vno, Booktype) Values                
(@Lno, @Narration, @@Refno, @Vtyp, @Vno, @Booktype)                
/* Inserting Common Narration In Ledger3 */                
If @Lno = 2                 
Begin                
       Insert Into Ledger3(Naratno, Narr, Refno, Vtyp, Vno, Booktype) Values                
       (0, @Narration, @@Refno, @Vtyp, @Vno, @Booktype)                
End                 
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */                
/* Inserting Record In Ledger1 In Case Of Bank Related Vouchers*/                
If @Vtyp = 2 Or @Vtyp = 3 Or @Vtyp = 5 Or @Vtyp = 16 Or @Vtyp = 17  Or @Vtyp = 19 Or @Vtyp = 20                 
Begin              
    
   If (@Vtyp = 2 Or @Vtyp = 19 Or @Vtyp = 16)                
      Begin                
 If   ( @Drcr = 'C' Or @Drcr = 'C' ) And @Lno = 2                
      Begin      
             Insert Into  Ledger1(Lno, Bnkname, Brnname, Dd, Ddno, Dddt, Relamt, Vtyp, Vno, Booktype, Refno, Reldt, Micrno, Slipno, Slipdate, Clear_mode, Chequeinname, Chqprinted, Receiptno, Drcr)                
     Values (@Lno, @Bnkname, Substring(@Brnname, 1, 20), @Dd, Rtrim(@Ddno), @@Dddt1, @Relamt, @Vtyp, @Vno, @Booktype, @@Refno, @Reldt, @Micrno, @@Slipno, @@Slipdate, @Clearingmode, @Chequeinname, @Chqprinted, @@Receiptno, @Drcr)                
     End                 
      End                 
    Else If (@Vtyp = 3 Or @Vtyp = 20 Or @Vtyp = 17)                
        Begin                
   If  ( @Drcr = 'D' Or @Drcr = 'D' ) And @Lno = 2                
                 
   Begin                
        Insert Into Ledger1(Lno, Bnkname, Brnname, Dd, Ddno, Dddt, Relamt, Vtyp, Vno, Booktype, Refno, Reldt, Micrno, Slipno, Slipdate, Clear_mode, Chequeinname, Chqprinted, Receiptno, Drcr)                
            Values (@Lno, @Bnkname, Substring(@Brnname, 1, 20), @Dd, Rtrim(@Ddno), @@Dddt1, @Relamt, @Vtyp, @Vno, @Booktype, @@Refno, @Reldt, @Micrno, @@Slipno, @@Slipdate, @Clearingmode, @Chequeinname, @Chqprinted, @@Receiptno, @Drcr)                
      Insert Into Payadv(Cltcode, Acname, Vdt, Amt, Chequeno, Chequeinname, Narration, Printedflag, Actamt, Shortage, Vtyp, Vno, Booktype)                
            Values (Upper(@Cltcode), @Acname, @@Vdt1, @Relamt, Rtrim(@Ddno), @Chequeinname, @Narration, 0, @Vamt, 0, @Vtyp, @Vno, @Booktype)                
                  End                 
     End                
    Else If @Vtyp = 5                
        Begin                
             Insert Into  Ledger1(Lno, Bnkname, Brnname, Dd, Ddno, Dddt, Relamt, Vtyp, Vno, Booktype, Refno, Reldt, Micrno, Slipno, Slipdate, Clear_mode, Chequeinname, Chqprinted, Receiptno, Drcr)                
         Values (@Lno, @Bnkname, Substring(@Brnname, 1, 20), @Dd, Rtrim(@Ddno), @@Dddt1, @Relamt, @Vtyp, @Vno, @Booktype, @@Refno, @@Reldt1, @Micrno, @@Slipno, @@Slipdate, @Clearingmode, @Chequeinname, @Chqprinted, @@Receiptno, @Drcr)                
   If @Accat = 2 And @Drcr = 'C'                
   Begin                
           Insert Into Payadv(Cltcode, Acname, Vdt, Amt, Chequeno, Chequeinname, Narration, Printedflag, Actamt, Shortage, Vtyp, Vno, Booktype)                
            Values (Upper(@Cltcode), @Acname, @@Vdt1, @Relamt, Rtrim(@Ddno), @Chequeinname, @Narration, 0, @Vamt, 0, @Vtyp, @Vno, @Booktype)                
   End                
        End                
End                
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */                
/* Inserting Records In Matchdetails And Updating Billmatch */                
If @Lno = 2                 
Begin                
      Delete  From Tempbilldetails Where Payamount = 0 And Rtrim(Sessionid) = Rtrim(@Sessionid)                
       Update Billmatch Set Billmatch.Balamt = Billmatch.Balamt - Payamount From Tempbilldetails T                
        Where  Rtrim(T.Sessionid) = Rtrim(@Sessionid)                 
        And T.Party_code = Billmatch.Party_code And T.Billvtype = Billmatch.Vtype And T.Billbooktype = Billmatch.Booktype                 
        And T.Billvno = Billmatch.Vno And T.Billlno = Billmatch.Lno   
        Insert Into Matchdetails                
        Select Description, Upper(Party_code), Billvtype, Billvno, Billlno, Billbooktype, Drcr, Payamount, Vtype, @Vno, @Lno, Booktype                
        From Tempbilldetails Where  Rtrim(Sessionid) = Rtrim(@Sessionid)                 
End                
/* Insertting Records In Margin Ledger */                
If @Accat = 14 And (@Vtyp = 19 Or @Vtyp = 20 Or @Vtyp = 22 Or @Vtyp = 23 Or @Vtyp = 24)                
Begin                
   Insert Into Marginledger(Vtyp, Vno, Lno, Drcr, Vdt, Amount, Party_code, Exchange, Segment, Sett_no, Sett_type, Booktype, Mcltcode)                
   Values (@Vtyp, @Vno, @Lno, @Drcr, @@Vdt1, @Vamt, Upper(@@Party_code), @@Exchange, @@Segment, 0, @@Sett_type, @Booktype, Upper(@Cltcode))                
End                
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */                
If (@Vtyp = '8' or @Vtyp = '19' or @Vtyp = '20' or @Vtyp = '24') And Upper(@Emode) = 'M'                  
Begin                
Declare @Recordcounter Smallint           Declare @Partycode Varchar(50)                   
 Declare Cur_ledger_insert Cursor For                   
        Select Count(Party_code), Party_code From Templedger2 Where                   
        Vtype = @Vtyp And Vno = @Vno And Lno = @Lno And Drcr = @Drcr And                 
 Booktype = @Booktype And Sessionid = @Sessionid And Party_code = @Cltcode and costflag = 'A'  Group By Party_code                
                  
        Open Cur_ledger_insert                  
                  
        Fetch Next From Cur_ledger_insert                 
        Into @Recordcounter, @Partycode                
While @@Fetch_status = 0                  
Begin                 
--if  @Partycode <> @Cltcode                
If @Recordcounter = 1                
 Begin                
        Delete From Templedger2 Where Vtype = @Vtyp And Vno = @Vno And Lno = @Lno And Drcr = @Drcr And Booktype = @Booktype And Sessionid = @Sessionid                 
 --       Insert Into Templedger2 Values (@@Branch, @Branchname, @Vamt, @Vtyp, @Vno, @Lno, @Drcr, '0', @Booktype, @Sessionid, Upper(@Cltcode), 'A', 0 )                  
End                
/* Else                
 Begin                
  Update Templedger2 Set Paidamt = @Vamt Where Vtype = @Vtyp And Vno = @Vno And Lno = @Lno And Drcr = @Drcr And Booktype = @Booktype And Sessionid = @Sessionid                 
 End*/                
Fetch Next From Cur_ledger_insert                   
                   
End                  
                  
Close Cur_ledger_insert                  
Deallocate Cur_ledger_insert                  
End                 
/* Inserting Record In Templedger2 For Branch Wise Breakup When Brnachflag = 1 And Match_ctoc = 1 In Parameter For Selected Year*/                
If Upper(@Emode) = 'A' Or Upper(@Emode) = 'M'                
/*select @@Recordcount = Count(Party_code) From Templedger2 Where                 
Vtype = @Vtyp And Vno = @Vno And Lno = @Lno And Drcr = @Drcr And Booktype = @Booktype And Sessionid = @Sessionid And Party_code = Upper(@Cltcode) And Paidamt = @Vamt                
If @@Recordcount = 0                
Begin*/                
Begin                
 Insert Into Templedger2 Values ( @@Branch, @Branchname, @Vamt, @Vtyp, @Vno, @Lno, @Drcr, '0', @Booktype, @Sessionid, Upper(@Cltcode), 'A', 0 )                
End                
--end                
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */

GO
