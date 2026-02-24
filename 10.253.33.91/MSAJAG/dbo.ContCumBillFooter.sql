-- Object: PROCEDURE dbo.ContCumBillFooter
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





CREATE proc ContCumBillFooter (@Sdate varchar(12), @Sett_Type varchar(2), @ContNo varchar(6), @sell_buy varchar(1)) as
begin
 select Qty =isnull( sum(qty),0), Amount =isnull( sum(amount),0), Brokerage =isnull( sum(brokerage),0), Ser = isnull(sum(ser),0) from contFootPS where 
 rtrim(sett_type) = @sett_type
 and sauda_date like  @sdate + '%'
 and (convert(int,contractno) = @contno )
 and sell_buy = @sell_buy
end

GO
