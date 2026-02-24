-- Object: PROCEDURE dbo.rpt_partymapping
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE     proceDURE [dbo].[rpt_partymapping]
	@date varchar(11),
	@OrderType Varchar(10),
	@RptType Varchar(10)

	AS
  
set transaction isolation level read uncommitted

If (@RptType = 'Summary')
Begin
	select
		RptOrder = (Case When @OrderType = 'PARTY' 
				Then Party_Code
				Else ContractNo
				End),	
		party_code,
		contractno,
		User_Id,
		branch_id,
		sell_buy,
		Tradeqty = sum(Tradeqty),
		avgrate = sum(Marketrate*Tradeqty)/Sum(Tradeqty),
		Scrip_CD,
		Series		
	from
		Settlement S (Nolock),
		Client1 C1 (Nolock)
	where 
		S.Party_code = C1.CL_Code
		And sauda_date like @date +'%' 
		And tradeqty > 0
	
	group by
		party_code,
		user_id,
		branch_id,
		contractno,
		sell_buy,
		Scrip_CD,
		Series	

	order by 
		contractno,
		Party_code,
		RptOrder
		
		
	
End
Else
Begin
	select
		RptOrder = (Case When @OrderType = 'PARTY' 
				Then Party_Code
				Else ContractNo
				End),	
		party_code,
		contractno,
		User_Id,
		branch_id,
		sell_buy,
		Tradeqty = Tradeqty,
		avgrate = Marketrate,
		Scrip_CD,
		Series		
	from
		Settlement S (Nolock),
		Client1 C1 (Nolock)
	where 
		S.Party_code = C1.CL_Code
		And sauda_date like @date +'%' 
		and tradeqty > 0
	order by 
		contractno,
		Party_code,
		RptOrder

End

GO
