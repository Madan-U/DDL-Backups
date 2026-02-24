-- Object: PROCEDURE dbo.sp_VoucherReport
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROCEDURE sp_VoucherReport  
 ( @Reptype varchar(2),@FromDate varchar(11), @ToDate varchar(11), @FromBankCode varchar(10),   
  @ToBankCode varchar(10), @FromClientId varchar(10), @ToClientId varchar(10), @StatusId varchar(12), @Statusname varchar(12) )  
  
AS  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
declare @strSql as varchar(1000)  
  
IF  @StatusId <> 'BRANCH'  
BEGIN  
-- **** OTHER THAN BRANCH LOGIN.  
 If @Reptype='1'  
  Begin  
--  ****  Cheque is CANCELLED.  
  set @strSql = "SELECT c.ddno, a.vtyp, a.cltcode, a.vno, convert(varchar(11),a.vdt,109) vdt, a.acname," +   
   " a.drcr, a.vAmt, Convert(varchar(11),c.dddt,109) cdt, a.narration FROM ledger a (Nolock)" +   
   " INNER JOIN (select vno, cltcode, acname, vtyp, booktype from ledger(Nolock) where vtyp=16 AND drcr='D' "   
  
   if  @FromBankCode <> ''   
    Begin  
     set @strSql = @strSql + " AND (cltcode >= ' " + @FromBankCode + "' and cltcode <= '" + @ToBankCode + "')"  
    end  
     
  set @strSql = @strSql + " ) d on a.vno = d.vno AND a.vtyp = d.vtyp AND a.booktype = d.booktype " +  
   " INNER JOIN ledger1 c (Nolock) on a.vno = c.vno AND a.vtyp = c.vtyp AND a.BookType = c.BookType " +  
   " WHERE a.vno <> '' AND a.vtyp=16 AND a.drcr='C' AND a.vdt >= '" + @FromDate + "' AND a.vdt <= '" + @ToDate + " 23:59:59'" --test  
  
   if @FromClientId <> ''  
    begin  
     set @strSql = @strSql + " AND (a.cltcode >= '" + @FromClientId + "' and a.cltcode <= '" + @ToClientId + "')"   
    end  
  
  set @strSql = @strSql + " GROUP BY c.ddno, a.vtyp, a.cltcode, a.vno, a.vdt, a.acname, a.drcr, a.vAmt, c.dddt, a.narration ORDER BY a.vno, a.vdt, a.drcr DESC "  
  End   
 else if @Reptype='2'   
  Begin  
--  ****  Cheque is RETURNED.  
  set @strSql = "SELECT c.ddno, a.vtyp, a.cltcode, a.vno, convert(varchar(11),a.vdt,109) vdt, a.acname, a.drcr, " +  
   " a.vAmt, Convert(varchar(11),c.dddt,109) cdt, a.narration FROM ledger a (Nolock) " +  
   " INNER JOIN (select vno, cltcode, acname, vtyp, booktype from ledger(Nolock) where vtyp=17 AND drcr='C' "   
  
   if @FromBankCode <> ''  
   begin  
    set @strSql = @strSql + " AND (cltcode >='" + @FromBankCode + "' and cltcode <='" + @ToBankCode + "')"   
   end   
  
  set @strSql = @strSql + " ) d on a.vno = d.vno AND a.vtyp = d.vtyp AND a.booktype = d.booktype " +  
   " INNER JOIN ledger1 c (Nolock) on a.vno = c.vno AND a.vtyp = c.vtyp AND a.BookType = c.BookType " +  
   " WHERE a.vno <> '' AND a.vtyp=17 AND a.drcr='D' AND a.vdt >='" + @FromDate + " 00:00:00'" +  
   " AND a.vdt <='" + @ToDate + " 23:59:59' "  
  
   if @FromClientId <> ''  
   begin  
    set @strSql = @strSql + " AND (a.cltcode >='" + @FromClientId + "' and a.cltcode <='" + @ToClientId + "')"   
   end  
  
  set @strSql = @strSql + " GROUP BY c.ddno, a.vtyp, a.cltcode, a.vno, a.vdt, a.acname, a.drcr, a.vAmt, c.dddt, a.narration " +  
    "ORDER BY a.vno, a.vdt, a.drcr DESC "  
  End  
 else if @Reptype = '4'   
  Begin  
--  **** MARGIN BANK RECEIVED.  
  set @strSql = "SELECT ledger.narration, a.BookType, a.vtyp, a.vno, a.Party_code cltCode,  " +  
   "convert(varchar(11),a.vdt,109) vdt, b.acname, a.Amount vAmt, a.drcr, c.ddno, convert(varchar(11),c.dddt,109) cdt " +  
   "FROM ledger(Nolock) INNER JOIN MarginLedger(Nolock) a ON ledger.vno = a.vno AND ledger.vtyp = a.vtyp AND ledger.BookType = a.BookType " +  
   "INNER JOIN ledger1 c (Nolock) ON a.vno = c.vno AND a.vtyp = c.vtyp AND a.BookType = c.BookType " +  
   "INNER JOIN acmast b ON a.Party_code = b.cltcode WHERE a.vtyp = 19 AND a.vdt >='" + @FromDate + " 00:00:00'" +  
   " AND a.vdt <='" + @ToDate + " 23:59:59' "  
  
   if @FromBankCode <> ''  
   begin  
    set @strSql = @strSql + " AND (a.party_code >='" + @FromBankCode + "' and a.party_code <='" + @ToBankCode + "')"       
   end  
  
   if @FromClientId <> ''  
   begin  
    set @strSql = @strSql + " AND (a.party_code >='" + @FromClientId + "' and a.party_code <='" + @ToClientId + "')"  
   end  
   
 set @strSql = @strSql + " GROUP BY a.BookType, a.vtyp, a.vno,  a.Party_code, a.vdt, b.acname, a.Amount, a.drcr, c.ddno, c.dddt, ledger.narration"  
  
  End  
 else if @Reptype = '7'   
  Begin  
