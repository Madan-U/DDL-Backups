-- Object: PROCEDURE dbo.CBO_ADDEDIT_SCRIP
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------






CREATE      PROCEDURE [dbo].[CBO_ADDEDIT_SCRIP]
	@scripCode varchar(6),
        @series varchar(3),
        @scripName varchar(50),
        @marketlot int=0,
        @facevalue float=10.0,
        @bookcldt varchar(20),
        @exDivDate varchar(20),
        @exBonDate varchar(20),
        @exRitDate varchar(20),
        @eqtType varchar(3),
        @subType varchar(3),
        @agentCd varchar(6),
        @dematFlag smallint=0,
        @dematDate varchar(20),
        @strExchange varchar(3),
        @scripcd varchar(12),
        @scripCat varchar(3),
        @noDelFr varchar(20),
        @noDelTo varchar(20),
        @clRate float=0,
        @closeRateDate varchar(20),
        @minTradeQty int=0,
        @bsecode varchar(10),
        @inin varchar(20),
        @group varchar(3),
        @sector varchar(10),
        @track varchar(10),
        @cdolno varchar(10),
        @globalcustodian varchar(10),
        @common_code char(10),
        @indexName varchar(10),
        @industry varchar(10),
        @bloomberg varchar(10),
        @ricCode varchar(10),
        @reuters varchar(10),
        @ies varchar(10),
        @noofIssuedshares numeric(18,0)=0,
        @status varchar(10),
        @adrgdrRatio numeric(18,4)=0,
        @geMultiple numeric(18,4)=0,
        @groupforGE int=0,
        @rbiCeilingIndicatorFlag varchar(2),
        @rbiCeilingIndicatorValue numeric(18,4)=0,
        @shareServer Varchar(50),
        @shareDB Varchar(50),
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

declare @sql varchar(2000)	

if @flag='A'
  Begin
	
				
			
			set @sql= "select ISNULL(max(CONVERT(INT,co_code)),0) + 1 co_code from "+ @shareServer + "."+ @shareDB + ".dbo.scrip1" 
			--select ISNULL(max(CONVERT(INT,co_code)),0)+1 co_code from  scrip1
			
			
			CREATE TABLE #a (a varchar(200))
			
			
			
			Insert into #a exec(@sql)
			
			
			SELECT * FROM #a
			
			SELECT @scripCode=a FROM #a
			DROP TABLE #a
			
			
			
			  
			--Select Convert(Varchar(11), Convert(Datetime,'01/12/2007',103), 109)
								
					
			          	
				set @sql="INSERT INTO "+ @shareServer + "." + @shareDB + ".dbo.Scrip1 Values ('" +
										@scripCode +"','"+
										@series +"','"+
										@scripName+"','"+
										@scripName+"',"+
										Convert(Varchar, @marketlot)+","+
										Convert(Varchar,@facevalue)+",'"+
										Convert(Varchar(11), Convert(Datetime,@bookcldt, 103), 109)+"','"+
										Convert(Varchar(11), Convert(Datetime, @exDivDate, 103), 109)+"','"+
										Convert(Varchar(11), Convert(Datetime,@exBonDate, 103), 109)+"','"+
										Convert(Varchar(11), Convert(Datetime,@exRitDate, 103), 109)+"','"+
										@eqtType+"','"+
										@subType+"','"+
										@agentCd+"',"+
										Convert(Varchar,@dematFlag)+",'"+
										Convert(Varchar(11), Convert(Datetime,@dematDate, 103), 109)+"',"+
										"'','','',''
									   )"
								print (@sql)
								exec(@sql)
						set @sql="INSERT INTO "+ @shareServer + "." + @shareDB + ".dbo.Scrip2 Values ("
						set @sql = @sql + "'" + @scripCode + "',"
						set @sql = @sql + "'" + @series + "',"
						set @sql = @sql + "'" + @strExchange + "'," 
			       			set @sql = @sql + "'" + @scripcd + "'," 
			        		set @sql = @sql + "'" + @scripCat +"',"
			        		set @sql = @sql + "'" + Convert(Varchar(11), Convert(Datetime,@noDelFr, 103), 109)+"', "
			        		set @sql = @sql + "'" + Convert(Varchar(11), Convert(Datetime,@noDelTo, 103), 109)+"', "
			        		set @sql = @sql + Convert(Varchar,@clRate) + ", "
			        		set @sql = @sql + "'" + Convert(Varchar(11), Convert(Datetime,@closeRateDate , 103), 109)+"', "
			        		set @sql = @sql + Convert(Varchar,@minTradeQty) + ",'" +
			        						@bsecode +"','"+
			        						@inin +"','"+
			        						@group +"','"+
			        						@sector+"','"+
			       							@track+"','"+ 
			        						@cdolno +"',"+
										"'','','','','"+
			        						@globalcustodian+"','"+
			        						@common_code +"','"+
			        						@indexName +"','"+
			        						@industry +"','"+
			        						@bloomberg +"','"+
			        						@ricCode+"','"+
			        						@reuters+"','"+
			        						@ies+"',"+
			        						Convert(Varchar,@noofIssuedshares) +",'"+
			        						@status+"',"+
			        						Convert(Varchar,@adrgdrRatio) +","+
			        						Convert(Varchar,@geMultiple)+","+
			        						Convert(Varchar,@groupforGE)+",'"+
			        						@rbiCeilingIndicatorFlag +"',"+
			      		        				Convert(Varchar,@rbiCeilingIndicatorValue) + ")"
			print (@sql)
								exec(@sql)


	end				



