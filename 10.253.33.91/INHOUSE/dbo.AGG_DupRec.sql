-- Object: PROCEDURE dbo.AGG_DupRec
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE procedure AGG_DupRec      
as      
set nocount on      
select * INTO #A1 from ACCOUNT.dbo.ledger where vdt >=convert(Date,getdate()-10)       
AND CHECKEDBY='ONLINE' AND VTYP=2      
select * INTO #A2 from ACCOUNT.dbo.ledger where vdt >=convert(Date,getdate()-10)       
AND CHECKEDBY<>'ONLINE' AND VTYP=2      
SELECT B.*,A.DDNO,A.L1_SNO INTO #B1 FROM ACCOUNT.dbo.LEDGER1 A JOIN #A1 B ON A.VNO=B.VNO       
AND A.VTYP=B.VTYP AND A.LNO=B.LNO      
SELECT B.*,A.DDNO,A.L1_SNO INTO #B2 FROM ACCOUNT.dbo.LEDGER1 A JOIN #A2 B ON A.VNO=B.VNO       
AND A.VTYP=B.VTYP AND A.LNO=B.LNO      
SELECT A.* INTO #C1 FROM #B1 A JOIN  #B2 B ON A.CLTCODE=B.CLTCODE AND A.VAMT=B.VAMT AND A.DDNO=B.DDNO  
DELETE from AGG_DupRecLog where CONVERT(varchar(11),GETDATE(),106)= CONVERT(varchar(11),GETDATE(),106)     
insert into AGG_DupRecLog      
select count(1) as DupCount,Getdate() as ProTime From ACCOUNT.dbo.ledger where vtyp=2       
and vno in (Select vno from #c1)       
and checkedby='ONLINE' --AND CLTCODE NOT IN ('02020','03014')      
having count(1) > 0      
set nocount off

GO
