-- Object: PROCEDURE dbo.GetBranchList
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc GetBranchList AS

SET NOCOUNT ON

Declare      
@strBranchCodes  varchar(500),
@BranchCode  varchar(10),
@strAreaCodePrv varchar(20),
@strAreaCode varchar(20),
@strAreaDescPrv varchar(50),
@strAreaDesc varchar(50),
@BranchCur Cursor      


Create Table #AreaCode
(
	AreaCode Varchar(80)  ,
	Details Varchar(100) 
)

Set @BranchCur = Cursor for  Select Distinct AREACODE, [DESCRIPTION] ,BRANCH_CODE   From AREA Order By AREACODE
Open @BranchCur      

Fetch Next From @BranchCur into @strAreaCode,@strAreaDesc,@BranchCode
Set @strAreaCodePrv = @strAreaCode
Set @strBranchCodes =''
While @@Fetch_Status = 0       
Begin      
  
	if @strAreaCodePrv <> @strAreaCode
	begin
                --Insert Into #AreaCode Values (@strAreaCodePrv + ' ' + @strAreaDescPrv, @strAreaCodePrv + ','+ @strAreaDescPrv + ',' + @strBranchCodes)
                Insert Into #AreaCode Values (@strAreaCodePrv + space(22-len(@strAreaCodePrv)) + @strAreaDescPrv, @strAreaCodePrv + ','+ @strAreaDescPrv + ',' + @strBranchCodes)
		Set @strBranchCodes= ''
		Set @strAreaCodePrv = @strAreaCode
		Set @strAreaDescPrv = @strAreaDesc
	end
    
	if @strBranchCodes=''
		Begin
			Set @strBranchCodes =  @BranchCode
		End
	else
		Begin
			Set @strBranchCodes = @strBranchCodes + ',' + @BranchCode
		End
Fetch Next From @BranchCur into @strAreaCode,@strAreaDesc,@BranchCode
End      
Close @BranchCur      
DeAllocate @BranchCur      
select * from #AreaCode where areacode is not null 
drop table #AreaCode

GO