--  **** JOURNAL VOUCHER.  
  set @strSql = "SELECT  a.vtyp,  a.cltcode, a.vno, convert(varchar(11),a.vdt,109) vdt, a.acname, a.drcr, " +  
   "a.vAmt, a.narration FROM ledger a(Nolock) WHERE a.vno <> '' AND a.vtyp=8  " +  
   "AND a.vdt >='" + @FromDate + " 00:00:00' AND a.vdt <='" + @ToDate + " 23:59:59' "  
    
   /*if(@FromBankCode <> "")   
    --@strSql = @strSql + " AND (cltcode >= '" & trim(strBankCode) & "' and cltcode <= '" & Trim(strToBankCode) & "')"       
   end if  
    
   if(trim(strFromClientId) <> "")   
    'strSql = strSql + " AND (a.cltcode >= '" & trim(strFromClientId) & "' and a.cltcode <= '" & Trim(strToClientId) & "') "   
   end if */  
  
  set @strSql = @strSql + " GROUP BY  a.vtyp,  a.cltcode, a.vno, a.vdt, a.acname, a.drcr, a.vAmt,  a.narration " +  
   "order by a.vno, a.vdt, a.drcr DESC "  
  
  End  
 else if @Reptype = '9'   
  Begin  
--  **** DEBIT NOTE.  
  set @strSql = "SELECT  a.vtyp, a.cltcode, a.vno, convert(varchar(11),a.vdt,109) vdt, a.acname, a.drcr, a.vAmt, " +  
   "Convert(varchar(11),a.cdt,109) cdt, b.PoBankName, b.PoBankCode, a.narration " +  
   "FROM ledger a (Nolock) inner join acMast b on a.cltCode = b.cltCode WHERE a.vtyp=6  " +  
   "AND a.vdt >='" + @FromDate + " 00:00:00' AND a.vdt <='" + @ToDate + " 23:59:59' "  
     
   if @FromBankCode <> ''  
   begin  
    set @strSql = @strSql + " AND (a.cltcode >='" + @FromBankCode + "' and a.cltcode <='" + @ToBankCode + "')"   
   end  
    
   if @FromClientId <> ''  
   begin  
    set @strSql = @strSql + " AND (a.cltcode >='" + @FromClientId + "' and a.cltcode <='" + @ToClientId + "') "   
   end  
  
  set @strSql = @strSql + " ORDER BY a.vno, a.vdt, a.drcr DESC"  
  End  
 else if @Reptype = '10'   
  Begin  
--  **** CREDIT NOTE.  
  set @strSql = "SELECT  a.vtyp, a.cltcode, a.vno, convert(varchar(11),a.vdt,109) vdt, a.acname, a.drcr, a.vAmt, " +  
   "Convert(varchar(11),a.cdt,109) cdt, b.PoBankName, b.PoBankCode, a.narration " +  
   "FROM ledger a (Nolock) inner join acMast(Nolock) b on a.cltCode = b.cltCode WHERE a.vtyp=7  " +  
   "AND a.vdt >='" + @FromDate + " 00:00:00' AND a.vdt <='" + @ToDate + " 23:59:59' "  
  
   if @FromBankCode <> ''  
   begin  
    set @strSql = @strSql + " AND (a.cltcode >='" + @FromBankCode + " and a.cltcode <='" + @ToBankCode + "')"  
   end  
    
   if @FromClientId <> ''  
   begin  
    set @strSql = @strSql + " AND (a.cltcode >='" + @FromClientId + "' and a.cltcode <='" + @ToClientId + "') "   
   end  
  
  set @strSql = @strSql + " ORDER BY a.vno, a.vdt, a.drcr DESC"  
  
  End  
 else if @Reptype = '11'   
  Begin  
--  **** CONTRA ENTRY.  
  set @strSql = "SELECT  a.vtyp, a.cltcode, a.vno, convert(varchar(11),a.vdt,109) vdt, a.acname, a.drcr, a.vAmt, " +  
   "Convert(varchar(11),a.cdt,109) cdt, b.PoBankName, b.PoBankCode, a.narration " +  
   "FROM ledger a (Nolock) inner join acMast (Nolock) b on a.cltCode = b.cltCode WHERE a.vtyp=5 " +  
   "AND a.vdt >='" + @FromDate + " 00:00:00' AND a.vdt <='" + @ToDate + " 23:59:59' "  
  
   if @FromBankCode <> ''  
   begin  
    set @strSql = @strSql + " AND (a.cltcode >='" + @FromBankCode + "' and a.cltcode <='" + @ToBankCode + "')"   
   end  
    
   if @FromClientId <> ''  
   begin  
    set @strSql = @strSql + " AND (a.cltcode >='" + @FromClientId + "' and a.cltcode <='" + @ToClientId + "') "   
   end  
  
  set @strSql = @strSql + " ORDER BY a.vno, a.vdt, a.drcr DESC"  
   
  End  
 else if @Reptype = '13'   
  Begin  
--  **** MARGIN BANK REPAYMENT.  
  set @strSql = "SELECT ledger.narration, a.BookType, a.vtyp, a.vno, a.Party_code cltCode, " +  
   "convert(varchar(11),a.vdt,109) vdt, b.acname, a.Amount vAmt, a.drcr, c.ddno, convert(varchar(11),c.dddt,109) cdt " +  
   "FROM ledger (Nolock) INNER JOIN MarginLedger a (Nolock) ON ledger.vno = a.vno AND ledger.vtyp = a.vtyp AND " +  
   "ledger.BookType = a.BookType INNER JOIN ledger1 c (Nolock) ON a.vno = c.vno AND a.vtyp = c.vtyp AND " +  
   "a.BookType = c.BookType INNER JOIN acmast b ON a.Party_code = b.cltcode WHERE a.vtyp = 20 "  
  
   if @FromBankCode <> ''   
   begin  
    set @strSql = @strSql + " AND (a.party_code >='" + @FromBankCode + "' and a.party_code <='" + @ToBankCode + "')"       
   end  
  
   if @FromClientId <> ''  
   begin   
    set @strSql = @strSql + " AND (a.party_code >='" + @FromClientId + "' and a.party_code <='" + @ToClientId + "')"  
   end  
   
  set @strSql = @strSql + " GROUP BY a.BookType, a.vtyp, a.vno,  a.Party_code, a.vdt, b.acname, a.Amount, a.drcr,   
   c.ddno,  c.dddt, ledger.narration"  
  
  End  
 else if @Reptype = '14'    
  Begin  
