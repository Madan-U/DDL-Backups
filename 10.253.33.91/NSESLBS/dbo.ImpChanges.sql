-- Object: PROCEDURE dbo.ImpChanges
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Impchanges As     
    
Update Trade Set Party_code = Newparty_code From Partymapping    
Where Party_code Like Oldparty_code    
    
Update Trade Set Party_code = T.newparty_code From Tradechanges T    
Where T.party_code = Trade.party_code    
And T.scrip_cd = Trade.scrip_cd And T.series = Trade.series     
And Trade.sauda_date Like Left(convert(varchar,t.sauda_date,109),11) + '%'  And T.user_id = Trade.user_id    
And T.order_no = Trade.order_no

GO
