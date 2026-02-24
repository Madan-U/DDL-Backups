-- Object: PROCEDURE citrus_usr.pr_dump_client_new
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

Create proc [citrus_usr].[pr_dump_client_new](@pa_id varchar(1))        
as        
    
declare @holddate varchar(11)    
set @holddate= ( select TOP 1 HLD_HOLD_DATE FROM HOLDINGDATA WITH(NOLOCK))    

Declare @Time time    
    
Set @Time=CONVERT(Time,getdate(),116)


--IF (@Time< ='14:45:00.000000')
   Begin 
		BEGIN         
		TRUNCATE TABLE TBL_CLIENT_MASTER_TMP
     
		INSERT INTO  TBL_CLIENT_MASTER_TMP        
		SELECT  * FROM  TBL_CLIENT_MASTER_FORDUMP  

				UPDATE T SET POA_VER = '2' FROM TBL_CLIENT_MASTER_TMP T, TBL_CLIENT_POA P    
				WHERE T.CLIENT_CODE=P.CLIENT_CODE AND HOLDER_INDI =1    
				AND ISNULL(POA_VER,'')= '' AND POA_STATUS ='A'  AND STATUS ='ACTIVE'    
				AND MASTER_POA ='2203320000000014'  AND POA_DATE_FROM >='2010-01-01'   
		  
		  
		    
				UPDATE T SET POA_VER ='' FROM TBL_CLIENT_MASTER_TMP T, TBL_CLIENT_POA P    
				WHERE T.CLIENT_CODE=P.CLIENT_CODE AND HOLDER_INDI =1    
				AND POA_VER in ('2' ,'1')
				AND POA_STATUS ='D' 
				AND STATUS ='ACTIVE'    
				AND MASTER_POA ='2203320000000014'     
		    
		    
				UPDATE T SET POA_VER = '2' FROM TBL_CLIENT_MASTER_TMP T, TBL_CLIENT_POA P    
				WHERE T.CLIENT_CODE=P.CLIENT_CODE AND HOLDER_INDI =1    
				AND POA_VER= '' AND POA_STATUS ='A'  AND STATUS ='ACTIVE'    
				AND MASTER_POA ='2203320000000014'


				SELECT BOID,PRIPHNUM,PRI_EMAIL  INTO #TEST                                                                           
				FROM DPS8_PC1  WHERE PRI_EMAIL <>'' OR SMART_FLAG ='Y'

 
				UPDATE T SET FIRST_HOLD_MOBILE=RIGHT(PRIPHNUM,10),EMAIL_ADD =PRI_EMAIL  FROM TBL_CLIENT_MASTER_TMP T,#TEST S
				WHERE T.CLIENT_CODE =S.BOID
				AND (  ISNULL(FIRST_HOLD_MOBILE,'')<>PRIPHNUM OR EMAIL_ADD<>PRI_EMAIL)
      
		
		IF (SELECT COUNT(*) FROM TBL_CLIENT_MASTER_TMP )>1
			BEGIN 
  
			BEGIN TRAN 
				TRUNCATE TABLE TBL_CLIENT_MASTER    
    
				INSERT INTO  TBL_CLIENT_MASTER        
				SELECT  * FROM  TBL_CLIENT_MASTER_TMP     
		
			COMMIT	
		    
 
     
		   END  
	 END
    
     END
	    
	select *  into #Synergy_Client_Master from Synergy_Client_Master WITH(NOLOCK) WHERE 1=2    
	    
	insert into #Synergy_Client_Master        
	select * from  Synergy_Client_Master_fordump        
	    
	    
	TRUNCATE TABLE Synergy_Client_Master    
	insert into Synergy_Client_Master        
	select * from  #Synergy_Client_Master        

	
	    
	Delete from dbo.synergy_holding where HLD_HOLD_DATE = @holddate    
	    
	INSERT INTO dbo.synergy_holding      
	    
	SELECT * FROM HOLDINGDATA    --5639639 --5651832

GO