--  **** MARGIN CASH RECEIVED.    
  set @strSql = "SELECT ledger.narration, a.BookType, a.vtyp, a.vno, a.Party_code cltCode, " +  
   "convert(varchar(11),a.vdt,109) vdt, b.acname, a.Amount vAmt, a.drcr  FROM ledger (nolock) " +  
   "INNER JOIN MarginLedger a (Nolock) ON ledger.vno = a.vno AND ledger.vtyp = a.vtyp AND ledger.BookType = a.BookType " +  
   "INNER JOIN acmast b ON a.Party_code = b.cltcode WHERE a.vtyp = 22 "  
  
   if @FromBankCode <> ''  
   begin  
    set @strSql = @strSql + " AND (a.party_code >='" + @FromBankCode + "' and a.party_code <='" + @ToBankCode + "')"   
   end  
  
   if @FromClientId <> ''  
   begin  
    set @strSql = @strSql + " AND (a.party_code >='" + @FromClientId + "' and a.party_code <='" + @ToClientId + "')"  
   end  
   
  set @strSql = @strSql + " GROUP BY a.BookType, a.vtyp, a.vno,  a.Party_code, a.vdt, b.acname, a.Amount, a.drcr, ledger.narration"  
  
  End  
 else if @Reptype = '15'   
  Begin  
--  **** MARGIN CASH REPAYMENT.  
  
  set @strSql = "SELECT ledger.narration, a.BookType, a.vtyp, a.vno, a.Party_code cltCode, " +  
   "convert(varchar(11),a.vdt,109) vdt, b.acname, a.Amount vAmt, a.drcr  FROM ledger(Nolock) " +  
   "INNER JOIN MarginLedger a (Nolock) ON ledger.vno = a.vno AND ledger.vtyp = a.vtyp AND ledger.BookType = a.BookType " +  
   "INNER JOIN acmast b ON a.Party_code = b.cltcode WHERE a.vtyp = 23 "  
  
   if @FromBankCode <> ''   
   begin  
    set @strSql = @strSql + " AND (a.party_code >='" + @FromBankCode + "' and a.party_code <='" + @ToBankCode + "')"   
   end  
  
   if @FromClientId <> ''   
   begin  
    set @strSql = @strSql + " AND (a.party_code >='" + @FromClientId + "' and a.party_code <='" + @ToClientId + "')"  
   end  
   
  set @strSql = @strSql + " GROUP BY a.BookType, a.vtyp, a.vno,  a.Party_code, a.vdt, b.acname, a.Amount, a.drcr, ledger.narration"  
  End  
 else if @Reptype = '16'      
  Begin  
--  **** MARGIN JOURNAL ENTRIES.(vtyp=24)  
    
  set @strSql = "SELECT a.vtyp, a.party_code  cltcode, a.vno, convert(varchar(11),a.vdt,109) vdt, b.acname, a.drcr, " +  
   " a.Amount vAmt, c.narration FROM marginledger a (Nolock) INNER JOIN ledger c (Nolock) on a.vno = c.vno AND a.vtyp = c.vtyp " +  
   "AND a.booktype = c.booktype INNER JOIN acmast b on  a.party_code = b.cltcode and a.booktype = b.booktype " +  
   "WHERE a.vno <> ''  AND a.vdt >='" + @FromDate + " 00:00:00' AND a.vdt <='" + @ToDate + " 23:59:59' "   
  
   /*if(trim(strBankCode) <> "")   
    'strSql = strSql + " AND (cltcode >= '" & trim(strBankCode) & "' and cltcode <= '" & Trim(strToBankCode) & "')"       
   end if */  
    
   if @FromClientId <> ''   
   begin  
    set @strSql = @strSql + " AND (a.cltcode >='" + @FromClientId + "' and a.cltcode <='" + @ToClientId + "') "   
   end  
  
  set @strSql = @strSql + " GROUP BY  a.vtyp, a.party_code, a.vno, a.vdt, b.acname, a.drcr, a.Amount, c.narration " +  
     "ORDER BY a.vno, a.vdt, a.drcr DESC "  
  
  End  
 else if @Reptype = '19'   
--  **** PAYMENT BANK.  
  Begin  
  set @strSql = "SELECT c.ddno, a.vtyp, a.cltcode, a.vno, convert(varchar(11),a.vdt,109) vdt, a.acname, a.drcr, a.vAmt, " +  
   "Convert(varchar(11),c.dddt,109) cdt, a.narration, ChequeInName FROM ledger a (Nolock) INNER JOIN (select vno, cltcode, acname, vtyp, " +  
   "booktype from ledger(Nolock) where vtyp=3 AND drcr='C' "  
  
   if @FromBankCode <> ''   
   begin  
    set @strSql = @strSql + " AND (cltcode >='" + @FromBankCode + "' and cltcode <='" + @ToBankCode + "')"       
   end  
   
   set @strSql = @strSql + " ) d on a.vno = d.vno AND a.vtyp = d.vtyp AND a.booktype = d.booktype INNER JOIN " +  
   "ledger1 c (Nolock) on a.vno = c.vno AND a.vtyp = c.vtyp AND a.BookType = c.BookType WHERE a.vno <> '' " +  
   "AND a.vtyp=3 AND a.drcr='D' AND a.vdt >='" + @FromDate + " 00:00:00' AND a.vdt <='" + @ToDate + " 23:59:59' "  
  
   if @FromClientId <> ''  
   begin  
    set @strSql = @strSql + " AND (a.cltcode >='" + @FromClientId + "' and a.cltcode <='" + @ToClientId + "')"   
   end  
  
  set @strSql = @strSql + " GROUP BY c.ddno, a.vtyp, a.cltcode, a.vno, a.vdt, a.acname, a.drcr, a.vAmt,   
     c.dddt, a.narration, ChequeInName ORDER BY a.vno, a.vdt, a.drcr DESC "  
  
  End  
 else if @Reptype = '20'   
  Begin  
