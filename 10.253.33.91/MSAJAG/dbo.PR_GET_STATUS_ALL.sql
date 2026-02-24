-- Object: PROCEDURE dbo.PR_GET_STATUS_ALL
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
  
  
CREATE PROC [dbo].[PR_GET_STATUS_ALL]  
(  
 @DATEFROM VARCHAR(11),  
 @DATETO VARCHAR(11)  
)  
AS  
  
/*--------------------------------------------------------------------  
 Include the segments as per the requirement  
----------------------------------------------------------------------*/  
  
IF @DATEFROM <>'' AND @DATETO <> ''  
BEGIN  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
   
 EXEC MSAJAG..PR_GET_STATUS @DATEFROM,@DATETO,'NSE','CAPITAL'  
 EXEC AngelBSECM.BSEDB_ab.dbo.PR_GET_STATUS @DATEFROM,@DATETO,'BSE','CAPITAL'  
 EXEC angelfo.NSEFO.dbo.PR_GET_STATUS @DATEFROM,@DATETO,'NSE','FUTURES' 
EXEC angelfo.nsecurfo.dbo.PR_GET_STATUS  @DATEFROM,@DATETO,'nsx','FUTURES'
EXEC angelcommodity.mcdx.dbo.PR_GET_STATUS  @DATEFROM,@DATETO,'mcx','FUTURES'
EXEC angelcommodity.ncdx.dbo.PR_GET_STATUS  @DATEFROM,@DATETO,'ncx','FUTURES'
EXEC angelcommodity.mcdxcds.dbo.PR_GET_STATUS  @DATEFROM,@DATETO,'mcd','FUTURES' 
END

GO
