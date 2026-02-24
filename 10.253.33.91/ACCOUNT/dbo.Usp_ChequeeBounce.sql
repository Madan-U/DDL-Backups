-- Object: PROCEDURE dbo.Usp_ChequeeBounce
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

--exec Usp_ChequeeBounce  
CREATE Proc Usp_ChequeeBounce  
As  
BEGIN  
  
truncate table Tbl_ChequeeBounce
  
select  CLTCODE,ACNAME,VDT,NARRATION,VTYP,VAMT,VNO,BOOKTYPE,DRCR,'NSE' AS EXCHANGE,EDT into #Ledger FROM LEDGER (NOLOCK)  
where VTYP in ('16','17') and  vdt >='2022-04-01'  
  
select CLTCODE,VTYP,COUNT (CLTCODE) clt_count into #tbl_count from #Ledger group by CLTCODE,VTYP having COUNT (CLTCODE)>=2  
  
select a.*,b.VAMT,b.BOOKTYPE,b.VDT,b.VNO into #final_Data from #tbl_count a left join #Ledger b   
on a.CLTCODE=b.CLTCODE  
and a.VTYP=b.VTYP  
  
--select CLTCODE,VTYP,clt_count,sum (VAMT) as VAMT,BOOKTYPE,VDT,vno into #azx from #final_Data  
--group by CLTCODE,VTYP,clt_count,BOOKTYPE,VDT,vno  
  
  
select a.*,b.relamt into #tbl_Final_Amt from #final_Data a inner join LEDGER1 b on   
a.VTYP=b.vtyp  
and a.vno=b.vno  
and a.BOOKTYPE=b.BookType  
where a.VDT >='2022-04-01'  
  
  
insert into Tbl_ChequeeBounce  
select CLTCODE, SUM (relamt) as relamt from #tbl_Final_Amt where VDT>GETDATE()-2 group by   
CLTCODE  
  
END

GO