--  **** PAYMENT CASH.  
  set @strSql = "SELECT  a.vtyp, a.cltcode, a.vno, convert(varchar(11),a.vdt,109) vdt, a.acname, a.drcr, a.vAmt,  a.narration FROM ledger a (Nolock) INNER JOIN (select vno, cltcode, acname, vtyp, booktype from ledger(Nolock) where vtyp=4 AND drcr='C' "  
  
   if @FromBankCode <> ''   
   begin   
    set @strSql = @strSql + " AND (cltcode >='" + @FromBankCode + "' and cltcode <='" + @ToBankCode + "')"   
   end  
  
   set @strSql = @strSql + " ) d on a.vno = d.vno AND a.vtyp = d.vtyp AND a.booktype = d.booktype WHERE a.vno <> '' AND a.vtyp=4 AND a.drcr='D' AND a.vdt >='" + @FromDate + " 00:00:00' AND a.vdt <='" + @ToDate + " 23:59:59' "   
  
   if @FromClientId <> ''   
   begin  
    set @strSql = @strSql + " AND (a.cltcode >='" + @FromClientId + "' and a.cltcode <='" + @ToClientId + "')"   
   end  
  
  set @strSql = @strSql + " GROUP BY  a.vtyp, a.cltcode, a.vno, a.vdt, a.acname, a.drcr, a.vAmt,  a.narration " +  
     "ORDER BY a.vno, a.vdt, a.drcr DESC "  
  
  End  
 else if @Reptype =  '21'   
  Begin  
--  **** RECEIPT BANK.  
  set @strSql = "SELECT c.ddno, a.vtyp, a.cltcode, a.vno, convert(varchar(11),a.vdt,109) vdt, a.acname, a.drcr, " +  
   "a.vAmt, Convert(varchar(11),c.dddt,109) cdt, a.narration FROM ledger a (Nolock) INNER JOIN " +  
   "(select vno, cltcode, acname, vtyp, booktype from ledger(Nolock) where vtyp=2 AND drcr='D' "  
  
   if @FromBankCode <> ''   
   begin  
    set @strSql = @strSql + " AND (cltcode >='" + @FromBankCode + "' and cltcode <='" + @ToBankCode + "')"       
   end  
   set @strSql = @strSql + " ) d on a.vno = d.vno AND a.vtyp = d.vtyp AND a.booktype = d.booktype " +  
   "INNER JOIN ledger1 c (Nolock) on a.vno = c.vno AND a.vtyp = c.vtyp AND a.BookType = c.BookType " +  
   "WHERE a.vno <> '' AND a.vtyp=2 AND a.drcr='C' AND a.vdt >='" + @FromDate + " 00:00:00' " +  
   "AND a.vdt <='" + @ToDate + " 23:59:59' "  
  
   if @FromClientId <> ''   
   begin  
    set @strSql = @strSql + " AND (a.cltcode >='" + @FromClientId + "' and a.cltcode <='" + @ToClientId + "' )"   
   end  
  
  set @strSql = @strSql + " GROUP BY c.ddno, a.vtyp, a.cltcode, a.vno, a.vdt, a.acname, a.drcr, a.vAmt, c.dddt, a.narration order by a.vno, a.vdt, a.drcr DESC "  
  
  End  
 else if @Reptype = '22'   
  Begin  
--  **** RECEIPT CASH.  
  set @strSql = "SELECT  a.vtyp, a.cltcode, a.vno, convert(varchar(11),a.vdt,109) vdt, a.acname, a.drcr, a.vAmt,  a.narration FROM ledger a (Nolock) INNER JOIN (select vno, cltcode, acname, vtyp, booktype from ledger(Nolock) where vtyp=1 AND drcr='D' "  
  
   if @FromBankCode <> ''   
   begin  
    set @strSql = @strSql + " AND (cltcode >='" + @FromBankCode + "' and cltcode <='" + @ToBankCode + "')"   
   end  
  
   set @strSql = @strSql + " ) d on a.vno = d.vno AND a.vtyp = d.vtyp AND a.booktype = d.booktype WHERE a.vno <> '' " + 

   "AND a.vtyp=1 AND a.drcr='C' AND a.vdt >='" + @FromDate + " 00:00:00' AND a.vdt <='" + @ToDate + " 23:59:59' "  
  
   if @FromClientId <> ''   
   begin  
    set @strSql = @strSql + " AND (a.cltcode >='" + @FromClientId + "' and a.cltcode <='" + @ToClientId + "')"   
   end  
  
  set @strSql = @strSql + " GROUP BY  a.vtyp, a.cltcode, a.vno, a.vdt, a.acname, a.drcr, a.vAmt,  a.narration " +  
   "order by a.vno, a.vdt, a.drcr DESC "  
   
 --Else RAISERROR ('50001 : NO VOUCHER TYPE FOUND',0,13)  
  End  
END  
  
ELSE  
  
BEGIN  
  
-- **** BRANCH LOGIN.  
  
 If @Reptype = '1'   
  Begin  
