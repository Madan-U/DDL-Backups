-- Object: PROCEDURE dbo.RPT_PLEDGE_MARGIN_MTF_DIFF
-- Server: 10.253.33.91 | DB: scratchpad
--------------------------------------------------


CREATE PROCEDURE [dbo].[RPT_PLEDGE_MARGIN_MTF_DIFF]
(@TODATE DATETIME)  
  
AS
Select exchange,segment,Party_Code,scrip_Cd,series,ISIN,Qty Into #colla from MSAJAG..collateraldetails (Nolock)
where effdate=@TODATE and cash_Ncash ='N'

Select exchange,segment,Party_Code,scrip_Cd,series,ISIN,Qty Into #Margin_Colla from MSAJAG..v2_tbl_collateral_margin_combine (Nolock)
where effdate=@TODATE

Select Party_Code,ISIN,Qty Into #MTf  from MTFTRADE.dbo.tbl_mtf_marking (Nolock)
where sauda_date=@TODATE and HOLDFLAG ='FOCOLL'

Alter table #colla
Add Margin_Qty numeric(18,4),Mtf_Adjustment Numeric(18,4)


Create index #c on #colla(exchange,segment,Party_Code,ISIN)
Create index #c on #Margin_Colla(exchange,segment,Party_Code,ISIN)
Create index #c on #MTf(Party_Code,ISIN)
 

Update C Set Margin_Qty =0 ,Mtf_Adjustment=0 from #colla C

Update C Set Margin_Qty=M.QTY from #colla C, #Margin_Colla M
where C.Exchange=M.EXCHANGE and C.Segment =M.SEGMENT and C.Party_Code=M.PARTY_CODE and C.Isin=M.ISIN

Update C Set Mtf_Adjustment=M.QTY from #colla C, #MTf M
where   C.Party_Code=M.PARTY_CODE and C.Isin=M.ISIN


	IF OBJECT_ID(N'SCRATCHPAD..COLLATERAL_RECON_DATA') IS NOT NULL
    DROP TABLE COLLATERAL_RECON_DATA

    SELECT *
    INTO COLLATERAL_RECON_DATA
    FROM #colla
    WHERE Qty <> Margin_qty;
	
      
	  DECLARE @COUNT VARCHAR (MAX) 
	  SELECT @COUNT=COUNT(1) FROM COLLATERAL_RECON_DATA WHERE Qty <> Margin_qty;

    DECLARE @FILENAME VARCHAR(100) = 'J:\Backoffice\BHARAT\OUTPUT\' + 'COLLATERAL_DATA' + '.CSV';

    DECLARE @ALL VARCHAR(MAX)  
SET @all = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''EXCHANGE'''',''''SEGMENT'''',''''PARTY_CODE'''',''''SCRIP_CD'''',''''SERIES'''',''''ISIN'''',''''QTY'''',''''MARGIN_QTY'''',''''MTF_ADJUSTMENT'''''
SET @all = @all+ ' UNION ALL SELECT EXCHANGE,SEGMENT,PARTY_CODE,SCRIP_CD,SERIES,ISIN,CONVERT (VARCHAR,QTY),CONVERT (VARCHAR,MARGIN_QTY),CONVERT (VARCHAR,MTF_ADJUSTMENT) FROM SCRATCHPAD.DBO.COLLATERAL_RECON_DATA'                
            
set @all=@all+' " queryout ' +@filename+ ' -c -t"," -c -t"," -r"\n" -T'', NO_OUTPUT'
                 
EXEC(@all)    

    DROP TABLE #colla;
    DROP TABLE #Margin_Colla;
    DROP TABLE #MTf;
    DROP TABLE COLLATERAL_RECON_DATA;

    SELECT 'MTF_ADJUSTMENT DATA EXPORTED TO ' + @FILENAME +' AND THE TOTAL COUNT IS ' + @COUNT AS 'REMARK';

GO
