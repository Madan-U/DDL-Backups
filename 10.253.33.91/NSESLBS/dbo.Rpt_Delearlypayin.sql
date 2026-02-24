-- Object: PROCEDURE dbo.Rpt_Delearlypayin
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_DelEarlyPayIn   
(@Sett_No Varchar(7),  
 @Sett_Type Varchar(2),  
 @TransDate Varchar(11),  
 @ClDate Varchar(11)  
) As  


Select Scrip_Cd, Series, Qty = Sum(Qty), Amt = Convert(Numeric(18,4),0)
INTO #DEL From DelTrans 
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type
And Filler2 = 1 And TrType = 906 And DrCr = 'D'
And SlipNo > 0 And TransDate Like @TransDate + '%'  
GROUP BY Scrip_Cd, Series

UPDATE #DEL SET AMT = QTY * ISNULL(CL_RATE,0)
FROM CLOSING C
WHERE #DEL.SCRIP_CD = C.SCRIP_CD
AND #DEL.SERIES = C.SERIES
AND MARKET = 'NORMAL'
AND C.SysDate = (Select Max(SysDate) From Closing Where Scrip_CD = C.Scrip_Cd And Series = C.Series   
And Market = 'NORMAL' And SysDate <= @ClDate + ' 23:59:59')

SELECT * FROM #DEL
ORDER BY SCRIP_CD, SERIES

GO