--  **** When Cheque is CANCELLED.  
  set @strSql = "SELECT c.ddno, a.vtyp, a.cltcode, a.vno, convert(varchar(11),a.vdt,109) vdt, a.acname, " +  
   "a.drcr, a.vAmt, Convert(varchar(11),c.dddt,109) cdt, a.narration FROM ledger a (Nolock) " +  
   "INNER JOIN (select vno, cltcode, acname, vtyp, booktype from ledger(Nolock) where vtyp=16 AND drcr='D' "  
  
   if @FromBankCode <> ''   
   begin  
    set @strSql = @strSql + " AND (cltcode >='" + @FromBankCode + "' and cltcode <='" + @ToBankCode + "')"  
   end  
    
  set @strSql = @strSql + " ) d on a.vno = d.vno AND a.vtyp = d.vtyp AND a.booktype = d.booktype " +  
   "INNER JOIN acmast b on a.cltcode = b.cltcode " +  
   "INNER JOIN ledger1 c (nolock) on a.vno = c.vno AND a.vtyp = c.vtyp AND a.BookType = c.BookType " +  
   "WHERE a.vno <> '' and b.branchcode ='" + @Statusname + "' AND a.vtyp=16 AND a.drcr='C' " +  
   "AND a.vdt >='" + @FromDate + " 00:00:00' AND a.vdt <='" + @ToDate + " 23:59:59' "  
  
   if @FromClientId <> ''   
   begin  
    set @strSql = @strSql + " AND (a.cltcode >='" + @FromClientId + "' and a.cltcode <='" + @ToClientId + "')"   
   end  
  
  set @strSql = @strSql + " GROUP BY c.ddno, a.vtyp, a.cltcode, a.vno, a.vdt, a.acname, a.drcr, a.vAmt, c.dddt, a.narration  " +  
     "ORDER BY a.vno, a.vdt, a.drcr DESC "  
  End  
 else if @Reptype = '2'   
  Begin  
--  **** When Cheque is RETURNED.(vtyp=17)  
  set @strSql = "SELECT c.ddno, a.vtyp, a.cltcode, a.vno, convert(varchar(11),a.vdt,109) vdt, a.acname, a.drcr, " +  
   ".vAmt, Convert(varchar(11),c.dddt,109) cdt, a.narration FROM ledger a (Nolock) " +  
   "NNER JOIN (select vno, cltcode, acname, vtyp, booktype from ledger(Nolock) where vtyp=17 AND drcr='C' "  
  
   if @FromBankCode <> ''   
   begin  
    set @strSql = @strSql + " AND (cltcode >='" + @FromBankCode + "' and cltcode <='" + @ToBankCode + "')"   
   end  
  
  set @strSql = @strSql + " ) d on a.vno = d.vno AND a.vtyp = d.vtyp AND a.booktype = d.booktype  " +  
   "INNER JOIN acmast b on a.cltcode = b.cltcode " +  
   "INNER JOIN ledger1 c (Nolock) on a.vno = c.vno AND a.vtyp = c.vtyp AND a.BookType = c.BookType  " +  
   "WHERE a.vno <> '' and b.branchcode ='" + @Statusname + "' AND a.vtyp=17 AND a.drcr='D' AND a.vdt >='" + @FromDate + " 00:00:00' " +  
   "AND a.vdt <='" + @ToDate + " 23:59:59' "  
  
   if @FromClientId <> ''   
   begin  
    set @strSql = @strSql + " AND (a.cltcode >='" + @FromClientId + "' and a.cltcode <='" + @ToClientId + "')"   
   end  
  
  set @strSql = @strSql + " GROUP BY c.ddno, a.vtyp, a.cltcode, a.vno, a.vdt, a.acname, a.drcr, a.vAmt, c.dddt, a.narration " +  
     "ORDER BY a.vno, a.vdt, a.drcr DESC "  
  
  End  
 else if @Reptype = '4'   
  Begin  
--  **** MARGIN BANK RECEIVED.(vtyp=19)  
  set @strSql = "SELECT ledger.narration, a.BookType, a.vtyp, a.vno, a.Party_code cltCode,  " +  
   "convert(varchar(11),a.vdt,109) vdt, b.acname, a.Amount vAmt, a.drcr, c.ddno, convert(varchar(11),c.dddt,109) cdt " +  
   "FROM ledger(Nolock) INNER JOIN MarginLedger a (Nolock) ON ledger.vno = a.vno AND ledger.vtyp = a.vtyp AND ledger.BookType = a.BookType  " +  
   "INNER JOIN ledger1 c (Nolock) ON a.vno = c.vno AND a.vtyp = c.vtyp AND a.BookType = c.BookType " +  
   "INNER JOIN acmast b ON a.Party_code = b.cltcode WHERE b.branchcode ='" + @Statusname + "' a.vtyp = 19 AND a.vdt >='" + @FromDate + " 00:00:00' AND a.vdt <='" + @ToDate + " 23:59:59' "  
  
   if @FromBankCode <> ''   
   begin  
    set @strSql = @strSql + " AND (a.party_code >='" + @FromBankCode + "' and a.party_code <='" + @ToBankCode + "')"   
   end  
  
   if @FromClientId <> ''  
   begin  
    set @strSql = @strSql + " AND (a.party_code >='" + @FromClientId + "' and a.party_code <='" + @ToClientId + "')"  
   end  
   
  set @strSql = @strSql + " GROUP BY a.BookType, a.vtyp, a.vno,  a.Party_code, a.vdt, b.acname, a.Amount, a.drcr, c.ddno, c.dddt, ledger.narration"  
    
  End  
 else if @Reptype = '7'   
  Begin  
