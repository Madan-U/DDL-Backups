-- Object: PROCEDURE dbo.V2_SubBroker_Client_Stats
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Proc V2_SubBroker_Client_Stats  
(  
 @date varchar(11),
 @subbroker  varchar(25) = '%'
)  
  
as  
  
if @subbroker = '%'
begin
  
	/*Notice: Formatted SQL is not the same as input*/  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
	SELECT
			 REGION = isnull(R.REGIONCODE,''),
			 SB.BRANCH_CODE,
			 SB.SUB_BROKER,  
			 SB.NAME,  
			 SB.ADDRESS1,  
			 SB.ADDRESS2,  
			 SB.CITY,  
			 SB.ZIP,  
			 SB.STATE,  
			 SB.PHONE1,  
			 SB.PHONE2,  
			 SB.EMAIL,  
			 SB.CONTACT_PERSON,  
			 CLIENT_COUNT = COUNT(CM.CL_CODE),  
	   INACTIVE_CLIENT = Sum(isnull(CM.INACTIVE,0)),  
	   ACTIVE_CLIENT = sum(isnull(CM.ACTIVE,0))  
	FROM     SUBBROKERS SB (NOLOCK)  
	left outer join  
		(  
		  
		Select c1.Cl_Code, c1.sub_Broker, InActive = (Case when c5.InactiveFrom <= @date + ' 23:59:59' then 1 else 0 end),  
		Active = (Case when c5.InactiveFrom > @date + ' 23:59:59' then 1 else 0 end)  
		From Client1 c1 (nolock)  
		join client2 c2 (nolock)  
		on (c2.cl_code = c1.cl_code)  
		join client5 c5 (nolock)  
		on (c5.cl_code = c1.cl_code)  
		) cM  
		on (cm.sub_broker = sb.sub_broker)  
	left Outer Join
		REGION R
	on (R.BRANCH_CODE = SB.BRANCH_CODE)
	GROUP BY 	isnull(R.REGIONCODE,''),
			 SB.BRANCH_CODE,
			 SB.SUB_BROKER,  
			 SB.NAME,  
			 SB.ADDRESS1,  
			 SB.ADDRESS2,  
			 SB.CITY,  
			 SB.ZIP,  
			 SB.STATE,  
			 SB.PHONE1,  
			 SB.PHONE2,  
			 SB.EMAIL,  
			 SB.CONTACT_PERSON  
end
else
begin
	/*Notice: Formatted SQL is not the same as input*/  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
	SELECT
			 REGION = isnull(R.REGIONCODE,''),
			 SB.BRANCH_CODE,
			 SB.SUB_BROKER,  
			 SB.NAME,  
			 SB.ADDRESS1,  
			 SB.ADDRESS2,  
			 SB.CITY,  
			 SB.ZIP,  
			 SB.STATE,  
			 SB.PHONE1,  
			 SB.PHONE2,  
			 SB.EMAIL,  
			 SB.CONTACT_PERSON,  
			 CLIENT_COUNT = COUNT(CM.CL_CODE),  
	   INACTIVE_CLIENT = Sum(isnull(CM.INACTIVE,0)),  
	   ACTIVE_CLIENT = sum(isnull(CM.ACTIVE,0))  
	FROM     SUBBROKERS SB (NOLOCK)  
	left outer join  
		(  
		  
		Select c1.Cl_Code, c1.sub_Broker, InActive = (Case when c5.InactiveFrom <= @date + ' 23:59:59' then 1 else 0 end),  
		Active = (Case when c5.InactiveFrom > @date + ' 23:59:59' then 1 else 0 end)  
		From Client1 c1 (nolock)  
		join client2 c2 (nolock)  
		on (c2.cl_code = c1.cl_code)  
		join client5 c5 (nolock)  
		on (c5.cl_code = c1.cl_code)  
		) cM  
		on (cm.sub_broker = sb.sub_broker)  
	left Outer Join
		REGION R
	on (R.BRANCH_CODE = SB.BRANCH_CODE)
	WHERE
		SB.SUB_BROKER = @subbroker
	GROUP BY 	isnull(R.REGIONCODE,''),
			 SB.BRANCH_CODE,
			 SB.SUB_BROKER,  
			 SB.NAME,  
			 SB.ADDRESS1,  
			 SB.ADDRESS2,  
			 SB.CITY,  
			 SB.ZIP,  
			 SB.STATE,  
			 SB.PHONE1,  
			 SB.PHONE2,  
			 SB.EMAIL,  
			 SB.CONTACT_PERSON  
end

GO
