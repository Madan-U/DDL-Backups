-- Object: PROCEDURE dbo.CBO_ADDEDIT_MULTICLIENT
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------








CREATE         PROCEDURE [dbo].[CBO_ADDEDIT_MULTICLIENT]
		@Party_Code VARCHAR(25),
		@Introducer  VARCHAR(50), 
		@Dptype VARCHAR(25),
		@OCltDpId   VARCHAR(25)='', 
		@ODpId    VARCHAR(25)='',
		@OPOA      INT,  
		@NCltDpID    VARCHAR(25),     
		@NDpId    VARCHAR(25),
		@NPOA      INT, 
		@DEFAULTDP varchar(5),   
		@ChangedBy VARCHAR(25),
		@RecordFrom VARCHAR(25),
		@shareServer Varchar(50),
		@shareDB Varchar(50),
		@err varchar(100) output,
		@STATUSID VARCHAR(25) = 'BROKER',
		@STATUSNAME VARCHAR(25) = 'BROKER',
		@flag Varchar(5)
AS
/*
	Begin Tran
	Exec CBO_ADDEDIT_SCRIP '0','eq','reliance natural',1,1,'01/12/2007','01/12/2007','01/12/2007','01/12/2007','','','',0,'01/12/2007','NCX','reln','','01/12/2007','01/12/2007',0,'01/12/2007',0,'22332211','','D','','N','','','','','','','','','',0,'Active',0,0,0,'N',0,'MTSRVR03','NCDX','Broker','Broker'
rollback


*/



	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END

		declare @sql varchar(2000),
		@cnt int
		if @flag='A'
			Begin
			set @cnt=0
			IF NOT EXISTS(select 1 FROM MTSRVR03.MSAJAG.DBO.Client1 c1, MTSRVR03.MSAJAG.DBO.Client2 c2 where c2.cl_code = c1.cl_code  and Party_code=@Party_Code)
			begin
			set @err='PARTY CODE  NOT FOUND'
			return 
			end
			IF NOT EXISTS(select 1 from MSAJAG.dbo.bank where BankId=@NDpId and BankType=@Dptype)
			begin
			set @err='DP NOT FOUND'
			return 
			end

			