--  **** JOURNAL VOUCHER.(vtyp=8)  
  set @strSql = "SELECT  a.vtyp,  a.cltcode, a.vno, convert(varchar(11),a.vdt,109) vdt, a.acname, a.drcr, " +   
   "a.vAmt, a.narration FROM ledger a (Nolock) Inner Join acmast b on a.cltcode = b.cltcode WHERE a.vno <> '' " +  
   "AND b.branchcode ='" + @Statusname + "' AND a.vtyp=8  " +  
   "AND a.vdt >='" + @FromDate + " 00:00:00' AND a.vdt <='" + @ToDate + " 23:59:59' "  
    
   /*if(@FromBankCode <> "")   
    --@strSql = @strSql + " AND (cltcode >= '" & trim(strBankCode) & "' and cltcode <= '" & Trim(strToBankCode) & "')"       
   end if  
    
   if(trim(strFromClientId) <> "")   
    'strSql = strSql + " AND (a.cltcode >= '" & trim(strFromClientId) & "' and a.cltcode <= '" & Trim(strToClientId) & "') "   
   end if */  
  
  set @strSql = @strSql + " GROUP BY  a.vtyp,  a.cltcode, a.vno, a.vdt, a.acname, a.drcr, a.vAmt,  a.narration " +  
   "order by a.vno, a.vdt, a.drcr DESC "  
  
  End  
 else if @Reptype = '9'   
  Begin  
--  **** DEBIT NOTE.(vtyp=6)  
  set @strSql = "SELECT  a.vtyp, a.cltcode, a.vno, convert(varchar(11),a.vdt,109) vdt, a.acname, a.drcr, a.vAmt, " +  
   "Convert(varchar(11),a.cdt,109) cdt, b.PoBankName, b.PoBankCode, a.narration " +  
   "FROM ledger a (Nolock) inner join acMast b on a.cltCode = b.cltCode WHERE b.branchcode ='" + @Statusname + "' AND a.vtyp=6  " +  
   "AND a.vdt >='" + @FromDate + " 00:00:00' AND a.vdt <='" + @ToDate + " 23:59:59' "  
     
   if @FromBankCode <> ''  
   begin  
    set @strSql = @strSql + " AND (a.cltcode >='" + @FromBankCode + "' and a.cltcode <='" + @ToBankCode + "')"       
   end  
    
   if @FromClientId <> ''   
   begin  
    set @strSql = @strSql + " AND (a.cltcode >='" + @FromClientId + "' and a.cltcode <='" + @ToClientId +"' ) "   
   end  
  
  set @strSql = @strSql + " ORDER BY a.vno, a.vdt, a.drcr DESC"  
  
  End  
 else if @Reptype = '10'  
  Begin   
--  **** CREDIT NOTE.(vtyp=7)  
  set @strSql = "SELECT  a.vtyp, a.cltcode, a.vno, convert(varchar(11),a.vdt,109) vdt, a.acname, a.drcr, a.vAmt, " +  
   "Convert(varchar(11),a.cdt,109) cdt, b.PoBankName, b.PoBankCode, a.narration " +  
   "FROM ledger a (Nolock) inner join acMast b on a.cltCode = b.cltCode WHERE b.branchcode ='" + @Statusname + "' AND a.vtyp=7   " +  
   "AND a.vdt >='" + @FromDate + " 00:00:00' AND a.vdt <='" + @ToDate + " 23:59:59' "  
  
   if @FromBankCode <> ''  
   begin   
    set @strSql = @strSql + " AND (a.cltcode >='" + @FromBankCode + "' and a.cltcode <='" + @ToBankCode + "')"   
   end   
    
   if @FromClientId <> ''   
   begin  
    set @strSql = @strSql + " AND (a.cltcode >='" + @FromClientId + "' and a.cltcode <='" + @ToClientId + "') "   
   end  
  
  set @strSql = @strSql + " ORDER BY a.vno, a.vdt, a.drcr DESC"  
  
  End  
 else if @Reptype = '11'   
  Begin  
--  **** CONTRA ENTRY. (vtyp=5)  
  set @strSql = "SELECT  a.vtyp, a.cltcode, a.vno, convert(varchar(11),a.vdt,109) vdt, a.acname, a.drcr, a.vAmt, " +  
   "Convert(varchar(11),a.cdt,109) cdt, b.PoBankName, b.PoBankCode, a.narration " +  
   "FROM ledger a (Nolock) inner join acMast b on a.cltCode = b.cltCode WHERE b.branchcode ='" + @Statusname + "' AND a.vtyp=5 " +  
   "AND a.vdt >='" + @FromDate + " 00:00:00' AND a.vdt <='" + @ToDate + " 23:59:59' "  
  
   if @FromBankCode <> ''   
   begin  
    set @strSql = @strSql + " AND (a.cltcode >='" + @FromBankCode + "' and a.cltcode <='" + @ToBankCode + "')"   
   end  
    
   if @FromClientId <> ''   
   begin   
    set @strSql = @strSql + " AND (a.cltcode >='" + @FromClientId + "' and a.cltcode <='" + @ToClientId + "') "   
   end  
  
  set @strSql = @strSql + " ORDER BY a.vno, a.vdt, a.drcr DESC"  
   
  End  
 else if @Reptype = '13'   
  Begin  
--  **** MARGIN BANK REPAYMENT. (vtyp=20)  
  set @strSql = "SELECT ledger.narration, a.BookType, a.vtyp, a.vno, a.Party_code cltCode, " +  
   "convert(varchar(11),a.vdt,109) vdt, b.acname, a.Amount vAmt, a.drcr, c.ddno, convert(varchar(11),c.dddt,109) cdt  " +  
   "FROM ledger(Nolock) INNER JOIN MarginLedger a (Nolock) ON ledger.vno = a.vno AND ledger.vtyp = a.vtyp AND " +  
   "ledger.BookType = a.BookType INNER JOIN ledger1 c (Nolock) ON a.vno = c.vno AND a.vtyp = c.vtyp AND " +  
   "a.BookType = c.BookType INNER JOIN acmast b ON a.Party_code = b.cltcode WHERE b.branchcode ='" + @Statusname + "' AND a.vtyp = 20 "  
  
   if (@FromBankCode <> "")   
   begin  
    set @strSql = @strSql + " AND (a.party_code >='" + @FromBankCode + "' and a.party_code <='" + @ToBankCode + "' )"  
   end  
  
   if @FromClientId <> ''  
   begin  
    set @strSql = @strSql + " AND (a.party_code >='" + @FromClientId + "' and a.party_code <='" + @ToClientId + "')"  
   end  
   
  set @strSql = @strSql + " GROUP BY a.BookType, a.vtyp, a.vno,  a.Party_code, a.vdt, b.acname, a.Amount, a.drcr, " +  
   "c.ddno,  c.dddt, ledger.narration"  
  
  End  
 else if @Reptype = '14'   
  Begin  
