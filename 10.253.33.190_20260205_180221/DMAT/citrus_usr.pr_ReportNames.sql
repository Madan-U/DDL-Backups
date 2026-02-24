-- Object: PROCEDURE citrus_usr.pr_ReportNames
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_ReportNames]  
	(  
		 @PA_ACTION   VARCHAR(100)       
		,@PA_MSGID    VARCHAR(20)     
		,@PA_DESC     VARCHAR(8000)
		,@PA_FOOTER   VARCHAR(8000)	  
		,@PA_REF_CUR  VARCHAR(8000) OUT      
	)  
	AS  
	BEGIN  
		--  
		DECLARE @L_ERROR  INT  
		IF @PA_ACTION = 'EDT'  
		BEGIN  
			--   
			--   
			UPDATE REPORT_MESSAGE SET PAGE_SPL_MSG = ISNULL(@PA_DESC,''), PAGE_FOOTER_MSG = ISNULL(@PA_FOOTER,'') WHERE MSG_ID = @PA_MSGID  
			--  
			SET @L_ERROR = @@ERROR   
			--  
				IF @L_ERROR > 0            
				BEGIN     
				--  
					SET @PA_REF_CUR = 1  
				--  
				END  
				ELSE  
				BEGIN  
				--  
					SET @PA_REF_CUR = 0      
				--  
				END  
			--  
		END  
		--  
	END

GO
