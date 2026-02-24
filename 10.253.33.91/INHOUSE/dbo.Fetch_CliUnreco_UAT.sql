-- Object: PROCEDURE dbo.Fetch_CliUnreco_UAT
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE Procedure [dbo].[Fetch_CliUnreco_UAT](@pcode as varchar(10) = null)      
as      
Begin
/*------NEW LINE ADD FOR FINANCIAL YEAR CALENDER-----*/      
declare @fromdt as datetime,@todate as datetime        
select @fromdt=sdtcur from account.dbo.parameter with (nolock) where sdtnxt = (select sdtcur  from account.dbo.parameter with (nolock) where sdtcur <= getdate() and ldtcur >=getdate())        
--select @todate=ldtcur from account.dbo.parameter with (nolock) where sdtcur <= getdate() and ldtcur >=getdate() 
select @todate  = convert(varchar(11),getdate())+' 23:59:59' 
--------END-----------       

SELECT cltcode, SUM(unreco_amount) AS unreco_amount
INTO #final
FROM (
    SELECT 
        cltcode, 
        SUM(VAMT) AS unreco_amount
    FROM ledger WITH (NOLOCK)
    WHERE VDT >= @fromdt
      AND VDT < CAST(GETDATE() AS DATE)
      AND DRCR = 'C'
      AND EDT > CAST(GETDATE() AS DATE)
      AND VTYP IN (2, 8)
      AND ENTEREDBY <> 'mtf process'
    GROUP BY cltcode
    UNION ALL
    SELECT 
        l.cltcode, 
        SUM(l.VAMT) AS unreco_amount
    FROM ledger l WITH (NOLOCK)
    JOIN ledger1 t WITH (NOLOCK) 
        ON l.vtyp = t.vtyp 
       AND l.vno = t.vno 
       AND l.booktype = t.booktype
    WHERE l.VDT >= @fromdt
      AND l.VDT < CAST(GETDATE() AS DATE)
      AND l.DRCR = 'C'
      AND l.EDT <= CAST(GETDATE() AS DATE)
      AND l.VTYP = 2
      AND l.narration NOT LIKE 'Amount Received%'
      AND l.ENTEREDBY <> 'mtf process'
      AND t.reldt = '1900-01-01 00:00:00'
    GROUP BY l.cltcode

) a
GROUP BY cltcode

	      
	truncate table ncms_unreco_amt       
	insert into ncms_unreco_amt 
	select cltcode,unreco_amount from #final     
End

GO