--  **** MARGIN CASH RECEIVED.(vtyp=22)    
  set @strSql = "SELECT ledger.narration, a.BookType, a.vtyp, a.vno, a.Party_code cltCode,  " +  
   "convert(varchar(11),a.vdt,109) vdt, b.acname, a.Amount vAmt, a.drcr  FROM ledger(Nolock) " +  
   "INNER JOIN MarginLedger a (Nolock) ON ledger.vno = a.vno AND ledger.vtyp = a.vtyp AND ledger.BookType = a.BookType " +  
   "INNER JOIN acmast b ON a.Party_code = b.cltcode WHERE b.branchcode ='" + @Statusname + "' AND a.vtyp = 22 "  
  
   if @FromBankCode <> ''  
   begin  
    set @strSql = @strSql + " AND (a.party_code >='" + @FromBankCode + "' and a.party_code <='" + @ToBankCode + "')"   
   end  
  
   if @FromClientId <> ''  
   begin  
    set @strSql = @strSql + " AND (a.party_code >='" + @FromClientId + "' and a.party_code <='" + @ToClientId + "')"  
   end  
   
  set @strSql = @strSql + " GROUP BY a.BookType, a.vtyp, a.vno,  a.Party_code, a.vdt, b.acname, a.Amount, a.drcr, ledger.narration"  
    
  End    
 else if @Reptype = '15'   
  Begin  
--  **** MARGIN CASH REPAYMENT.  
  
  set @strSql = "SELECT ledger.narration, a.BookType, a.vtyp, a.vno, a.Party_code cltCode, " +  
   "convert(varchar(11),a.vdt,109) vdt, b.acname, a.Amount vAmt, a.drcr  FROM ledger(Nolock) " +  
   "INNER JOIN MarginLedger a (Nolock) ON ledger.vno = a.vno AND ledger.vtyp = a.vtyp AND ledger.BookType = a.BookType " +  
   "INNER JOIN acmast b ON a.Party_code = b.cltcode WHERE b.branchcode ='" + @Statusname + "' AND a.vtyp = 23 "  
  
   if @FromBankCode <> ''   
   begin  
    set @strSql = @strSql + " AND (a.party_code >='" + @FromBankCode + "' and a.party_code <='" + @ToBankCode + "')"   
   end  
  
   if @FromClientId <> ''   
   begin  
    set @strSql = @strSql + " AND (a.party_code >='" + @FromClientId + "' and a.party_code <='" + @ToClientId + "')"  
   end  
   
  set @strSql = @strSql + " GROUP BY a.BookType, a.vtyp, a.vno,  a.Party_code, a.vdt, b.acname, a.Amount, a.drcr, ledger.narration"  
  
  End  
 else if @Reptype = '16'      
  Begin  
--  **** MARGIN JOURNAL ENTRIES.(vtyp=24)  
    
  set @strSql = "SELECT a.vtyp, a.party_code  cltcode, a.vno, convert(varchar(11),a.vdt,109) vdt, b.acname, a.drcr, "+  
   " a.Amount vAmt, c.narration FROM marginledger a (Nolock) INNER JOIN ledger c (Nolock) on a.vno = c.vno AND a.vtyp = c.vtyp " +  
   "AND a.booktype = c.booktype INNER JOIN acmast b on  a.party_code = b.cltcode and a.booktype = b.booktype " + 
   "WHERE a.vno <> '' and b.branchcode ='" + @Statusname + "' AND a.vdt >='" + @FromDate + " 00:00:00' AND a.vdt <='" + @ToDate + " 23:59:59' "   
  
   /*if(trim(strBankCode) <> "")   
    'strSql = strSql + " AND (cltcode >= '" & trim(strBankCode) & "' and cltcode <= '" & Trim(strToBankCode) & "')"       
   end if */  
    
   if @FromClientId <> ''  
   begin  
    set @strSql = @strSql + " AND (a.cltcode >='" + @FromClientId + "' and a.cltcode <='" + @ToClientId + "') "   
   end   
  
  set @strSql = @strSql + " GROUP BY  a.vtyp, a.party_code, a.vno, a.vdt, b.acname, a.drcr, a.Amount, c.narration  " +  
     "ORDER BY a.vno, a.vdt, a.drcr DESC "  
  
  End  
 else if @Reptype = '19'   
  Begin  
--  **** PAYMENT BANK.  
  
  set @strSql = "SELECT c.ddno, a.vtyp, a.cltcode, a.vno, convert(varchar(11),a.vdt,109) vdt, a.acname, a.drcr, a.vAmt, " +  
   "Convert(varchar(11),c.dddt,109) cdt, a.narration, ChequeInName FROM ledger a (Nolock) INNER JOIN (select vno, cltcode, acname, vtyp, " +  
   "booktype from ledger(Nolock) where vtyp=3 AND drcr='C' "  
  
   if @FromBankCode <> ''   
   begin  
    set @strSql = @strSql + " AND (cltcode >='" + @FromBankCode + "' and cltcode <='" + @ToBankCode + "')"   
   end  
   
   set @strSql = @strSql + " ) d on a.vno = d.vno AND a.vtyp = d.vtyp AND a.booktype = d.booktype " +  
   "INNER JOIN acmast b on a.cltcode = b.cltcode INNER JOIN ledger1 c (Nolock) on a.vno = c.vno " +  
   "AND a.vtyp = c.vtyp AND a.BookType = c.BookType WHERE a.vno <> '' and b.branchcode ='" + @Statusname + "'" +  
   "AND a.vtyp=3 AND a.drcr='D' AND a.vdt >='" + @FromDate + " 00:00:00' AND a.vdt <='" + @ToDate + " 23:59:59' "  
  
   if @FromClientId <> ''  
   begin  
    set @strSql = @strSql + " AND (a.cltcode >='" + @FromClientId + "' and a.cltcode <='" + @ToClientId + "' )"   
   end  
  
  set @strSql = @strSql + " GROUP BY c.ddno, a.vtyp, a.cltcode, a.vno, a.vdt, a.acname, a.drcr, a.vAmt, " +  
     "c.dddt, a.narration, ChequeInName ORDER BY a.vno, a.vdt, a.drcr DESC "  
  
  End  
 else if @Reptype = '20'   
  Begin  
