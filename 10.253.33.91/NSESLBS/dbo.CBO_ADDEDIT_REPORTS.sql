-- Object: PROCEDURE dbo.CBO_ADDEDIT_REPORTS
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------








CREATE       PROCEDURE [dbo].[CBO_ADDEDIT_REPORTS]
	
(
     	@reportCode INT,
	@reportName VARCHAR(50),   
	@path VARCHAR(100),       
	@target VARCHAR(100),
	@desc VARCHAR(100),
	@reportGrp VARCHAR(50),
	@menuGrp VARCHAR(5),
	@seenby VARCHAR(15),
	@order INT,
	@flag VARCHAR(1),
	@statusId VARCHAR(15)='BROKER',
	@statusName VARCHAR(15)='BROKER',
	@block int
)
AS
	IF @statusId <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
	IF @flag <> 'A' AND @flag <> 'E' AND @flag <> 'D' AND @flag <> 'C'
		BEGIN
			RAISERROR ('Add/Edit Flags Not Set Properly', 16, 1)
			RETURN
		END
	
		
	ELSE IF @flag = 'A'
	BEGIN
		
		
                   	
			INSERT INTO TblReports
			(
				Fldreportname,
				Fldpath,
				Fldtarget,
				Flddesc,
				Fldreportgrp,
				Fldmenugrp,
				Fldstatus,
				Fldorder
			)
			VALUES
			(
				@reportName,   
				@path,       
				@target,
				@desc,
				@reportGrp,
				@menuGrp,
				@seenby,
				@order
	
			)
			if  @block <> 0 
			       begin 
			
			         declare @RPTPATH varchar(100) 
			      
			         SET @RPTPATH = @path
			      
			         SELECT @RPTPATH = REPLACE(@RPTPATH,SPLITTED_VALUE,'') 
			         FROM   (SELECT   TOP 1 SPLITTED_VALUE 
			                FROM     PRADNYA.DBO.FUN_SPLITSTRING (@RPTPATH,'/' )
			                ORDER BY SNO DESC) A 
			
			       insert into TblReports_Blocked values ('','',0,'',1,@reportCode,@RPTPATH) 
			
			       end      
			
	END
  
             
		

ELSE IF @flag = 'C'
	BEGIN
		UPDATE TblReports set Fldorder=@order where fldreportcode=@reportCode
	END


ELSE IF @flag = 'E'
	BEGIN
		update tblreports  
		set 
			fldreportname =@reportName,
			fldpath =@path,
     			fldtarget =@target,
     			fldreportgrp =@reportGrp,
      			flddesc =@desc,
      			fldstatus =@seenby,
      			fldmenugrp =@menuGrp
      		where fldreportcode = @reportCode    

       Update TblReports_Blocked set Block_Flag = @block where fldreportcode =@reportCode

       if @@rowcount = 0 and @block <> 0 
	       begin 
	
	        
	      
	       SET @RPTPATH = @path
	      
	         SELECT @RPTPATH = REPLACE(@RPTPATH,SPLITTED_VALUE,'') 
	         FROM   (SELECT   TOP 1 SPLITTED_VALUE 
	                FROM     PRADNYA.DBO.FUN_SPLITSTRING (@RPTPATH,'/' )
	                ORDER BY SNO DESC) A 
	
	       insert into TblReports_Blocked values ('','',0,'',1,@reportCode,@RPTPATH) 
	
	       end      

	END

GO
