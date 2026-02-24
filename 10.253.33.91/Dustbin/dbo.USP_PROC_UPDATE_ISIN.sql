-- Object: PROCEDURE dbo.USP_PROC_UPDATE_ISIN
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------

        
CREATE PROC [dbo].[USP_PROC_UPDATE_ISIN] (@ISIN varchar(30),@Sett_No int ,@Sett_type Varchar(2),@Scripname Varchar(max),@Sauda_Date varchar(30))        
AS        
         
 BEGIN         
        
 update MSAJAG..COMMON_CONTRACT_DATA set ISIN=@ISIN where Sauda_Date >=@Sauda_Date        
and Sauda_Date <=@Sauda_Date + ' 23:59:59' and Sett_no=@Sett_No        
and Sett_type=@Sett_type and Scripname=@Scripname and ISIN=''        

SELECT 'ISIN '+ @ISIN + ' IS UPDATED SUCESSFULLY...!!!' AS STATUS      
    
END

GO
