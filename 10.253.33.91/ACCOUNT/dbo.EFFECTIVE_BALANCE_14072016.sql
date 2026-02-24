-- Object: PROCEDURE dbo.EFFECTIVE_BALANCE_14072016
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE proc [dbo].[EFFECTIVE_BALANCE_14072016] (  
@TODATE   VARCHAR (11)  
) AS BEGIN  
SELECT  
cltcode,SUM(vamt)as vamt  from (  
select CLTCODE,SUM(BALAMT)vamt   from ledger  
where  
edt>='apr  1 2017' and   
edt<=@TODATE + ' 23:59:59' and VTYP='18' group by cltcode  
union all  
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from ledger  
where  
edt>='apr  1 2017' and  
 edt<=@TODATE + ' 23:59:59' and VTYP<>'18' group by cltcode)a  
 group by cltcode  
  
END

GO
