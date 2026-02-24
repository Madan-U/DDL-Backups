-- Object: PROCEDURE dbo.PROC_TURNTAX_EXCEPTION
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC [dbo].[PROC_TURNTAX_EXCEPTION]        
(            
	@SETT_TYPE VARCHAR(2),
	@SAUDA_DATE VARCHAR(11),
	@FROMPARTY  VARCHAR(10)='0',        
    @TOPARTY VARCHAR(10)='ZZZZZZZZZZ'          
)
AS

/*---------------------------------------------------------
 Proc for Turnover Tax Exception for Exchange Traded Funds
 eg. LIQUIDBEES,GOLDBEES
----------------------------------------------------------*/

select party_code,sett_type,scrip_Cd,sum(tradeqty*marketrate),sum(turn_tax)
 from settlement where sauda_date>='2020-08-03'  and sett_type ='N'  and party_code ='M139135'
 group by party_code,sett_type,scrip_Cd 

EXEC PROC_TOTTAX_SLAB_NEW @SETT_TYPE, @SAUDA_DATE, @FROMPARTY, @TOPARTY  

select party_code,sett_type,scrip_Cd,sum(tradeqty*marketrate),sum(turn_tax)
 from settlement where sauda_date>='2020-08-03'  and sett_type ='N'  and party_code ='M139135'
 group by party_code,sett_type,scrip_Cd 
    
DECLARE @SETT_NO VARCHAR(7)    
    
SELECT @SETT_NO = SETT_NO    
FROM SETT_MST     
WHERE START_DATE LIKE @SAUDA_DATE + '%'    
AND SETT_TYPE = @SETT_TYPE
    
UPDATE SETTLEMENT 
SET TURN_TAX = (TRADEQTY*MARKETRATE*TAX_PERC/100)
FROM TURNTAX_EXCEPTION (NOLOCK)
WHERE SETT_NO = @SETT_NO    
AND SETT_TYPE = @SETT_TYPE      
AND SAUDA_DATE BETWEEN DATEFROM AND DATETO
AND SETTLEMENT.SCRIP_CD = TURNTAX_EXCEPTION.SCRIP_CD
AND TURN_TAX > 0
and TAX_PERC >-1
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
    
UPDATE ISETTLEMENT
SET TURN_TAX = (TRADEQTY*MARKETRATE*TAX_PERC/100)
FROM TURNTAX_EXCEPTION (NOLOCK)
WHERE SETT_NO = @SETT_NO    
AND SETT_TYPE = @SETT_TYPE      
AND SAUDA_DATE BETWEEN DATEFROM AND DATETO
AND ISETTLEMENT.SCRIP_CD = TURNTAX_EXCEPTION.SCRIP_CD
AND TURN_TAX > 0
and TAX_PERC >-1
AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY

/*------------------------- EOF ----------------------*/

GO
