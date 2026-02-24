-- Object: PROCEDURE dbo.Spx_GetCountForEmailandMobile_Kyc
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


-- exec Spx_GetCountForEmailandMobile_Kyc 'hradeshh11@gmail.com','E'
-- exec Spx_GetCountForEmailandMobile_Kyc '','M'
Create Proc Spx_GetCountForEmailandMobile_Kyc

(
 @Value varchar(200),
 @Flag varchar(1)
)
As
begin

set @Value=LTRIM(rtrim(@Value))
Create table #CountDetails (PanNo varchar(15),value varchar(200),Deactive_Value varchar(10))

If @Flag='E'
begin
	insert into #CountDetails(PanNo,value,Deactive_Value)
	SELECT cd.pan_gir_no  ,cd.email  ,cd1.Deactive_Value
		FROM CLIENT_DETAILS CD WITH (NOLOCK)      
	   inner join CLIENT_Brok_DETAILS CD1 WITH (NOLOCK) on CD.Cl_Code=CD1.Cl_Code    
	   WHERE  EMAIL = @Value       
	   and isnull(CD1.Deactive_Value,'')<>'T' 
	   
	   Delete from #CountDetails where ISNULL(value,'')=''
	   Delete from #CountDetails where ISNULL(Deactive_Value,'')='T'
   
   
   end 
   
   else if  @Flag='M'
   begin
   
   	insert into #CountDetails(PanNo,value,Deactive_Value)
	SELECT cd.pan_gir_no  ,cd.email  ,cd1.Deactive_Value
		FROM CLIENT_DETAILS CD WITH (NOLOCK)      
	   inner join CLIENT_Brok_DETAILS CD1 WITH (NOLOCK) on CD.Cl_Code=CD1.Cl_Code    
	   WHERE  mobile_pager = @Value       
	   and isnull(CD1.Deactive_Value,'')<>'T' 
	   
	   Delete from #CountDetails where ISNULL(value,'')=''
	   Delete from #CountDetails where ISNULL(Deactive_Value,'')='T'

       
   end
   
   Select COUNT(Distinct panNo) as ExistCount from #CountDetails
   
   
   end

GO
