-- Object: PROCEDURE dbo.CBO_ADDNEWBROKRAGE
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

--SELECT * FROM BROKTABLE
/*  
 DECLARE   
	 @TABLE_NO SMALLINT,  
	 @LINE_NO DECIMAL(3,0),  
	 @VAL_PERC CHAR(1),  
	 @UPPER_LIM MONEY,     
	 @DAY_PUC NUMERIC(18, 14),   
	 @DAY_SALES NUMERIC(18, 14),  
	 @SETT_PURCH NUMERIC(18, 14),    
	 @ROUND_TO DECIMAL(10, 2),  
	 @TABLE_NAME CHAR(25),  
	 @SETT_SALES NUMERIC(18, 4),  
	 @NORMAL DECIMAL(10, 6),  
	 @TRD_DEL CHAR(1),  
	 @LOWER_LIM DECIMAL(10, 2),  
	 @DEF_TABLE TINYINT,  
	 @ROFIG INT,  
	 @ERRNUM NUMERIC(18, 4),  
	 @NOZERO INT,  
	 @BRANCH_CODE VARCHAR(10),  
	 @STATUSID VARCHAR(25),  
	 @STATUSNAME VARCHAR(25),  
	 @RETURNMSG VARCHAR(100) OUTPUT
		
		SET @TABLE_NO = 2  
		SET @LINE_NO = 1  
		SET @VAL_PERC = 'P'  
		SET @UPPER_LIM = 10000  
		SET @DAY_PUC = 0.5  
		SET @DAY_SALES = 0  
		SET @SETT_PURCH = 0  
		SET @ROUND_TO = 2  
		SET @TABLE_NAME = 'table #2'  
		SET @SETT_SALES = 0  
		SET @NORMAL = 0.5  
		SET @TRD_DEL = 'T'  
		SET @LOWER_LIM = 0  
		SET @DEF_TABLE = 0  
		SET @ROFIG = 0  
		SET @ERRNUM = 0  
		SET @NOZERO = 0  
		SET @BRANCH_CODE = 'ALL'  
		SET @STATUSID = 'broker'  
		SET @STATUSNAME = 'broker'  
  
  
 EXEC CBO_ADDNEWBROKRAGE   
 @TABLE_NO,  
 @LINE_NO,  
 @VAL_PERC,  
 @UPPER_LIM,  
 @DAY_PUC,  
 @DAY_SALES,  
 @SETT_PURCH,  
 @ROUND_TO,  
 @TABLE_NAME,  
 @SETT_SALES,  
 @NORMAL,  
 @TRD_DEL,  
 @LOWER_LIM,  
 @DEF_TABLE,  
 @ROFIG,  
 @ERRNUM,  
 @NOZERO,  
 @BRANCH_CODE,  
 @STATUSID,  
 @STATUSNAME,  
 @RETURNMSG OUTPUT  
  
print @RETURNMSG   
  
*/  
  
CREATE PROCEDURE  CBO_ADDNEWBROKRAGE  
(  
	 @TABLE_NO SMALLINT,  
	 @LINE_NO DECIMAL(3,0),  
	 @VAL_PERC CHAR(1),  
	 @UPPER_LIM MONEY,     
	 @DAY_PUC NUMERIC(18, 14),   
	 @DAY_SALES NUMERIC(18, 14),  
	 @SETT_PURCH NUMERIC(18, 14),    
	 @ROUND_TO DECIMAL(10, 2),  
	 @TABLE_NAME CHAR(25),  
	 @SETT_SALES NUMERIC(18, 4),  
	 @NORMAL DECIMAL(10, 6),  
	 @TRD_DEL CHAR(1),  
	 @LOWER_LIM DECIMAL(10, 2),  
	 @DEF_TABLE TINYINT,  
	 @ROFIG INT,  
	 @ERRNUM NUMERIC(18, 4),  
	 @NOZERO INT,  
	 @BRANCH_CODE VARCHAR(10),  
	 @STATUSID VARCHAR(25) = 'BROKER',  
	 @STATUSNAME VARCHAR(25) = 'BROKER',  
	 @RETURNMSG VARCHAR(100) OUTPUT  
) 
  
AS  
BEGIN  
  
 SET @RETURNMSG = ''  
   
 IF EXISTS(SELECT 1 FROM BROKTABLE WHERE Table_No = @TABLE_NO AND Line_No = @LINE_NO)  
 BEGIN  
  SET @RETURNMSG =  'Brokerage Table - ' + RTRIM(CONVERT(CHAR(20), @TABLE_NO)) + ' Already Exists in database.'  
  RETURN  
 END    
  
 INSERT INTO BROKTABLE  
 (  
		  Table_No,  
		  Line_No,  
		  Val_perc,  
		  Upper_lim,  
		  Day_puc,  
		  Day_Sales,  
		  Sett_Purch,  
		  round_to,  
		  Table_name,  
		  sett_sales,  
		  NORMAL,  
		  Trd_Del,  
		  Lower_lim,  
		  Def_table,  
		  RoFig,  
		  ErrNum,  
		  NoZero,  
		  Branch_code  
 )  
 VALUES  
 (  
		  @TABLE_NO,  
		  @LINE_NO,  
		  @VAL_PERC,  
		  @UPPER_LIM,     
		  @DAY_PUC,   
		  @DAY_SALES,  
		  @SETT_PURCH,    
		  @ROUND_TO,   
		  @TABLE_NAME,  
		  @SETT_SALES,  
		  @NORMAL,  
		  @TRD_DEL,  
		  @LOWER_LIM,  
		  @DEF_TABLE,  
		  @ROFIG,  
		  @ERRNUM,  
		  @NOZERO,  
		  @BRANCH_CODE   
 )
 
 IF @@ERROR <> 0   
		SET @RETURNMSG = 'Error while inserting table details into the database.'
 END

GO
