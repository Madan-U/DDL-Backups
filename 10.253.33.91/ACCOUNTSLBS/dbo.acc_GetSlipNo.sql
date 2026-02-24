-- Object: PROCEDURE dbo.acc_GetSlipNo
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

/****** Object:  Stored Procedure dbo.acc_GetSlipNo    Script Date: 06/24/2004 8:32:35 PM ******/    
    
/****** Object:  Stored Procedure dbo.acc_GetSlipNo    Script Date: 05/10/2004 5:29:36 PM ******/    
    
/****** Object:  Stored Procedure dbo.acc_GetSlipNo    Script Date: 04/07/2003 12:28:25 PM ******/    
CREATE PROCEDURE  acc_GetSlipNo    
@cltcode varchar(10),    
@booktype varchar(2),    
@flag integer    
AS    
/*    
select distinct convert(integer,slipno) slipno from slipreceipt order by slipno     
*/    
    
if @flag = 1    
begin    
 select distinct slipno     
 from ledger1 l1, ledger l    
 where l1.vtyp = l.vtyp and l1.booktype= l.booktype and l1.vno = l.vno     
 and l.cltcode = @cltcode and l1.vtyp in (2,19) and l1.booktype = @booktype and slipno <> 0    
 order by slipno    
end    
else    
begin    
 select distinct convert(varchar,slipdate,103)  slipdate from ledger1 l    
 where l.vtyp in (2,19) and l.booktype =@booktype  and slipno <> 0    
 order by convert(varchar,slipdate,103)    
end

GO