if @flag='E'
	Begin

	set  @sql= "delete "+@shareServer + "." + @shareDB + ".dbo.Scrip1 where Co_Code='" +@scripCode+"'"
exec (@sql)	
set  @sql= "delete "+@shareServer + "." + @shareDB + ".dbo.Scrip2 where Co_Code='" +@scripCode+"'"
	
exec (@sql)

					set @sql="INSERT INTO "+ @shareServer + "." + @shareDB + ".dbo.Scrip1 Values ('" +
										@scripCode +"','"+
										@series +"','"+
										@scripName+"','"+
										@scripName+"',"+
										Convert(Varchar, @marketlot)+","+
										Convert(Varchar,@facevalue)+",'"+
										Convert(Varchar(11), Convert(Datetime,@bookcldt, 103), 109)+"','"+
										Convert(Varchar(11), Convert(Datetime, @exDivDate, 103), 109)+"','"+
										Convert(Varchar(11), Convert(Datetime,@exBonDate, 103), 109)+"','"+
										Convert(Varchar(11), Convert(Datetime,@exRitDate, 103), 109)+"','"+
										@eqtType+"','"+
										@subType+"','"+
										@agentCd+"',"+
										Convert(Varchar,@dematFlag)+",'"+
										Convert(Varchar(11), Convert(Datetime,@dematDate, 103), 109)+"',"+
										"'','','',''
									   )"
								print (@sql)
								exec(@sql)
						set @sql="INSERT INTO "+ @shareServer + "." + @shareDB + ".dbo.Scrip2 Values ("
						set @sql = @sql + "'" + @scripCode + "',"
						set @sql = @sql + "'" + @series + "',"
						set @sql = @sql + "'" + @strExchange + "'," 
			       			set @sql = @sql + "'" + @scripcd + "'," 
			        		set @sql = @sql + "'" + @scripCat +"',"
			        		set @sql = @sql + "'" + Convert(Varchar(11), Convert(Datetime,@noDelFr, 103), 109)+"', "
			        		set @sql = @sql + "'" + Convert(Varchar(11), Convert(Datetime,@noDelTo, 103), 109)+"', "
			        		set @sql = @sql + Convert(Varchar,@clRate) + ", "
			        		set @sql = @sql + "'" + Convert(Varchar(11), Convert(Datetime,@closeRateDate , 103), 109)+"', "
			        		set @sql = @sql + Convert(Varchar,@minTradeQty) + ",'" +
			        						@bsecode +"','"+
			        						@inin +"','"+
			        						@group +"','"+
			        						@sector+"','"+
			       							@track+"','"+ 
			        						@cdolno +"',"+
										"'','','','','"+
			        						@globalcustodian+"','"+
			        						@common_code +"','"+
			        						@indexName +"','"+
			        						@industry +"','"+
			        						@bloomberg +"','"+
			        						@ricCode+"','"+
			        						@reuters+"','"+
			        						@ies+"',"+
			        						Convert(Varchar,@noofIssuedshares) +",'"+
			        						@status+"',"+
			        						Convert(Varchar,@adrgdrRatio) +","+
			        						Convert(Varchar,@geMultiple)+","+
			        						Convert(Varchar,@groupforGE)+",'"+
			        						@rbiCeilingIndicatorFlag +"',"+
			      		        				Convert(Varchar,@rbiCeilingIndicatorValue) + ")"
			print (@sql)
								exec(@sql)




	End

GO
