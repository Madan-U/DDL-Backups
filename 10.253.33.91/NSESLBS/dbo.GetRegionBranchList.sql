-- Object: PROCEDURE dbo.GetRegionBranchList
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc GetRegionBranchList AS

SET NOCOUNT ON

Declare      
@strBranchCodes  varchar(500),
@BranchCode  varchar(10),
@strRegionCodePrv varchar(20),
@strRegionCode varchar(20),
@strRegionDescPrv varchar(50),
@strRegionDesc varchar(50),
@BranchCur Cursor      


Create Table #RegionCode
(
	RegionCode Varchar(80)  ,
	Details Varchar(100) 
)

Set @BranchCur = Cursor for  Select Distinct REGIONCODE, [DESCRIPTION] ,BRANCH_CODE   From region Order By REGIONCODE
Open @BranchCur      

Fetch Next From @BranchCur into @strRegionCode,@strRegionDesc,@BranchCode
Set @strRegionCodePrv = @strRegionCode
Set @strBranchCodes =''
While @@Fetch_Status = 0       
Begin      
  
	if @strRegionCodePrv<> @strRegionCode
	begin
                --Insert Into #AreaCode Values (@strAreaCodePrv + ' ' + @strAreaDescPrv, @strAreaCodePrv + ','+ @strAreaDescPrv + ',' + @strBranchCodes)
                Insert Into #RegionCode Values (@strRegionCodePrv + space(22-len(@strRegionCodePrv)) + @strRegionDescPrv, @strRegionCodePrv + ','+@strRegionDescPrv + ',' + @strBranchCodes)
		Set @strBranchCodes= ''
		Set @strRegionCodePrv = @strRegionCode
		Set @strRegionDescPrv = @strRegionDesc
	end
    
	if @strBranchCodes=''
		Begin
			Set @strBranchCodes =  @BranchCode
		End
	else
		Begin
			Set @strBranchCodes = @strBranchCodes + ',' + @BranchCode
		End
Fetch Next From @BranchCur into @strRegionCode,@strRegionDesc,@BranchCode
End      
Close @BranchCur      
DeAllocate @BranchCur      
select * from #RegionCode where regioncode is not null 
drop table #RegionCode

GO
