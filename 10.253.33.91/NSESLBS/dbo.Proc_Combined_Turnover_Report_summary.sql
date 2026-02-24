-- Object: PROCEDURE dbo.Proc_Combined_Turnover_Report_summary
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE  Procedure Proc_Combined_Turnover_Report_summary
(
@strConsolidate varchar(10),
@strExchange varchar(10), 
@strDateFrom Varchar(11),
@strDateTo Varchar(11),   
@strFromParty Varchar(20),
@strToParty Varchar(20),   
@strOrderBy Varchar(5), 
@ClientType Varchar(4),
@ReportType varchar(20),  
@check varchar(1),
@ConsolId Varchar(20),
@ConsolName Varchar(25),
@StatusId Varchar(20),
@StatusName Varchar(25)
)

AS

Declare
@@Select Varchar(8000)

 if @strFromParty = '' or @strToParty = ''
 Begin
  set @strFromParty = '0'
  set @strToParty ='zzzzzzzzz'
 End

  if @strConsolidate = 'PARTY' and @strOrderBy <> '4'
  begin
   set @@Select = "Select Party_Code,Long_name=party_name,Clienttype,"
  end

  if @strConsolidate = 'SCRIP' and @strOrderBy <> '4'
  begin
   set @@Select = "Select Party_Code,Long_name=party_name,Clienttype,"
  end

  if @strConsolidate = 'BROKER' and @strOrderBy <> '4'
  begin
   set @@Select = "Select Party_Code,Long_name=party_name,"
  end
 
 if @strConsolidate = 'AREA' and @strOrderBy <> '4'
  begin
   set @@Select = "Select Area, " 
  end
 if @strConsolidate = 'BRANCH' and @strOrderBy <> '4'
  begin
   set @@Select = " Select Branch_cd, " 
  end
 if @strConsolidate = 'TRADER' and @strOrderBy <> '4'
  begin
   set @@Select = " select Trader, " 
  end
 if @strConsolidate = 'SUB_BROKER' and @strOrderBy <> '4'
  begin
   set @@Select =  " Select Sub_broker, " 
  end
 if @strConsolidate = 'FAMILY' and @strOrderBy <> '4'
  begin
   set @@Select = " Select Family, Family_name, " 
  end
 if @strConsolidate = 'REGION' and @strOrderBy <> '4'
  begin
   set @@Select = " Select Region, " 
  end
 if (@strOrderBy = '5')
  begin    
   set @@Select = @@Select + " Scrip_Name, Scrip_CD,"     
  end    
 if @strOrderBy = '4'
  begin
   set @@Select = "Select "
	/*if @strConsolidate <> 'BROKER'
	begin
		set @@Select = @@Select + "Sett_no,Sett_type,"
	end*/ 
	set @@Select = @@Select + "trade_date = Left(convert(varchar,S.sauda_date,112),11), sauda_date = Left(convert(varchar,sauda_date,109),11)," 
  end
 if @strConsolidate = 'DATE' and @strOrderBy = '5'
  begin
   set @@Select = " Select "
	/*if @strConsolidate <> 'BROKER'
	begin
		set @@Select = @@Select + "Sett_no,Sett_type,"
	end*/ 
	set @@Select = @@Select + "trade_date = Left(convert(varchar,S.sauda_date,112),11),sauda_date = Left(convert(varchar,sauda_date,109),11),"
   	set @@Select = @@Select + "Scrip_Name, Scrip_CD,"     
  end

  set @@Select = @@Select  +" TrdTurn=Sum(TrdAmt-DelAmt), "
  set @@Select = @@Select  +" DelTurn=Sum(DelAmt), "
  set @@Select = @@Select  +" TotTurn=Sum(TrdAmt),"
  set @@Select = @@Select  +" TrdBuyBrk=Sum(PBrokTrd),"
  set @@Select = @@Select  +" TrdSellBrk=Sum(SBrokTrd),"
  set @@Select = @@Select  +" DelBuyBrk=Sum(PBrokDel),"
  set @@Select = @@Select  +" DelSellBrk=Sum(SBrokDel),"
  set @@Select = @@Select  +" TotBrk=Sum(PBrokTrd+SBrokTrd+PBrokDel+SBrokDel),"
  set @@Select = @@Select  +" STT=Sum(ins_chrg),"
  set @@Select = @@Select  +" Service_Tax=Sum(Service_Tax)"  
  set @@Select = @@Select  +" from  NSEBSEValan s where "

	if @strExchange <> 'ALL'   and  @strExchange <> 'CAPITAL'
	  begin
	   set @@Select = @@Select  +"  Exchange = '" +@strExchange + "' and"
	  end
	if  @strExchange = 'CAPITAL' 
	  begin  
	   set @@Select = @@Select  +"  Exchange in('NSE','BSE') and"  
	  end   
  
	set @@Select = @@Select  + " S.sauda_date Between '" + @strDateFrom + " 00:00:00'  And '" + @strDateTo + " 23:59:00'"
  	set @@Select = @@Select  +" and S.scrip_cd Between '0' And  'ZZZZZZZZZZ'  And   "
	if @strConsolidate = 'PARTY' 
		BEGIN
		  set @@Select = @@Select  +" S.party_code Between '"+ @strFromParty +"' And '"+ @strToParty + "' and "  
		END
	if @strConsolidate = 'BROKER' 
		BEGIN
		  set @@Select = @@Select  +" S.party_code Between '"+ @strFromParty +"' And '"+ @strToParty + "' and "  
		END
	if @strConsolidate = 'BRANCH' 
		BEGIN
		  set @@Select = @@Select  +" S.BRANCH_CD Between '"+ @strFromParty +"' And '"+ @strToParty + "' and "  
		END
	if @strConsolidate = 'TRADER' 
		BEGIN
		  set @@Select = @@Select  +" S.Trader Between '"+ @strFromParty +"' And '"+ @strToParty + "' and "  
		END
	if @strConsolidate = 'CLIENT' 
		BEGIN
		  set @@Select = @@Select  +" S.Party_code Between '"+ @strFromParty +"' And '"+ @strToParty + "' and "  
		END
	if @strConsolidate = 'REGION' 
		BEGIN
		  set @@Select = @@Select  +" S.Region Between '"+ @strFromParty +"' And '"+ @strToParty + "' and "  
		END
	if @strConsolidate = 'AREA' 
		BEGIN
		  set @@Select = @@Select  +" S.Area Between '"+ @strFromParty +"' And '"+ @strToParty + "' and "  
		END
	if @strConsolidate = 'SUB_BROKER' 
		BEGIN
		  set @@Select = @@Select  +" S.SUB_BROKER Between '"+ @strFromParty +"' And '"+ @strToParty + "' and "  
		END
	if @strConsolidate = 'FAMILY'
		BEGIN
		  set @@Select = @@Select  +" S.FAMILY Between '"+ @strFromParty +"' And '"+ @strToParty + "' and "
		END
	if @strConsolidate = 'SCRIP'
		BEGIN
		  set @@Select = @@Select  +" S.SCRIP_CD Between '"+ @strFromParty +"' And '"+ @strToParty + "' and "
		END

	 If @statusid = "family"   
	  Set @@Select =  @@Select + " Family Between '" + @statusname  + "' And '" + @statusname   +"' And "
	 If @statusid = "trader"
	  Set @@Select =  @@Select + " Trader Between '" + @statusname  + "' And '" + @statusname   +"' And "
	 If @statusid = "branch"
	  Set @@Select =  @@Select + " Branch_cd Between '" + @statusname  + "' And '" + @statusname   +"' And "
	 If @statusid = "subbroker"
	  Set @@Select =  @@Select + " Sub_broker Between '" + @statusname  + "' And '" + @statusname   +"' And "
	 If @statusid = "client"
	  Set @@Select =  @@Select + " Party_code Between '" + @statusname  + "' And '" + @statusname   +"' And "
	 If @statusid = "region"
	  Set @@Select =  @@Select + " Region Between '" + @statusname  + "' And '" + @statusname   +"' And "
	 If @statusid = "area"
	  Set @@Select =  @@Select + " Area Between '" + @statusname  + "' And '" + @statusname   +"' And "
  
	 If @ConsolId = "family"
	  Set @@Select =  @@Select + " Family Between '" + @Consolname  + "' And '" + @Consolname   +"' And "
	 If @ConsolId = "trader"  
	  Set @@Select =  @@Select + " Trader Between '" + @Consolname  + "' And '" + @Consolname   +"' And "
	 If @ConsolId = "branch"   
	  Set @@Select =  @@Select + " Branch_cd Between '" + @Consolname  + "' And '" + @Consolname   +"' And "
	 If @ConsolId = "sub_broker"   
	  Set @@Select =  @@Select + " Sub_broker Between '" + @Consolname  + "' And '" + @Consolname   +"' And "
	 If @ConsolId = "party"   
	  Set @@Select =  @@Select + " Party_code Between '" + @Consolname  + "' And '" + @Consolname   +"' And "
	 If @ConsolId = "region"   
	  Set @@Select =  @@Select + " Region Between '" + @Consolname  + "' And '" + @Consolname   +"' And "
	 If @ConsolId = "area"   
	  Set @@Select =  @@Select + " Area Between '" + @Consolname  + "' And '" + @Consolname   +"' And "
	 If @ConsolId = "date"   
	  set @@Select = @@Select  +" S.sett_no Between '"+ @Consolname +"' And '"+ @Consolname + "' and "
	 If @ConsolId = "scrip"   
	  set @@Select = @@Select  +" S.Scrip_cd Between '"+ @Consolname +"' And '"+ @Consolname + "' and "

 if @strOrderBy <> '4'
  begin
   set @@Select = @@Select  +" Tradetype Not In ( 'scf','icf','ir' ) "
  end
 if @strOrderBy = '4'
  begin
   set @@Select = @@Select  +" Tradetype Not In ( 'ir' ) "
  end
 if @ClientType <> 'ALL'
  begin
   set @@Select = @@Select  +" and S.clienttype ='" + @ClientType + "'"
  end  
  
 if @strConsolidate = 'PARTY' and @strOrderBy <> '4'
  begin
   set @@Select = @@Select  +" Group By Party_Code,party_name,Clienttype " 
  end

 if @strConsolidate = 'SCRIP' and @strOrderBy <> '4'
  begin
   set @@Select = @@Select  +" Group By Party_Code,party_name,Clienttype " 
  end
  
 if @strConsolidate = 'BROKER' and @strOrderBy <> '4'
  begin
   set @@Select = @@Select  +" Group By Party_Code,party_name " 
  end

 if @strConsolidate = 'AREA' and @strOrderBy <> '4'
  begin
   set @@Select = @@Select  +" Group By Area " 
  end
  
 if @strConsolidate = 'BRANCH' and @strOrderBy <> '4'
  begin
   set @@Select = @@Select  +" Group By Branch_cd " 
  end
  
 if @strConsolidate = 'TRADER' and @strOrderBy <> '4'
  begin
   set @@Select = @@Select  +" Group By Trader " 
  end
  
 if @strConsolidate = 'SUB_BROKER' and @strOrderBy <> '4'
  begin
   set @@Select = @@Select  +" Group By Sub_broker " 
  end
  
 if @strConsolidate = 'FAMILY' and @strOrderBy <> '4' 
  begin
   set @@Select = @@Select  +" Group By Family, Family_name " 
  end
  
 if @strConsolidate = 'REGION' and @strOrderBy <> '4' 
  begin
   set @@Select = @@Select  +" Group By Region " 
  end
 if  @strOrderBy = '4'
  begin
   set @@Select = @@Select  +" Group By " 
	/*if @strConsolidate <> 'BROKER'
	begin
	set @@Select = @@Select + "Sett_no,Sett_type,"
	end*/ 
	set @@Select = @@Select + "left(convert(varchar,sauda_date,112),11),left(convert(varchar,sauda_date,109),11) " 
   end
 if @strConsolidate = 'DATE' and @strOrderBy = '5'
  begin
   set @@Select = @@Select  +" Group By "
	/*if @strConsolidate <> 'BROKER'
	begin
	set @@Select = @@Select + "Sett_no,Sett_type,"
	end*/ 
	set @@Select = @@Select + "left(convert(varchar,sauda_date,112),11),left(convert(varchar,sauda_date,109),11) " 
  end
 if (@strOrderBy = '5')    
  begin    
   set @@Select = @@Select  +",Scrip_CD,Scrip_Name "     
  end    
 
  if @strOrderBy = '1' and @strConsolidate = 'PARTY'
  begin
   set @@Select = @@Select  +" Order By Party_code "
  end

  if @strOrderBy = '1' and @strConsolidate = 'SCRIP'
  begin
   set @@Select = @@Select  +" Order By Party_code "
  end
  
 if @strOrderBy = '1' and @strConsolidate = 'BROKER'
  begin
   set @@Select = @@Select  +" Order By Party_code "
  end

 if @strOrderBy = '1' and @strConsolidate = 'AREA'
  begin
   set @@Select = @@Select  +" Order By AREA "
  end
  
 if @strOrderBy = '1' and @strConsolidate = 'BRANCH'
  begin
   set @@Select = @@Select  +" Order By Branch_cd "
  end
  
 if @strOrderBy = '1' and @strConsolidate = 'TRADER'
  begin
   set @@Select = @@Select  +" Order By Trader "
  end
  
 if @strOrderBy = '1' and @strConsolidate = 'SUB_BROKER'
  begin
   set @@Select = @@Select  +" Order By SUB_BROKER "
  end
  
 if @strOrderBy = '1' and @strConsolidate = 'FAMILY'
  begin
   set @@Select = @@Select  +" Order By FAMILY "
  end
  
 if @strOrderBy = '1' and @strConsolidate = 'REGION'
  begin
   set @@Select = @@Select  +" Order By Region "
  end
 if @strOrderBy = '4'
  begin
   set @@Select = @@Select  +" Order By left(convert(varchar,sauda_date,112),11)"
	/*if @strConsolidate <> 'BROKER'
	begin
	set @@Select = @@Select  +",S.sett_no,s.sett_type "
	end*/
  end
 if @strConsolidate = 'DATE' and @strOrderBy = '5'
  begin
   set 	@@Select = @@Select  +" Order By left(convert(varchar,sauda_date,112),11)"
	/*if @strConsolidate <> 'BROKER'
	begin
	set @@Select = @@Select  +",S.sett_no,s.sett_type "
	end*/
  end
 if (@strOrderBy = '5')
  begin    
   set @@Select = @@Select  +",Scrip_CD,Scrip_Name"
  end    
  
print @@Select
exec (@@Select)

GO
