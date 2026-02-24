-- Object: PROCEDURE dbo.RPT_PNL_REPORT_FINYEAR
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC RPT_PNL_REPORT_FINYEAR  
(  
 @FROMDATE DATETIME,  
 @TODATE   DATETIME  
)  
AS  
  
DECLARE @FINYEARFROM DATETIME,  
  @FINYEARTO DATETIME  
  
SELECT @FINYEARFROM = (CASE WHEN MONTH(@FROMDATE) <= 3   
       THEN 'APR  1 ' + CONVERT(VARCHAR,YEAR(@FROMDATE) - 1)  
       ELSE 'APR  1 ' + CONVERT(VARCHAR,YEAR(@FROMDATE))  
        END),  
    @FINYEARTO   = (CASE WHEN MONTH(@FROMDATE) <= 3   
       THEN 'MAR 31 ' + CONVERT(VARCHAR,YEAR(@FROMDATE))  
       ELSE 'MAR 31 ' + CONVERT(VARCHAR,YEAR(@FROMDATE) + 1)  
        END)  
  
SELECT FLAG = (CASE WHEN @FROMDATE > @TODATE  
     THEN 'From Date should be less or equal to To Date'  
     WHEN @FROMDATE >= @FINYEARFROM AND @FROMDATE <= @FINYEARTO  
     AND @TODATE >= @FINYEARFROM AND @TODATE <= @FINYEARTO  
     THEN ''  
     ELSE 'From Date And To Date should belongs to same financial year.'  
      END)

GO