-- -- 			CREATE TABLE #PARTYEXIST (PARTYCNT int)
-- -- 			set @sql="INSERT INTO #PARTYEXIST (PARTYCNT) select count(*) from "+ @shareServer + "." + @shareDB +".dbo.multicltid where party_code = '"+@Party_Code+ "' and cltdpno = '"+ @NCltDpID +"' and dpid = '"+@NDpId+"'" 
-- -- 			exec(@sql)
-- -- 			select @cnt= PARTYCNT from #PARTYEXIST
-- -- 			select @cnt= PARTYCNT from #PARTYEXIST
-- -- 
-- -- 			if @cnt <> 0
-- -- 			begin
-- -- 			set @err='Client With same DP and AccountNo Already Present'
-- -- 			return 
-- -- 			end
-- -- 			TRUNCATE TABLE #PARTYEXIST

			set @sql="select 1 from "+ @shareServer + "." + @shareDB +".dbo.multicltid where party_code = '"+@Party_Code+ "' and cltdpno = '"+ @NCltDpID +"' and dpid = '"+@NDpId+"'" 
			exec(@sql)

			if @@ROWCOUNT <> 0
			begin
				set @err='Client With same DP and AccountNo Already Present'
				return 
			end

			if @NPOA=1 
			begin
				set @sql= "update "+@shareServer + "." + @shareDB + ".dbo.multicltid set def = 0"
				set @sql = @sql + " where party_code = '"+ @Party_Code +"'"
				exec(@sql)
			end
				
			SET @OPOA=0

			set @sql="INSERT INTO " 
			SET @sql = @sql + @shareServer + "." + @shareDB  
			SET @sql = @sql +".dbo.multicltid (party_code,dptype,dpid,cltdpno,def,introducer) values ('" 
			SET @sql = @sql + @Party_Code 
			SET @sql = @sql+ "','" 
			SET @sql = @sql+ @Dptype 
			SET @sql = @sql+ "','" 
			SET @sql = @sql+ @NDpId 
			SET @sql = @sql+ "','" 
			SET @sql = @sql+ @NCltDpID 
			SET @sql = @sql	+ "'," 
			SET @sql = @sql+ Convert(Varchar, @NPOA) 
			SET @sql = @sql + ",'" 
			SET @sql = @sql+ @Introducer 
			SET @sql = @sql+ "')"
			exec(@sql)

			set @err='Record Added Successfully'	

			set @sql="INSERT INTO "+ @shareServer + "." + @shareDB + ".dbo.MultiCltLog Select Party_Code,'" + @OCltDpId + "','" + @ODpId  + "',"+ Convert(Varchar, @OPOA)+",'" + @NCltDpID + "','" + @NDpId + "'," +Convert(Varchar, @NPOA)  + ",'" + @ChangedBy + "',GetDate() ,'" + @RecordFrom + "' From MultiCltId "
			SET @sql = @sql + " where party_code = '" + @Party_Code + "' and cltdpno = '" + @NCltDpID + "' and dpid ='" + @NDpId + "'"
			exec(@sql)
				
			if @DEFAULTDP='YES' and @shareDB='MSAJAG'
			BEGIN
				set @sql= "update "+@shareServer + "." + @shareDB + ".dbo.client_Details set Depository1 ='"
				SET @sql = @sql+ @Dptype + "',"
				SET @sql = @sql+ "DpId1='" + @NDpId +"',"
				SET @sql = @sql+ "CltDpId1='" + @NCltDpID +"',"
				SET @sql = @sql+ "Poa1='"+Convert(Varchar, @NPOA)+ "'"
				SET @sql = @sql + " where party_code = '" + @Party_Code +"'"
				exec(@sql)
			END
		end				


		if @flag='E'
		Begin
			set @cnt=0
			IF NOT EXISTS(select 1  from MSAJAG.dbo.bank where BankId=@NDpId and BankType=@Dptype)
			begin
			set @err='DP NOT FOUND'
			return 
			end

			--select @cnt=count(*) from MSAJAG.dbo.Client1 where party_code=@Party_Code 
			IF NOT EXISTS(select 1 FROM MTSRVR03.MSAJAG.DBO.Client1 c1, MTSRVR03.MSAJAG.DBO.Client2 c2 where c2.cl_code = c1.cl_code  and Party_code=@Party_Code)
			begin
			set @err='PARTY CODE  NOT FOUND'
			return 
			end

			if @NPOA=1 
			begin
				set @sql= "update "+@shareServer + "." + @shareDB + ".dbo.multicltid set def = 0"
				set @sql = @sql + " where party_code = '"+ @Party_Code +"'"
				exec(@sql)
			end

			SET @sql = " Insert into "+ @shareServer + "." + @shareDB + ".dbo.MultiCltLog Select Party_Code,CltDpNo,DpId,Def,'','','','" + @ChangedBy + "',GetDate(),'"+ @RecordFrom + "' From MultiCltId "
			SET @sql = @sql + " where party_code = '" + @Party_Code + "' and cltdpno = '" + @OCltDpId + "' and dpid ='" + @ODpId + "'"
			exec(@sql)

			if rtrim(@OCltDpId) <> rtrim(@NCltDpID)
			begin
				set @sql="INSERT INTO " 
				SET @sql = @sql + @shareServer + "." + @shareDB  
				SET @sql = @sql +".dbo.multicltid (party_code,dptype,dpid,cltdpno,def,introducer) values ('" 
				SET @sql = @sql + @Party_Code 
				SET @sql = @sql+ "','" 
				SET @sql = @sql+ @Dptype 
				SET @sql = @sql+ "','" 
				SET @sql = @sql+ @NDpId 
				SET @sql = @sql+ "','" 
				SET @sql = @sql+ @NCltDpID 
				SET @sql = @sql	+ "'," 
				SET @sql = @sql+ Convert(Varchar, @NPOA) 
				SET @sql = @sql + ",'" 
				SET @sql = @sql+ @Introducer 
				SET @sql = @sql+ "')"
				exec(@sql)
			end
				else
				begin																								
				SET @sql = "update "+ @shareServer + "." + @shareDB + ".dbo.multicltid set def = "+ Convert(Varchar, @NPOA) +",introducer='" + @Introducer + "'"
				SET @sql =@sql +",dptype='" + @Dptype + "',dpid='"+@NDpId+"',cltdpno='"+@NCltDpID+"'"
				SET @sql = @sql + " where party_code = '" +@Party_Code + "' and cltdpno = '" + @OCltDpId + "' and dpid ='" + @ODpId + "'"
				exec(@sql)
				end
				set @err='Record Updated Successfully'		
				if @DEFAULTDP='YES' and @shareDB='MSAJAG'
				BEGIN
				set @sql= "update "+@shareServer + "." + @shareDB + ".dbo.client_Details set Depository1 ='"
				SET @sql = @sql+ @Dptype + "',"
				SET @sql = @sql+ "DpId1='" + @NDpId +"',"
				SET @sql = @sql+ "CltDpId1='" + @NCltDpID +"',"
				SET @sql = @sql+ "Poa1='"+Convert(Varchar, @NPOA)+ "'"
				SET @sql = @sql + " where party_code = '" + @Party_Code +"'"
				exec(@sql)
				END
			End
		
		if @flag='D'
			Begin

			set @sql="INSERT INTO "+ @shareServer + "." + @shareDB + ".dbo.MultiCltLog Select Party_Code,'" + @OCltDpId + "','" + @ODpId  + "',"+ Convert(Varchar, @OPOA)+",'" + @NCltDpID + "','" + @NDpId + "'," +Convert(Varchar, @NPOA)  + ",'" + @ChangedBy + "',GetDate() ,'" + @RecordFrom + "' From MultiCltId "
			SET @sql = @sql + " where party_code = '" + @Party_Code + "' and cltdpno = '" + @NCltDpID + "' and dpid ='" + @NDpId + "'"
			exec(@sql)
			
			set @sql="DELETE FROM " 
			SET @sql = @sql + @shareServer + "." + @shareDB  
			SET @sql = @sql +".dbo.multicltid "
			SET @sql = @sql + " where party_code = '" +@Party_Code + "' and cltdpno = '" + @NCltDpID + "' and dpid ='" + @NDpId + "'"
			exec(@sql) 
			End

GO
