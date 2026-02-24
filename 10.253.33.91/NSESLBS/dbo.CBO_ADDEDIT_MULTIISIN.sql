-- Object: PROCEDURE dbo.CBO_ADDEDIT_MULTIISIN
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------







CREATE     PROCEDURE [dbo].[CBO_ADDEDIT_MULTIISIN]

	@Scrip_Cd varchar(12), 
	@Series varchar(2),
	@Isin varchar(20),
	@Valid int,     
	@flag varchar(2),
	@shareServer Varchar(50),
   @shareDB Varchar(50),
	@prevIsin varchar(20),
	@err varchar(100) output,
	@STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'


AS



IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END



		declare @sql varchar(2000),@cnt int,
		@DPCur Cursor,
		@share_db   varchar(50),
		@share_server varchar(50),
		@exchange varchar(50),
		@TScrip  varchar(50),
		@TSeries varchar(50),
		@TIsin varchar(50)
	
		CREATE TABLE #SCRIP (Scrip varchar(50),series varchar(50),isin varchar(50))
		if @flag='A'
		Begin
			
		
			
			set @sql="INSERT INTO #SCRIP (Scrip,series,isin) select Scrip_Cd,Series,Isin from "+ @shareServer + "." + @shareDB +".dbo.multiisin where scrip_cd = '" +@Scrip_Cd+ "' and Series='" + @Series +"'" 
			exec(@sql)
			select @TScrip= Scrip,@TSeries=series,@TIsin=isin from #SCRIP
			TRUNCATE TABLE #SCRIP
			if @TScrip<>@Scrip_Cd or  @TSeries <> @Series or  @TIsin <> @Isin
			begin
			set @err='Isin Alreadey Exist For Other Scrip and Series'
			return
			end
			
			set @sql = "Delete "+@shareServer+"."+ @shareDB+ ".dbo.multiisin  where  isin = '"+ @Isin +"'"
			exec(@sql)	
			
			if @Valid = 1
			begin
			set @sql = "update "+@shareServer+"."+ @shareDB+ ".dbo.multiisin set valid = 0 "
			set @sql =	@sql+ " where Scrip_cd='" +@Scrip_Cd + "'"
			exec(@sql)
			end

			set @sql = "Insert into "+@shareServer+"."+ @shareDB+".dbo.multiisin values('"+@Scrip_Cd +"','"+@Series +"','"+@Isin+"',"+Convert(Varchar, @Valid)+ ")"
			exec(@sql)	
			set @err='Record Added Successfully'

			Set @DPCur = Cursor for  Select sharedb,shareserver,exchange From Pradnya.dbo.multicompany where primaryserver = 1
			
			Open @DPCur	
			Fetch Next From @DPCur into @share_db,@share_server,@exchange
			While @@Fetch_Status = 0  
			begin
				if @share_db<>@shareDB and  @exchange<>'BSE'
			 	begin	 	
				

				
					set @sql = "Delete "+@share_server+"."+ @share_db+ ".dbo.multiisin  where  isin = '"+ @Isin +"' or (Scrip_cd='" +@Scrip_Cd + "'  and Series='" + @Series +"')" 
					exec(@sql)
		
					if @Valid = 1
					begin
					set @sql = "update "+@share_server+"."+ @share_db+ ".dbo.multiisin set valid = 0 "
					set @sql =@sql+ " where Scrip_cd='" +@Scrip_Cd + "'"
					exec(@sql)
					end
		
					set @sql = "Insert into "+@share_server+"."+ @share_db+".dbo.multiisin values('"+@Scrip_Cd +"','"+@Series +"','"+@Isin+"',"+Convert(Varchar, @Valid)+ ")"
					exec(@sql)	

			 	end

			Fetch Next From @DPCur into @share_db,@share_server,@exchange
			END     

		Close @DPCur  
		DeAllocate @DPCur
		
		end






		if @flag='E'
		Begin

			
		
			CREATE TABLE #PARTYEXIST (PARTYCNT int)
			set @sql="INSERT INTO #PARTYEXIST (PARTYCNT) select count(1) from "+ @shareServer + "." + @shareDB +".dbo.multiisin where Isin='"+ @Isin+ "' and (scrip_cd <> '" +@Scrip_Cd+"' and Series<>'" + @Series+"')"
			exec(@sql)
			select @cnt= PARTYCNT from #PARTYEXIST
			if @cnt <> 0
			begin
			set @err='Isin Alreadey Exist For Other Scrip and Series'
			return 
			end
			TRUNCATE TABLE #PARTYEXIST

			if @Valid = 1
			begin
			set @sql = "update "+@shareServer+"."+ @shareDB+ ".dbo.multiisin set valid = 0 "
			set @sql =	@sql+ " where Scrip_cd='" +@Scrip_Cd + "'"
			exec(@sql)
			end

			set @sql = "update "+@shareServer+"."+ @shareDB+ ".dbo.multiisin set Isin='"+ @Isin+ "',Valid="+Convert(Varchar, @Valid)+ " where scrip_cd = '" +@Scrip_Cd+"' and isin = '"+ @prevIsin +"'"

			exec(@sql)	
			set @err='Record Updated Successfully'

			Set @DPCur = Cursor for  Select sharedb,shareserver,exchange From Pradnya.dbo.multicompany where primaryserver = 1
			
			Open @DPCur	
			Fetch Next From @DPCur into @share_db,@share_server,@exchange
			While @@Fetch_Status = 0  
			begin
				if @share_db<>@shareDB and  @exchange<>'BSE'
			 	begin	

				
					set @sql = "Delete "+@share_server+"."+ @share_db+ ".dbo.multiisin  where  isin = '"+ @prevIsin +"' or (Scrip_cd='" +@Scrip_Cd + "'  and Series='" + @Series +"')" 
					exec(@sql)
		
					if @Valid = 1
					begin
					set @sql = "update "+@share_server+"."+ @share_db+ ".dbo.multiisin set valid = 0 "
					set @sql =@sql+ " where Scrip_cd='" +@Scrip_Cd + "'"
					exec(@sql)
					end
		
					set @sql = "Insert into "+@share_server+"."+ @share_db+".dbo.multiisin values('"+@Scrip_Cd +"','"+@Series +"','"+@Isin+"',"+Convert(Varchar, @Valid)+ ")"
					exec(@sql)	

			 	end

			Fetch Next From @DPCur into @share_db,@share_server,@exchange
			END     

		Close @DPCur  
		DeAllocate @DPCur
		end



		if @flag='D'
		begin
			set @sql = "Delete "+@shareServer+"."+ @shareDB+ ".dbo.multiisin  where  isin = '"+ @Isin +"'"
	
			exec(@sql)	
			set @err='Record Deleted Successfully'
			Set @DPCur = Cursor for  Select sharedb,shareserver,exchange From Pradnya.dbo.multicompany where primaryserver = 1
			
			Open @DPCur	
			Fetch Next From @DPCur into @share_db,@share_server,@exchange
			While @@Fetch_Status = 0  
			begin
				if @share_db<>@shareDB and  @exchange<>'BSE'
			 	begin	

				set @sql = "Delete "+@share_server+"."+ @share_db+ ".dbo.multiisin  where  isin = '"+ @Isin +"'"
				exec(@sql)		

			 	end

			Fetch Next From @DPCur into @share_db,@share_server,@exchange
			end
		end

GO
