-- Object: PROCEDURE citrus_usr.PR_ACC_CORP_ACT_EX
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

/*Record Type Integer 2 2 M Detail Record (02)
Line Number Integer 7 9 M Starts from 1 unique and serial for each client
SHR order no Decimal 16 25 M  
DM Order No Decimal 7 32 M
Base Isin Character 12 44 M
Debit Isin Character 12 56 M
Credit Isin Character 12 68 M
Market Type Int 2 70 O Mandatory for CM
Settelement Number Character 7 77 O Mandatory for CM
ACA Type  Integer 4 81 M
ACA Execution Date  Date 8 89 M
Credit Multiplication Factor decimal 7 96 M Decimal (7,3) So Max 4 digit integer and 3 as decimal part.
Debit Multiplication Factor decimal 7 103 M Decimal (7,3) So Max 4 digit integer and 3 as decimal part
ACA Description Character 35 138 O 
ACA Status Integer 4 142 M 
Record Date  Date  8 150 O For Aca Bonus Only
Allotment Date  Date  8 158 O For Aca Bonus Only


CREATE TABLE ACC_CORP_ACTION_EX
(RECORD_TYPE INT 
,LINE_NUMBER BIGINT
,SHR_ORD_NO  NUMERIC(16) 
,DM_ORD_NO   NUMERIC(7)
,BASE_ISIN   VARCHAR(12)
,DB_ISIN     VARCHAR(12)
,CR_ISIN     VARCHAR(12)
,MKT_TYPE    INT
,SETT_NO     VARCHAR(7)
,ACA_TYPE    INT
,ACA_EXE_DT  DATETIME
,CR_MULTI_FACTOR NUMERIC(18,3)
,DB_MULTI_FACTOR NUMERIC(18,3)
,ACA_DESC        VARCHAR(35)
,ACA_STATUS      INT 
,RECORD_DT       DATETIME
,ALLOT_DT        DATETIME 
)
*/

CREATE PROCEDURE [citrus_usr].[PR_ACC_CORP_ACT_EX]
(@pa_exch          VARCHAR(20)  
,@pa_login_name    VARCHAR(20)  
,@pa_mode          VARCHAR(10)  																																
,@pa_db_source     VARCHAR(250)  
,@rowdelimiter     CHAR(4) =     '*|~*'    
,@coldelimiter     CHAR(4) =     '|*~|'    
,@pa_errmsg        VARCHAR(8000) output  
)
AS
BEGIN
--
  	IF @pa_mode = 'BULK'
			BEGIN
			--

								truncate table TMP_ACC_CORP_ACT_EX

								DECLARE @@ssql varchar(8000)
								SET @@ssql ='BULK INSERT TMP_ACC_CORP_ACT_EX from ''' + @pa_db_source + ''' WITH 
								(
											FIELDTERMINATOR = ''\n'',
											ROWTERMINATOR = ''\n''
								)'

								EXEC(@@ssql)
			--
			END
			
			
			INSERT INTO ACC_CORP_ACTION_EX
			(RECORD_TYPE
			,LINE_NUMBER
			,SHR_ORD_NO
			,DM_ORD_NO
			,BASE_ISIN
			,DB_ISIN
			,CR_ISIN
			,MKT_TYPE
			,SETT_NO
			,ACA_TYPE
			,ACA_EXE_DT
			,CR_MULTI_FACTOR
			,DB_MULTI_FACTOR
			,ACA_DESC
			,ACA_STATUS
			,RECORD_DT
			,ALLOT_DT)
				SELECT SUBSTRING(DATA_VALUE,1,2)
				,SUBSTRING(DATA_VALUE,3,7)
				,SUBSTRING(DATA_VALUE,10,16)
				,SUBSTRING(DATA_VALUE,26,7)
				,SUBSTRING(DATA_VALUE,33,12)
				,SUBSTRING(DATA_VALUE,55,12)
				,SUBSTRING(DATA_VALUE,67,2)
				,SUBSTRING(DATA_VALUE,69,2)
				,SUBSTRING(DATA_VALUE,71,7)
				,SUBSTRING(DATA_VALUE,78,4)
				,SUBSTRING(DATA_VALUE,82,8)
				,SUBSTRING(DATA_VALUE,90,7)
				,SUBSTRING(DATA_VALUE,97,7)
				,SUBSTRING(DATA_VALUE,104,35)
				,SUBSTRING(DATA_VALUE,139,4)
				,SUBSTRING(DATA_VALUE,143,8)
				,SUBSTRING(DATA_VALUE,151,8)
				FROM TMP_ACC_CORP_ACT_EX 

--
END

GO
