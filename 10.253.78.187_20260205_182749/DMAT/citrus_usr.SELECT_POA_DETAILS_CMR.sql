-- Object: PROCEDURE citrus_usr.SELECT_POA_DETAILS_CMR
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE   PROCEDURE [citrus_usr].[SELECT_POA_DETAILS_CMR] 
 (   
@PA_ACTION VARCHAR(16),  
@PA_BOID VARCHAR(20),  
@PA_MASTERPOAID VARCHAR(20) 
     
)  

AS
BEGIN

IF @PA_ACTION ='POA_dtls'
begin
select distinct  dps8_pc5.HolderNum as HolderNum,dps8_pc5.POARegNum as poaref ,MasterPOAId as Master_Poa
from dps8_pc5 where BOId = @PA_BOID
and TypeOfTrans in ('1','2','4','')
end

else IF @PA_ACTION ='Auth_dtls'
begin
select distinct BOName as Auth_name from dps8_pc18 where BOId = @PA_BOID
and TypeOfTrans in ('1','2','4','')

end

END

GO
