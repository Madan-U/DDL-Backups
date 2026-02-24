-- Object: PROCEDURE dbo.V2_Offline_ClientMaster_Test
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc V2_Offline_ClientMaster_test
(      
 @ModifyDate varchar(10) ,  
 @ModifyType varchar(1)     
)      
      
as      
      
/*      
 V2_Offline_ClientMaster_Test '20060713','U'  
*/      
      

Set @ModifyDate = left(Convert(datetime, replace(@ModifyDate,'/',''), 112),11)


      
if @ModifyType = 'I'  
begin  
	 Set Transaction Isolation Level Read Uncommitted      
	 select Distinct  
	  cd.Cl_Code,       
	  cd.Party_Code,       
	  cd.Long_Name,       
	  cd.Branch_cd,       
	  cd.Sub_Broker,       
	  cd.Trader,       
	  Imp_Status = case when cbd.Imp_Status = 0 then 'Pending' else 'Updated' end,       
	/*  
	  ModifiedOn = cd.ModifidedOn,       
	  ModifiedBy = cd.ModifidedBy,  
	*/  
	  NSE =   
	 (  
	 SELECT ISNULL((Select 'YES' FROM CLIENT_BROK_DETAILS A (NOLOCK)  
	 WHERE a.EXCHANGE = 'NSE'  
	 AND a.SEGMENT = 'CAPITAL'  
	 AND a.CL_CODE = CD.cl_code),'NO')  
	 ),  
	  BSE=   
	 (  
	 SELECT ISNULL((Select 'YES' FROM CLIENT_BROK_DETAILS b (NOLOCK)  
	 WHERE b.EXCHANGE = 'BSE'  
	 AND b.SEGMENT = 'CAPITAL'  
	 AND b.CL_CODE = CD.cl_code),'NO')  
	 ),  
	  
	  FO =   
	 (  
	 SELECT ISNULL((Select 'YES' FROM CLIENT_BROK_DETAILS c (NOLOCK)  
	 WHERE c.EXCHANGE = 'NSE'  
	 AND c.SEGMENT = 'FUTURES'  
	 AND c.CL_CODE = CD.cl_code),'NO')  
	 ),  
	  
	  NCDX =   
	 (  
	 SELECT ISNULL((Select 'YES' FROM CLIENT_BROK_DETAILS d (NOLOCK)  
	 WHERE d.EXCHANGE = 'NCX'  
	 AND d.SEGMENT = 'FUTURES'  
	 AND d.CL_CODE = CD.cl_code),'NO')  
	 ),  
	  
	  MCX=   
	 (  
	 SELECT ISNULL((Select 'YES' FROM CLIENT_BROK_DETAILS e (NOLOCK)  
	 WHERE e.EXCHANGE = 'MCX'  
	 AND e.SEGMENT = 'FUTURES'  
	 AND e.CL_CODE = CD.cl_code),'NO')  
	 )  
	 from       
	  client_details cd (Nolock)      
	 left Outer Join      
	  Client_Brok_details cbd (nolock)      
	 on       
	  (cbd.Cl_code = cd.Cl_code)       
	 Where       
		cd.cl_code in
			(
				select cl_code from client_details (nolock)
				where modifidedOn like @ModifyDate+'%'
				and cl_code not in
				(select cl_code from client_details_log (nolock))
				Union
				(
				select distinct cl_code from client_details_log (nolock)
				where modifidedOn like @ModifyDate+'%'
				and Status = 'I'
				)
			)
	Order by 2  
end  
else  
begin  
	 Set Transaction Isolation Level Read Uncommitted      
	 select Distinct  
	  cd.Cl_Code,       
	  cd.Party_Code,       
	  cd.Long_Name,       
	  cd.Branch_cd,       
	  cd.Sub_Broker,       
	  cd.Trader,       
	  Imp_Status = case when cbd.Imp_Status = 0 then 'Pending' else 'Updated' end,       
	/*  
	  ModifiedOn = cd.ModifidedOn,       
	  ModifiedBy = cd.ModifidedBy,  
	*/  
	  NSE =   
	 (  
	 SELECT ISNULL((Select 'YES' FROM CLIENT_BROK_DETAILS A (NOLOCK)  
	 WHERE a.EXCHANGE = 'NSE'  
	 AND a.SEGMENT = 'CAPITAL'  
	 AND a.CL_CODE = CD.cl_code),'NO')  
	 ),  
	  BSE=   
	 (  
	 SELECT ISNULL((Select 'YES' FROM CLIENT_BROK_DETAILS b (NOLOCK)  
	 WHERE b.EXCHANGE = 'BSE'  
	 AND b.SEGMENT = 'CAPITAL'  
	 AND b.CL_CODE = CD.cl_code),'NO')  
	 ),  
	  
	  FO =   
	 (  
	 SELECT ISNULL((Select 'YES' FROM CLIENT_BROK_DETAILS c (NOLOCK)  
	 WHERE c.EXCHANGE = 'NSE'  
	 AND c.SEGMENT = 'FUTURES'  
	 AND c.CL_CODE = CD.cl_code),'NO')  
	 ),  
	  
	  NCDX =   
	 (  
	 SELECT ISNULL((Select 'YES' FROM CLIENT_BROK_DETAILS d (NOLOCK)  
	 WHERE d.EXCHANGE = 'NCX'  
	 AND d.SEGMENT = 'FUTURES'  
	 AND d.CL_CODE = CD.cl_code),'NO')  
	 ),  
	  
	  MCX=   
	 (  
	 SELECT ISNULL((Select 'YES' FROM CLIENT_BROK_DETAILS e (NOLOCK)  
	 WHERE e.EXCHANGE = 'MCX'  
	 AND e.SEGMENT = 'FUTURES'  
	 AND e.CL_CODE = CD.cl_code),'NO')  
	 )  
	 from       
	  client_details cd (Nolock)      
	 left Outer Join      
	  Client_Brok_details cbd (nolock)      
	 on       
	  (cbd.Cl_code = cd.Cl_code)       
	 Where       
	  (      
		cd.ModifidedOn like @ModifyDate+'%'
		or   
		cbd.Modifiedon like @ModifyDate+'%'
	 )
	and
			cd.cl_code not in
				(
					select cl_code from client_details (nolock)
					where modifidedOn like @ModifyDate+'%'
					and cl_code not in
					(select cl_code from client_details_log (nolock))
					Union
					(
					select distinct cl_code from client_details_log (nolock)
					where modifidedOn like @ModifyDate+'%'
					and Status = 'I'
					)
				)
	      
	Order by 2  
end

GO