--  **** PAYMENT CASH.  
  
  set @strSql = "SELECT  a.vtyp, a.cltcode, a.vno, convert(varchar(11),a.vdt,109) vdt, a.acname, a.drcr, a.vAmt,  a.narration " +  
   "FROM ledger a (Nolock) INNER JOIN (select vno, cltcode, acname, vtyp, booktype from ledger(Nolock) where vtyp=4 AND drcr='C' "  
  
   if @FromBankCode <> ''   
   begin  
    set @strSql = @strSql + " AND (cltcode >='" + @FromBankCode + "' and cltcode <='" + @ToBankCode + "')"   
   end   
  
   set @strSql = @strSql + " ) d on a.vno = d.vno AND a.vtyp = d.vtyp AND a.booktype = d.booktype " +  
   "Inner Join acmast b on a.cltcode = b.cltcode WHERE a.vno <> '' AND b.branchcode ='" + @Statusname + "'" +  
   "AND a.vtyp=4 AND a.drcr='D' AND a.vdt >='" + @FromDate + " 00:00:00' AND a.vdt <='" + @ToDate + " 23:59:59' "   
  
   if @FromClientId <> ''    
   begin  
    set @strSql = @strSql + " AND (a.cltcode >='" + @FromClientId + "' and a.cltcode <='" + @ToClientId + "')"   
   end   
  
  set @strSql = @strSql + " GROUP BY  a.vtyp, a.cltcode, a.vno, a.vdt, a.acname, a.drcr, a.vAmt,  a.narration " +  
     "ORDER BY a.vno, a.vdt, a.drcr DESC "  
  
  End  
 else if @Reptype = '21'   
  Begin  
--  **** RECEIPT BANK.  
  set @strSql = "SELECT c.ddno, a.vtyp, a.cltcode, a.vno, convert(varchar(11),a.vdt,109) vdt, a.acname, a.drcr, " +  
   "a.vAmt, Convert(varchar(11),c.dddt,109) cdt, a.narration FROM ledger a (Nolock) INNER JOIN " +  
   "(select vno, cltcode, acname, vtyp, booktype from ledger(Nolock) where vtyp=2 AND drcr='D' "  
  
   if @FromBankCode <> ''   
   begin  
    set @strSql = @strSql + " AND (cltcode >='" + @FromBankCode + "' and cltcode <='" + @ToBankCode + "' )"  
   end  
  
   set @strSql = @strSql + " ) d on a.vno = d.vno AND a.vtyp = d.vtyp AND a.booktype = d.booktype " +  
   "Inner Join acmast b on a.cltcode = b.cltcode " +  
   "INNER JOIN ledger1 c (Nolock) on a.vno = c.vno AND a.vtyp = c.vtyp AND a.BookType = c.BookType " +  
   "WHERE a.vno <> '' and b.branchcode ='" + @Statusname + "' AND a.vtyp=2 AND a.drcr='C' AND a.vdt >='" + @FromDate + " 00:00:00' " +  
   "AND a.vdt <='" + @ToDate + " 23:59:59' "  
  
   if @FromClientId <> ''   
   begin  
    set @strSql = @strSql + " AND (a.cltcode >='" + @FromClientId + "' and a.cltcode <='" + @ToClientId + "')"   
   end  
  
  set @strSql = @strSql + " GROUP BY c.ddno, a.vtyp, a.cltcode, a.vno, a.vdt, a.acname, a.drcr, a.vAmt, c.dddt, a.narration order by a.vno, a.vdt, a.drcr DESC "  
  
  End  
 else if @Reptype = '22'   
  Begin  
--  **** RECEIPT CASH.  
  set @strSql = "SELECT  a.vtyp, a.cltcode, a.vno, convert(varchar(11),a.vdt,109) vdt, a.acname, a.drcr, a.vAmt,  a.narration FROM ledger a (Nolock) INNER JOIN (select vno, cltcode, acname, vtyp, booktype from ledger(nolock) where vtyp=1 AND drcr='D' "  
  
   if @FromBankCode <> ''   
   begin  
    set @strSql = @strSql + " AND (cltcode >='" + @FromBankCode + "' and cltcode <='" + @ToBankCode + "')"       
   end  
  
   set @strSql = @strSql + " ) d on a.vno = d.vno AND a.vtyp = d.vtyp AND a.booktype = d.booktype " +  
   " Inner Join acmast b on a.cltcode = b.cltcode WHERE a.vno <> '' and b.branchcode ='" + @Statusname + "'" +  
   " AND a.vtyp=1 AND a.drcr='C' AND a.vdt >='" + @FromDate + " 00:00:00' AND a.vdt <='" + @ToDate + " 23:59:59' "  
  
   if @FromClientId <> ''  
   begin  
    set @strSql = @strSql + " AND (a.cltcode >='" + @FromClientId + "' and a.cltcode <='" + @ToClientId + "')"   
   end  
  
  set @strSql = @strSql + " GROUP BY  a.vtyp, a.cltcode, a.vno, a.vdt, a.acname, a.drcr, a.vAmt,  a.narration " +  
   "order by a.vno, a.vdt, a.drcr DESC "  
  
 --Else RAISERROR ('50001 : NO VOUCHER TYPE FOUND FOR BRANCH.',0,13)  
  
 End  
  
END  
  
PRINT ( @strSql )
EXECUTE ( @strSql )

GO
