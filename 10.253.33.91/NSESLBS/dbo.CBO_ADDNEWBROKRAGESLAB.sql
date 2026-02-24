-- Object: PROCEDURE dbo.CBO_ADDNEWBROKRAGESLAB
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


--EXEC CBO_ADDNEWBROKRAGESLAB 3, 1, 'V', 1000000, 0, 0, 0,2,'TEst.10*.099',1000,00,'T',0,0,0,5000,1,'GLOBAL','Broker','Broker'
--EXEC CBO_ADDNEWBROKRAGESLAB 3, 1, 'V', 1000000, 0, 0, 0,2,'TEst.10*.099',1000,00,'T',0,0,0,5000,1,'GLOBAL','Broker','Broker'

--sp_help broktable

CREATE PROCEDURE CBO_ADDNEWBROKRAGESLAB
(    
  @TABLE_NO CHAR(2),    
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
  @STATUSNAME VARCHAR(25) = 'BROKER'

)   
    
AS

/*IF @TABLE_NO=@TABLE_NO
BEGIN
 IF EXISTS(SELECT TOP 1 * FROM BROKTABLE WHERE Table_No = @TABLE_NO AND Line_No = @LINE_NO)    
 BEGIN
	RAISERROR ('Brokerage Table Already Exists in database.', 16, 1)
  RETURN    
 END
*/
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
--END

GO
