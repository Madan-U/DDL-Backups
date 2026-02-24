-- Object: PROCEDURE dbo.V2_AGEING_REPORT_NEW
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE PROCEDURE [DBO].[V2_AGEING_REPORT_NEW](              
                @FILTER      VARCHAR(11),              
                @FROMPARTY   VARCHAR(10),              
                @TOPARTY     VARCHAR(10),              
                @BALANCE     MONEY,              
                @AGEINGON    VARCHAR(3),              
                @SEGMENT     INT,              
                @STATUSID    VARCHAR(20),              
                @STATUSNAME  VARCHAR(20),              
                @BRANCH_CD   VARCHAR(10)  = '%',      
    @AMOUNTOVER MONEY)              

/*==============================================================================================              
 @FILTER =               
  'CLIENT'               
  'FAMILY'               
  'TRADER'               
  'SUBBROKER'               
  'BRANCH'               
  'REGION'               
  'AREA'               
==============================================================================================*/              
              
AS              
            
  SET NOCOUNT ON            

SELECT        @SEGMENT = 1     

            
  DECLARE               
   @@SELECT_CLAUSE  VARCHAR(1000),               
   @@FROM_CLAUSE    VARCHAR(1000),               
   @@WHERE_CLAUSE   VARCHAR(1000),               
   @@GROUP_CLAUSE   VARCHAR(200),               
   @@ORDER_CLAUSE   VARCHAR(100),               
   @@GROUPCODE      VARCHAR(20),               
   @@GROUPNAME      VARCHAR(100)              
            
  SELECT @@GROUPCODE = ( CASE @FILTER               
      WHEN "CLIENT" THEN " F.PARTY_CODE "               
      WHEN "FAMILY" THEN " F.FAMILY "              
      WHEN "TRADER" THEN " F.TRADER "              
      WHEN "SUBBROKER" THEN " F.SUB_BROKER "              
      WHEN "BRANCH" THEN " F.BRANCH_CD "              
      WHEN "REGION" THEN " F.REGION "              
      WHEN "AREA" THEN " F.AREA "              
        END )               
                
  SELECT @@GROUPNAME = ( CASE @FILTER               
      WHEN "CLIENT" THEN " F.PARTY_NAME "               
      WHEN "FAMILY" THEN " F.FAMILY "              
      WHEN "TRADER" THEN " F.TRADER "              
      WHEN "SUBBROKER" THEN " F.SUB_BROKER "              
      WHEN "BRANCH" THEN " F.BRANCH_CD "              
      WHEN "REGION" THEN " F.REGION "              
      WHEN "AREA" THEN " F.AREA "              
        END )               
            
  SET @@SELECT_CLAUSE =                   " SELECT CLTCODE = " + @@GROUPCODE + ", LONG_NAME = " + @@GROUPNAME + ", "               
  SET @@SELECT_CLAUSE = @@SELECT_CLAUSE + "   BALANCE = SUM(BALANCE), "             
  SET @@SELECT_CLAUSE = @@SELECT_CLAUSE + "   BUCKET_1 = SUM(BUCKET_1), "             
  SET @@SELECT_CLAUSE = @@SELECT_CLAUSE + "   BUCKET_2 = SUM(BUCKET_2), "             
  SET @@SELECT_CLAUSE = @@SELECT_CLAUSE + "   BUCKET_3 = SUM(BUCKET_3), "             
  SET @@SELECT_CLAUSE = @@SELECT_CLAUSE + "   BUCKET_4 = SUM(BUCKET_4), "             
  SET @@SELECT_CLAUSE = @@SELECT_CLAUSE + "   BUCKET_5 = SUM(BUCKET_5), "             
  SET @@SELECT_CLAUSE = @@SELECT_CLAUSE + "   CASH = SUM(F.CASH), "             
  SET @@SELECT_CLAUSE = @@SELECT_CLAUSE + "   NONCASH = SUM(F.NONCASH), "             
  SET @@SELECT_CLAUSE = @@SELECT_CLAUSE + "   IMMARGIN = SUM(F.IMMARGIN), "             
  SET @@SELECT_CLAUSE = @@SELECT_CLAUSE + "   VARMARGIN = SUM(F.VARMARGIN) "             
            
  SET @@FROM_CLAUSE =                 " FROM V2_AGEINGFINAL V WITH(NOLOCK), "              
  SET @@FROM_CLAUSE = @@FROM_CLAUSE + "      V2_FOUT_LEDGERBALANCES F WITH(NOLOCK) "              
            
  SET @@WHERE_CLAUSE  =                  " WHERE V.CLTCODE = F.PARTY_CODE "              
  SET @@WHERE_CLAUSE  = @@WHERE_CLAUSE + "    AND V.SEGMENTCODE = " + CONVERT(CHAR,@SEGMENT) + " "             
  SET @@WHERE_CLAUSE  = @@WHERE_CLAUSE + "    AND V.BALDATETYPE = (CASE WHEN '" + @AGEINGON + "' = 'VDT' THEN 1 ELSE 2 END) "             
  SET @@WHERE_CLAUSE  = @@WHERE_CLAUSE + "    AND " + @@GROUPCODE + " BETWEEN '" + @FROMPARTY + "' AND '" + @TOPARTY + "' "            
            
  SET @@GROUP_CLAUSE = " Group By " + @@GROUPCODE + ", " + @@GROUPNAME               
  IF @BALANCE <> 0             
  BEGIN             
    SET @@GROUP_CLAUSE  = @@GROUP_CLAUSE + "    HAVING SIGN(SUM(BALANCE)) = " + CONVERT(CHAR,@BALANCE) + " AND"            
  END             
ELSE      
 BEGIN       
  SET @@GROUP_CLAUSE  = @@GROUP_CLAUSE + "  HAVING "       
 END      
      
  SET @@GROUP_CLAUSE  = @@GROUP_CLAUSE + " abs(sum(BUCKET_1+BUCKET_2+BUCKET_3+BUCKET_4+BUCKET_5))>" + CONVERT(CHAR,@AMOUNTOVER)      
      
  SET @@ORDER_CLAUSE = " Order By 1 "             
            
--PRINT ( @@SELECT_CLAUSE + @@FROM_CLAUSE + @@WHERE_CLAUSE + @@GROUP_CLAUSE + @@ORDER_CLAUSE )            
            
EXEC ( @@SELECT_CLAUSE + @@FROM_CLAUSE + @@WHERE_CLAUSE + @@GROUP_CLAUSE + @@ORDER_CLAUSE )

GO
