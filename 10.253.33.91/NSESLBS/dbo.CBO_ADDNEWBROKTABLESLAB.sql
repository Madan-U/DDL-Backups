-- Object: PROCEDURE dbo.CBO_ADDNEWBROKTABLESLAB
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/*
exec CBO_ADDNEWBROKTABLESLAB @TABLE_NO = 2, @LINE_NO = 1, @VAL_PERC = 'V', @UPPER_LIM = $11.0000, @DAY_PUC = 1, @DAY_SALES = 1, @SETT_PURCH = 1, @ROUND_TO = 2, @TABLE_NAME = '444', @SETT_SALES = 1, @NORMAL = 0, @TRD_DEL = 't', @LOWER_LIM = 0, @DEF_TABLE = 0, @ROFIG = 0, @ERRNUM = 5000, @NOZERO = 1, @BRANCH_CODE = 'GLOBAL', @STATUSID = 'Broker', @STATUSNAME = 'Broker',@ValidateTableExists='Y' 
if @@error = 0   
begin   
	exec CBO_ADDNEWBROKTABLESLAB @TABLE_NO = 2, @LINE_NO = 1, @VAL_PERC = 'V', @UPPER_LIM = $11.0000, @DAY_PUC = 1, @DAY_SALES = 1, @SETT_PURCH = 1, @ROUND_TO = 2, @TABLE_NAME = '444', @SETT_SALES = 1, @NORMAL = 0, @TRD_DEL = 't', @LOWER_LIM = 0, @DEF_TABLE = 0, @ROFIG = 0, @ERRNUM = 5000, @NOZERO = 1, @BRANCH_CODE = 'GLOBAL', @STATUSID = 'Broker', @STATUSNAME = 'Broker',@ValidateTableExists='N'  
	exec CBO_ADDNEWBROKTABLESLAB @TABLE_NO = 2, @LINE_NO = 1, @VAL_PERC = 'V', @UPPER_LIM = $11.0000, @DAY_PUC = 1, @DAY_SALES = 1, @SETT_PURCH = 1, @ROUND_TO = 2, @TABLE_NAME = '444', @SETT_SALES = 1, @NORMAL = 0, @TRD_DEL = 't', @LOWER_LIM = 0, @DEF_TABLE = 0, @ROFIG = 0, @ERRNUM = 5000, @NOZERO = 1, @BRANCH_CODE = 'GLOBAL', @STATUSID = 'Broker', @STATUSNAME = 'Broker',@ValidateTableExists='N'  
end  
*/

CREATE PROCEDURE CBO_ADDNEWBROKTABLESLAB  
(  
      
  @TABLE_NO SMALLINT,  
  @LINE_NO DECIMAL,  
  @VAL_PERC CHAR(1),  
  @UPPER_LIM MONEY,  
  @DAY_PUC NUMERIC,  
  @DAY_SALES NUMERIC,  
  @SETT_PURCH NUMERIC,  
  @ROUND_TO DECIMAL,  
  @TABLE_NAME CHAR(25),  
  @SETT_SALES NUMERIC,  
  @NORMAL DECIMAL,  
  @TRD_DEL CHAR(1),  
  @LOWER_LIM DECIMAL,  
  @DEF_TABLE TINYINT,  
  @ROFIG INT,  
  @ERRNUM NUMERIC,  
  @NOZERO INT,  
  @BRANCH_CODE VARCHAR(10),    
  @STATUSID VARCHAR(25) = 'BROKER',  
  @STATUSNAME VARCHAR(25) = 'BROKER',  
  @ValidateTableExists CHAR(1) = 'Y'
)  
  
AS  
  
IF @TABLE_NO=@TABLE_NO AND @ValidateTableExists = 'Y'  
BEGIN  
 IF EXISTS(SELECT TOP 1 * FROM BROKTABLE WHERE Table_No = @TABLE_NO AND Line_No = @LINE_NO)      
 BEGIN  
 RAISERROR ('Brokerage Table Already Exists in database.', 16, 1)  
  RETURN      
 END  
END  

 INSERT INTO broktable  
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

GO
